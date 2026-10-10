#!/usr/bin/env python3
"""Reproduce Z8 3.11 video-mode gates using isolated AArch64 emulation.

No camera access and no firmware output. Settings services are mocked; geometry
inputs are probes, not claims that those combinations are camera-supported.
Requires capstone and unicorn. Addresses apply only to the pinned EG image.
"""
import argparse
import hashlib
import itertools
import json
from pathlib import Path
import struct

from reverse_z8_dsp_host import BASE, disassembler

ROOT = Path(__file__).resolve().parents[1]
EXPECTED_SHA = 'f85e0138e2f5e660ece8560de62e0d12cb795e0e14983e50f20b61dce906c46c'
RAM = 0xA02808000
RAM_FILE = 0x4B13000
RAM_SIZE = 0x2AD000
FILETYPES = {1: 'H264_MP4', 2: 'H265_8bit', 3: 'H265_10bit',
             4: 'ProRes422HQ', 5: 'ProResRAW', 6: 'NRAW'}
RANGES = {
    'sdk_size_setter': (0x408401EC, 0x408403B4),
    'sdk_allowed_list': (0x40841C8C, 0x40841D44),
    'sdk_enum_lookup': (0x40811C40, 0x40811C70),
    'rate_setting_id': (0x408568D0, 0x4085692C),
    'size_setting_id': (0x40856964, 0x408569C0),
    'movie_width_height': (0x406D2BA4, 0x406D2CA4),
    'effective_video_settings': (0x40ED0310, 0x40ED0BD4),
    'effective_size_selection': (0x40ED8F74, 0x40ED90D0),
    'geometry_builder': (0x41065194, 0x4106669C),
    'geometry_caller_excerpt': (0x41057F64, 0x41058030),
}


def decode_mode(value):
    return {'packed': f'0x{value:016x}', 'width': value >> 48,
            'height': (value >> 32) & 65535, 'fps': (value >> 16) & 255,
            'scan_type': (value >> 14) & 3, 'special': (value >> 8) & 63,
            'extra': value & 255}


class Probe:
    def __init__(self, data):
        from unicorn import Uc, UC_ARCH_ARM64, UC_MODE_ARM, UC_HOOK_CODE
        from unicorn import arm64_const as regs
        self.regs = regs
        self.uc = Uc(UC_ARCH_ARM64, UC_MODE_ARM)
        self.uc.mem_map(BASE, (len(data) + 4095) & ~4095)
        self.uc.mem_write(BASE, data)
        self.uc.mem_map(RAM, RAM_SIZE)
        self.uc.mem_write(RAM, data[RAM_FILE:RAM_FILE + RAM_SIZE])
        self.stack, self.stop, self.buf = 0x10000000, 0x20000000, 0x30000000
        for addr in (self.stack, self.stop, self.buf):
            self.uc.mem_map(addr, 0x10000)
        self.filetype = 6
        self.writes = []
        self.hooks = {0x408564EC, 0x41012C84, 0x40856BE8,
                      0x40856BCC, 0x40814800, 0x4127A900}
        for addr in self.hooks:
            self.uc.hook_add(UC_HOOK_CODE, self.hook, begin=addr, end=addr)
        self.clean_context = self.uc.context_save()

    def reg(self, name):
        return self.uc.reg_read(getattr(self.regs, 'UC_ARM64_REG_' + name))

    def hook(self, uc, address, size, user):
        x0, x1, x2 = (self.reg(f'X{i}') for i in range(3))
        result = 0
        if address in (0x408564EC, 0x41012C84):
            if x0 != 0x06001206:
                raise ValueError(f'Unexpected setting read {x0:#x}')
            result = self.filetype
        elif address == 0x40856BE8:
            if x2 != 2:
                raise ValueError(f'Unexpected batch count {x2}')
            ids = struct.unpack('<2I', uc.mem_read(x0, 8))
            values = struct.unpack('<2I', uc.mem_read(x1, 8))
            self.writes.extend(zip(ids, values))
        elif address == 0x40856BCC:
            self.writes.append((x0, x1))
        elif address == 0x40814800:
            if x0 != 0xD1A8:
                raise ValueError(f'Unexpected notification {x0:#x}')
        elif address == 0x4127A900:
            if x2 != 12:
                raise ValueError(f'Unexpected geometry copy length {x2}')
            uc.mem_write(x0, bytes(uc.mem_read(x1, x2)))
            result = x0
        uc.reg_write(self.regs.UC_ARM64_REG_X0, result)
        uc.reg_write(self.regs.UC_ARM64_REG_PC, self.reg('LR'))

    def call(self, address, *args):
        self.uc.context_restore(self.clean_context)
        self.uc.mem_write(self.stack, bytes(0x10000))
        self.uc.reg_write(self.regs.UC_ARM64_REG_SP, self.stack + 0xF000)
        self.uc.reg_write(self.regs.UC_ARM64_REG_LR, self.stop)
        for i, arg in enumerate(args):
            self.uc.reg_write(getattr(self.regs, f'UC_ARM64_REG_X{i}'), arg)
        self.uc.emu_start(address, self.stop, count=100000)
        if self.reg('PC') != self.stop:
            raise RuntimeError(f'Instruction budget exceeded at {self.reg("PC"):#x}')
        return self.reg('X0') & 0xFFFFFFFF

    def set_mode(self, value):
        self.uc.mem_write(self.buf, struct.pack('<Q', value))
        self.uc.mem_write(0xA02992278, bytes(8))
        self.writes = []
        code = self.call(0x408401EC, self.buf)
        return {'return': f'0x{code:04x}',
                'writes': [{'id': f'0x{i:08x}', 'value': v} for i, v in self.writes]}


