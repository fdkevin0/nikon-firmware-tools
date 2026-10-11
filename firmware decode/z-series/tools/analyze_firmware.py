#!/usr/bin/env python3
"""Decode Nikon's legacy XOR container, validate it, and extract analysis artifacts.

No camera access, patching, or network access. Python standard library only.
The three index tables and container layout come from Nikon Hacker's Package.cs;
see nikon_xor_tables.json for attribution. Offsets in manifests are decimal integers.
"""

import argparse
import binascii
import csv
import hashlib
import json
import math
import re
import struct
from collections import Counter
from functools import lru_cache
from pathlib import Path

TABLE_PATH = Path(__file__).with_name("nikon_xor_tables.json")
TABLES = [bytes.fromhex(t) for t in json.loads(TABLE_PATH.read_text())["tables"]]
if len(TABLES) != 3 or any(len(t) != 256 for t in TABLES):
    raise ValueError("Expected three 256-byte XOR tables")
MARKER = b" " * 32


def sha256(data):
    return hashlib.sha256(data).hexdigest()


def entropy(data):
    if not data:
        return 0.0
    return -sum((n / len(data)) * math.log2(n / len(data)) for n in Counter(data).values())


@lru_cache(maxsize=1)
def legacy_keystream():
    """Build the exact 24-bit period using C-level byte translations."""
    a, b, c = TABLES
    translations = [bytes(value ^ key for value in range(256)) for key in range(256)]
    low16 = b"".join(a.translate(translations[key]) for key in b)
    return b"".join(low16.translate(translations[key]) for key in c)


def transform(data):
    """Preserve the 32-byte space marker; XOR the rest using container indices.

    Unlike upstream's full-buffer XOR output, this keeps the original marker so
    the decoded package's trailing CRC can be verified directly.
    """
    key = legacy_keystream()
    chunks = [data[:32]]
    offset = 32
    while offset < len(data):
        phase = offset & 0xFFFFFF
        size = min(1024 * 1024, len(data) - offset, len(key) - phase)
        value = int.from_bytes(data[offset : offset + size], "little")
        mask = int.from_bytes(key[phase : phase + size], "little")
        chunks.append((value ^ mask).to_bytes(size, "little"))
        offset += size
    return b"".join(chunks)


def crc_result(data):
    if len(data) < 2:
        raise ValueError("CRC-bearing region is too short")
    stored = int.from_bytes(data[-2:], "big")
    computed = binascii.crc_hqx(data[:-2], 0)
    return {"stored": stored, "computed": computed, "valid": stored == computed}


def decode_container(encoded):
    if encoded[:32] == MARKER:
        skip = 0
    elif encoded[32:64] == MARKER:
        skip = 32
    else:
        raise ValueError("No legacy Nikon space marker at offset 0 or 0x20")
    decoded = transform(encoded[skip:])
    if len(decoded) < 48:
        raise ValueError("Truncated container header")
    count, header_len, reserved1, reserved2 = struct.unpack_from(">4I", decoded, 32)
    if not 1 <= count <= (len(decoded) - 48) // 32:
        raise ValueError("Invalid section count")
    if not 48 + count * 32 <= header_len <= len(decoded):
        raise ValueError("Invalid directory length")

    sections = []
    names = set()
    for index in range(count):
        name_raw, start, size, r1, r2 = struct.unpack_from(">16s4I", decoded, 48 + index * 32)
        name = name_raw.split(b"\0", 1)[0].decode("ascii")
        if not re.fullmatch(r"[A-Za-z0-9_][A-Za-z0-9_.-]*", name) or name in names:
            raise ValueError(f"Unsafe or duplicate section name: {name!r}")
        names.add(name)
        if start < header_len or size < 2 or start + size > len(decoded):
            raise ValueError(f"Out-of-bounds section: {name}")
        crc = crc_result(decoded[start : start + size])
        if not crc["valid"]:
            raise ValueError(f"Section CRC mismatch: {name}")
        sections.append(
            {
                "name": name,
                "container_offset": start,
                "original_file_offset": skip + start,
                "size": size,
                "payload_size": size - 2,
                "reserved": [r1, r2],
                "crc16": crc,
            }
        )

    end = header_len
    for section in sorted(sections, key=lambda s: s["container_offset"]):
        if section["container_offset"] != end:
            raise ValueError("Sections overlap or have an unexplained gap")
        end += section["size"]
    # This analyzer deliberately accepts only the trailer observed in this sample.
    if len(decoded) - end != 16 or decoded[end + 2 :] != bytes(14):
        raise ValueError("Unsupported package trailer")
    package_crc = crc_result(decoded[: end + 2])
    if not package_crc["valid"]:
        raise ValueError("Package CRC mismatch")
    return decoded, {
        "xor_origin": skip,
        "opaque_prefix_hex": encoded[:skip].hex(),
        "section_count": count,
        "header_size": header_len,
        "reserved": [reserved1, reserved2],
        "sections": sections,
        "package_crc16": package_crc,
        "trailer_offset": end,
        "trailer_hex": decoded[end:].hex(),
    }


