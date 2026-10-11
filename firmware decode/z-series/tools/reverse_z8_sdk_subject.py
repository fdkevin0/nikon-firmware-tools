#!/usr/bin/env python3
"""Connect Remote SDK subject properties to Z8 setters; never access a camera.

Optional Unicorn runs actual setters and enum lookup instructions. The settings
service is intercepted. For 3.x, typed copying is replaced by valid UINT8 copying.
This verifies local value dispatch, not USB admission or successful application.
"""

import argparse
import csv
import json
import re
import struct
from pathlib import Path

from capstone.arm64 import ARM64_OP_IMM
from reverse_z8_dsp_host import BASE, RET, disassembler, next_return, sha, wide_constants


def instructions(data, address):
    end = next_return(data, address - BASE, 4096)
    return list(disassembler().disasm(data[address - BASE : end], address))


def calls(insns):
    return [i.operands[0].imm for i in insns if i.mnemonic == "bl"]


def find_property(data, prop, code_end):
    found = []
    for match in re.finditer(re.escape(struct.pack("<Q", prop)), data):
        offset = match.start()
        if offset % 8 or offset + 0x90 > len(data):
            continue
        for start, count in ((8, 6), (0x58, 7)):
            pointers = struct.unpack_from(f"<{count}Q", data, offset + start)
            if all(BASE <= p < BASE + code_end and p % 4 == 0 for p in pointers):
                found.append((offset, start, pointers))
    if len(found) != 1:
        raise ValueError(f"Ambiguous property {prop:#x}: {found}")
    offset, pointer_offset, pointers = found[0]
    modern = pointer_offset == 0x58
    setter = pointers[-2 if modern else -1]
    insns = instructions(data, setter)
    direct = calls(insns)
    if len(direct) != (4 if modern else 2) or (modern and direct[0] != direct[3]):
        raise ValueError("Unrecognized setter call shape")
    lookup, setting_service = direct[1:3] if modern else direct
    refs = wide_constants(data, setter - BASE, insns[-1].address - BASE + 4)
    tables = [r["value"] for r in refs if BASE <= r["value"] < BASE + len(data)]
    if len(tables) != 1:
        raise ValueError("Unrecognized conversion table")
    counts = [
        i.operands[1].imm
        for i in insns
        if i.mnemonic == "mov" and i.op_str.startswith("w1,") and i.operands[1].type == ARM64_OP_IMM
    ]
    if len(counts) != 1 or not 1 <= counts[0] <= 16:
        raise ValueError("Unrecognized table extent")
    pairs = [list(struct.unpack_from("<II", data, tables[0] - BASE + 8 * i)) for i in range(counts[0])]
    search_calls = calls(instructions(data, lookup))
    if len(search_calls) != 1:
        raise ValueError("Unrecognized enum search")
    descriptor_insns = instructions(data, pointers[3])
    descriptor_refs = wide_constants(data, pointers[3] - BASE, descriptor_insns[-1].address - BASE + 4)
    enum_bytes = struct.pack(f"<{len(pairs)}I", *(p[0] for p in pairs))
    enum_tables = [
        r["value"]
        for r in descriptor_refs
        if BASE <= r["value"] <= BASE + len(data) - len(enum_bytes)
        and data[r["value"] - BASE : r["value"] - BASE + len(enum_bytes)] == enum_bytes
    ]
    if len(enum_tables) != 1:
        raise ValueError("Descriptor enumeration disagrees with setter table")
    return {
        "property": prop,
        "record_offset": offset,
        "pointer_offset": pointer_offset,
        "function_pointers": list(pointers),
        "setter": setter,
        "descriptor_builder": pointers[3],
        "setter_sha256": sha(b"".join(i.bytes for i in insns)),
        "descriptor_enum_address": enum_tables[0],
        "descriptor_enum_values": [p[0] for p in pairs],
        "table_address": tables[0],
        "table_pairs": pairs,
        "lookup": lookup,
        "search": search_calls[0],
        "setting_service": setting_service,
        "typed_copy": direct[0] if modern else None,
        "cache_addresses": [r["value"] for r in refs if r["value"] >= 0xA00000000],
    }