def analyze(data):
    p = Probe(data)
    pairs = lambda addr, n: list(struct.iter_unpack('<II', data[addr-BASE:addr-BASE+8*n]))
    size_pairs, rate_pairs = pairs(0x440F41C0, 7), pairs(0x440F41F8, 7)
    sizes, rates = dict(size_pairs), dict(rate_pairs)
    result = {'image_sha256': EXPECTED_SHA, 'runtime_base': hex(BASE),
              'scope': 'Offline function execution, settings services mocked; no sensor/encoder/USB execution',
              'hooks': [hex(a) for a in sorted(p.hooks)],
              'initialized_ram': {'address': hex(RAM), 'file_offset': hex(RAM_FILE), 'size': hex(RAM_SIZE)},
              'landmarks': {k: [hex(a), hex(b)] for k, (a, b) in RANGES.items()},
              'filetype_sdk_to_internal': pairs(0x440F4190, 6),
              'size_mapping': [{'width': v >> 16, 'height': v & 65535, 'enum': e}
                               for v, e in size_pairs],
              'rate_mapping': rate_pairs, 'filetypes': [], 'rejected_3_2': [],
              'whitelist_only_experiment': [], 'movie_dimension_probes': []}
    for ft, name in FILETYPES.items():
        p.filetype = ft
        count = p.call(0x40841C8C, p.buf)
        pointer = struct.unpack('<Q', p.uc.mem_read(p.buf, 8))[0]
        values = struct.unpack(f'<{count}Q', p.uc.mem_read(pointer, count * 8))
        size_id = p.call(0x40856964)
        rate_id = p.call(0x408568D0)
        modes = []
        for value in values:
            mode = decode_mode(value)
            checked = p.set_mode(value)
            expected = [{'id': f'0x{size_id:08x}', 'value': sizes[value >> 32]},
                        {'id': f'0x{rate_id:08x}', 'value': rates[mode['fps']]}]
            if checked['return'] != '0x2001' or checked['writes'][:2] != expected:
                raise ValueError(f'Listed mode failed {name}: {mode}, {checked}')
            modes.append(mode | checked)
        result['filetypes'].append({'name': name, 'internal': ft, 'count': count,
                                   'list_address': hex(pointer), 'size_id': hex(size_id),
                                   'rate_id': hex(rate_id), 'modes': modes})
        for width, fps in itertools.product((8256, 4128), (24, 25, 30)):
            # Use the ordinary progressive low bits from a real mode.
            height = width * 2 // 3
            value = (width << 48) | (height << 32) | (fps << 16) | (values[0] & 0xC000)
            checked = p.set_mode(value)
            if checked != {'return': '0x201c', 'writes': []}:
                raise ValueError(f'Unexpected 3:2 acceptance: {checked}')
            result['rejected_3_2'].append({'filetype': name} | decode_mode(value) | checked)
        if ft == 6:
            original = bytes(p.uc.mem_read(pointer, 8))
            value = (8256 << 48) | (5504 << 32) | (24 << 16) | (values[0] & 0xC000)
            try:
                # Only this emulator's RAM changes; input firmware remains untouched.
                p.uc.mem_write(pointer, struct.pack('<Q', value))
                checked = p.set_mode(value)
                if checked['return'] != '0x2001' or checked['writes'][0]['value'] != 0x7FFFFFFF:
                    raise ValueError(f'Unexpected unmapped size behavior: {checked}')
                result['whitelist_only_experiment'].append(decode_mode(value) | checked)
            finally:
                p.uc.mem_write(pointer, original)
    for mode in (*range(8), 0x7FFFFFFF):
        p.uc.mem_write(p.buf, bytes(0x400))
        p.uc.mem_write(p.buf + 12, struct.pack('<I', mode))
        p.uc.mem_write(p.buf + 0x200, bytes([0xA5]) * 0x100)
        wr = p.call(0x406D2BA4, p.buf, p.buf + 0x200)
        hr = p.call(0x406D2C24, p.buf, p.buf + 0x200)
        width, height = struct.unpack('<HH', p.uc.mem_read(p.buf + 0x2A4, 4))
        expected = next(((v >> 16, v & 65535) for v, e in size_pairs if e == mode), None)
        if expected and ((width, height) != expected or (wr, hr) != (1, 1)):
            raise ValueError('Movie dimension mapping mismatch')
        if not expected and ((wr, hr) != (0, 0) or (width, height) != (0xA5A5, 0xA5A5)):
            raise ValueError('Unexpected unknown-enum handling')
        result['movie_dimension_probes'].append({'enum': mode, 'width': width, 'height': height,
                                                 'width_return': wr, 'height_return': hr})
    geometry = []
    for mode, crop, rate, flag_c, flag_10 in itertools.product(range(23), (4, 5, 7), range(7), (0, 1), (0, 1)):
        p.uc.mem_write(p.buf, struct.pack('<4IB', mode, crop, rate, flag_c, flag_10))
        p.uc.mem_write(p.buf + 0x200, bytes(0x100))
        p.call(0x41065194, p.buf, p.buf + 0x200)
        words = list(struct.unpack('<54H', p.uc.mem_read(p.buf + 0x200, 0x6C)))
        geometry.append({'inputs': [mode, crop, rate, flag_c, flag_10], 'output_u16': words})
    indexed = {tuple(g['inputs']): g['output_u16'] for g in geometry}
    if indexed[(0, 4, 6, 1, 0)][:2] != [8256, 5504]:
        raise ValueError('Full-height geometry anchor mismatch')
    if indexed[(12, 4, 6, 0, 0)][6:8] != [8256, 4644]:
        raise ValueError('Video geometry anchor mismatch')
    result['validation'] = {'listed_modes': sum(f['count'] for f in result['filetypes']),
                            'rejected_3_2': len(result['rejected_3_2']),
                            'geometry_probes': len(geometry), 'checks_passed': True}
    return result, geometry


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--image', type=Path, default=ROOT / 'analysis/Z_8_0311/eg2070_0311b0.bi')
    parser.add_argument('--output', type=Path, default=ROOT / 'analysis/z8_open_gate')
    args = parser.parse_args()
    data = args.image.read_bytes()
    actual = hashlib.sha256(data).hexdigest()
    if actual != EXPECTED_SHA:
        raise SystemExit(f'Unsupported image hash: {actual}; expected {EXPECTED_SHA}')
    result, geometry = analyze(data)
    args.output.mkdir(parents=True, exist_ok=True)
    for name, content in (('manifest.json', result), ('geometry_probes.json', geometry)):
        (args.output / name).write_text(json.dumps(content, indent=2) + '\n')
    lines = []
    for name, (start, end) in RANGES.items():
        lines.append(f'\n; {name}: [{start:#x}, {end:#x})')
        result_bytes = data[start-BASE:end-BASE]
        lines.append('; sha256 ' + hashlib.sha256(result_bytes).hexdigest())
        for ins in disassembler().disasm(result_bytes, start):
            lines.append(f'{ins.address:08x} {ins.bytes.hex():8s} {ins.mnemonic:8s} {ins.op_str}')
    (args.output / 'code_landmarks.asm').write_text('\n'.join(lines) + '\n')
    print(json.dumps(result['validation']))


if __name__ == '__main__':
    main()
