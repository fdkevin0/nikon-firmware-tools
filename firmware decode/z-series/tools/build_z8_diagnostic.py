#!/usr/bin/env python3
"""Build and emulate an experimental, offline-only Z8 C 3.11 diagnostic patch.

Only the pinned vendor image is accepted. Module sizes and the stock command
table are preserved. No camera access or flashing is implemented. Requires
clang, ld.lld, llvm-objcopy, Capstone and Unicorn.
"""

import argparse
import binascii
import hashlib
import json
import re
import shutil
import struct
import subprocess
import tempfile
from pathlib import Path

from analyze_firmware import decode_container, transform
from analyze_zr import Z8_EG_SHA256, Z8_SHA256, prefix_tail
from reverse_z8_dsp_host import BASE, disassembler, wide_constants
from z8_diagnostic_protocol import SUBCODE

ROOT = Path(__file__).resolve().parents[1]
SOURCE = Path(__file__).with_name("patches") / "z8_0311_diagnostic.S"
EG_NAME = "eg2070_0311b0.bi"
HOOK = 0x407FE27C
RESUME = HOOK + 4
RESPONSE = 0x407DF0D4
PAYLOAD = 0x412A3200
CAPACITY = 0x200
DISPLACED = bytes.fromhex("ff4301d1")  # sub sp, sp, #0x50
OUTPUT_NAME = "Z_8_0311_diagnostic_EXPERIMENTAL.bin"


def sha(data):
    return hashlib.sha256(data).hexdigest()


