#!/usr/bin/env python3
"""Recover Z8 EG update boundaries without programming or reading flash.

The RAM-resident writer's address loops execute offline. Hardware operations,
blank checks and readback comparisons are bypassed explicitly. This is a trace
of its success-path address plan, not validation of a firmware update.
"""
import argparse
import hashlib
import json
from pathlib import Path
import struct

from reverse_z8_sensor_inputs import InputProbe, ROOT, EXPECTED_SHA, offset, disassembler

INFO = 0xA03E18DA8
BLOCK = 0x20000
FLASH_BASE = 0x40000000
SOURCE = 0x60000000  # Synthetic, unmapped source buffer.
SKIPS = {
    0xA02AB4074: 0xA02AB409C,  # Treat every remaining block as nonblank.
    0xA02AB40AC: 0xA02AB40CC,  # Assume erase readback succeeds.
    0xA02AB4158: 0xA02AB4178,  # Assume ordinary block comparison succeeds.
    0xA02AB4000: 0xA02AB41C4,  # Assume final first-block comparison succeeds.
}
STUBS = {0xA02AB3730, 0xA02AB3120, 0xA02AB30BC,
         0xA02AB4304, 0xA02AB4388, 0xA02AB43CC}
RANGES = {
    'eg_update_target_initialization': (0x41023014, 0x41023034),
    'eg_device_update': (0x41026598, 0x4102667C),
    'resource_info': (0x40D6B460, 0x40D6B4E0),
    'resource_info_fields': (0x40D6C53C, 0x40D6C628),
    'update_writer_setup_in_ram': (0xA02AB3DD4, 0xA02AB3ED4),
    'update_writer_in_ram': (0xA02AB3EEC, 0xA02AB4214),
    'program_words_frontend': (0xA02AB30BC, 0xA02AB3120),
    'program_word_loop_excerpt': (0xA02AB2EC4, 0xA02AB2F8C),
    'address_to_128k_block': (0x40D6BF88, 0x40D6BF98),
    'ai_device_update': (0x41028CB8, 0x41028DD0),
    'ai_block_address': (0x41273110, 0x41273118),
}


