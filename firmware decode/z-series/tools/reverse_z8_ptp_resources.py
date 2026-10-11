#!/usr/bin/env python3
"""Trace private PTP resource-read dispatch offline, without camera access.

Real dispatcher, preflight, resource queries and resource-read handler execute.
Session state is synthetic; the send/response functions are intercepted. Resource
payloads remain unmapped and no USB transport or resource write handler runs.
"""

import argparse
import hashlib
import json
import struct
from pathlib import Path

from reverse_z8_sensor_inputs import EXPECTED_SHA, ROOT, InputProbe, disassembler, offset

TABLE = 0x440EC590
SESSION = 0xA047D9FC8
PARAM_RAM = 0xA155D78C0
LENGTH = 0xF2000
RANGES = {
    "private_descriptor_lookup": (0x407FE064, 0x407FE0F8),
    "outer_operation_wrappers": (0x407FE12C, 0x407FE170),
    "cached_lookup_and_admission": (0x407FE228, 0x407FE36C),
    "session_callback_registration": (0x407FE4F0, 0x407FE53C),
    "request_parameter_count_check": (0x4034AF38, 0x4034AF88),
    "resource_read_preflight": (0x407FFC6C, 0x407FFD54),
    "resource_read_handler": (0x407FFD54, 0x407FFE74),
    "address_read_preflight": (0x408008A4, 0x40800A08),
    "address_read_handler_excerpt": (0x40800A08, 0x40800AF0),
    "resource_info": (0x40D6B460, 0x40D6B4E0),
}


