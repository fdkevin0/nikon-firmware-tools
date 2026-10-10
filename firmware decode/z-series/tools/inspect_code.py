#!/usr/bin/env python3
"""Record verified code landmarks for Z6 C 3.80; requires Python capstone."""

import argparse
import hashlib
import json
from pathlib import Path
import struct

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM, CS_MODE_THUMB, CS_MODE_MCLASS


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", type=Path)
    args = parser.parse_args()
    root = args.directory
    main_data = (root / "eg1620_038000.bi").read_bytes()
    ex_data = (root / "ex1620_037000.bi").read_bytes()
    expected = [
        (main_data, "1e6348d58750e67372d0a8e363932c57ee9c04d0eb8f62803bcd19812df0d25c"),
        (ex_data, "72f1fb29e24b36b872eec697a486abeff8bcef77f6020fa89473fd014aa18131"),
    ]
    if any(hashlib.sha256(data).hexdigest() != digest for data, digest in expected):
        parser.error("Code offsets are valid only for the recorded Z6 3.80 sample")

    base = 0x10020000
    reset_offset = 0xBC88
    vector_offset = 0x14140
    # Independent consistency checks: reset branch, VBAR literal, vector's reset PC.
    first_word = struct.unpack_from("<I", main_data)[0]
    if first_word != 0xEA002F20 or 8 + (first_word & 0xFFFFFF) * 4 != reset_offset:
        raise ValueError("Unexpected reset branch")
    if struct.unpack_from("<I", main_data, 0xBFD4)[0] != base + vector_offset:
        raise ValueError("VBAR literal does not match the code mapping")
    if struct.unpack_from("<I", main_data, vector_offset + 32)[0] != base + reset_offset:
        raise ValueError("Reset vector does not match the image entry")

    ranges = [
        ("main_entry", main_data, base, 0, 4, CS_MODE_ARM),
        ("main_reset", main_data, base, 0xBC88, 0xBFC8, CS_MODE_ARM),
        ("main_vectors", main_data, base, 0x14140, 0x14160, CS_MODE_ARM),
        ("firmware_check_candidate", main_data, base, 0x1A3BBA, 0x1A3C3E, CS_MODE_THUMB),
        ("sha1_finalize_candidate", main_data, base, 0x1A3C3E, 0x1A3CD8, CS_MODE_THUMB),
        ("file_handling_candidate_near_hdmi_raw", main_data, base, 0x50F156, 0x50F200, CS_MODE_THUMB),
        ("ex_reset", ex_data, 0x08000000, 0x1C4, 0x1F6, CS_MODE_THUMB | CS_MODE_MCLASS),
    ]
    lines = ["Addresses are virtual; offsets are relative to each extracted section.",
             "Candidate names describe hypotheses, not recovered debug symbols."]
    for name, data, mapping, start, end, mode in ranges:
        lines.append(f"\n{name}: file offset 0x{start:x}, base 0x{mapping:08x}")
        for instruction in Cs(CS_ARCH_ARM, mode).disasm(data[start:end], mapping + start):
            lines.append(f"{instruction.address:08x}  {instruction.bytes.hex():10}  "
                         f"{instruction.mnemonic:9} {instruction.op_str}")
    (root / "code_landmarks.asm").write_text("\n".join(lines) + "\n")
    result = {
        "main": {"name": "eg1620_038000.bi", "base": base,
                 "language_candidate": "ARM:LE:32:v7", "entry_arm": base,
                 "reset_arm": base + reset_offset, "vectors_arm": base + vector_offset,
                 "evidence": "Relative entry branch and absolute VBAR/reset-vector references agree",
                 "runtime_copies": [
                     {"source": 0x11E94DD4, "file_offset": 0x1E74DD4,
                      "destination": 0xC1800000, "size": 0x101400},
                     {"source": 0x11F96200, "file_offset": 0x1F76200,
                      "destination": 0xC2A10000, "size": 0xFF8}],
                 "zero_length_copy": {"source": 0x11F97200, "destination": 0xC2A11000,
                                      "size": 0}},
        "ex": {"name": "ex1620_037000.bi", "base": 0x08000000,
               "initial_sp": struct.unpack_from("<I", ex_data)[0],
               "reset_vector_thumb": struct.unpack_from("<I", ex_data, 4)[0],
               "architecture": "ARM M-profile Thumb; exact core not established",
               "boot_copy": {"source": 0x08000000, "destination": 0x20000000,
                             "size": 0x1C4}},
        "unresolved": ["Opaque original 32-byte prefix", "Exact SoC/core models",
                       "_tpj01 and vr instruction sets", "Complete update authentication path"],
    }
    (root / "code_landmarks.json").write_text(json.dumps(result, indent=2) + "\n")
    print("Validated main base/reset/vectors; wrote code_landmarks.asm and .json")


if __name__ == "__main__":
    main()