def all_offsets(data, needle):
    start = 0
    while True:
        hit = data.find(needle, start)
        if hit < 0:
            return
        yield hit
        start = hit + 1


def analyze(source, output):
    encoded = source.read_bytes()
    decoded, manifest = decode_container(encoded)
    if encoded[: manifest["xor_origin"]] + transform(decoded) != encoded:
        raise ValueError("Round-trip verification failed")
    # Do not let generated artifacts overwrite the input, even via a symlink.
    artifact_names = ["decoded_package.bin", "manifest.json", "entropy.csv"]
    for section in manifest["sections"]:
        artifact_names.extend([section["name"], section["name"] + ".strings.txt"])
    if any((output / name).resolve() == source.resolve() for name in artifact_names):
        raise ValueError("Output would overwrite the input firmware")
    output.mkdir(parents=True, exist_ok=True)
    (output / "decoded_package.bin").write_bytes(decoded)
    manifest.update(
        {
            "source": source.name,
            "input_size": len(encoded),
            "input_sha256": sha256(encoded),
            "input_entropy": entropy(encoded),
            "decoded_sha256": sha256(decoded),
            "round_trip_exact": True,
            "crc_parameters": "CRC-16/XMODEM poly=0x1021 init=0 refin=false refout=false xorout=0; stored big endian",
            "decoded_header_convention": "First 32 space bytes preserved; XOR index starts at container offset 32",
            "xor_table_sha256": sha256(TABLE_PATH.read_bytes()),
            "analyzer_sha256": sha256(Path(__file__).read_bytes()),
        }
    )
    markers = [
        b"SMP T-Kernel",
        b"NIKON Z 6",
        b"NikonBVR",
        b"FirmwareManagement.c",
        b"FirmwareChkLib.c",
        b"MovieRecordApplicationService.c",
        b"PtpMemoryControl.c",
        b"A:\\HDMIRAW.KEY",
        b"Booted ARM926",
        b"LvRaw",
        b"NvmExpress.c",
    ]
    for section in manifest["sections"]:
        start, size = section["container_offset"], section["size"]
        data = decoded[start : start + size]
        (output / section["name"]).write_bytes(data)
        string_count = 0
        with (output / (section["name"] + ".strings.txt")).open("w") as f:
            for match in re.finditer(rb"[ -~]{6,}", data):
                f.write(f"{match.start():08x} {match.group().decode('ascii')}\n")
                string_count += 1
        section.update(
            {
                "sha256": sha256(data),
                "entropy": entropy(data),
                "head_hex": data[:64].hex(),
                "ascii_strings_min6": string_count,
                "markers": {m.decode(): list(all_offsets(data, m)) for m in markers},
            }
        )
    with (output / "entropy.csv").open("w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["region", "offset", "size", "entropy_bits_per_byte"])
        regions = [("input", encoded)] + [
            (s["name"], decoded[s["container_offset"] : s["container_offset"] + s["size"]])
            for s in manifest["sections"]
        ]
        for name, data in regions:
            for offset in range(0, len(data), 65536):
                chunk = data[offset : offset + 65536]
                writer.writerow([name, offset, len(chunk), f"{entropy(chunk):.8f}"])
    (output / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    return manifest


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("firmware", type=Path)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    try:
        result = analyze(args.firmware, args.output)
    except (ValueError, OSError) as error:
        parser.exit(1, f"Analysis failed: {error}\n")
    print(f"Input SHA-256: {result['input_sha256']}")
    print(f"XOR origin: 0x{result['xor_origin']:x}; package CRC and round trip: OK")
    for section in result["sections"]:
        print(
            f"{section['name']:20} {section['size']:10} bytes  "
            f"CRC={section['crc16']['stored']:04x} OK  H={section['entropy']:.6f}"
        )


if __name__ == "__main__":
    main()
