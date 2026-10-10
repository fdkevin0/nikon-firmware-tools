#!/usr/bin/env python3
"""Recover Z8 3.11 sensor-backend selectors without parameter bytes or hardware.

The resource getter runs with an explicitly zero synthetic state. Command probes
stop at the stream sender; its bytes and the transport are never executed.
"""
import argparse
import hashlib
import itertools
import json
import struct

from reverse_z8_video_modes import BASE, EXPECTED_SHA, Probe, ROOT
from reverse_z8_capture_state import offset
from reverse_z8_dsp_host import disassembler

PARAM_POINTER = 0xA0496F6A0
RESOURCE = 0xA0291C948 + 0x5C * 48
MODE_COLUMNS = 0xA02AAA3D0
COMMAND_MATRIX = 0xA02A99E70
# These arms only calculate stream/length-array addresses. Other commands build
# mutable packets or read the unavailable parameter block and are not emulated.
DIRECT_COMMANDS = list(range(7)) + list(range(14, 38)) + [41, 42, 44, 45, 46]
RANGES = {
    'service_callback_registration_and_parameter_binding': (0x40F588BC, 0x40F58948),
    'backend_callback_registration': (0x411540AC, 0x411540F8),
    'backend_event_0201000a': (0x41151B50, 0x41151B80),
    'service_event_dispatch_excerpt': (0x40F58A44, 0x40F58B24),
    'configuration_request': (0x41158850, 0x41158C04),
    'apply_configuration_excerpt': (0x41158C04, 0x41158CE0),
    'request_to_backend_mode': (0x411717F4, 0x41171964),
    'parameter_pointer_setter': (0x41166D54, 0x41166D6C),
    'command_dispatcher': (0x41166D6C, 0x411679DC),
    'mode_to_command_column': (0x411679DC, 0x41167A08),
    'stream_sender': (0x41167B7C, 0x41167BD8),
    'mode_to_timing_row': (0x41167E40, 0x41167ECC),
    'timing_queries': (0x41171E4C, 0x41171EA8),
    'timing_parameter_access_excerpt': (0x41172080, 0x411721B8),
    'resource_getter': (0x40D6B4F4, 0x40D6B538),
    'resource_pointer_paths': (0x40D6CC6C, 0x40D6CCD8),
    'resource_descriptors': (0x40D712AC, 0x40D712FC),
}


class SensorProbe(Probe):
    def __init__(self, data):
        super().__init__(data)
        from unicorn import UC_HOOK_CODE
        self.uc.mem_map(0xA0496F000, 0x2000)
        self.uc.mem_map(0xA03426000, 0x1000)
        self.streams = []
        self.uc.hook_add(UC_HOOK_CODE, self.stop_stream,
                         begin=0x41167B7C, end=0x41167B7C)

    def hook(self, uc, address, size, user):
        raise ValueError(f'Unexpected service {address:#x}')

    def stop_stream(self, uc, address, size, user):
        self.streams.append([self.reg('X0'), self.reg('X1')])
        uc.reg_write(self.regs.UC_ARM64_REG_X0, 0)
        uc.reg_write(self.regs.UC_ARM64_REG_PC, self.reg('LR'))


