#!/usr/bin/env python3
"""Compare the recorded Z f packages with related opaque Nikon containers.

Evidence collection only: does not decrypt, extract sections, or validate CRCs.
Uses the standard library. Input hashes pin the scope of the interpretations.
"""

import argparse
import hashlib
import heapq
import json
import re
import struct
from pathlib import Path

from analyze_zr import legacy_phase_probe

SAMPLES = {
    "Z_f_0301.bin": "bfc1ef4ec1588ef10c85e06bf1bf5bcaa7456e49bb2b7160dd4043ab8934d1a6",
    "Z_f_0121.bin": "0c6ea7c59659bade5c8ca08d1275451e592b2b87e3482373008e63583ab9deda",
    "Z6_3_0200.bin": "b5c08335dc79d3d36d7bad0976434134db8ce160886d1c8c2935f3b185bcdbc9",
    "Z5_2_0120.bin": "96fa8c2d735864c4c612dee498818f2e3b6911458b13ad55befcfe9ffdf35af9",
    "ZR__0111.bin": "de1eb5af56568e4921a0eb5e50942f06a6c00205f76dd9d2a4e42364d7476e93",
}
REGIONS = [
    (0, 0x20, "fixed_first32"),
    (0x20, 0x120, "variable_256_bytes"),
    (0x120, 0x220, "fixed_128_u16"),
    (0x220, 0x240, "reversed_first32"),
    (0x240, 0x260, "variable_32_bytes"),
    (0x260, 0x280, "space_marker"),
    (0x280, 0x290, "candidate_directory_header"),
    (0x290, 0x330, "candidate_five_directory_entries"),
]


def xor_bytes(a, b):
    if len(a) != len(b):
        raise ValueError("XOR operands must have equal lengths")
    return (int.from_bytes(a, "little") ^ int.from_bytes(b, "little")).to_bytes(len(a), "little")


def equal_runs(a, b, minimum=64, limit=12, chunk_size=65536):
    """Compare only overlapping offsets; merge runs across chunk boundaries."""
    if minimum < 1 or limit < 1 or chunk_size < 1:
        raise ValueError("Run and chunk limits must be positive")
    length = min(len(a), len(b))
    equal = 0
    pending = None
    longest = []

    def keep(start, end):
        if end - start >= minimum:
            heapq.heappush(longest, (end - start, start, end))
            if len(longest) > limit:
                heapq.heappop(longest)

    for base in range(0, length, chunk_size):
        end = min(base + chunk_size, length)
        delta = xor_bytes(a[base:end], b[base:end])
        equal += delta.count(0)
        if pending is not None and delta[0] != 0:
            keep(pending, base)
            pending = None
        for match in re.finditer(b"\x00+", delta):
            start = base + match.start()
            if pending is not None:
                start = pending
                pending = None
            stop = base + match.end()
            if stop == end:
                pending = start
            else:
                keep(start, stop)
    if pending is not None:
        keep(pending, length)
    return {
        "compared_bytes": length,
        "equal_bytes": equal,
        "equal_fraction": equal / length if length else None,
        "uncompared_tail_bytes": [len(a) - length, len(b) - length],
        "minimum_run": minimum,
        "longest_equal_runs": [
            {"start": start, "end_exclusive": end, "size": size} for size, start, end in sorted(longest, reverse=True)
        ],
    }


def compare_headers(a, b):
    if min(len(a), len(b)) < 0x330:
        raise ValueError("Need bytes through the candidate directory")
    return [
        {
            "name": name,
            "start": start,
            "end_exclusive": end,
            "different_bytes": sum(x != y for x, y in zip(a[start:end], b[start:end])),
        }
        for start, end, name in REGIONS
    ]


def analyze(directory, output):
    source = directory / "Z_f_0301.bin"
    output_names = ["manifest.json", "header_differences.json"]
    inputs = {(directory / name).resolve() for name in SAMPLES}
    if any((output / name).resolve() in inputs for name in output_names):
        raise ValueError("Output would overwrite an input")
    summaries, headers = {}, {}
    for name, expected in SAMPLES.items():
        path = directory / name
        with path.open("rb") as file:
            digest = hashlib.file_digest(file, "sha256").hexdigest()
            file.seek(0)
            head = file.read(0x330)
        if digest != expected:
            raise ValueError(f"Input hash mismatch: {name}")
        headers[name] = head
        words = struct.unpack_from("<128H", head, 0x120)
        summaries[name] = {
            "size": path.stat().st_size,
            "sha256": digest,
            "size_minus_0x280_mod16": (path.stat().st_size - 0x280) % 16,
            "first32_hex": head[:32].hex(),
            "reverse_copy_valid": head[:32][::-1] == head[0x220:0x240],
            "space_marker_valid": head[0x260:0x280] == b" " * 32,
            "u16_table": {
                "count": len(words),
                "unique": len(set(words)),
                "min": min(words),
                "max": max(words),
                "all_below_0x8000": all(v < 0x8000 for v in words),
            },
        }
    baseline = headers[source.name]
    differences = {}
    for name, head in headers.items():
        if name == source.name:
            continue
        differences[name] = {
            "regions": compare_headers(baseline, head),
            "directory_xor_rows": [
                {
                    "offset": offset,
                    "xor_hex": xor_bytes(baseline[offset : offset + 16], head[offset : offset + 16]).hex(),
                }
                for offset in range(0x280, 0x330, 16)
            ],
        }
    current = source.read_bytes()
    older = (directory / "Z_f_0121.bin").read_bytes()
    comparison = equal_runs(current, older)
    comparison["sources"] = [source.name, "Z_f_0121.bin"]
    # This is a crib, not an independently established plaintext header.
    crib = struct.pack(">4I", 5, 0xD0, 0, 0)
    result = {
        "source": source.name,
        "status": "not_decoded",
        "section_count": None,
        "architecture": None,
        "crc_verified": False,
        "analyzer_sha256": hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        "samples": summaries,
        "header_comparisons": differences,
        "same_model_aligned_comparison": comparison,
        "legacy_phase_probe": legacy_phase_probe(baseline[0x280:0x290], len(current) - 0x260),
        "candidate_directory": {
            "assumptions": "Unverified legacy schema: count=5, header_size=0xd0, reserved=0; XOR transform",
            "encrypted_header_hex": baseline[0x280:0x290].hex(),
            "assumed_plaintext_hex": crib.hex(),
            "conditional_mask_hex": xor_bytes(baseline[0x280:0x290], crib).hex(),
            "candidate_first_section_offset": 0x330,
            "verified": False,
        },
        "limitations": [
            "Ciphertext equality does not establish plaintext equality without an encoding model.",
            "The five-entry directory is a hypothesis; no section names or CRCs are recovered.",
            "A common position-dependent XOR mask is consistent with the evidence but not proven.",
            "File alignment alone cannot identify a cipher or exclude partially encrypted formats.",
        ],
    }
    output.mkdir(parents=True, exist_ok=True)
    (output / "manifest.json").write_text(json.dumps(result, indent=2) + "\n")
    (output / "header_differences.json").write_text(json.dumps(differences, indent=2) + "\n")
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", type=Path, help="Directory containing the five recorded samples")
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    result = analyze(args.directory, args.output)
    comparison = result["same_model_aligned_comparison"]
    print(f"Not decoded; aligned Z f equal-byte fraction: {comparison['equal_fraction']:.6%}")
    print(f"Evidence: {args.output / 'manifest.json'}")


if __name__ == "__main__":
    main()
