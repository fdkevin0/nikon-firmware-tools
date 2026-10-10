#!/usr/bin/env python3
"""Trace Z8 sensor-resource loading and capture-size request adapters offline.

Loader experiment supplies only a synthetic ENDM footer and intercepts the copy.
Capture experiments execute bounded code excerpts with synthetic context flags;
they do not run the complete capture state machine or touch a camera.
"""
import argparse
import hashlib
import itertools
import json
from pathlib import Path
import struct

from reverse_z8_sensor_backend import BASE, EXPECTED_SHA, RESOURCE, ROOT, SensorProbe
from reverse_z8_capture_state import (DERIVED_SIZE, ID_ARRAY, SNAPSHOT, STATUS,
                                      CaptureProbe, dataid_record, offset, registry)
from reverse_z8_dsp_host import disassembler
from reverse_z8_video_modes import FILETYPES, Probe, decode_mode

RANGES = {
    'resource_ram_assignment_excerpt': (0x40D70DBC, 0x40D70F88),
    'resource_load_entry_excerpt': (0x40D6BFF4, 0x40D6C164),
    'resource_load_descriptor_adapter': (0x40D6C320, 0x40D6C3C0),
    'resource_load_copy': (0x40D702BC, 0x40D70370),
    'resource_footer_validation': (0x40D70370, 0x40D704AC),
    'resource_footer_address': (0x40D70B4C, 0x40D70BA4),
    'capture_context_request_caller_excerpt': (0x40F81CC4, 0x40F81DBC),
    'capture_selector_builder': (0x40F889A8, 0x40F88A78),
    'capture_selector_store_excerpt': (0x40F88A78, 0x40F88A98),
    'capture_selector_leaf': (0x410666F8, 0x410668E0),
    'sensor_request_producer_excerpt': (0x41031DA0, 0x41031E18),
    'sensor_request_producer_call_excerpt': (0x41035168, 0x410351FC),
    'sensor_request_forward_excerpt': (0x410352CC, 0x410352D4),
    'sensor_service_wrapper_excerpt': (0x40F4E108, 0x40F4E15C),
    'sensor_service_request_adapter_excerpt': (0x40F5C18C, 0x40F5C22C),
    'backend_mode_store_excerpt': (0x41158878, 0x411588FC),
    'request_kind_and_auxiliary_selectors': (0x41035D98, 0x41035EE0),
    'sdk_effective_mode_getter': (0x40841BFC, 0x40841C40),
    'sdk_mode_builder': (0x40811DA4, 0x40811E7C),
    'snapshot_fps_update_arm': (0x40F3F3E0, 0x40F3F404),
    'capture_context_initialization_call': (0x40F79348, 0x40F793A8),
    'capture_context_builder_read_excerpt': (0x40F28488, 0x40F28590),
    'capture_context_cache_transfer_excerpt': (0x40F28590, 0x40F28620),
    'capture_context_kind_excerpt': (0x40F28638, 0x40F28688),
    'capture_context_video_fields_excerpt': (0x40F2888C, 0x40F288F4),
    'capture_context_auxiliary_fields_excerpt': (0x40F28960, 0x40F28980),
    'effective_format_fields_callback': (0x40F1AE50, 0x40F1B168),
    'effective_rate_callback': (0x40EE02BC, 0x40EE0560),
    'video_area_callback': (0x40EE1924, 0x40EE21C8),
    'area_selector': (0x40ED90D0, 0x40ED9288),
}


class InputProbe(SensorProbe):
    def hook(self, uc, address, size, user):
        if address == 0x41012C84:
            return  # Execute the genuine DataID reader.
        super().hook(uc, address, size, user)

    def put32(self, address, value):
        self.uc.mem_write(address, struct.pack('<I', value))

    def get32(self, address):
        return struct.unpack('<I', self.uc.mem_read(address, 4))[0]

    def run_slice(self, start, end, registers=None, stack_data=None):
        self.uc.context_restore(self.clean_context)
        self.uc.mem_write(self.stack, bytes(0x10000))
        self.uc.reg_write(self.regs.UC_ARM64_REG_SP, self.stack + 0xF000)
        for displacement, value in (stack_data or []):
            self.uc.mem_write(self.stack + 0xF000 + displacement, value)
        for name, value in (registers or {}).items():
            self.uc.reg_write(getattr(self.regs, 'UC_ARM64_REG_' + name), value)
        self.uc.emu_start(start, end, count=100000)
        if self.reg('PC') != end:
            raise RuntimeError(f'Excerpt did not reach {end:#x}: {self.reg("PC"):#x}')


