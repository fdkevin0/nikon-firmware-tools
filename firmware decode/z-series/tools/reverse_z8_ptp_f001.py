#!/usr/bin/env python3
"""Extract Z8 3.11 private session commands and probe admission offline.

No USB or camera access. The F001 handler runs only with an already-open
synthetic session, which returns before camera initialization. F002 and the
F001 opening path are disassembled, never executed.
"""

import argparse
import hashlib
import json
import struct
from pathlib import Path

from reverse_z8_ptp_resources import SESSION, TABLE
from reverse_z8_sensor_inputs import EXPECTED_SHA, ROOT, InputProbe, disassembler, offset

RANGES = {
    "descriptor_lookup_and_dispatch": (0x407FE064, 0x407FE0F8),
    "outer_wrappers_and_parameter_checks": (0x407FE12C, 0x407FE228),
    "admission_and_handler_dispatch": (0x407FE228, 0x407FE36C),
    "registration_open_close": (0x407FE4F0, 0x407FE85C),
    "parameter_count_check": (0x4034AF38, 0x4034AF88),
}


def analyze(data):
    from unicorn import UC_HOOK_CODE

    outer = []
    for address, opcode in zip(range(0x44DF2820, 0x44DF28E0, 64), (0x94FD, 0x94FE, 0x94FF)):
        fields = struct.unpack_from("<8Q", data, offset(address))
        assert fields[0] & 0xFFFF == opcode
        outer.append({"address": hex(address), "opcode": hex(opcode), "raw_fields": [hex(v) for v in fields]})
    inner = []
    for address, command, handler in ((TABLE, 0xF001, 0x407FE53C), (TABLE + 48, 0xF002, 0x407FE734)):
        fields = struct.unpack_from("<6Q", data, offset(address))
        assert fields == (command, 0, 0, 0, handler, 0x407FE4F0)
        inner.append({"address": hex(address), "command": hex(command), "raw_fields": [hex(v) for v in fields]})

    p = InputProbe(data)
    p.uc.mem_map(0xA047D9000, 0x1000)
    responses = []

    def response(uc, address, size, user):
        responses.append(
            {
                "code": hex(p.reg("X1")),
                "parameters": list(struct.unpack("<5I", uc.mem_read(p.reg("X3"), 20))),
                "status_argument": p.reg("X4"),
            }
        )
        uc.reg_write(p.regs.UC_ARM64_REG_X0, 1)
        uc.reg_write(p.regs.UC_ARM64_REG_PC, p.reg("LR"))

    p.uc.hook_add(UC_HOOK_CODE, response, begin=0x407DF0D4, end=0x407DF0D4)
    p.call(0x407FE4F0)
    cases = []
    for state, command, count, expected in (
        (0, 0xF001, 5, 1),
        (0, 0xF002, 5, 0),
        (0, 0xF029, 5, 0),
        (0, 0xF001, 1, 0),
        (1, 0xF001, 5, 1),
    ):
        packet = struct.pack("<IHHI", 12 + count * 4, 1, 0x94FD, 1)
        packet += struct.pack("<" + "I" * count, command, *([0] * (count - 1)))
        p.uc.mem_write(p.buf, bytes(32))
        p.uc.mem_write(p.buf, packet)
        p.uc.mem_write(SESSION, bytes([state]))
        responses.clear()
        admitted = p.call(0x407FE130, 0, p.buf)
        assert admitted == expected
        handler_result = None
        if state == 1 and command == 0xF001:
            handler_result = p.call(0x407FE138, 0, p.buf)
            assert handler_result == 0
            assert responses[0]["code"] == "0x2001"
            assert responses[0]["parameters"][0] == 0x201E
        elif not admitted:
            assert responses[0]["code"] == ("0x2006" if count == 1 else "0xa004")
        assert bytes(p.uc.mem_read(SESSION, 1)) == bytes([state])
        cases.append(
            {
                "outer_opcode": "0x94fd",
                "command": hex(command),
                "session_flag": state,
                "parameter_count": count,
                "packet_hex": packet.hex(),
                "admitted": admitted,
                "handler_result": handler_result,
                "responses": list(responses),
            }
        )
    return {
        "image_sha256": EXPECTED_SHA,
        "scope": __doc__.strip(),
        "outer_descriptors": outer,
        "inner_descriptors": inner,
        "probes": cases,
        "usb_commands_sent": 0,
        "opening_backend_executed": False,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--image", type=Path, default=ROOT / "analysis/Z_8_0311/eg2070_0311b0.bi")
    parser.add_argument("--output", type=Path, default=ROOT / "analysis/z8_ptp_f001")
    args = parser.parse_args()
    data = args.image.read_bytes()
    if hashlib.sha256(data).hexdigest() != EXPECTED_SHA:
        raise ValueError("Expected the pinned Z8 3.11 EG image")
    result = analyze(data)
    lines = []
    for name, (start, end) in RANGES.items():
        code = data[offset(start) : offset(end)]
        lines.append(f"\n; {name} [{start:#x}, {end:#x}); SHA-256 {hashlib.sha256(code).hexdigest()}")
        lines.extend(
            f"{i.address:09x} {i.bytes.hex():8s} {i.mnemonic:8s} {i.op_str}" for i in disassembler().disasm(code, start)
        )
    args.output.mkdir(parents=True, exist_ok=True)
    (args.output / "manifest.json").write_text(json.dumps(result, indent=2) + "\n")
    (args.output / "code_landmarks.asm").write_text("\n".join(lines) + "\n")
    print(json.dumps({"probes": len(result["probes"]), "usb_commands_sent": 0}))


if __name__ == "__main__":
    main()