def emulate_setter(data, item):
    from unicorn import UC_ARCH_ARM64, UC_HOOK_CODE, UC_MODE_ARM, Uc
    from unicorn.arm64_const import (
        UC_ARM64_REG_LR,
        UC_ARM64_REG_PC,
        UC_ARM64_REG_SP,
        UC_ARM64_REG_X0,
        UC_ARM64_REG_X1,
        UC_ARM64_REG_X2,
        UC_ARM64_REG_X3,
    )

    uc = Uc(UC_ARCH_ARM64, UC_MODE_ARM)
    mapped = set()

    def put(address, content):
        for page in range(address & ~4095, (address + len(content) + 4095) & ~4095, 4096):
            if page not in mapped:
                uc.mem_map(page, 4096)
                mapped.add(page)
        uc.mem_write(address, content)

    for address in (item["setter"], item["lookup"], item["search"]):
        insns = instructions(data, address)
        put(address, b"".join(i.bytes for i in insns))
    put(item["table_address"], b"".join(struct.pack("<II", *p) for p in item["table_pairs"]))
    for address in item["cache_addresses"]:
        put(address, bytes(8))
    hooks = [item["setting_service"]]
    if item["typed_copy"]:
        hooks.append(item["typed_copy"])
    for address in hooks:
        put(address, RET)
    stack, stop, descriptor, payload, cache = 0x10000000, 0x20000000, 0x30000000, 0x30001000, 0x30002000
    put(stack, bytes(4096))
    put(stop, RET)
    put(descriptor, bytes(0x100))
    put(descriptor + 0x3C, struct.pack("<I", 2))  # MTP UINT8
    put(descriptor + 0x48, struct.pack("<Q", cache))
    put(descriptor + 0x50, struct.pack("<I", 1))
    put(payload, bytes(8))
    put(cache, bytes(8))
    writes = []

    def hook(machine, address, size, user):
        if address not in hooks:
            return
        if address == item["setting_service"]:
            writes.append([machine.reg_read(UC_ARM64_REG_X0), machine.reg_read(UC_ARM64_REG_X1)])
            result = 0  # Intercepted, no settings store or hardware executed.
        else:
            kind, dest, length, source = [
                machine.reg_read(r) for r in (UC_ARM64_REG_X0, UC_ARM64_REG_X1, UC_ARM64_REG_X2, UC_ARM64_REG_X3)
            ]
            if kind != 2 or length != 1:
                raise ValueError("Unexpected typed copy arguments")
            machine.mem_write(dest, bytes(machine.mem_read(source, 1)))
            result = 1
        machine.reg_write(UC_ARM64_REG_X0, result)
        machine.reg_write(UC_ARM64_REG_PC, machine.reg_read(UC_ARM64_REG_LR))

    uc.hook_add(UC_HOOK_CODE, hook)
    cases = []
    expected = dict(item["table_pairs"])
    for value in range(256):
        writes.clear()
        put(payload, bytes([value]))
        put(cache, b"\xff")
        for address in item["cache_addresses"]:
            put(address, b"\xff")
        uc.reg_write(UC_ARM64_REG_SP, stack + 0xF00)
        uc.reg_write(UC_ARM64_REG_LR, stop)
        uc.reg_write(UC_ARM64_REG_X0, descriptor if item["typed_copy"] else payload)
        uc.reg_write(UC_ARM64_REG_X1, payload)
        uc.emu_start(item["setter"], stop, count=1024)
        if uc.reg_read(UC_ARM64_REG_PC) != stop:
            raise ValueError("Setter did not return within instruction bound")
        response = uc.reg_read(UC_ARM64_REG_X0)
        accepted = value in expected
        dsid = 0x0600069A if item["property"] == 0x1D005 else 0x06001254
        if response != (0x2001 if accepted else 0x201C):
            raise ValueError("Unexpected local setter response")
        if writes != ([[dsid, expected[value]]] if accepted else []):
            raise ValueError("Unexpected settings-service dispatch")
        cache_address = cache if item["typed_copy"] else item["cache_addresses"][0]
        if uc.mem_read(cache_address, 1)[0] != (value if accepted else 255):
            raise ValueError("Unexpected local cache update")
        cases.append({"value": value, "response": response, "settings_calls": list(writes)})
    return {
        "case_count": len(cases),
        "accepted_values": list(expected),
        "dsid": dsid,
        "cases": cases,
        "all_assertions_passed": True,
    }


