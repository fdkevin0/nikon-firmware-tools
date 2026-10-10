#!/usr/bin/env python3
"""Recover Z8 host-side DSP asset loading and network selection across eight releases.

Capstone validates reconstructed MOVZ/MOVK references. Optional Unicorn executes
only bounded AArch64 selectors: copy/ELF-load calls are recorded and skipped;
no DSP, operating system, MMIO, or camera is executed. Names are analytical.
"""
import argparse
import csv
from collections import defaultdict
import hashlib
import json
from pathlib import Path
import re
import struct
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN, CS_GRP_JUMP, CS_GRP_CALL, CS_GRP_RET

BASE = 0x40160000
ARENA = 0xA01800000
RET = bytes.fromhex('c0035fd6')
LOOKUP_END = bytes.fromhex('290000f9480000b9c0035fd6')


def sha(data):
    return hashlib.sha256(data).hexdigest()


def disassembler():
    cs = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN)
    cs.detail = True
    return cs


def wide_constants(data, start=0, end=None, targets=None):
    """Find complete 64-bit immediate chains, rejecting intervening clobbers/branches."""
    if end is None:
        end = len(data) & ~3
    state, found = {}, []
    cs = disassembler()
    for offset in range(start, end, 4):
        word = struct.unpack_from('<I', data, offset)[0]
        kind = word & 0xFF800000
        if kind not in (0xD2800000, 0xF2800000):
            continue
        reg, shift, imm = word & 31, ((word >> 21) & 3) * 16, (word >> 5) & 0xFFFF
        if kind == 0xD2800000:
            state[reg] = (imm << shift, [offset], {shift})
            continue
        if reg not in state:
            continue
        value, chain, shifts = state[reg]
        if offset - chain[-1] > 80 or offset - chain[0] > 256:
            state.pop(reg)
            continue
        value = (value & ~(0xFFFF << shift)) | (imm << shift)
        chain, shifts = chain + [offset], shifts | {shift}
        state[reg] = value, chain, shifts
        if shifts != {0, 16, 32, 48} or shift != 48 or (targets is not None and value not in targets):
            continue
        valid = True
        decoded = list(cs.disasm(data[chain[0]:offset + 4], BASE + chain[0]))
        if sum(i.size for i in decoded) != offset + 4 - chain[0]:
            continue
        for ins in decoded:
            if ins.address - BASE in chain:
                continue
            if any(g in ins.groups for g in (CS_GRP_JUMP, CS_GRP_CALL, CS_GRP_RET)):
                valid = False
                break
            _, written = ins.regs_access()
            if any(ins.reg_name(r) in (f'x{reg}', f'w{reg}') for r in written):
                valid = False
                break
        if valid:
            found.append({'value': value, 'register': reg, 'instruction_offsets': chain})
    return found


def prior_return(data, offset, bound=1024):
    for pos in range(offset - 4, max(-1, offset - bound), -4):
        if data[pos:pos + 4] == RET:
            return pos + 4
    raise ValueError('No bounded preceding return')


def next_return(data, offset, bound=1024):
    for pos in range(offset, min(len(data) - 3, offset + bound), 4):
        if data[pos:pos + 4] == RET:
            return pos + 4
    raise ValueError('No bounded terminating return')


def direct_branches(data, code_end):
    for pos in range(0, code_end, 4):
        word = struct.unpack_from('<I', data, pos)[0]
        if word & 0x7C000000 != 0x14000000:
            continue
        imm = word & 0x3FFFFFF
        if imm & 0x2000000:
            imm -= 0x4000000
        yield {'offset': pos, 'target': BASE + pos + 4 * imm,
               'kind': 'bl' if word & 0x80000000 else 'b'}


def locate_lookup(data, code_end):
    candidates = []
    for match in re.finditer(re.escape(LOOKUP_END), data[:code_end]):
        pos = match.start()
        if pos % 4:
            continue
        start = prior_return(data, pos)
        # CMP W0, immediate; the first arm is an unused legacy zero-size resource.
        word = struct.unpack_from('<I', data, start)[0]
        if word & 0xFFC003FF == 0x7100001F:
            candidates.append((start, pos + len(LOOKUP_END)))
    if len(candidates) != 1:
        raise ValueError(f'Ambiguous network lookup: {candidates}')
    return candidates[0]


