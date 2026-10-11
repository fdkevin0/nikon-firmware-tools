#!/usr/bin/env python3
"""Offline C-version UI getter/display probes; backend and drawing are intercepted."""

import hashlib
import json
import struct
import subprocess
import tempfile
from pathlib import Path

from capstone import CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN, Cs
from unicorn import UC_ARCH_ARM64, UC_HOOK_CODE, UC_MODE_ARM, Uc
from unicorn import arm64_const as R

ROOT = Path(__file__).resolve().parents[1]
BASE = 0x40160000
GETTER, HOOK, PAYLOAD = 0x405AB41C, 0x405AB454, 0x412A3800
EXPECTED = "f85e0138e2f5e660ece8560de62e0d12cb795e0e14983e50f20b61dce906c46c"
ASM = """.text
.global ui_version
ui_version:
 stp x19, x30, [sp, #-16]!
 mov x19, x1
 bl stock_version
 movz x8, #0x2e33
 movk x8, #0x3131, lsl #16
 movk x8, #0x5020, lsl #32
 str x8, [x19]
 ldp x19, x30, [sp], #16
 ret
"""


def run(data, patch=None, status=0):
    u = Uc(UC_ARCH_ARM64, UC_MODE_ARM)
    u.mem_map(BASE, (len(data) + 4095) & ~4095)
    u.mem_write(BASE, data)
    if patch:
        u.mem_write(HOOK, struct.pack("<I", 0x14000000 | (((PAYLOAD - HOOK) // 4) & 0x3FFFFFF)))
        u.mem_write(PAYLOAD, patch)
    stack, buf, stop = 0x20000000, 0x21000000, 0x22000000
    for a in (stack, buf, stop):
        u.mem_map(a, 0x10000)
    backend, drawn = [], []

    def reg(n):
        return u.reg_read(getattr(R, "UC_ARM64_REG_" + n))

    def ret(v=0):
        u.reg_write(R.UC_ARM64_REG_X0, v)
        u.reg_write(R.UC_ARM64_REG_PC, reg("LR"))

    def trace(uc, address, size, user):
        if address == 0x41022748:
            backend.append({"kind": reg("X0"), "capacity_request": 10})
            uc.mem_write(reg("X1"), b"03.11\0\0\0\0\0")
            ret(status)
        elif address == 0x403EC384:
            ret(0)
        elif address == 0x403F2920:
            drawn.append(bytes(uc.mem_read(reg("X0"), 10)).split(b"\0")[0].decode())
            ret()
        elif address in (0x403F645C, 0x403F6254, 0x403F625C, 0x403F621C):
            ret()

    u.hook_add(UC_HOOK_CODE, trace)

    def call(addr, *args):
        u.reg_write(R.UC_ARM64_REG_SP, stack + 0xFF00)
        u.reg_write(R.UC_ARM64_REG_LR, stop)
        for i in range(19, 30):
            u.reg_write(getattr(R, "UC_ARM64_REG_X" + str(i)), 0x70000000 + i)
        for i, v in enumerate(args):
            u.reg_write(getattr(R, "UC_ARM64_REG_X" + str(i)), v)
        u.emu_start(addr, stop, count=100000)
        assert reg("PC") == stop
        assert reg("SP") == stack + 0xFF00
        assert all(reg("X" + str(i)) == 0x70000000 + i for i in range(19, 30))
        return reg("X0")

    u.mem_write(buf, b"\0" * 10 + b"GUARD!")
    code = call(GETTER, buf, buf + 32)
    output = bytes(u.mem_read(buf, 10))
    assert bytes(u.mem_read(buf + 10, 6)) == b"GUARD!"
    assert code == status
    assert bytes(u.mem_read(buf + 32, 3)) == b"C\0\0"
    if patch:
        assert output == b"3.11 P\0\0\0\0"
    call(0x405A7A88, buf, buf + 64, buf + 96)
    assert drawn == [("3.11 P" if patch else (" 3.11" if status != 4 else ""))]
    return {
        "patched": bool(patch),
        "backend_status": status,
        "return": code,
        "getter_bytes": output.hex(),
        "label": "C",
        "submitted_text": drawn,
        "callee_saved_preserved": True,
        "stack_preserved": True,
        "guard_preserved": True,
        "backend_calls": backend,
    }


def main():
    data = (ROOT / "analysis/Z_8_0311/eg2070_0311b0.bi").read_bytes()
    assert hashlib.sha256(data).hexdigest() == EXPECTED
    with tempfile.TemporaryDirectory(prefix="z8-ui-version-") as d:
        d = Path(d)
        (d / "p.S").write_text(ASM)
        subprocess.run(["clang", "--target=aarch64-none-elf", "-c", str(d / "p.S"), "-o", str(d / "p.o")], check=True)
        subprocess.run(
            [
                "ld.lld",
                f"-Ttext={PAYLOAD:#x}",
                "--entry=ui_version",
                "--defsym=stock_version=0x403eddac",
                str(d / "p.o"),
                "-o",
                str(d / "p.elf"),
            ],
            check=True,
        )
        subprocess.run(
            ["llvm-objcopy", "--only-section=.text", "-O", "binary", str(d / "p.elf"), str(d / "p.bin")], check=True
        )
        patch = (d / "p.bin").read_bytes()
    cases = [run(data), *[run(data, patch, s) for s in (0, 2, 4)]]
    out = ROOT / "analysis/z8_ui_version"
    out.mkdir(exist_ok=True)
    (out / "manifest.json").write_text(
        json.dumps(
            {
                "image_sha256": EXPECTED,
                "scope": "Synthetic backend version; actual getter and leading-zero display helper; font/drawing intercepted; no camera",
                "hook": hex(HOOK),
                "probe_payload": hex(PAYLOAD),
                "original_hook": data[HOOK - BASE : HOOK - BASE + 4].hex(),
                "assembly": ASM,
                "payload_hex": patch.hex(),
                "cases": cases,
            },
            indent=2,
        )
        + "\n"
    )
    cs = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN)
    lines = []
    for a, b in [
        (0x405AB414, 0x405AB458),
        (0x405A259C, 0x405A2980),
        (0x405A7A88, 0x405A7B2C),
        (0x403EDDAC, 0x403EDE0C),
        (0x403F2920, 0x403F29F4),
    ]:
        lines.append(f"\n; {a:#x}..{b:#x}")
        lines += [
            f"{i.address:08x} {i.bytes.hex()} {i.mnemonic} {i.op_str}" for i in cs.disasm(data[a - BASE : b - BASE], a)
        ]
    (out / "code_landmarks.asm").write_text("\n".join(lines) + "\n")
    print(json.dumps(cases, indent=2))


if __name__ == "__main__":
    main()