def analyze(data):
    p = SensorProbe(data)
    descriptor = data[offset(RESOURCE):offset(RESOURCE) + 48]
    resource_id, relative, alternate, length = struct.unpack_from('<4Q', descriptor)
    group = struct.unpack_from('<I', descriptor, 36)[0]
    group_address = 0xA0291DAB8 + group * 40
    group_base = struct.unpack_from('<Q', data, offset(group_address))[0]
    fallback = p.call(0x40D6B4F4, 0x5C)
    assert (resource_id, group, length, fallback) == (0x5C, 38, 0xF2000, 0x47E80000)
    assert fallback == group_base + relative and alternate == 0
    # Use the actual pointer setter. No bytes are mapped at the parameter address.
    p.call(0x411540F4, fallback)
    assert struct.unpack('<Q', p.uc.mem_read(PARAM_POINTER, 8))[0] == fallback

    requests = []
    for kind, selector, submode in itertools.product(range(10), range(10), range(5)):
        p.uc.mem_write(p.buf, struct.pack('<12I', kind, selector, 0, submode, *([0] * 8)))
        mode = p.call(0x411717F4, p.buf)
        requests.append({'input_00': kind, 'input_04': selector, 'input_0c': submode,
                         'backend_mode': mode})
    # Branches not exercised by the all-zero flag baseline.
    flags = []
    for flag20, field24, flag2c, byte2d in [(1, n, 0, 0) for n in range(5)] + [(0, 0, 1, 0), (0, 0, 0, 3)]:
        request = bytearray(48)
        request[0x20] = flag20
        struct.pack_into('<I', request, 0x24, field24)
        request[0x2C], request[0x2D] = flag2c, byte2d
        p.uc.mem_write(p.buf, bytes(request))
        flags.append({'flag20': flag20, 'field24': field24, 'flag2c': flag2c,
                      'byte2d': byte2d, 'backend_mode': p.call(0x411717F4, p.buf)})
    assert [v['backend_mode'] for v in flags] == [5, 3, 3, 3, 0, 1, 3]
    lookup = {(r['input_00'], r['input_04'], r['input_0c']): r['backend_mode'] for r in requests}
    assert lookup[5, 4, 2] == 9 and lookup[5, 6, 2] == 16
    assert lookup[6, 0, 0] == 21 and lookup[7, 0, 0] == 22
    assert lookup[9, 0, 0] == 0

    columns = struct.unpack_from('<23I', data, offset(MODE_COLUMNS))
    matrix = data[offset(COMMAND_MATRIX):offset(COMMAND_MATRIX) + 47 * 15]
    modes, commands = [], []
    for mode in range(24):
        p.uc.mem_write(p.buf, bytes(0x1A8))
        p.uc.mem_write(p.buf, struct.pack('<I', mode))
        column = p.call(0x411679DC, p.buf)
        assert column == (columns[mode] if mode < 23 else 0xFFFF)
        modes.append({'mode': mode, 'command_column': column,
                      'timing_row_flag0': p.call(0x41167E40, mode, 0),
                      'timing_row_flag1': p.call(0x41167E40, mode, 1)})
        for command in DIRECT_COMMANDS:
            p.streams.clear()
            try:
                result = p.call(0x41166D6C, command, p.buf)
            except Exception as error:
                raise RuntimeError(f'Mode {mode}, command {command}, PC {p.reg("PC"):#x}') from error
            entry = matrix[command * 15 + column] if column < 15 else 255
            assert result == (1 if entry == 255 else 0)
            assert len(p.streams) == (0 if entry == 255 else 1)
            streams = [{'data_offset': a - fallback, 'lengths_offset': b - fallback}
                       for a, b in p.streams]
            assert all(0 <= v < length for s in streams for v in s.values())
            commands.append({'mode': mode, 'command': command, 'matrix_value': entry,
                             'return': result, 'streams': streams})
    return {
        'image_sha256': EXPECTED_SHA,
        'scope': 'Synthetic selector probes; resource state zero; sender intercepted; no parameter bytes or hardware execution',
        'resource': {'id': resource_id, 'descriptor': hex(RESOURCE), 'group': group,
                     'length': length, 'relative_offset': relative, 'alternate_pointer': alternate,
                     'group_descriptor': hex(group_address), 'configured_group_base': hex(group_base),
                     'zero_state_getter_result': hex(fallback), 'backend_pointer': hex(PARAM_POINTER)},
        'tables': {'mode_to_column': list(columns),
                   'command_matrix': [list(matrix[i * 15:(i + 1) * 15]) for i in range(47)]},
        'mode_probes': modes, 'flag_probes': flags,
        'validation': {'request_probes': len(requests), 'flag_probes': len(flags),
                       'mode_probes': len(modes), 'command_address_probes': len(commands),
                       'sender_calls_intercepted': sum(bool(c['streams']) for c in commands),
                       'parameter_bytes_read': 0, 'transport_calls': 0},
    }, {'requests': requests, 'command_addresses': commands}


def main():
    from pathlib import Path
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--image', type=Path, default=ROOT / 'analysis/Z_8_0311/eg2070_0311b0.bi')
    parser.add_argument('--output', type=Path, default=ROOT / 'analysis/z8_sensor_backend')
    args = parser.parse_args()
    data = args.image.read_bytes()
    if hashlib.sha256(data).hexdigest() != EXPECTED_SHA:
        raise ValueError('Expected the pinned Z8 3.11 EG image')
    manifest, probes = analyze(data)
    lines = []
    for name, (a, b) in RANGES.items():
        code = data[a - BASE:b - BASE]
        lines.append(f'\n; {name} [{a:#x}, {b:#x}); SHA-256 {hashlib.sha256(code).hexdigest()}')
        lines.extend(f'{i.address:08x} {i.bytes.hex():8s} {i.mnemonic:8s} {i.op_str}'
                     for i in disassembler().disasm(code, a))
    args.output.mkdir(parents=True, exist_ok=True)
    for name, content in [('manifest.json', manifest), ('probes.json', probes)]:
        (args.output / name).write_text(json.dumps(content, indent=2) + '\n')
    (args.output / 'code_landmarks.asm').write_text('\n'.join(lines) + '\n')
    print(json.dumps(manifest['validation']))


if __name__ == '__main__':
    main()
