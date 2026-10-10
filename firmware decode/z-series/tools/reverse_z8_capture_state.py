#!/usr/bin/env python3
"""Trace Z8 3.11 video settings into the capture-information snapshot offline.

Executes the real SDK setter, derived-size callback, update-queue append, DataID
reader and snapshot updater. Queue commitment is a harness transfer, not the
camera's transaction scheduler. No sensor, encoder, camera or firmware writes.
"""
import argparse
import hashlib
import json
from pathlib import Path
import struct

from reverse_z8_video_modes import (BASE, EXPECTED_SHA, FILETYPES, Probe, RAM,
                                    RAM_FILE, RAM_SIZE, ROOT, decode_mode)
from reverse_z8_dsp_host import disassembler

SNAPSHOT = 0xA03B98570
STATUS = 0xA03B9915C
ID_ARRAY = 0xA0292A624
REGISTRY = 0xA02A28FF8
DERIVED_SIZE = 0x0400211E
RANGES = {
    'registry_partition_selector': (0x40F23438, 0x40F234A0),
    'registry_lookup': (0x40F2350C, 0x40F2355C),
    'snapshot_initialization_wrapper': (0x40ED3B14, 0x40ED3B48),
    'snapshot_initialization_excerpt': (0x40F38E58, 0x40F38ED0),
    'effective_size_update_callback': (0x40EE0070, 0x40EE02BC),
    'effective_size_selection': (0x40ED8F74, 0x40ED90D0),
    'append_updates': (0x40ED3E24, 0x40ED3ED0),
    'dataid_reader': (0x4101553C, 0x41015618),
    'snapshot_size_update_arm': (0x40F3EBDC, 0x40F3EC08),
    'snapshot_fps_update_arm': (0x40F3F3E0, 0x40F3F404),
    'image_info_context_adapter_excerpt': (0x4105C138, 0x4105C19C),
}


def offset(address):
    if RAM <= address < RAM + RAM_SIZE:
        return address - RAM + RAM_FILE
    return address - BASE


def dataid_record(data, dataid):
    group = 0x440244C8 + ((dataid >> 8) & 255) * 48
    active = struct.unpack_from('<I', data, offset(group))[0]
    first, count = struct.unpack_from('<HH', data, offset(group) + 24)
    if not active or (dataid & 255) >= count:
        raise ValueError('DataID group is absent or too short')
    address = 0x4400A5C0 + (first + (dataid & 255)) * 24
    kind = struct.unpack_from('<I', data, offset(address))[0]
    pointer = struct.unpack_from('<Q', data, offset(address) + 8)[0]
    return {'id': hex(dataid), 'record_address': hex(address),
            'kind': kind, 'storage_address': hex(pointer)}


def registry(data):
    records = []
    # 0x40f2350c scans indices 0..0x29c. 0x40f23438 separately exposes
    # the first 197 and next 147 records as two callback partitions.
    for i in range(0x29D):
        address = REGISTRY + i * 48
        did, a, b, c, fn1, fn2 = struct.unpack_from('<6Q', data, offset(address))
        if did > 0xFFFFFFFF or any(f and not BASE <= f < 0x41647000 for f in (fn1, fn2)):
            raise ValueError('Unexpected registry record')
        lists = []
        for pointer in (a, b, c):
            if not pointer:
                lists.append([])
                continue
            if not RAM <= pointer < RAM + RAM_SIZE - 16:
                raise ValueError('Invalid registry list descriptor')
            n, items = struct.unpack_from('<QQ', data, offset(pointer))
            if n > 5000 or (n and not RAM <= items <= RAM + RAM_SIZE - n * 4):
                raise ValueError('Invalid registry ID array')
            lists.append(list(struct.unpack_from(f'<{n}I', data, offset(items))) if n else [])
        records.append({'id': hex(did), 'address': hex(address),
                        'id_lists': [[hex(v) for v in x] for x in lists],
                        'callbacks': [hex(fn1), hex(fn2)]})
    return records


class CaptureProbe(Probe):
    def hook(self, uc, address, size, user):
        if address == 0x41012C84:
            return  # Keep executing the genuine DataID reader, not a mock.
        raise ValueError(f'Unexpected external service in capture probe: {address:#x}')

    def put32(self, address, value):
        self.uc.mem_write(address, struct.pack('<I', value))

    def get32(self, address):
        return struct.unpack('<I', self.uc.mem_read(address, 4))[0]