def emulate(data, bounds, globals_, jump_table, hooks, x0, x1=0, flags=None, lookup=False):
    """Independent instruction execution with synthetic RAM and intercepted helpers."""
    from unicorn import Uc, UC_ARCH_ARM64, UC_MODE_ARM, UC_HOOK_CODE
    from unicorn.arm64_const import UC_ARM64_REG_X0, UC_ARM64_REG_X1, UC_ARM64_REG_X2, UC_ARM64_REG_LR, UC_ARM64_REG_PC, UC_ARM64_REG_SP
    uc = Uc(UC_ARCH_ARM64, UC_MODE_ARM)
    mapped = set()
    def put(address, content):
        for page in range(address & ~4095, (address + len(content) + 4095) & ~4095, 4096):
            if page not in mapped:
                uc.mem_map(page, 4096)
                mapped.add(page)
        uc.mem_write(address, content)
    start, end = bounds
    put(BASE + start, data[start:end])
    base_global, flags_global = globals_
    put(base_global, struct.pack('<Q', ARENA))
    put(flags_global, bytes(flags or [0] * 6) + b'\0')
    if jump_table is not None:
        put(jump_table, data[jump_table - BASE:jump_table - BASE + 48])
    stop, output, stack = 0x30000000, 0x20000000, 0x10000000
    put(stop, RET)
    put(output, bytes(16))
    put(stack, bytes(4096))
    uc.reg_write(UC_ARM64_REG_SP, stack + 0xF00)
    uc.reg_write(UC_ARM64_REG_LR, stop)
    uc.reg_write(UC_ARM64_REG_X0, x0)
    uc.reg_write(UC_ARM64_REG_X1, output if lookup else x1)
    uc.reg_write(UC_ARM64_REG_X2, output + 8 if lookup else 0)
    calls, steps = [], 0
    for address in hooks:
        put(address, RET)
    def on_code(machine, address, size, user):
        nonlocal steps
        steps += 1
        if address in hooks:
            calls.append({'target': address, 'arguments': [machine.reg_read(r) for r in
                         (UC_ARM64_REG_X0, UC_ARM64_REG_X1, UC_ARM64_REG_X2)]})
            machine.reg_write(UC_ARM64_REG_X0, 0)
            machine.reg_write(UC_ARM64_REG_PC, machine.reg_read(UC_ARM64_REG_LR))
    uc.hook_add(UC_HOOK_CODE, on_code)
    uc.emu_start(BASE + start, stop, count=512)
    if uc.reg_read(UC_ARM64_REG_PC) != stop:
        raise ValueError('Selector exceeded bounded execution')
    return {'input_id': x0, 'skip_load_argument': None if lookup else x1, 'steps': steps, 'calls': calls,
            'pointer': struct.unpack('<Q', uc.mem_read(output, 8))[0] if lookup else None,
            'length': struct.unpack('<I', uc.mem_read(output + 8, 4))[0] if lookup else None,
            'loaded_flags': list(uc.mem_read(flags_global, 6)), 'error_flag': uc.mem_read(flags_global + 6, 1)[0]}


