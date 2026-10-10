#!/usr/bin/env python3
"""Build the pinned, offline Z8 diagnostic menu experiment; never flash a camera."""
import argparse
import json
from pathlib import Path
import re
import struct
import subprocess
import tempfile

import build_z8_diagnostic as core
from reverse_z8_video_modes import RAM, RAM_FILE, RAM_SIZE

ROOT = core.ROOT
SOURCE = Path(__file__).with_name('patches') / 'z8_0311_diagnostic_ui.S'
CAPACITY = 0x1800
NODE_FILE = 0x4DBF500
NODE = RAM + NODE_FILE - RAM_FILE
SETUP_SCHEMA_FILE = 0x4BD5040
SETUP_NODE = RAM + 0x4C0F560 - RAM_FILE
MENU_ID, TITLE_ID, ROW_ID = 0x600, 0x7FF0, 0x4FFE
OUTPUT_NAME = 'Z_8_0311_diagnostic_UI_3.11_P_EXPERIMENTAL.bin'
HOOKS = {
    0x405AB454: ('ui_version', '560af917'),
    0x403DB694: ('ui_node', '1f180071'),
    0x4032E130: ('ui_text', '098995d2'),
    0x4032E19C: ('ui_text_class', '88ab99d2'),
    0x4032E2A0: ('ui_text_size', '88ab99d2'),
    0x4032E258: ('ui_text_flags', '88ab99d2'),
    0x4032E364: ('ui_text_spacing', '88ab99d2'),
    0x4032E618: ('ui_text_style', '88ab99d2'),
    0x4032E554: ('ui_text_weight', '88ab99d2'),
    0x4032E4B0: ('ui_text_options', '88ab99d2'),
    0x4032E458: ('ui_text_alignment', '88ab99d2'),
    0x4032DB6C: ('ui_text_normalize', '89ab99d2'),
}
SERVICES = {
    'stock_response': core.RESPONSE, 'stock_preflight_resume': core.RESUME,
    'stock_version': 0x403EDDAC, 'stock_node_resume': 0x403DB698,
    'stock_text_resume': 0x4032E134, 'stock_current_node': 0x403DBDB4,
    'stock_text_class_resume': 0x4032E1A0, 'stock_text_size_resume': 0x4032E2A4,
    'stock_text_flags_resume': 0x4032E25C, 'stock_text_spacing_resume': 0x4032E368,
    'stock_text_style_resume': 0x4032E61C, 'stock_page_mode': 0x403B2FC0,
    'stock_text_weight_resume': 0x4032E558, 'stock_text_options_resume': 0x4032E4B4,
    'stock_text_alignment_resume': 0x4032E45C, 'stock_text_normalize_resume': 0x4032DB70,
    'stock_find_object': 0x4039E810, 'stock_visibility': 0x403F621C,
    'stock_display_label': 0x405A79F8, 'stock_display_value': 0x405A7A88,
    'stock_navigate': 0x403AD6A4,
}


def byte_directive(data):
    return '.byte ' + ','.join(str(b) for b in data)