def analyze(data):
    nodes = registry(data)
    node = next(r for r in nodes if r['id'] == hex(DERIVED_SIZE))
    if node['callbacks'] != ['0x40ee0070', '0x0']:
        raise ValueError('Derived-size callback changed')
    ids = struct.unpack_from('<763I', data, offset(ID_ARRAY))
    index = {did: i * 4 for i, did in enumerate(ids)}
    if index[0x0500125A] != 0x28C or index[DERIVED_SIZE] != 0x38C:
        raise ValueError('Snapshot schema changed')
    p = CaptureProbe(data)
    p.uc.mem_map(0xA03B98000, 0x3000)
    p.uc.mem_map(0xA03D7C000, 0x2000)
    output = p.buf + 0x2000
    context = p.buf + 0x4000
    storage = dataid_record(data, DERIVED_SIZE)
    if storage['kind'] != 9:
        raise ValueError('Unexpected storage type')
    storage_address = int(storage['storage_address'], 16)
    result = p.call(0x40F2350C, DERIVED_SIZE, p.buf)
    resolved = struct.unpack('<Q', p.uc.mem_read(p.buf, 8))[0]
    if result != 1 or resolved != int(node['address'], 16):
        raise ValueError('Registry lookup disagrees with record extraction')

    def run(ft, writes, previous=0xFFFFFFFF, capacity=8):
        p.uc.mem_write(SNAPSHOT, bytes(0xBEC))
        p.uc.mem_write(STATUS, bytes(0x184))
        p.uc.mem_write(output, bytes(0x500))
        p.uc.mem_write(context, bytes(0x1000))
        p.put32(SNAPSHOT + index[0x280C], 1)
        p.put32(SNAPSHOT + index[0x06001206], ft)
        p.put32(SNAPSHOT + index[DERIVED_SIZE], previous)
        for did, value in writes:
            p.put32(SNAPSHOT + index[did], value)
        p.put32(output, capacity)
        p.uc.mem_write(output + 8, struct.pack('<QQ', output + 0x200, output + 0x240))
        p.uc.mem_write(output + 0x178, struct.pack('<Q', output + 0x300))
        code = p.call(0x40EE0070, 0, output)
        count = p.get32(output + 4)
        queued = []
        for i in range(count):
            did = p.get32(output + 0x200 + i * 4)
            value = p.get32(output + 0x240 + i * 4)
            if did != DERIVED_SIZE:
                raise ValueError('Unexpected derived property')
            # Explicit harness boundary: commit the queued value to DataID RAM.
            # The real transaction commit and notification scheduler are omitted.
            p.put32(storage_address, value)
            p.call(0x40F3911C, did, context, STATUS)
            actual = p.get32(context + 0x38C)
            if actual != value:
                raise ValueError('Real snapshot updater lost the derived size')
            queued.append({'id': hex(did), 'value': value, 'context_38c': actual})
        return {'return': code, 'queued_count': count, 'queued': queued}

    sdk = Probe(data)
    cases = []
    for ft, name in FILETYPES.items():
        sdk.filetype = ft
        n = sdk.call(0x40841C8C, sdk.buf)
        ptr = struct.unpack('<Q', sdk.uc.mem_read(sdk.buf, 8))[0]
        for packed in struct.unpack(f'<{n}Q', sdk.uc.mem_read(ptr, n * 8)):
            checked = sdk.set_mode(packed)
            if checked['return'] != '0x2001':
                raise ValueError('Original SDK mode rejected')
            writes = [(int(w['id'], 16), w['value']) for w in checked['writes']]
            outcome = run(ft, writes)
            if outcome['return'] != 1 or outcome['queued_count'] != 1 or outcome['queued'][0]['value'] != writes[0][1]:
                raise ValueError(f'Unexpected derived-size result: {outcome}')
            cases.append({'filetype': name, **decode_mode(packed), 'sdk_writes': checked['writes'], **outcome})
    invalid = []
    for value in (7, 0x7FFFFFFF):
        outcome = run(6, [(0x0500125A, value)])
        if outcome['queued'] != [{'id': hex(DERIVED_SIZE), 'value': value, 'context_38c': value}]:
            raise ValueError('Unexpected invalid-enum behavior')
        invalid.append({'injected_size_enum': value, **outcome})
    unchanged = run(6, [(0x0500125A, 6)], previous=6)
    full = run(6, [(0x0500125A, 6)], capacity=0)
    if unchanged != {'return': 1, 'queued_count': 0, 'queued': []}:
        raise ValueError('Unchanged-state suppression failed')
    if full != {'return': 0, 'queued_count': 0, 'queued': []}:
        raise ValueError('Queue-capacity guard failed')
    snapshot_fields = [{'offset': hex(index[v]), 'id': hex(v)} for v in
                       (0x280C, 0x06001206, 0x0500125A, 0x0500125B, DERIVED_SIZE, 0x2171)]
    references = [n for n in nodes if any(hex(0x0500125A) in values for values in n['id_lists'])]
    return {'image_sha256': EXPECTED_SHA, 'scope': 'Synthetic baseline snapshot; no sensor or encoder execution',
            'snapshot_address': hex(SNAPSHOT), 'snapshot_id_array': hex(ID_ARRAY),
            'snapshot_fields': snapshot_fields, 'derived_storage': storage, 'node': node,
            'direct_nraw_references': references, 'cases': cases, 'invalid_enum_injections': invalid,
            'unchanged_state': unchanged, 'full_queue': full,
            'validation': {'listed_modes': len(cases), 'invalid_enum_cases': len(invalid),
                           'registry_records': len(nodes), 'registry_lookup_checked': True,
                           'checks_passed': True}}, nodes


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--image', type=Path, default=ROOT / 'analysis/Z_8_0311/eg2070_0311b0.bi')
    parser.add_argument('--output', type=Path, default=ROOT / 'analysis/z8_capture_state')
    args = parser.parse_args()
    data = args.image.read_bytes()
    if hashlib.sha256(data).hexdigest() != EXPECTED_SHA:
        raise SystemExit('Unsupported EG image hash')
    result, nodes = analyze(data)
    args.output.mkdir(parents=True, exist_ok=True)
    for name, content in (('manifest.json', result), ('registry.json', nodes)):
        (args.output / name).write_text(json.dumps(content, indent=2) + '\n')
    lines = []
    for name, (a, b) in RANGES.items():
        code = data[a-BASE:b-BASE]
        lines.append(f'\n; {name} [{a:#x}, {b:#x}); SHA-256 {hashlib.sha256(code).hexdigest()}')
        lines.extend(f'{i.address:08x} {i.bytes.hex():8s} {i.mnemonic:8s} {i.op_str}'
                     for i in disassembler().disasm(code, a))
    (args.output / 'code_landmarks.asm').write_text('\n'.join(lines) + '\n')
    print(json.dumps(result['validation']))


if __name__ == '__main__':
    main()