def analyze(data):
    from unicorn import UC_HOOK_CODE

    p = InputProbe(data)
    p.uc.mem_map(0xA047D9000, 0x1000)
    events = []

    def intercept(uc, address, size, user):
        if address == 0x407DF2C4:
            events.append(
                {"kind": "send_intercepted", "source": hex(p.reg("X1")), "length": p.reg("X2"), "timeout": p.reg("X3")}
            )
        else:
            events.append(
                {
                    "kind": "response_intercepted",
                    "response_code": hex(p.reg("X1")),
                    "parameter_count": p.reg("X2"),
                    "status_argument": p.reg("X4"),
                    "parameters": list(struct.unpack("<5I", uc.mem_read(p.reg("X3"), 20))),
                }
            )
        uc.reg_write(p.regs.UC_ARM64_REG_X0, 1)
        uc.reg_write(p.regs.UC_ARM64_REG_PC, p.reg("LR"))

    for address in (0x407DF2C4, 0x407DF0D4):
        p.uc.hook_add(UC_HOOK_CODE, intercept, begin=address, end=address)

    def info(resource):
        assert p.call(0x40D6B460, resource, p.buf + 0x100) == 1
        ram, mapped, relative, length, allocation = struct.unpack("<QQIII", p.uc.mem_read(p.buf + 0x100, 28))
        return {
            "resource": hex(resource),
            "ram": hex(ram),
            "mapped": hex(mapped),
            "relative": relative,
            "length": length,
            "allocation": allocation,
        }

    before = info(0x5C)
    assert before["ram"] == "0x0"
    p.uc.mem_map(0xA03424000, 0x2000)
    p.uc.mem_map(0xA03451000, 0x1000)
    # Pointer assignment only. Do not simulate successful payload loading.
    p.run_slice(0x40D70DBC, 0x40D70F88)
    after = info(0x5C)
    assert after["ram"] == hex(PARAM_RAM) and after["length"] == LENGTH
    p.call(0x407FE4F0)  # Register the genuine session-state callback.
    assert struct.unpack("<Q", p.uc.mem_read(0xA047D9FA8, 8))[0] == 0x407FE524

    def request(command, a, b, c, *, state=1, execute=False):
        # Standard 12-byte container prefix, inner command in parameter 1;
        # three request arguments and one unused zero parameter follow.
        p.uc.mem_write(p.buf, struct.pack("<IHH6I", 32, 1, 0x94FF, 1, command, a, b, c, 0))
        p.uc.mem_write(SESSION, bytes([state]))
        events.clear()
        admitted = p.call(0x407FE160, 0, p.buf)
        result = None
        if admitted and execute:
            assert command == 0xF029  # Never run an address-read or write handler.
            result = p.call(0x407FE168, 0, p.buf)
        return {
            "command": hex(command),
            "arguments": [a, b, c],
            "session_flag": state,
            "admitted": admitted,
            "handler_result": result,
            "events": list(events),
        }

    closed = request(0xF029, 0, 16, 0, state=0, execute=True)
    assert closed["admitted"] == 0 and closed["events"][0]["response_code"] == "0xa004"
    selectors = []
    expected = [0x5C, 0x52, 0x4D, 0x5B, 0xB, 0xC, 0x4A, 0x5A]
    for selector, resource in enumerate(expected):
        # Decode both jump-table arms; execute only the target resource path.
        arms = [struct.unpack_from("<Q", data, offset(t + selector * 8))[0] for t in (0x440EE840, 0x440EE880)]
        for arm in arms:
            instruction = next(disassembler().disasm(data[offset(arm) : offset(arm) + 4], arm))
            assert instruction.mnemonic == "mov" and instruction.op_str == f"w0, #{resource:#x}"
        selectors.append({"selector": selector, "resource": hex(resource), "branch_addresses": [hex(a) for a in arms]})
    target = request(0xF029, 0, 16, 0, execute=True)
    assert target["admitted"] == 1 and target["handler_result"] == 1
    assert target["events"][0] == {"kind": "send_intercepted", "source": hex(PARAM_RAM), "length": 16, "timeout": 5000}

    boundaries = []
    for displacement, size, selector, accept in [
        (0, 0, 0, 0),
        (0, LENGTH, 0, 1),
        (LENGTH - 1, 1, 0, 1),
        (LENGTH, 1, 0, 0),
        (0, 1, 8, 0),
        (0x100, 0x40, 0, 1),
    ]:
        case = request(0xF029, displacement, size, selector, execute=bool(accept))
        assert case["admitted"] == accept
        if accept:
            assert case["events"][0]["source"] == hex(PARAM_RAM + displacement)
            assert case["events"][0]["length"] == size
        else:
            assert case["events"][0]["parameters"][0] == 0x201D
        boundaries.append(case)

    address_checks = []
    for address, size, accept in [
        (0x47E80000, 16, 0),
        (0x47F7FFFC, 4, 0),
        (0x40160000, 16, 0),
        (PARAM_RAM, 16, 1),
        (PARAM_RAM, 1024, 1),
        (PARAM_RAM, 1025, 0),
    ]:
        case = request(0xF032, address & 0xFFFFFFFF, address >> 32, size)
        assert case["admitted"] == accept
        address_checks.append({"address": hex(address), "probe": case})

    records = []
    for i in range(182):
        address = TABLE + i * 48
        fields = struct.unpack_from("<6Q", data, offset(address))
        assert fields[0] & 0xFFFF and fields[4]
        records.append(
            {"address": hex(address), "command": hex(fields[0] & 0xFFFF), "raw_fields": [hex(v) for v in fields]}
        )
    assert struct.unpack_from("<Q", data, offset(TABLE + 182 * 48))[0] == 0
    outer = struct.unpack_from("<8Q", data, offset(0x44DF28A0))
    assert outer == (0x1000094FF, 0, 0, 0, 0, 0x407FE160, 0x407FE168, 0x407FE12C)
    return {
        "image_sha256": EXPECTED_SHA,
        "scope": "Offline inner dispatcher only; synthetic session flag; no full boot, USB transport, payload loading or camera access",
        "outer_read_descriptor": {"address": "0x44df28a0", "raw_fields": [hex(v) for v in outer]},
        "inner_descriptors": records,
        "parameter_resource_before_pointer_assignment": before,
        "parameter_resource_after_pointer_assignment": after,
        "closed_session": closed,
        "resource_read_selectors": selectors,
        "target_read_probe": target,
        "resource_read_boundary_probes": boundaries,
        "address_read_preflight_probes": address_checks,
        "intercepted_functions": ["0x407df2c4", "0x407df0d4"],
        "actual_parameter_bytes_recovered": 0,
        "usb_commands_sent": 0,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--image", type=Path, default=ROOT / "analysis/Z_8_0311/eg2070_0311b0.bi")
    parser.add_argument("--output", type=Path, default=ROOT / "analysis/z8_ptp_resources")
    args = parser.parse_args()
    data = args.image.read_bytes()
    if hashlib.sha256(data).hexdigest() != EXPECTED_SHA:
        raise ValueError("Expected the pinned Z8 3.11 EG image")
    result = analyze(data)
    lines = []
    for name, (a, b) in RANGES.items():
        code = data[offset(a) : offset(b)]
        lines.append(f"\n; {name} [{a:#x}, {b:#x}); SHA-256 {hashlib.sha256(code).hexdigest()}")
        lines.extend(
            f"{i.address:09x} {i.bytes.hex():8s} {i.mnemonic:8s} {i.op_str}" for i in disassembler().disasm(code, a)
        )
    args.output.mkdir(parents=True, exist_ok=True)
    (args.output / "manifest.json").write_text(json.dumps(result, indent=2) + "\n")
    (args.output / "code_landmarks.asm").write_text("\n".join(lines) + "\n")
    print(
        json.dumps(
            {
                "resource_selectors": len(result["resource_read_selectors"]),
                "boundary_probes": len(result["resource_read_boundary_probes"]),
                "address_preflight_probes": len(result["address_read_preflight_probes"]),
                "actual_parameter_bytes_recovered": 0,
                "usb_commands_sent": 0,
            }
        )
    )


if __name__ == "__main__":
    main()