def run(root, emulate):
    ref = root / "references/remote-sdk-2.0.0"
    sdk = json.loads((ref / "manifest.json").read_text())
    pdf = next(d for d in sdk["documents"] if d["model"] == "Z8")
    if sha((ref / pdf["pdf"]).read_bytes()) != pdf["sha256"]:
        raise ValueError("SDK PDF identity changed")
    with (ref / "indexes/range_values.csv").open(newline="") as f:
        sdk_ranges = [
            r
            for r in csv.DictReader(f)
            if r["model_label"] == "Z 8"
            and r["capability"] in ("kNkMAIDCapability_AFSubjectDetection", "kNkMAIDCapability_MovieAFSubjectDetection")
        ]
    result = {
        "scope": "Local protocol value conversion and settings dispatch, not hardware behavior",
        "tool_sha256": sha(Path(__file__).read_bytes()),
        "emulator_used": emulate,
        "sdk_archive_sha256": sdk["source_sha256"],
        "sdk_z8_pdf": pdf,
        "sdk_z8_ranges": sdk_ranges,
        "versions": [],
    }
    if emulate:
        import unicorn

        result["unicorn_version"] = unicorn.__version__
    out = root / "analysis/z8_sdk_subject"
    out.mkdir(parents=True, exist_ok=True)
    asm = []
    history = json.loads((root / "analysis/z8_history/manifest.json").read_text())
    for version in history["versions"]:
        eg = next(s for s in version["sections"] if s["component"] == "eg")
        path = root / "analysis" / Path(version["filename"]).stem / eg["name"]
        data = path.read_bytes()
        if sha(data) != eg["sha256"]:
            raise ValueError("Firmware identity changed")
        code_end = struct.unpack_from("<Q", data, 0x80B0)[0]
        if struct.unpack_from("<Q", data, 0x670)[0] != BASE + 0x250 or not 0 < code_end < len(data):
            raise ValueError("Unsupported boot mapping")
        entry = {
            "version": version["version"],
            "eg_path": str(path.relative_to(root)),
            "eg_sha256": eg["sha256"],
            "properties": [],
        }
        for prop in (0x1D005, 0x1D006):
            item = find_property(data, prop, code_end)
            if emulate:
                item["emulation"] = emulate_setter(data, item)
            entry["properties"].append(item)
            asm.append(f"\n; Z8 {version['version']} property {prop:#x}, names are analytical\n")
            for label in ("setter", "lookup", "search", "descriptor_builder"):
                asm.append(f"; {label}\n")
                for ins in instructions(data, item[label]):
                    asm.append(f"{ins.address:012x}: {ins.bytes.hex():8s}  {ins.mnemonic:8s} {ins.op_str}\n")
        result["versions"].append(entry)
        if version["version"] == "3.11":
            entry["downstream_landmarks"] = {
                "setting_reader": 0x41012C84,
                "brightness_subject_setting_excerpt": [0x40DA41B4, 0x40DA427C],
                "capability_movie_setting_excerpt": [0x40F3EAD4, 0x40F3EB00],
                "note": "Partial consumers only; no proven path to DSP network selection",
            }
            for label, (start, end) in (
                ("brightness_subject_setting_excerpt", (0x40DA41B4, 0x40DA427C)),
                ("capability_movie_setting_excerpt", (0x40F3EAD4, 0x40F3EB00)),
            ):
                asm.append(f"\n; Z8 3.11 {label}, NOT a complete function\n")
                for ins in disassembler().disasm(data[start - BASE : end - BASE], start):
                    asm.append(f"{ins.address:012x}: {ins.bytes.hex():8s}  {ins.mnemonic:8s} {ins.op_str}\n")
            # Descriptor-backed initialized RAM mapping, not BASE + file offset.
            init_file = struct.unpack_from("<Q", data, 0x8148)[0]
            init_ram = struct.unpack_from("<Q", data, 0x80D8)[0]
            init_size = struct.unpack_from("<Q", data, 0x80D0)[0]
            entry["downstream_source_strings"] = []
            for address, expected_name in (
                (0xA029E6CAC, "CalcFaceBrightness.c"),
                (0xA02A616B0, "CapabilityDataTable.c"),
            ):
                if not init_ram <= address < init_ram + init_size:
                    raise ValueError("Source string outside initialized RAM mapping")
                offset = init_file + address - init_ram
                name = data[offset : offset + 100].split(b"\0", 1)[0].decode("ascii")
                if name != expected_name:
                    raise ValueError("Source string identity mismatch")
                entry["downstream_source_strings"].append({"address": address, "file_offset": offset, "text": name})
        print(version["version"], [p["table_pairs"] for p in entry["properties"]])
    (out / "manifest.json").write_text(json.dumps(result, indent=2) + "\n")
    (out / "code_landmarks.asm").write_text("".join(asm))
    print("Verified", len(result["versions"]), "releases; emulation:", emulate)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("root", type=Path)
    parser.add_argument("--emulate-setters", action="store_true")
    args = parser.parse_args()
    run(args.root, args.emulate_setters)
