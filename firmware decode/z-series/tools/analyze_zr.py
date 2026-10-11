#!/usr/bin/env python3
"""Record ZR 1.11 container evidence; this is NOT a ZR decryptor.

Standard library only. Optional Z8 comparison validates a recovered SHA-1 check
against that original sample. Capstone, if installed, adds Z8 code excerpts.
Never executes firmware, modifies input, or treats a marker as a decoded package.
"""

import argparse
import csv
import hashlib
import json
import struct
import zlib
from collections import Counter
from pathlib import Path

from analyze_firmware import TABLES, all_offsets, entropy, sha256

ZR_SHA256 = "de1eb5af56568e4921a0eb5e50942f06a6c00205f76dd9d2a4e42364d7476e93"
Z8_SHA256 = "d67413c2ede6b9ce8887175f20700bd9fbad2a973a4820968c45503d15d80d96"
Z8_EG_SHA256 = "f85e0138e2f5e660ece8560de62e0d12cb795e0e14983e50f20b61dce906c46c"
Z8_DECODED_SHA256 = "da0b0843d2e790ed6267f8a7fbbb393f464de4ed1c217964df782bf0a2795b43"


def xor_at(data, index):
    """Apply the legacy keystream at an arbitrary 24-bit phase, without a marker."""
    a, b, c = TABLES
    return bytes(
        v ^ a[(index + i) & 255] ^ b[((index + i) >> 8) & 255] ^ c[((index + i) >> 16) & 255]
        for i, v in enumerate(data)
    )


def directory_header(data, container_size):
    if len(data) < 16:
        return False
    count, header_size, r1, r2 = struct.unpack_from(">4I", data)
    return (
        1 <= count <= (container_size - 48) // 32 and 48 + count * 32 <= header_size <= container_size and r1 == r2 == 0
    )


def legacy_phase_probe(header, container_size):
    """Exhaust all 2**24 phases using the observed legacy reserved-zero fields.

    The first zero byte determines table C; only 2**16 low-index candidates
    need visiting. Carries into C and the 16 MiB wrap are retained. This tests
    the legacy directory schema, not every conceivable new container schema.
    """
    if len(header) < 16:
        raise ValueError("Need a complete 16-byte candidate directory header")
    a, b, c = TABLES
    c_indices = {}
    for index, value in enumerate(c):
        c_indices.setdefault(value, []).append(index)
    zero_matches, valid = [], []
    for low in range(65536):
        i = low + 8
        needed = header[8] ^ a[i & 255] ^ b[(i >> 8) & 255]
        for ci in c_indices.get(needed, []):
            high = (ci - (i >> 16)) & 255
            phase = (high << 16) | low
            if xor_at(header[8:16], phase + 8) != bytes(8):
                continue
            zero_matches.append(phase)
            plain = xor_at(header[:16], phase)
            if directory_header(plain, container_size):
                valid.append({"phase": phase, "header_hex": plain.hex()})
    return {
        "phases_covered": 1 << 24,
        "assumption": "big-endian legacy count/header_size and two zero reserved u32s",
        "reserved_zero_matches": zero_matches,
        "plausible_headers": valid,
    }


def normalized_blocks(data, start, size=256):
    """Count exact blocks modulo a block-wide single-byte XOR constant."""
    counts = Counter()
    for offset in range(start, len(data) - size + 1, size):
        chunk = data[offset : offset + size]
        counts[bytes(v ^ chunk[0] for v in chunk)] += 1
    return {
        "start": start,
        "block_size": size,
        "blocks": sum(counts.values()),
        "unique_normalized_blocks": len(counts),
        "most_frequent_count": max(counts.values(), default=0),
    }


def gzip_probe(data, offset):
    """Bound false-positive validation to 1 MiB input and output per hit."""
    limit = 1024 * 1024
    decoder = zlib.decompressobj(31)
    try:
        plain = decoder.decompress(data[offset : offset + limit], limit)
    except zlib.error as error:
        return {"offset": offset, "status": "invalid", "error": str(error)}
    return {
        "offset": offset,
        "status": "valid_stream" if decoder.eof else "inconclusive_at_limit",
        "decompressed_bytes": len(plain),
    }