def resource_flow(data):
    from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_READ_UNMAPPED, UcError
    p = InputProbe(data)
    p.uc.mem_map(0xA03424000, 0x2000)
    p.uc.mem_map(0xA03451000, 0x1000)
    p.run_slice(0x40D70DBC, 0x40D70F88)
    assigned = struct.unpack('<Q', p.uc.mem_read(RESOURCE + 16, 8))[0]
    assert assigned == 0xA155D78C0
    missing = []

    def missing_read(uc, access, address, size, value, user):
        missing.append({'address': hex(address), 'size': size, 'pc': hex(p.reg('PC'))})
        return False

    p.uc.hook_add(UC_HOOK_MEM_READ_UNMAPPED, missing_read)
    try:
        p.call(0x40D6BFF4, 0x5C)
    except UcError:
        assert missing == [{'address': '0x47f7fffc', 'size': 1, 'pc': '0x40d70468'}]
    else:
        raise AssertionError('Expected the unmapped resource-footer read')
    # Only the footer page is mapped. The actual 0xf2000-byte payload remains
    # unmapped, as does its RAM destination. A successful copy is simulated.
    p.uc.mem_map(0x47F7F000, 0x1000)
    p.uc.mem_write(0x47F7FFFC, b'ENDM')
    copies = []

    def intercept_copy(uc, address, size, user):
        copies.append([p.reg(f'X{i}') for i in range(3)])
        uc.reg_write(p.regs.UC_ARM64_REG_X0, 0)
        uc.reg_write(p.regs.UC_ARM64_REG_PC, p.reg('LR'))

    p.uc.hook_add(UC_HOOK_CODE, intercept_copy, begin=0x40CA95FC, end=0x40CA95FC)
    result = p.call(0x40D6BFF4, 0x5C)
    assert result == 1 and copies == [[assigned, 0x47E80000, 0xF2000]]
    p.call(0x40D6B4F4, 0x5C)
    # Probe.call returns W0; this is a 64-bit pointer, so read X0 explicitly.
    selected = p.reg('X0')
    assert selected == assigned
    return {'assigned_ram_pointer': hex(assigned), 'missing_read': missing[0],
            'synthetic_footer': {'address': '0x47f7fffc', 'bytes': 'ENDM'},
            'intercepted_copy': {'destination': hex(assigned), 'source': '0x47e80000',
                                 'length': 0xF2000},
            'loader_return_with_copy_stub': result,
            'getter_after_simulated_load': hex(selected),
            'actual_parameter_bytes_loaded': 0}


def listed_mode_flow(data, run_request, builder_ids):
    """Compose real callbacks under a declared synthetic video baseline."""
    p, sdk = CaptureProbe(data), Probe(data)
    p.uc.mem_map(0xA03B98000, 0x7000)
    ids = struct.unpack_from('<763I', data, offset(ID_ARRAY))
    index = {did: i * 4 for i, did in enumerate(ids)}
    nodes = {int(n['id'], 16): n for n in registry(data)}
    callbacks = [(0x06001206, 0x40F1AE50), (DERIVED_SIZE, 0x40EE0070),
                 (0x04002120, 0x40EE02BC), (0x07001201, 0x40EE1924)]
    for did, fn in callbacks:
        assert nodes[did]['callbacks'][0] == hex(fn)
    out = p.buf + 0x2000
    results = []
    for ft, name in FILETYPES.items():
        sdk.filetype = ft
        count = sdk.call(0x40841C8C, sdk.buf)
        pointer = struct.unpack('<Q', sdk.uc.mem_read(sdk.buf, 8))[0]
        for packed in struct.unpack(f'<{count}Q', sdk.uc.mem_read(pointer, count * 8)):
            checked = sdk.set_mode(packed)
            assert checked['return'] == '0x2001'
            p.uc.mem_write(0xA03B98000, bytes(0x7000))
            initial = {0x280C: 1, 0x218C: 1, 0x06001206: ft}
            initial.update({int(w['id'], 16): w['value'] for w in checked['writes']})
            for did, value in initial.items():
                p.put32(SNAPSHOT + index[did], value)
            p.put32(STATUS + 4, 1)
            updates = []
            for did, fn in callbacks:
                p.uc.mem_write(out, bytes(0x1000))
                p.put32(out, 64)
                p.uc.mem_write(out + 8, struct.pack('<QQ', out + 0x200, out + 0x400))
                p.uc.mem_write(out + 0x178, struct.pack('<Q', out + 0x800))
                assert p.call(fn, int(nodes[did]['address'], 16), out) == 1
                for i in range(p.get32(out + 4)):
                    key = p.get32(out + 0x200 + i * 4)
                    value = p.get32(out + 0x400 + i * 4)
                    # Explicit harness commit between callbacks, not firmware's
                    # transaction scheduler or a proof of scheduling order.
                    p.put32(SNAPSHOT + index[key], value)
                    updates.append({'id': hex(key), 'value': value, 'callback': hex(fn)})
            derived = {did: p.get32(SNAPSHOT + index[did]) for did in builder_ids}
            result = run_request(derived)
            assert result['context_3a0'] == {1: 0, 2: 1, 3: 1, 4: 2, 5: 3, 6: 4}[ft]
            if ft == 6:
                width, fps = packed >> 48, (packed >> 16) & 255
                expected_mode = {8256: 7, 5392: 13, 3840: 16}.get(width)
                if width == 4128:
                    expected_mode = 15 if fps >= 50 else 9
                assert result['backend_mode'] == expected_mode
            results.append({'filetype': name, **decode_mode(packed),
                            'sdk_writes': checked['writes'], 'derived_updates': updates,
                            'builder_values': {hex(k): v for k, v in derived.items()}, **result})
    assert len(results) == 80
    return {'scope': 'SDK-listed inputs; snapshot 0x280c=1, 0x218c=1; internal status+4=1; other snapshot/status/global fields zero; callbacks explicitly sequenced and committed by harness',
            'callback_order': [hex(fn) for _, fn in callbacks], 'count': len(results), 'modes': results}