def ui_data(eg):
    """Clone the two existing schemas, retaining the original 44 setup rows."""
    schema = eg[SETUP_SCHEMA_FILE:SETUP_SCHEMA_FILE + 80]
    if struct.unpack_from('<H', schema, 0x20)[0] != 44:
        raise ValueError('Setup menu row count changed')
    rows_address, events_address = struct.unpack_from('<2Q', schema, 0x10)
    if (rows_address, events_address) != (0x43D596D8, 0x43D59E68):
        raise ValueError('Setup menu resources changed')
    rows = eg[rows_address - core.BASE:rows_address - core.BASE + 44 * 44]
    if any(struct.unpack_from('<I', rows, i * 44 + 24)[0] == ROW_ID for i in range(44)):
        raise ValueError('New setup object ID collides')
    row = bytearray(rows[42 * 44:43 * 44])
    if struct.unpack_from('<I', row)[0] != 0x379:
        raise ValueError('Firmware version row changed')
    struct.pack_into('<I', row, 0, TITLE_ID)
    struct.pack_into('<I', row, 24, ROW_ID)
    events = eg[events_address - core.BASE:events_address - core.BASE + 44 * 8]
    if struct.unpack_from('<Q', events, 42 * 8)[0] != 0x43D87CA0:
        raise ValueError('Firmware version event table changed')
    lines = ['.balign 8', '.global ui_setup_rows, ui_setup_events, ui_schema, ui_callbacks',
             'ui_setup_rows:', byte_directive(rows + row), '.balign 8',
             'ui_setup_events:', byte_directive(events), '.quad ui_open_events',
             'ui_open_events:']
    opening = list(struct.iter_unpack('<4Q', eg[0x3C27CA0:0x3C27CA0 + 14 * 32]))
    if [(e[0], e[3]) for e in opening if e[1] == 0x405A2CF8] != [
            (0x286, 0x2E0), (0x28B, 0x2E0), (0x29F, 0x2E0), (0x2AE, 0x2E0)]:
        raise ValueError('Firmware version selection actions changed')
    for event, function, condition, target in opening:
        if target == 0x2E0:
            function, target = 0x403B1BA8, MENU_ID
        lines.append(f'.quad {event}, {function}, {condition}, {target}')
    lines += ['.quad 0x3bb, 0, 0, 0x68c', 'ui_done_events:']
    done = list(struct.iter_unpack('<4Q', eg[0x3C47400:0x3C47400 + 13 * 32]))
    if [e[0] for e in done] != [0x27E, 0x27F, 0x283, 0x284, 0x285, 0x286,
                                      0x28B, 0x29D, 0x29E, 0x2A0, 0x2AE, 0x281, 0x306]:
        raise ValueError('Firmware Done actions changed')
    for event, function, condition, target in done:
        if event in (0x27F, 0x286, 0x28B, 0x2AE):
            function, condition, target = 'ui_close', 0, 0x68C
        lines.append(f'.quad {event}, {function}, {condition}, {target}')
    fw_schema = eg[0x4BD6710:0x4BD6710 + 80]
    if struct.unpack_from('<H', fw_schema, 0x20)[0] != 4:
        raise ValueError('Firmware version page schema changed')
    new_schema = bytearray(fw_schema)
    struct.pack_into('<H', new_schema, 0x20, 1)
    lines += ['.quad 0x3bb, 0, 0, 0x68c', '.balign 8', 'ui_done_row:',
              byte_directive(eg[0x3C09ED4:0x3C09ED4 + 44]), '.balign 8',
              'ui_done_event_pointer: .quad ui_done_events', 'ui_schema:',
              byte_directive(new_schema[:16]), '.quad ui_done_row, ui_done_event_pointer',
              byte_directive(new_schema[32:]), 'ui_callbacks:',
              '.quad ui_draw, 0x405a2d7c, 0x403b2210, 0x405ab414, 0x405a2dc0',
              '.balign 4']
    return '\n'.join(lines) + '\n'


def compile_ui(eg, directory):
    (directory / 'ui_data.S').write_text(ui_data(eg))
    obj, elf, binary = (directory / f'diagnostic_ui.{ext}' for ext in ('o', 'elf', 'bin'))
    commands = [
        ['clang', '--target=aarch64-none-elf', '-I', str(SOURCE.parent), '-I', str(directory),
         '-c', str(SOURCE), '-o', str(obj)],
        ['ld.lld', f'-Ttext={core.PAYLOAD:#x}', '--entry=diagnostic_preflight',
         *[f'--defsym={k}={v:#x}' for k, v in SERVICES.items()], str(obj), '-o', str(elf)],
        ['llvm-objcopy', '--only-section=.text', '-O', 'binary', str(elf), str(binary)],
    ]
    for command in commands:
        subprocess.run(command, check=True, capture_output=True, text=True)
    symbols = {}
    for line in subprocess.run(['llvm-nm', '--defined-only', str(elf)], check=True,
                               capture_output=True, text=True).stdout.splitlines():
        address, kind, name = line.split()
        symbols[name] = int(address, 16)
    payload = binary.read_bytes()
    if not payload or len(payload) % 4 or len(payload) > CAPACITY:
        raise ValueError('UI payload exceeds the reserved code padding')
    if symbols['ui_code_end'] > (core.PAYLOAD & ~4095) + 4096:
        raise ValueError('UI code must share the final stock executable page')
    return payload, symbols


def ram_evidence(eg):
    if struct.unpack_from('<2Q', eg, 0x80D0) != (RAM_SIZE, RAM):
        raise ValueError('Initialized RAM mapping changed')
    if eg[0x4DBF414:0x4DBF418] != bytes.fromhex('c0035fd6') or any(eg[0x4DBF420:RAM_FILE + RAM_SIZE]):
        raise ValueError('Initialized RAM tail padding changed')
    if not RAM_FILE <= NODE_FILE < NODE_FILE + 96 <= RAM_FILE + RAM_SIZE:
        raise ValueError('Mutable menu node is outside initialized RAM')
    references = [r for r in core.wide_constants(eg, 0, 0x14E7000)
                  if NODE <= r['value'] < NODE + 96]
    literals = [m.start() for m in re.finditer(rb'..\xab\x02\x0a\x00\x00\x00', eg, re.S)
                if NODE <= struct.unpack_from('<Q', eg, m.start())[0] < NODE + 96]
    if references or literals:
        raise ValueError('Existing reference to mutable menu node padding')
    return {'runtime_address': hex(NODE), 'file_offset': hex(NODE_FILE), 'bytes': 96,
            'initialized_ram_size': hex(RAM_SIZE), 'zero_padding': ['0x4dbf420', '0x4dc0000'],
            'complete_mov_references': references, 'absolute_references': literals,
            'limit': 'Computed references, boot-time clearing and hardware lifetime not verified.'}