def prefix_tail(eg):
    """Translate the Z8 call at EG 0xec77cc and primitive at 0x1032bdc.

    Parameter 0x451 is an observed constant; its semantic name is unknown.
    FirmwareChkLib initializes the eight-byte seed from EG 0x4a2a3f0.
    """
    seed = eg[0x4A2A3F0:0x4A2A3F8]
    table_a = eg[0x4A2A1EE:0x4A2A2EE]
    table_b = eg[0x4A2A2EE:0x4A2A3EE]
    if len(seed) != 8 or len(table_a) != 256 or len(table_b) != 256:
        raise ValueError("Truncated Z8 lookup data")
    value = 0
    for char in b"Z_8":
        value = value * 10 + (char - 48 if 48 <= char <= 57 else char % 10)
    parameter = int.from_bytes((~0x451 & 0xFFFFFFFF).to_bytes(4, "little"), "big")
    folded = (parameter ^ (parameter >> 8) ^ (parameter >> 16) ^ (parameter >> 24)) & 255
    state = table_a[folded]
    step = table_b[value & 255]
    accumulator = step * 0x260
    result = []
    for byte in seed:
        state = (state + accumulator) & 255
        accumulator = (accumulator + step) & 255
        result.append(byte ^ state)
    return bytes(result)


def verify_prefix(encoded, decoded, tail):
    computed = hashlib.sha1(decoded + tail).hexdigest()
    return {
        "algorithm": "SHA-1(decoded_package including trailer || derived 8-byte tail)",
        "tail_hex": tail.hex(),
        "stored": encoded[:20].hex(),
        "computed": computed,
        "valid": computed == encoded[:20].hex(),
        "remaining_prefix_hex": encoded[20:32].hex(),
    }


def compare_z8(firmware, directory, output):
    encoded = firmware.read_bytes()
    eg = (directory / "eg2070_0311b0.bi").read_bytes()
    decoded = (directory / "decoded_package.bin").read_bytes()
    for data, expected in [(encoded, Z8_SHA256), (eg, Z8_EG_SHA256), (decoded, Z8_DECODED_SHA256)]:
        if sha256(data) != expected:
            raise ValueError("Z8 comparison requires the recorded, unmodified 3.11 sample")
    check = verify_prefix(encoded, decoded, prefix_tail(eg))
    if not check["valid"]:
        raise ValueError("Recovered Z8 prefix check does not match")
    masks = []
    for i, old in enumerate(TABLES):
        actual = eg[0x3F63CB0 + i * 256 : 0x3F63DB0 + i * 256]
        delta = set(x ^ y for x, y in zip(actual, old))
        if len(delta) != 1:
            raise ValueError("Z8 XOR tables are not equivalent to the legacy tables")
        masks.append(delta.pop())
    if masks[0] ^ masks[1] ^ masks[2]:
        raise ValueError("Z8 XOR-table masks do not cancel")
    ranges = [
        ("Z8 legacy XOR decoder", 0xEC49F4, 0xEC4AC4),
        ("Z8 package check caller", 0xEC7730, 0xEC7874),
        ("Z8 derived-tail transform", 0x1032BDC, 0x1032CBC),
        ("Z8 checksum state and SHA-1 comparison", 0x1032DE4, 0x10330E4),
    ]
    phase_control = legacy_phase_probe(encoded[64:80], len(encoded) - 32)
    result = {
        "source": firmware.name,
        "input_sha256": sha256(encoded),
        "eg_sha256": sha256(eg),
        "decoded_sha256": sha256(decoded),
        "prefix_check": check,
        "xor_tables_eg_offset": 0x3F63CB0,
        "xor_table_constant_masks": masks,
        "code_ranges": [
            {"name": n, "eg_offset": s, "end_exclusive": e, "address": 0x40160000 + s} for n, s, e in ranges
        ],
        "legacy_phase_probe_control": {
            "plausible_count": len(phase_control["plausible_headers"]),
            "known_phase_32_found": any(row["phase"] == 32 for row in phase_control["plausible_headers"]),
            "note": "Short headers have equivalent phases; full CRC validation remains necessary.",
        },
        "normalized_blocks": normalized_blocks(encoded, 32),
    }
    try:
        from capstone import CS_ARCH_ARM64, Cs
    except ImportError:
        result["disassembly"] = "not generated: capstone unavailable"
    else:
        lines = [
            "; All code below is Z8 3.11 reference code, NOT decrypted ZR code.",
            "; Columns: EG file offset, virtual address, bytes, instruction.",
        ]
        md = Cs(CS_ARCH_ARM64, 0)
        for name, start, end in ranges:
            lines.append("\n; " + name)
            for insn in md.disasm(eg[start:end], 0x40160000 + start):
                lines.append(
                    f"{insn.address - 0x40160000:08x} {insn.address:012x} "
                    f"{insn.bytes.hex()} {insn.mnemonic:9} {insn.op_str}"
                )
        (output / "code_landmarks.asm").write_text("\n".join(lines) + "\n")
        result["disassembly"] = "code_landmarks.asm (Z8 reference only)"
    return result