def analyze(data):
    from unicorn import UC_HOOK_CODE
    p = InputProbe(data)
    p.uc.mem_map(0xA03E18000, 0x5000)
    groups = []
    for i in range(39):
        fields = struct.unpack_from('<Q8I', data, offset(0xA0291DAB8 + i * 40))
        groups.append({'index': i, 'base': hex(fields[0]),
                       'raw_remaining_u32': list(fields[1:]),
                       'allocation_length': fields[3], 'content_length': fields[4]})
    infos = {}
    for resource in (2, 0x5B, 0x5C):
        assert p.call(0x40D6B460, resource, p.buf) == 1
        ram, mapped, relative, content, allocation = struct.unpack('<QQIII', p.uc.mem_read(p.buf, 28))
        infos[hex(resource)] = {'ram_pointer': hex(ram), 'mapped_base': hex(mapped),
                                'relative_offset': relative, 'content_length': content,
                                'allocation_length': allocation}
    main, params = infos['0x2'], infos['0x5c']
    assert (main['mapped_base'], main['allocation_length']) == ('0x40160000', 0x5820000)
    assert (params['mapped_base'], params['content_length'], params['allocation_length']) == (
        '0x47e80000', 0xF2000, 0x100000)
    # Run the actual update-target initialization excerpt, stopping before the
    # rest of the service's initialization calls.
    p.run_slice(0x41023014, 0x41023034)
    assert struct.unpack('<Q', p.uc.mem_read(INFO + 8, 8))[0] == int(main['mapped_base'], 16)
    p.uc.mem_write(p.buf, struct.pack('<I4xQQ', 2, 0, 0))
    p.call(0xA02AB3DD4, SOURCE, len(data) - 2, p.buf)
    operations = []
    skipped = {hex(a): 0 for a in SKIPS}

    def intercept(uc, address, size, user):
        if address in SKIPS:
            skipped[hex(address)] += 1
            uc.reg_write(p.regs.UC_ARM64_REG_PC, SKIPS[address])
            return
        if address == 0xA02AB3120:
            operations.append({'kind': 'erase', 'block': p.reg('X0'), 'count': p.reg('X1')})
        elif address == 0xA02AB30BC:
            operations.append({'kind': 'program', 'address': p.reg('X0'),
                               'word_count': p.reg('X1'), 'source': p.reg('X2')})
        uc.reg_write(p.regs.UC_ARM64_REG_X0, 0)
        uc.reg_write(p.regs.UC_ARM64_REG_PC, p.reg('LR'))

    for address in STUBS | SKIPS.keys():
        p.uc.hook_add(UC_HOOK_CODE, intercept, begin=address, end=address)
    result = p.call(0xA02AB3EEC)
    erases = [o for o in operations if o['kind'] == 'erase']
    programs = [o for o in operations if o['kind'] == 'program']
    start = int(main['mapped_base'], 16)
    end = start + main['allocation_length']
    addresses = list(range(start, end, BLOCK))
    assert len(addresses) == 705 and result == 0
    assert [o['block'] for o in erases] == [(a - FLASH_BASE) // BLOCK for a in addresses]
    assert all(o['count'] == 1 for o in erases)
    assert [o['address'] for o in programs] == addresses[1:] + addresses[:1]
    assert all(o['word_count'] * 4 == BLOCK and o['source'] == SOURCE + o['address'] - start
               for o in programs)
    assert skipped == {hex(a): (704 if a != 0xA02AB4000 else 1) for a in SKIPS}
    parameter_start = int(params['mapped_base'], 16)
    assert end <= parameter_start
    ai_address = p.call(0x40D6B1D0)
    assert ai_address == 0x46480000
    return {'image_sha256': EXPECTED_SHA,
            'scope': 'Offline success-path address plan; hardware calls and all flash readback checks bypassed; synthetic source is unmapped; no camera access',
            'groups': groups, 'resource_info': infos,
            'eg_update': {'range_start': hex(start), 'range_end_exclusive': hex(end),
                          'erase_calls': len(erases), 'program_calls': len(programs),
                          'block_bytes': BLOCK, 'first_block_programmed_last': True,
                          'synthetic_source': hex(SOURCE), 'return_with_stubs': result,
                          'stubbed_functions': [hex(a) for a in sorted(STUBS)],
                          'skipped_readback_excerpts': skipped,
                          'overlap_with_sensor_parameter_allocation': False,
                          'gap_to_sensor_parameter_allocation': parameter_start - end},
            'ai_named_device': {'block_address': hex(ai_address), 'block_bytes': BLOCK,
                                'scope': 'Getter executed; updater statically inspected only'},
            'actual_flash_operations': 0, 'actual_parameter_bytes_recovered': 0}, operations


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--image', type=Path, default=ROOT / 'analysis/Z_8_0311/eg2070_0311b0.bi')
    parser.add_argument('--output', type=Path, default=ROOT / 'analysis/z8_flash_layout')
    args = parser.parse_args()
    data = args.image.read_bytes()
    if hashlib.sha256(data).hexdigest() != EXPECTED_SHA:
        raise ValueError('Expected the pinned Z8 3.11 EG image')
    result, operations = analyze(data)
    lines = []
    for name, (a, b) in RANGES.items():
        code = data[offset(a):offset(b)]
        lines.append(f'\n; {name} [{a:#x}, {b:#x}); SHA-256 {hashlib.sha256(code).hexdigest()}')
        lines.extend(f'{i.address:09x} {i.bytes.hex():8s} {i.mnemonic:8s} {i.op_str}'
                     for i in disassembler().disasm(code, a))
    args.output.mkdir(parents=True, exist_ok=True)
    for name, obj in [('manifest.json', result), ('probes.json', operations)]:
        (args.output / name).write_text(json.dumps(obj, indent=2) + '\n')
    (args.output / 'code_landmarks.asm').write_text('\n'.join(lines) + '\n')
    print(json.dumps({'erase_calls_intercepted': result['eg_update']['erase_calls'],
                      'program_calls_intercepted': result['eg_update']['program_calls'],
                      'parameter_allocation_overlap': False, 'actual_flash_operations': 0}))


if __name__ == '__main__':
    main()