def capture_flow(data):
    p = InputProbe(data)
    size_storage = int(dataid_record(data, DERIVED_SIZE)['storage_address'], 16)
    fps_record = dataid_record(data, 0x2171)
    fps_storage = int(fps_record['storage_address'], 16)
    assert fps_storage & ~0xFFF == size_storage & ~0xFFF
    auxiliary = dataid_record(data, 0x230B)
    assert int(auxiliary['storage_address'], 16) & ~0xFFF == size_storage & ~0xFFF
    ids_address = 0xA02A4C360
    ids = list(struct.unpack_from('<11I', data, offset(ids_address)))
    assert ids == [0x218C, 0x2124, 0x2167, DERIVED_SIZE, 0x04002120,
                   0x2171, 0x0400211B, 0x2312, 0x2869, 0x286A, 0x286B]
    records = [dataid_record(data, did) for did in ids]
    storage = {int(r['id'], 16): int(r['storage_address'], 16) for r in records}
    for page in sorted({a & ~0xFFF for a in storage.values()}):
        p.uc.mem_map(page, 0x1000)
    p.uc.mem_map(0xA03BC2000, 0x1000)
    status, outer, ctx, source, request, wrapper = [p.buf + n for n in
                                                  (0x1000, 0x2000, 0x4000, 0x7000, 0x8000, 0x9000)]
    cache, values, snapshot = [p.buf + n for n in (0xA000, 0xB000, 0xC000)]
    size_map = list(struct.unpack_from('<6I', data, offset(0xA029D8ED0)))
    kind_map = list(struct.unpack_from('<8I', data, offset(0xA029DA170)))
    fps_pairs = list(struct.iter_unpack('<II', data[offset(0x440F0398):offset(0x440F0398) + 56]))
    assert fps_pairs == [(120, 0), (100, 1), (60, 2), (50, 3), (30, 4), (25, 5), (24, 6)]
    fps_probes = []
    for fps, value in fps_pairs:
        p.put32(fps_storage, value)
        p.call(0x40F3911C, 0x2171, snapshot, status)
        assert p.get32(snapshot + 0x3A0) == value
        p.call(0x40811DA4, 6, value, 0)
        packed = p.reg('X0')
        assert (packed >> 16) & 255 == fps
        fps_probes.append({'enum': value, 'fps_label': fps, 'snapshot_3a0': value,
                           'packed_mode': hex(packed)})
    def run_request(injected):
        field3a0, field388, field390, size = (injected.get(did, 0) for did in
                                            (0x2869, 0x2124, 0x04002120, DERIVED_SIZE))
        p.uc.mem_write(ctx, bytes(0x2000))
        p.uc.mem_write(source, bytes(0xE0))
        p.uc.mem_write(request, bytes(0xB0))
        p.uc.mem_write(outer + 0x9E0, struct.pack('<Q', ctx))
        p.uc.mem_write(cache, bytes(0x500))
        for did, address in storage.items():
            p.put32(address, injected.get(did, 0))
        # The snapshot and capture context are distinct layouts. Execute the
        # real DataID bulk reader, then the capture builder's actual transfers.
        # This replaces the transaction reader 0x40f23658 with direct reads;
        # transaction scheduling and the other builder fields are not executed.
        p.call(0x41012CF0, ids_address, values, len(ids), 0, 0)
        read_values = bytes(p.uc.mem_read(values, 44))
        assert struct.unpack('<11I', read_values) == tuple(injected.get(did, 0) for did in ids)
        p.run_slice(0x40F28590, 0x40F28620,
                    {'X20': cache, 'X24': p.stack + 0xF000 + 0x198}, [(0x198, read_values)])
        # 0x40f28648 is after the cached-state pointer initialization.
        p.run_slice(0x40F28648, 0x40F28688, {'X19': ctx, 'X29': cache})
        p.run_slice(0x40F2888C, 0x40F288F4, {'X19': ctx, 'X29': cache})
        p.run_slice(0x40F28960, 0x40F28980, {'X19': ctx, 'X29': cache})
        assert p.get32(ctx) == 1
        assert p.get32(ctx + 0x388) == field388
        assert p.get32(ctx + 0x38C) == size
        assert p.get32(ctx + 0x390) == field390
        assert p.get32(ctx + 0x394) == injected.get(0x2171, 0)
        assert p.get32(ctx + 0x3A0) == field3a0
        p.run_slice(0x40F88A78, 0x40F88A98, {'X0': outer})
        selector = p.get32(ctx + 8)
        p.run_slice(0x41031DA0, 0x41031E18,
                    {'X0': ctx, 'X1': 0, 'X2': 0, 'X3': 0, 'X4': source + 0x34})
        assert p.get32(source + 0x3C) == size
        p.uc.mem_write(wrapper, struct.pack('<Q', source))
        p.run_slice(0x40F5C18C, 0x40F5C22C, {'X20': wrapper})
        # Preserve the exact stack-built request across isolated excerpts.
        p.uc.mem_write(request, bytes(p.uc.mem_read(p.reg('SP') + 0xB0, 0xB0)))
        submode = p.get32(request + 0x1C)
        assert submode == (size_map[size - 1] if 1 <= size <= 6 else 0)
        assert p.get32(request) == 5 and p.get32(request + 4) == selector
        p.run_slice(0x41158878, 0x411588FC, {'X19': request})
        mode = p.get32(0xA029BDCE8)
        if size in (0, 7, 0x7FFFFFFF):
            assert mode == 0
        return {'context_3a0': field3a0, 'context_388': field388, 'context_390': field390,
                'effective_size': size, 'derived_selector': selector,
                'request_kind': 5, 'request_submode': submode, 'backend_mode': mode}

    results = []
    for field3a0, field388, field390, size in itertools.product(
            range(7), range(9), (0, 6), list(range(8)) + [0x7FFFFFFF]):
        results.append(run_request({0x218C: 1, 0x2124: field388, DERIVED_SIZE: size,
                                    0x04002120: field390, 0x2171: 6, 0x2869: field3a0}))
    examples = [r for r in results if r['context_3a0'] == 6 and r['context_388'] == 4 and r['context_390'] == 6]
    assert [r['backend_mode'] for r in examples] == [0, 17, 9, 7, 15, 15, 15, 0, 0]
    listed = listed_mode_flow(data, run_request, ids)
    return {'scope': 'Context+0=1, FPS at context+0x394=6; other state zero except listed fields; DataID 0x230b zero; code excerpts composed by harness; direct bulk reads replace transaction reader',
            'dataid_auxiliary': auxiliary, 'fps_dataid': fps_record, 'fps_probes': fps_probes,
            'capture_builder_ids': [hex(did) for did in ids], 'capture_builder_records': records,
            'service_size_map': size_map, 'service_kind_map': kind_map,
            'probe_count': len(results), 'example_baseline': examples,
            'listed_mode_flow': listed}, results


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--image', type=Path, default=ROOT / 'analysis/Z_8_0311/eg2070_0311b0.bi')
    parser.add_argument('--output', type=Path, default=ROOT / 'analysis/z8_sensor_inputs')
    args = parser.parse_args()
    data = args.image.read_bytes()
    if hashlib.sha256(data).hexdigest() != EXPECTED_SHA:
        raise ValueError('Expected the pinned Z8 3.11 EG image')
    resource = resource_flow(data)
    capture, probes = capture_flow(data)
    manifest = {'image_sha256': EXPECTED_SHA, 'resource_flow': resource, 'capture_flow': capture}
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
    print(json.dumps({'capture_probes': len(probes),
                      'listed_mode_probes': capture['listed_mode_flow']['count'],
                      'resource_source': resource['intercepted_copy'],
                      'actual_parameter_bytes_loaded': 0}))


if __name__ == '__main__':
    main()