def analyze(source, output, z8_firmware=None, z8_directory=None):
    data = source.read_bytes()
    if sha256(data) != ZR_SHA256:
        raise ValueError("This analysis is specific to the recorded ZR 1.11 sample")
    artifact_names = ["manifest.json", "entropy.csv", "header.hex.txt", "code_landmarks.asm"]
    if any((output / name).resolve() == source.resolve() for name in artifact_names):
        raise ValueError("Output would overwrite the input firmware")
    output.mkdir(parents=True, exist_ok=True)
    words = struct.unpack_from("<128H", data, 0x120)
    origin_probes = []
    for origin in [0, 0x20, 0x40, 0x60, 0x100, 0x200, 0x240, 0x260, 0x280]:
        header = xor_at(data[0x280:0x290], 0x280 - origin)
        origin_probes.append(
            {"origin": origin, "header_hex": header.hex(), "plausible": directory_header(header, len(data) - 0x260)}
        )
    result = {
        "source": source.name,
        "input_size": len(data),
        "input_sha256": sha256(data),
        "analyzer_sha256": sha256(Path(__file__).read_bytes()),
        "status": "not_decoded",
        "section_count": None,
        "architecture": None,
        "crc_verified": False,
        "input_entropy": entropy(data),
        "space_marker_offsets": list(all_offsets(data, b" " * 32)),
        "prefix_size_candidate": 0x260,
        "payload_start_candidate": 0x280,
        "payload_size_candidate": len(data) - 0x280,
        "payload_size_mod_16": (len(data) - 0x280) % 16,
        "prefix_first32_hex": data[:32].hex(),
        "mirrored_prefix": {
            "source_offset": 0,
            "copy_offset": 0x220,
            "size": 32,
            "reversed_equal": data[:32][::-1] == data[0x220:0x240],
        },
        "u16_region": {
            "offset": 0x120,
            "size": 256,
            "endian": "little",
            "count": len(words),
            "unique": len(set(words)),
            "minimum": min(words),
            "maximum": max(words),
            "all_below_0x8000": all(v < 0x8000 for v in words),
        },
        "legacy_origin_probes": origin_probes,
        "legacy_phase_probe": legacy_phase_probe(data[0x280:0x290], len(data) - 0x260),
        "normalized_blocks": normalized_blocks(data, 0x260),
        "magic_hits": {
            name: list(all_offsets(data, magic))
            for name, magic in [
                ("ELF", b"\x7fELF"),
                ("NISI", b"NISI"),
                ("FDT", bytes.fromhex("d00dfeed")),
                ("gzip", b"\x1f\x8b\x08"),
            ]
        },
        "limits": [
            "No ZR segment or executable has been recovered.",
            "Entropy, alignment and lack of repetitions do not identify AES or RSA.",
            "The two-zero-reserved-fields assumption comes from Z6/Z8.",
            "The 15-bit values and reversed copy have no proven semantic meaning.",
        ],
    }
    if z8_firmware is not None:
        result["z8_reference"] = compare_z8(z8_firmware, z8_directory, output)
    result["gzip_probes"] = [gzip_probe(data, offset) for offset in result["magic_hits"]["gzip"]]
    with (output / "entropy.csv").open("w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["offset", "size", "entropy_bits_per_byte"])
        for offset in range(0, len(data), 65536):
            chunk = data[offset : offset + 65536]
            writer.writerow([offset, len(chunk), f"{entropy(chunk):.10f}"])
    (output / "header.hex.txt").write_text(
        "\n".join(f"{offset:08x}  {data[offset : offset + 16].hex(' ')}" for offset in range(0, 0x300, 16)) + "\n"
    )
    (output / "manifest.json").write_text(json.dumps(result, indent=2) + "\n")
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("firmware", type=Path)
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--z8-firmware", type=Path)
    parser.add_argument("--z8-directory", type=Path)
    args = parser.parse_args()
    if (args.z8_firmware is None) != (args.z8_directory is None):
        parser.error("Use --z8-firmware and --z8-directory together")
    try:
        result = analyze(args.firmware, args.output, args.z8_firmware, args.z8_directory)
    except (ValueError, OSError) as error:
        parser.exit(1, f"Analysis failed: {error}\n")
    print(f"ZR SHA-256: {result['input_sha256']}")
    print("ZR status: NOT DECODED; no verified sections or CRCs")
    print(f"Legacy phase candidates: {len(result['legacy_phase_probe']['plausible_headers'])}")
    if "z8_reference" in result:
        print(f"Z8 reference prefix SHA-1: {result['z8_reference']['prefix_check']['valid']}")


if __name__ == "__main__":
    main()