def branch(source, target):
    delta = target - source
    if delta % 4 or not -(1 << 27) <= delta < (1 << 27):
        raise ValueError("AArch64 branch is unaligned or out of range")
    return struct.pack("<I", 0x14000000 | ((delta // 4) & 0x3FFFFFF))


def read_stock(encoded):
    if sha(encoded) != Z8_SHA256:
        raise ValueError("Expected the unmodified, pinned Z8 C 3.11 vendor BIN")
    body, directory = decode_container(encoded)
    section = next(s for s in directory["sections"] if s["name"] == EG_NAME)
    start, size = section["container_offset"], section["size"]
    eg = body[start : start + size]
    if sha(eg) != Z8_EG_SHA256:
        raise ValueError("EG name, extent or hash does not match the pinned module")
    if encoded[:20] != hashlib.sha1(body + prefix_tail(eg)).digest():
        raise ValueError("Stock header SHA-1 does not match the recovered construction")
    return body, directory, eg


def placement_evidence(eg, capacity=CAPACITY):
    """Conservative static checks; not proof against computed runtime references."""
    start, end = PAYLOAD - BASE, PAYLOAD - BASE + capacity
    code_offset, code_size, code_address = struct.unpack_from("<3Q", eg, 0x8098)
    if (code_offset, code_size, code_address) != (0x8000, 0x14DEFE4, 0x40168000):
        raise ValueError("Startup code mapping changed")
    if not code_offset <= start < end <= code_offset + code_size:
        raise ValueError("Payload is outside the startup code mapping")
    # Mapping call: w3=0xf, then the same mapper used by stock executable code.
    if eg[0x1330:0x1334] != bytes.fromhex("e30f0032"):
        raise ValueError("Startup code mapping flags changed")
    if eg[0x11431F0:0x11431F4] != bytes.fromhex("c0035fd6"):
        raise ValueError("Last stock function return changed")
    if any(eg[0x11431F4:0x14A1000]):
        raise ValueError("Expected the recorded code-tail zero padding")
    if (PAYLOAD & ~0xFFF) != ((BASE + 0x11431F0) & ~0xFFF):
        raise ValueError("Payload no longer shares the final stock function page")
    if eg[HOOK - BASE : RESUME - BASE] != DISPLACED:
        raise ValueError("Hook instruction changed")
    commands = []
    pos = 0x440EC590 - BASE
    while pos + 48 <= len(eg):
        command = struct.unpack_from("<H", eg, pos)[0]
        if not command:
            break
        commands.append(command)
        pos += 48
    if len(commands) != 182 or len(set(commands)) != 182 or SUBCODE in commands:
        raise ValueError("Private command table changed or the diagnostic code collides")

    references = []
    for pos in range(0, 0x14E7000, 4):
        word = struct.unpack_from("<I", eg, pos)[0]
        if word & 0x7C000000 == 0x14000000:  # B / BL
            immediate, bits, scale = word & 0x3FFFFFF, 26, 4
        elif (
            word & 0xFF000010 == 0x54000000  # B.cond
            or word & 0x7E000000 == 0x34000000  # CBZ / CBNZ
            or word & 0x3B000000 == 0x18000000
        ):  # literal loads
            immediate, bits, scale = (word >> 5) & 0x7FFFF, 19, 4
        elif word & 0x7E000000 == 0x36000000:  # TBZ / TBNZ
            immediate, bits, scale = (word >> 5) & 0x3FFF, 14, 4
        elif word & 0x9F000000 == 0x10000000:  # ADR (not ADRP+ADD)
            immediate = ((word >> 5) & 0x7FFFF) << 2 | ((word >> 29) & 3)
            bits, scale = 21, 1
        else:
            continue
        if immediate & (1 << (bits - 1)):
            immediate -= 1 << bits
        target = BASE + pos + immediate * scale
        if PAYLOAD <= target < PAYLOAD + capacity:
            references.append({"offset": hex(pos), "target": hex(target)})
    wide = [r for r in wide_constants(eg, 0, 0x14E7000) if PAYLOAD <= r["value"] < PAYLOAD + capacity]
    # Include unaligned pointers, then restrict them to the reservation.
    literals = [
        m.start()
        for m in re.finditer(rb"..\x2a\x41\x00\x00\x00\x00", eg, re.S)
        if PAYLOAD <= struct.unpack_from("<Q", eg, m.start())[0] < PAYLOAD + capacity
    ]
    if references or wide or literals:
        raise ValueError(f"Existing references to payload reservation: {references}, {wide}, {literals}")
    return {
        "address": hex(PAYLOAD),
        "reserved_bytes": capacity,
        "code_mapping": {
            "file_offset": hex(code_offset),
            "size": hex(code_size),
            "address": hex(code_address),
            "flags": "0xf",
        },
        "preceding_function_return": "0x412a31f0",
        "same_4k_page_as_stock_function": True,
        "zero_padding_file_range": ["0x11431f4", "0x14a1000"],
        "pc_relative_references": references,
        "complete_mov_references": wide,
        "absolute_64bit_references": literals,
        "stock_subcommand_count": len(commands),
        "limit": "Static placement evidence only; computed references and full boot were not verified.",
    }


def compile_payload(directory):
    programs = {}
    for name in ("clang", "ld.lld", "llvm-objcopy"):
        programs[name] = shutil.which(name)
        if not programs[name]:
            raise ValueError(f"Missing build tool: {name}")
    obj, elf, binary = (directory / name for name in ("diagnostic.o", "diagnostic.elf", "diagnostic.bin"))
    commands = [
        [programs["clang"], "--target=aarch64-none-elf", "-c", str(SOURCE), "-o", str(obj)],
        [
            programs["ld.lld"],
            f"-Ttext={PAYLOAD:#x}",
            "--entry=diagnostic_preflight",
            f"--defsym=stock_response={RESPONSE:#x}",
            f"--defsym=stock_preflight_resume={RESUME:#x}",
            str(obj),
            "-o",
            str(elf),
        ],
        [programs["llvm-objcopy"], "--only-section=.text", "-O", "binary", str(elf), str(binary)],
    ]
    for command in commands:
        subprocess.run(command, check=True, capture_output=True, text=True)
    payload = binary.read_bytes()
    if not payload or len(payload) % 4 or len(payload) > CAPACITY:
        raise ValueError("Payload is empty, unaligned or too large")
    versions = {
        name: subprocess.run([path, "--version"], check=True, capture_output=True, text=True).stdout.splitlines()[0]
        for name, path in programs.items()
    }
    return payload, {
        "tools": versions,
        "source_sha256": sha(SOURCE.read_bytes()),
        "payload_sha256": sha(payload),
        "payload_bytes": len(payload),
    }


def make_image(encoded, payload, extra_edits=(), capacity=CAPACITY):
    body, directory, original_eg = read_stock(encoded)
    section = next(s for s in directory["sections"] if s["name"] == EG_NAME)
    if not payload or len(payload) % 4 or len(payload) > capacity:
        raise ValueError("Invalid diagnostic payload size")
    eg = bytearray(original_eg)
    edits = []
    for address, expected, replacement in (
        (HOOK, DISPLACED, branch(HOOK, PAYLOAD)),
        (PAYLOAD, bytes(len(payload)), payload),
        *extra_edits,
    ):
        offset = address - BASE
        if not expected or len(expected) != len(replacement) or not 0 <= offset < offset + len(expected) <= len(eg) - 2:
            raise ValueError("Patch must replace an existing, equal-length EG range")
        if bytes(eg[offset : offset + len(expected)]) != expected:
            raise ValueError(f"Original bytes do not match at {address:#x}")
        eg[offset : offset + len(expected)] = replacement
        edits.append(
            {
                "address": hex(address),
                "module_offset": hex(offset),
                "expected_hex": expected.hex(),
                "replacement_hex": replacement.hex(),
            }
        )
    struct.pack_into(">H", eg, len(eg) - 2, binascii.crc_hqx(eg[:-2], 0))
    rebuilt = bytearray(body)
    start = section["container_offset"]
    rebuilt[start : start + len(eg)] = eg
    struct.pack_into(">H", rebuilt, len(rebuilt) - 16, binascii.crc_hqx(rebuilt[:-16], 0))
    tail = prefix_tail(original_eg)
    digest = hashlib.sha1(rebuilt + tail).digest()
    product = digest + encoded[20:32] + transform(rebuilt)

    # Reparse independently of the patch offsets. All stock module names/extents
    # are reused from analyze_firmware, not from the other project's shifted names.
    checked, after = decode_container(product)
    if checked != rebuilt or len(product) != len(encoded):
        raise ValueError("Output round trip or package length changed")
    if product[:20] != hashlib.sha1(checked + tail).digest():
        raise ValueError("Output header verification failed")
    for before, now in zip(directory["sections"], after["sections"]):
        if any(before[k] != now[k] for k in ("name", "container_offset", "size")):
            raise ValueError("Module name or extent changed")
        a, n = before["container_offset"], before["size"]
        if before["name"] != EG_NAME and checked[a : a + n] != body[a : a + n]:
            raise ValueError("A non-EG module changed")
    allowed = [
        (int(e["module_offset"], 16), int(e["module_offset"], 16) + len(bytes.fromhex(e["expected_hex"])))
        for e in edits
    ] + [(len(eg) - 2, len(eg))]
    last = 0
    for a, b in sorted(allowed):
        if a < last:
            raise ValueError("Overlapping patch ranges")
        if original_eg[last:a] != eg[last:a]:
            raise ValueError("Unexpected EG modification outside patch and CRC")
        last = b
    if original_eg[last:] != eg[last:]:
        raise ValueError("Unexpected trailing EG modification")
    info = {
        "input_sha256": sha(encoded),
        "output_sha256": sha(product),
        "input_eg_sha256": sha(original_eg),
        "output_eg_sha256": sha(eg),
        "output_size": len(product),
        "module": EG_NAME,
        "edits": edits,
        "module_crcs_valid": len(after["sections"]),
        "package_crc_valid": True,
        "header_sha1_valid": True,
        "module_extents_unchanged": True,
        "other_modules_unchanged": True,
        "header_tail_unchanged": product[20:32] == encoded[20:32],
        "stock_round_trip_exact": encoded[:32] + transform(body) == encoded,
        "patched_header_changed": product[:20] != encoded[:20],
    }
    return product, original_eg, bytes(eg), info


def build(firmware, output):
    from verify_z8_diagnostic import verify

    if output.exists():
        raise ValueError(f"Output directory already exists: {output}")
    encoded = firmware.read_bytes()
    _, _, original = read_stock(encoded)
    evidence = placement_evidence(original)
    output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix=".z8-diagnostic-", dir=output.parent) as temp:
        work = Path(temp)
        payload, compilation = compile_payload(work)
        product, stock, patched, result = make_image(encoded, payload)
        probes = verify(stock, patched, PAYLOAD, len(payload), HOOK)
        result.update(
            {
                "scope": "Experimental offline build; no USB, flashing or full boot validation",
                "placement": evidence,
                "compilation": compilation,
                "verification": probes,
                "output_file": OUTPUT_NAME,
                "usb_commands_sent": 0,
            }
        )
        (work / OUTPUT_NAME).write_bytes(product)
        (work / "manifest.json").write_text(json.dumps(result, indent=2) + "\n")
        lines = [
            "; Hook",
            *(
                f"{i.address:09x} {i.bytes.hex()} {i.mnemonic} {i.op_str}"
                for i in disassembler().disasm(branch(HOOK, PAYLOAD), HOOK)
            ),
            "\n; Payload (last 40 bytes are constant response parameters)",
        ]
        lines.extend(
            f"{i.address:09x} {i.bytes.hex()} {i.mnemonic} {i.op_str}"
            for i in disassembler().disasm(payload[:-40], PAYLOAD)
        )
        lines.append(f"\n; constants: {payload[-40:].hex()}")
        (work / "code_landmarks.asm").write_text("\n".join(lines) + "\n")
        if output.exists():
            raise ValueError(f"Output directory appeared during build: {output}")
        # Publish artifacts only after all checks have passed.
        work.rename(output)
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--firmware", type=Path, default=ROOT / "Z_8_0311.bin")
    parser.add_argument("--output", type=Path, required=True, help="New artifact directory; must not exist")
    args = parser.parse_args()
    try:
        result = build(args.firmware, args.output)
    except (ValueError, OSError, subprocess.CalledProcessError) as error:
        parser.exit(1, f"Build failed: {error}\n")
    print(
        json.dumps(
            {
                "output": str(args.output / OUTPUT_NAME),
                "sha256": result["output_sha256"],
                "verification": {
                    k: result["verification"][k]
                    for k in ("differential_cases", "diagnostic_success_cases", "malformed_cases")
                },
                "usb_commands_sent": 0,
            },
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