def run(root, execute):
    history = json.loads((root / 'analysis/z8_history/manifest.json').read_text())
    out = root / 'analysis/z8_dsp_host'
    out.mkdir(parents=True, exist_ok=True)
    result = {'scope': 'Host-side resource loading, model lookup and initialization; no full DSP execution',
              'tool_sha256': sha(Path(__file__).read_bytes()), 'emulator_used': execute, 'versions': []}
    if execute:
        import unicorn
        result['unicorn_version'] = unicorn.__version__
    for source in history['versions']:
        eg = next(s for s in source['sections'] if s['component'] == 'eg')
        folder = root / 'analysis' / Path(source['filename']).stem
        data = (folder / eg['name']).read_bytes()
        if sha(data) != eg['sha256'] or sha((root / source['filename']).read_bytes()) != source['sha256']:
            raise ValueError('Source identity changed')
        if struct.unpack_from('<Q', data, 0x670)[0] != BASE + 0x250:
            raise ValueError('Boot mapping mismatch')
        code_end = struct.unpack_from('<Q', data, 0x80B0)[0]
        if not 0x10000 < code_end < len(data):
            raise ValueError('Invalid descriptor code bound')
        targets = {BASE + m['offset']: 'DSP_' + str(i) for i, m in enumerate(source['dsp_modules'])}
        targets.update({BASE + n['offset']: 'N' + str(i + 1) for i, n in enumerate(source['network_candidates'])})
        refs = wide_constants(data, 0, code_end, targets)
        for r in refs:
            r['resource'] = targets[r['value']]
        if set(r['resource'] for r in refs) != set(targets.values()):
            raise ValueError('Missing verified asset reference')
        loader_start = prior_return(data, min(r['instruction_offsets'][0] for r in refs))
        loader_end = next_return(data, max(r['instruction_offsets'][-1] for r in refs) + 4)
        constants = wide_constants(data, loader_start, loader_end)
        tables = []
        for c in constants:
            off = c['value'] - BASE
            if 0 <= off <= len(data) - 48:
                values = struct.unpack_from('<6Q', data, off)
                if all(BASE + loader_start <= value < BASE + loader_end and value % 4 == 0 for value in values):
                    tables.append((c['value'], list(values)))
        tables = list({t[0]: t for t in tables}.values())
        if len(tables) != 1:
            raise ValueError('Six-arm asset jump table not uniquely identified')
        table, arms = tables[0]
        lookup_start, lookup_end = locate_lookup(data, code_end)
        lookup_constants = wide_constants(data, lookup_start, lookup_end)
        globals_ = sorted({c['value'] for c in lookup_constants if 0xA02800000 < c['value'] < 0xB00000000})
        if len(globals_) != 2 or globals_[1] != globals_[0] + 8:
            raise ValueError('Unexpected base-pointer/load-state globals')
        branches = list(direct_branches(data, code_end))
        hooks = sorted({b['target'] for b in branches if loader_start <= b['offset'] < loader_end and b['kind'] == 'bl'})
        if len(hooks) != 2:
            raise ValueError('Expected separate ELF-load and blob-copy helpers')
        callers = [b for b in branches if b['target'] == BASE + lookup_start]
        init_ranges = sorted({(prior_return(data, b['offset']), next_return(data, b['offset'])) for b in callers})
        if len(callers) != 2 or len(init_ranges) != 1:
            raise ValueError('Expected one initializer querying two network slots')
        neural = next(m for m in source['dsp_modules'] if m['role_by_symbols'] == 'neural_inference')
        dsp = history['unique_dsp_modules'][neural['sha256']]
        slots = {name: entry['slot'] for entry in dsp['dispatch_table']['entries'] for name in entry['function_names']
                 if name in ('CCdnnNetwork_Initialize','CCdnnNetwork_Release','CAnimalDetectionApi','CVehicleDetectionApi')}
        row = {'version': source['version'], 'input_filename': source['filename'], 'input_sha256': source['sha256'],
               'eg_name': eg['name'], 'eg_sha256': eg['sha256'], 'boot_base': BASE, 'code_scan_end': code_end,
               'loader': {'start': BASE + loader_start, 'end_exclusive': BASE + loader_end, 'sha256': sha(data[loader_start:loader_end]),
                          'jump_table': table, 'case_targets': arms, 'intercepted_helpers': hooks},
               'lookup': {'start': BASE + lookup_start, 'end_exclusive': BASE + lookup_end, 'sha256': sha(data[lookup_start:lookup_end]),
                          'global_arena_pointer': globals_[0], 'global_loaded_flags': globals_[1], 'callers': callers},
               'initializer': {'start': BASE + init_ranges[0][0], 'end_exclusive': BASE + init_ranges[0][1]},
               'dsp_api_slots': slots, 'asset_references': refs, 'network_associations': []}
        row['loader']['callers'] = [b for b in branches if b['target'] == BASE + loader_start]
        if not row['loader']['callers']:
            raise ValueError('Resource loader entry lacks direct call evidence')
        if execute:
            row['loader_execution'] = []
            for asset in range(6):
                loaded = emulate(data, (loader_start, loader_end), globals_, table, hooks, asset)
                skipped = emulate(data, (loader_start, loader_end), globals_, table, hooks, asset, 1)
                if len(loaded['calls']) != 1 or skipped['calls'] or loaded['loaded_flags'][asset] != 1 or skipped['loaded_flags'][asset] != 1:
                    raise ValueError('Loader execution diverged from expected single operation')
                row['loader_execution'].extend([loaded, skipped])
            unknown = emulate(data, (loader_start, loader_end), globals_, table, hooks, 6)
            if unknown['calls'] or any(unknown['loaded_flags']):
                raise ValueError('Out-of-range asset was not rejected')
            row['loader_execution'].append(unknown)
            for name in ('CAnimalDetectionApi','CVehicleDetectionApi'):
                slot = slots[name]
                loaded = emulate(data, (lookup_start, lookup_end), globals_, None, [], slot, flags=[1]*6, lookup=True)
                unloaded = emulate(data, (lookup_start, lookup_end), globals_, None, [], slot, lookup=True)
                if unloaded['pointer'] or unloaded['length']:
                    raise ValueError('Unloaded network should not be returned')
                matches = [r for r in row['loader_execution'] if r['skip_load_argument'] == 0 and r['calls']
                           and r['calls'][0]['arguments'][0] == loaded['pointer'] and r['calls'][0]['arguments'][2] == loaded['length']]
                if len(matches) != 1:
                    raise ValueError('Lookup did not uniquely match a loaded blob')
                copied_from = matches[0]['calls'][0]['arguments'][1]
                candidates = [n for n in source['network_candidates'] if BASE + n['offset'] == copied_from
                              and n['declared_size_hypothesis'] == loaded['length']]
                if len(candidates) != 1:
                    raise ValueError('Actual copy length did not match the network candidate boundary')
                n = candidates[0]
                row['network_associations'].append({'api_symbol': name, 'slot': slot, 'asset_id': matches[0]['input_id'],
                    'source_address': copied_from, 'source_eg_offset': n['offset'], 'copy_size': loaded['length'],
                    'runtime_pointer_with_observed_arena': loaded['pointer'], 'network_sha256': n['sha256_available'],
                    'loaded_query': loaded, 'unloaded_query': unloaded,
                    'interpretation': 'Host API/resource association; does not enumerate all model classes or prove live scheduling'})
            invalid = emulate(data, (lookup_start, lookup_end), globals_, None, [], 0xFFFF, flags=[1]*6, lookup=True)
            if invalid['pointer'] or invalid['length']:
                raise ValueError('Unknown network query should return zero')
            row['invalid_query'] = invalid
        ranges = [('host_load_resource', loader_start, loader_end), ('host_get_network', lookup_start, lookup_end),
                  ('host_initialize_cdnn', *init_ranges[0])]
        if source['version'] == '3.11':
            # Manually followed callees/callbacks in this SHA-pinned version.
            ranges += [('initialize_resource_arena_pointer', 0xB31F08, 0xB31F30),
                       ('load_elf_program_headers', 0xB32194, 0xB32334),
                       ('queue_dsp_request', 0xB309A8, 0xB30AEC),
                       ('animal_submission_dsp_branch_excerpt', 0xE873C8, 0xE87510),
                       ('vehicle_submission_dsp_branch_excerpt', 0xE87B84, 0xE87CC4),
                       ('cdnn_completion_callback', 0xE886F8, 0xE8879C),
                       ('address_alias_conversion', 0x1026780, 0x10267B4)]
            row['additional_manually_traced_ranges'] = [{'name': name, 'start': BASE + a, 'end_exclusive': BASE + b,
                'sha256': sha(data[a:b])} for name, a, b in ranges[3:]]
        lines = ['Analytical names; virtual addresses = EG offset + 0x40160000.',
                 'Synthetic execution does not emulate the OS, DMA or DSP.']
        cs = disassembler()
        for label, start, end in ranges:
            lines.append(f'\n{label}: [{BASE+start:#x}, {BASE+end:#x})')
            for i in cs.disasm(data[start:end], BASE + start):
                lines.append(f'{i.address:08x}  {i.bytes.hex():8}  {i.mnemonic:9} {i.op_str}')
        (out / (source['version'] + '.asm')).write_text('\n'.join(lines) + '\n')
        if source['version'] == '3.11':
            (out / 'code_landmarks.asm').write_text('\n'.join(lines) + '\n')
        result['versions'].append(row)
        print(source['version'],hex(row['loader']['start']),hex(row['lookup']['start']),slots,flush=True)
    # Preserve raw named constants without guessing fixed-point scale or class labels.
    profile = history['unique_dsp_modules'][neural['sha256']]
    module = root / 'analysis/z8_history/modules' / (neural['sha256'] + '.elf')
    blob = module.read_bytes()
    if sha(blob) != neural['sha256']:
        raise ValueError('DSP reference artifact changed')
    result['dsp_named_constants'] = []
    with module.with_suffix('.symbols.csv').open() as stream:
        for symbol in csv.DictReader(stream):
            if not any(term in symbol['name'] for term in ('ClassEffectiveTh_Table', 'OutmapSet_Table')):
                continue
            address, size = int(symbol['value'], 16), int(symbol['size'])
            sec = next(s for s in profile['sections'] if s['type'] != 8 and
                       s['vaddr'] <= address < address + size <= s['vaddr'] + s['size'])
            off = sec['offset'] + address - sec['vaddr']
            raw = blob[off:off + size]
            result['dsp_named_constants'].append({'symbol': symbol['name'], 'dsp_address': address,
                'elf_file_offset': off, 'size': size, 'hex': raw.hex(),
                'u16_le_view': list(struct.unpack('<' + 'H' * (size // 2), raw)),
                'unresolved': 'Element types, fixed-point scale, class-index meaning and runtime overrides'})
    (out / 'manifest.json').write_text(json.dumps(result, indent=2) + '\n')
    print('Validated',len(result['versions']),'Z8 releases',flush=True)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('directory', type=Path)
    parser.add_argument('--emulate-selectors', action='store_true')
    args = parser.parse_args()
    run(args.directory, args.emulate_selectors)