def ui_edits(eg, symbols):
    stock_slot = 0x4BFFCC0 + MENU_ID * 96
    if struct.unpack_from('<I', eg, stock_slot)[0] == (MENU_ID << 16 | 2):
        raise ValueError('Diagnostic menu ID collides with an existing group-2 node')
    edits = [(address, bytes.fromhex(expected), core.branch(address, symbols[name]))
             for address, (name, expected) in HOOKS.items()]
    schema = eg[SETUP_SCHEMA_FILE:SETUP_SCHEMA_FILE + 80]
    replacement = bytearray(schema)
    struct.pack_into('<2Q', replacement, 0x10, symbols['ui_setup_rows'], symbols['ui_setup_events'])
    struct.pack_into('<H', replacement, 0x20, 45)
    edits.append((core.BASE + SETUP_SCHEMA_FILE, schema, bytes(replacement)))
    node = bytearray(eg[0x4C110C0:0x4C110C0 + 96])
    if struct.unpack_from('<I', node)[0] != 0x2E00002:
        raise ValueError('Firmware version menu node changed')
    struct.pack_into('<I', node, 0, MENU_ID << 16 | 2)
    struct.pack_into('<Q', node, 0x28, symbols['ui_callbacks'])
    struct.pack_into('<Q', node, 0x50, symbols['ui_schema'])
    edits.append((core.BASE + NODE_FILE, bytes(96), bytes(node)))
    return edits


def build(firmware, output):
    from verify_z8_diagnostic import verify
    from verify_z8_diagnostic_ui import verify_ui
    if output.exists():
        raise ValueError(f'Output directory already exists: {output}')
    encoded = firmware.read_bytes()
    _, _, stock = core.read_stock(encoded)
    evidence = core.placement_evidence(stock, CAPACITY)
    ram = ram_evidence(stock)
    output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='.z8-ui-', dir=output.parent) as temp:
        work = Path(temp)
        payload, symbols = compile_ui(stock, work)
        product, original, patched, manifest = core.make_image(
            encoded, payload, ui_edits(stock, symbols), CAPACITY)
        ptp = verify(original, patched, core.PAYLOAD, len(payload), core.HOOK)
        ui = verify_ui(original, patched, symbols)
        manifest.update({'output_file': OUTPUT_NAME, 'placement': evidence, 'mutable_node': ram,
                         'payload_bytes': len(payload), 'payload_sha256': core.sha(payload),
                         'assembly_sha256': core.sha(SOURCE.read_bytes()),
                         'included_ptp_assembly_sha256': core.sha(core.SOURCE.read_bytes()),
                         'generated_data_sha256': core.sha((work / 'ui_data.S').read_bytes()),
                         'build_tools': {name: subprocess.run([name, '--version'], check=True,
                                        capture_output=True, text=True).stdout.splitlines()[0]
                                         for name in ('clang', 'ld.lld', 'llvm-objcopy', 'llvm-nm')},
                         'symbols': {k: hex(v) for k, v in symbols.items()},
                         'ptp_verification': ptp, 'ui_verification': ui, 'usb_commands_sent': 0,
                         'scope': 'Offline experiment: no boot, real LCD rendering, camera USB or flash test.'})
        (work / OUTPUT_NAME).write_bytes(product)
        (work / 'manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
        lines = []
        for start, end in ((symbols['diagnostic_preflight'], symbols['diagnostic_info']),
                           (symbols['ui_version'], symbols['node_address'])):
            lines.append(f'; code {start:#x}..{end:#x}')
            lines.extend(f'{i.address:09x} {i.bytes.hex()} {i.mnemonic} {i.op_str}'
                         for i in core.disassembler().disasm(payload[start - core.PAYLOAD:end - core.PAYLOAD], start))
        (work / 'code_landmarks.asm').write_text('\n'.join(lines) + '\n')
        if output.exists():
            raise ValueError('Output directory appeared during build')
        work.rename(output)
    return manifest


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--firmware', type=Path, default=ROOT / 'Z_8_0311.bin')
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    try:
        result = build(args.firmware, args.output)
    except (ValueError, OSError, subprocess.CalledProcessError) as error:
        parser.exit(1, f'UI build failed: {error}\n')
    print(json.dumps({'output': str(args.output / OUTPUT_NAME), 'sha256': result['output_sha256'],
                      'ptp_cases': result['ptp_verification']['differential_cases'],
                      'ui': result['ui_verification'], 'usb_commands_sent': 0}, indent=2))


if __name__ == '__main__':
    main()
