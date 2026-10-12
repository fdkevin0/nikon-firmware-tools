#!/usr/bin/env python3
"""Cryptanalysis and section recovery for Nikon ZR (and modern container) firmware.

Exploits multi-sample keystream reuse (Two-Time Pad / consensus cryptanalysis)
across modern container firmware releases (ZR 1.10/1.11, Z f, Z 6 III, Z 5 II)
to recover directory metadata, platform identifiers, and decrypted sections.
"""

import argparse
import hashlib
import json
import os
import struct
from pathlib import Path

# Modern container header constants
MODERN_MAGIC = bytes.fromhex("420601f57f69308eab4d2a4ea3f486e256d93c6d8f165c968e99e4d20a029fb3")
MODERN_MAGIC_REV = MODERN_MAGIC[::-1]
HEADER_SIZE = 0x280  # 640 bytes

# Canonical model identifiers discovered via cryptanalysis
PLATFORM_MODELS = {
    "1990": "Nikon Z 9",
    "2070": "Nikon Z 8",
    "2100": "Nikon ZR",
    "2160": "Nikon Z 5 II",
    "2185": "Nikon Z 50 II",
    "2200": "Nikon Z f",
    "2300": "Nikon Z 6 III",
}

# Ground-truth directory keystream recovered via multi-model consensus cryptanalysis (208 bytes)
DIR_KEYSTREAM_PREFIX_16 = bytes.fromhex("e14c991dcd6382b68a35f65123f14e4f")
DIR_KEYSTREAM_208 = bytes.fromhex(
    "e14c991dcd6382b68a35f65123f14e4f"
    "d71d0bd2c53a972b7c57c0adf46052b5728bfadd2b7b42ea6f547c82857e208f"
    "a34b7b1fb03e2eb1816e0f9b523e8eedd740505980f0d2aff87e90a47204a86f"
    "ee17c6a5edc9028bbc721916e69b6ea63d74c5e5dbf80c724f383a1e2bed82dd"
    "c6229c6c1e50bd9f0bb4b3dc591cc157685a88a679628989fa992b7bea8ed8fd"
    "783cd458ef2005d10b65974b0d4f61b68d7d919a66ccfca4b4c14c8ab075a53a"
    "32be665762966e2aa4e2cf2e0547a856c771ee13a493216be7a9c1afdf0d1963"
)

# Ground truth layout for Nikon ZR modern container (payload offset relative to 0x280)
ZR_SECTION_SPEC = [
    {
        "index": 0,
        "name": "ex2100_011000.bi",
        "description": "Socionext / ARM Thumb microcontroller firmware",
        "payload_offset": 0x000000B0,
        "size": 524290,
    },
    {
        "index": 1,
        "name": "_tpj01_0210.bin",
        "description": "Touch panel controller firmware",
        "payload_offset": 0x000800B2,
        "size": 57346,
    },
    {
        "index": 2,
        "name": "eg2100_0111b0.bi",
        "description": "EXPEED 7 AArch64 Main OS",
        "payload_offset": 0x0008E0B4,
        "size": 88361204,
    },
    {
        "index": 3,
        "name": "vr2100_010100.bi",
        "description": "Vibration Reduction microcontroller firmware",
        "payload_offset": 0x054D29BC,
        "size": 838664,
    },
    {
        "index": 4,
        "name": "li2100_0111b0.bi",
        "description": "Linux 4.14 kernel + CPIO rootfs + DTBs (NISI container)",
        "payload_offset": 0x0559F5A9,
        "size": 27377560,
    },
]


def parse_container_header(data: bytes) -> dict:
    """Validate and parse the 0x280 modern container header."""
    if len(data) < HEADER_SIZE:
        raise ValueError(f"Header too short: {len(data)} bytes (expected {HEADER_SIZE})")

    magic = data[:0x20]
    is_valid_magic = (magic == MODERN_MAGIC)
    rsa_sig = data[0x20:0x120]
    table_128_raw = data[0x120:0x220]
    magic_rev = data[0x220:0x240]
    is_valid_rev = (magic_rev == MODERN_MAGIC_REV)
    checksum = data[0x240:0x260]
    spaces = data[0x260:0x280]
    is_valid_spaces = (spaces == b" " * 32)

    integers_128 = parse_128_integers(table_128_raw)

    return {
        "valid_magic": is_valid_magic,
        "valid_reverse_guard": is_valid_rev,
        "valid_spaces_marker": is_valid_spaces,
        "rsa_signature_sha256": hashlib.sha256(rsa_sig).hexdigest(),
        "table_128_sha256": hashlib.sha256(table_128_raw).hexdigest(),
        "table_128_integers": integers_128,
        "payload_checksum_256": checksum.hex(),
    }


def parse_128_integers(data: bytes) -> list:
    """Parse and validate the 128 15-bit integers at 0x120..0x220."""
    if len(data) != 256:
        raise ValueError(f"Expected 256 bytes for 128 integers, got {len(data)}")
    ints = list(struct.unpack("<128H", data))
    for i, val in enumerate(ints):
        if val >= 32768:
            raise ValueError(f"Integer {i} (0x{val:04x}) exceeds 15-bit maximum (32767)")
    return ints


def recover_directory_entries(zr_data: bytes, zf_data: bytes | None = None) -> list:
    """Recover section metadata from the 0x280 directory table."""
    if len(zr_data) < HEADER_SIZE + 0xD0:
        raise ValueError("Firmware too short for directory table")

    zr_dir = zr_data[HEADER_SIZE : HEADER_SIZE + 0xD0]

    # Verify header mask (count=5, header_len=0xd0, reserved=0,0)
    hdr_plain = struct.pack(">4I", 5, 0xD0, 0, 0)
    ks_hdr = bytes(a ^ b for a, b in zip(zr_dir[:16], hdr_plain))
    if ks_hdr != DIR_KEYSTREAM_PREFIX_16:
        raise ValueError("Directory prefix mask mismatch")

    sections = []
    for spec in ZR_SECTION_SPEC:
        idx = spec["index"]
        off = 16 + idx * 32
        entry_raw = zr_dir[off : off + 32]
        c_name = entry_raw[:16]
        c_off = entry_raw[16:20]
        c_len = entry_raw[20:24]
        c_res = entry_raw[24:32]

        file_offset = HEADER_SIZE + spec["payload_offset"]
        sections.append({
            "index": idx,
            "name": spec["name"],
            "description": spec["description"],
            "payload_offset": spec["payload_offset"],
            "file_offset": file_offset,
            "size": spec["size"],
            "raw_name_cipher": c_name.hex(),
            "raw_off_cipher": c_off.hex(),
            "raw_len_cipher": c_len.hex(),
            "reserved_keystream": c_res.hex(),
        })

    return sections

def parse_modern_directory(fw_data: bytes) -> dict:
    """Dynamically decrypt and parse the directory table for any modern container firmware.
    
    Supports Nikon ZR, Z f, Z 6 III, Z 5 II, and Z 50 II.
    """
    if len(fw_data) < HEADER_SIZE + 0xD0:
        raise ValueError(f"Firmware too short for modern directory ({len(fw_data)} bytes)")

    c_dir = fw_data[HEADER_SIZE : HEADER_SIZE + 0xD0]
    plain_hdr = bytes(a ^ b for a, b in zip(c_dir[:16], DIR_KEYSTREAM_208[:16]))
    count, hdr_len, r1, r2 = struct.unpack(">4I", plain_hdr)

    if count not in (4, 5) or hdr_len not in (0xB0, 0xD0):
        raise ValueError(f"Unexpected modern directory parameters: count={count}, hdr_len=0x{hdr_len:x}")

    sections = []
    detected_model = None

    for i in range(count):
        entry_c = c_dir[16 + i * 32 : 16 + (i + 1) * 32]
        entry_ks = DIR_KEYSTREAM_208[16 + i * 32 : 16 + (i + 1) * 32]
        entry_p = bytes(a ^ b for a, b in zip(entry_c, entry_ks))

        name = entry_p[:16].split(b"\x00", 1)[0].decode("latin1", errors="replace")
        payload_off, size = struct.unpack(">2I", entry_p[16:24])
        reserved = entry_p[24:32]

        # Infer component description
        desc = "Unknown component"
        if name.startswith("ex"):
            desc = "Microcontroller (MCU) bootloader / power management"
            # Extract 4-digit model code
            model_code = name[2:6]
            if model_code in PLATFORM_MODELS:
                detected_model = f"{model_code} ({PLATFORM_MODELS[model_code]})"
        elif name.startswith("_tp"):
            desc = "Touch panel controller firmware"
        elif name.startswith("eg"):
            desc = "EXPEED 7 AArch64 Main OS"
        elif name.startswith("vr"):
            desc = "Vibration Reduction (IBIS / VR) controller firmware"
        elif name.startswith("li"):
            desc = "Linux kernel + CPIO rootfs + DTBs (NISI container)"

        sections.append({
            "index": i,
            "name": name,
            "description": desc,
            "payload_offset": payload_off,
            "file_offset": HEADER_SIZE + payload_off,
            "size": size,
            "reserved_valid": reserved == bytes(8),
        })

    return {
        "section_count": count,
        "header_length": hdr_len,
        "platform_model": detected_model or "Unknown modern container",
        "sections": sections,
    }


def decrypt_section_0(zr_data: bytes, z8_reference: bytes | None = None) -> tuple[bytes, dict]:
    """Partially decrypt Section 0 (ex2100_011000.bi) using recovered keystream.
    
    Returns (decrypted_bytes, recovery_stats).
    """
    sec0_spec = ZR_SECTION_SPEC[0]
    file_off = HEADER_SIZE + sec0_spec["payload_offset"]
    c = zr_data[file_off : file_off + sec0_spec["size"]]
    n = len(c)

    keystream = [None] * n

    # Span 1: 0x4000..0x20000 (112 KB zero padding)
    for i in range(0x4000, 0x20000):
        keystream[i] = c[i]

    # Span 2: 0x5c000..0x7ff00 (143.75 KB zero padding)
    for i in range(0x5c000, 0x7FF00):
        keystream[i] = c[i]

    # Known copyright string at 0x370e
    target_str = b"Firmware Ex Copyright Nikon Corp."
    for j, b in enumerate(target_str):
        if 0x370E + j < n:
            keystream[0x370E + j] = c[0x370E + j] ^ b

    # Merge reference code if available
    ref_matched = 0
    if z8_reference and len(z8_reference) >= n:
        for i in range(n):
            if keystream[i] is None and z8_reference[i] == 0:
                keystream[i] = c[i]
                ref_matched += 1

    # Decrypt
    decrypted = bytearray(n)
    recovered_count = 0
    for i in range(n):
        if keystream[i] is not None:
            decrypted[i] = c[i] ^ keystream[i]
            recovered_count += 1
        else:
            decrypted[i] = 0x00  # unrecovered placeholder

    stats = {
        "total_bytes": n,
        "recovered_bytes": recovered_count,
        "recovery_ratio": recovered_count / n,
        "continuous_spans_bytes": (0x20000 - 0x4000) + (0x7FF00 - 0x5c000),
        "reference_matched_bytes": ref_matched,
    }
    return bytes(decrypted), stats


def decrypt_section_0_consensus(
    zr_data: bytes,
    z8_reference: bytes | None = None,
    z9_reference: bytes | None = None,
    peer_ciphertexts: list[bytes] | None = None,
) -> tuple[bytes, dict]:
    """Perform multi-model consensus decryption on Section 0 (ex2100_010100.b).
    
    Returns (decrypted_bytes, recovery_stats).
    """
    file_off = 0x350
    size = 524290
    if len(zr_data) < file_off + size:
        raise ValueError("Firmware data too short for Section 0")

    c = zr_data[file_off : file_off + size]
    n = len(c)
    keystream = [None] * n

    # 1. Definite zero padding spans
    for i in range(0x394C, 0x20000):
        keystream[i] = c[i]
    for i in range(0x5C13C, 0x7FFF0):
        keystream[i] = c[i]
    for i in range(0x7FFF0, 0x7FFFE):
        keystream[i] = c[i]

    # 2. Immutable Cortex-M bootloader routines
    boot_spans = [(0x0000, 0x02E2), (0x02E3, 0x060C), (0x0636, 0x0AA0), (0x0B07, 0x0E58)]
    if z8_reference and z9_reference:
        for s_start, s_end in boot_spans:
            for i in range(s_start, min(s_end, n)):
                if z8_reference[i] == z9_reference[i]:
                    keystream[i] = c[i] ^ z8_reference[i]
    elif z8_reference:
        for s_start, s_end in boot_spans:
            for i in range(s_start, min(s_end, n)):
                keystream[i] = c[i] ^ z8_reference[i]

    # 3. Known string literals & padding
    target_str = b"Firmware Ex Copyright Nikon Corp."
    for j, b in enumerate(target_str):
        if 0x370E + j < n:
            keystream[0x370E + j] = c[0x370E + j] ^ b
    for i in range(0x3730, 0x3740):
        if i < n:
            keystream[i] = c[i]

    # 4. Multi-peer consensus
    if peer_ciphertexts and z8_reference and z9_reference:
        from collections import Counter
        all_samples = [c] + [p for p in peer_ciphertexts if len(p) >= n]
        for i in range(n):
            if keystream[i] is None and z8_reference[i] == z9_reference[i]:
                counts = Counter(s[i] for s in all_samples)
                top_b, top_cnt = counts.most_common(1)[0]
                if top_cnt >= 3 and c[i] == top_b:
                    keystream[i] = c[i] ^ z8_reference[i]

    # 5. Reference zero matching
    ref_matched = 0
    if z8_reference and len(z8_reference) >= n:
        for i in range(n):
            if keystream[i] is None and z8_reference[i] == 0:
                keystream[i] = c[i]
                ref_matched += 1

    decrypted = bytearray(n)
    recovered_count = 0
    for i in range(n):
        if keystream[i] is not None:
            decrypted[i] = c[i] ^ keystream[i]
            recovered_count += 1
        else:
            decrypted[i] = 0x00

    stats = {
        "total_bytes": n,
        "recovered_bytes": recovered_count,
        "recovery_ratio": recovered_count / n,
        "zero_spans_bytes": (0x20000 - 0x394C) + (0x7FFF0 - 0x5C13C) + 14,
        "reference_matched_bytes": ref_matched,
    }
    return bytes(decrypted), stats


def compare_zr_versions(zr10_data: bytes, zr11_data: bytes) -> dict:
    """Perform differential cryptanalysis and section comparison between ZR 1.10 and ZR 1.11."""
    if len(zr10_data) != len(zr11_data):
        raise ValueError(f"ZR size mismatch: {len(zr10_data)} vs {len(zr11_data)}")

    total_len = len(zr10_data)
    total_match = sum(1 for a, b in zip(zr10_data, zr11_data) if a == b)

    dir10 = parse_modern_directory(zr10_data)
    dir11 = parse_modern_directory(zr11_data)

    section_diffs = []
    for s10, s11 in zip(dir10["sections"], dir11["sections"]):
        idx = s10["index"]
        fo = s10["file_offset"]
        sz = s10["size"]
        c10 = zr10_data[fo : fo + sz]
        c11 = zr11_data[fo : fo + sz]
        match_count = sum(1 for a, b in zip(c10, c11) if a == b)
        diff_count = sz - match_count
        section_diffs.append({
            "index": idx,
            "name_110": s10["name"],
            "name_111": s11["name"],
            "description": s10["description"],
            "size": sz,
            "file_offset": fo,
            "matched_bytes": match_count,
            "differing_bytes": diff_count,
            "match_ratio": match_count / sz if sz else 1.0,
            "is_identical": diff_count == 0,
        })

    return {
        "total_size": total_len,
        "overall_matched_bytes": total_match,
        "overall_differing_bytes": total_len - total_match,
        "overall_match_ratio": total_match / total_len,
        "section_comparisons": section_diffs,
    }


def decrypt_section_2_cross_offset(
    zr_data: bytes,
    zf_data: bytes,
    z8_eg_data: bytes,
    z9_eg_data: bytes | None = None,
    z6_data: bytes | None = None,
    z5_data: bytes | None = None,
    max_bytes: int | None = None,
) -> tuple[bytes, dict]:
    """Decrypt Section 2 (eg2100_011130.b) via cross-offset multi-camera consensus.

    Exploits the static file-offset stream cipher keystream and the constant shift:
    Delta_file = 0x000BFF70 - 0x0008E354 = 0x31C1C (203,804 bytes).

    Returns (decrypted_bytes, recovery_stats).
    """
    file_off = 0x000BFF70
    sec2_size = 88157708
    delta = 0x000BFF70 - 0x0008E354  # 0x31C1C

    limit = sec2_size
    if max_bytes:
        limit = min(limit, max_bytes)
    limit = min(limit, len(zr_data) - file_off, len(zf_data) - file_off, len(z8_eg_data) - delta)

    c_zr = zr_data[file_off : file_off + limit]
    c_zf = zf_data[file_off : file_off + limit]
    p_z8 = z8_eg_data[delta : delta + limit]
    p_z9 = z9_eg_data[delta : delta + limit] if z9_eg_data else None
    c_z6 = z6_data[file_off : file_off + limit] if z6_data else None
    c_z5 = z5_data[file_off : file_off + limit] if z5_data else None

    keystream = [None] * limit
    code_count = 0
    zero_count = 0

    for i in range(limit):
        is_ref_invariant = (p_z9 is None) or (p_z8[i] == p_z9[i])
        if not is_ref_invariant:
            continue

        peer_match = True
        if c_z6 and c_z5:
            peer_match = (c_zf[i] == c_z6[i]) or (c_zf[i] == c_z5[i]) or (c_z6[i] == c_z5[i])
        elif c_z6:
            peer_match = (c_zf[i] == c_z6[i])

        if peer_match:
            ks_byte = c_zf[i] ^ p_z8[i]
            keystream[i] = ks_byte
            if p_z8[i] == 0:
                zero_count += 1
            else:
                code_count += 1

    decrypted = bytearray(limit)
    recovered_total = 0
    for i in range(limit):
        if keystream[i] is not None:
            decrypted[i] = c_zr[i] ^ keystream[i]
            recovered_total += 1
        else:
            decrypted[i] = 0x00

    stats = {
        "analyzed_bytes": limit,
        "recovered_bytes": recovered_total,
        "recovery_ratio": recovered_total / limit if limit else 0.0,
        "recovered_code_data_bytes": code_count,
        "recovered_zero_padding_bytes": zero_count,
        "file_offset": file_off,
        "peer_offset_delta": delta,
    }
    return bytes(decrypted), stats


def parse_fdt_resilient(data: bytes) -> tuple[dict, str]:
    """Resiliently parse complete or partial Device Tree Blob into JSON metadata and DTS text."""
    if len(data) < 40:
        return {}, "// FDT data too short for v17 header\n"
    magic, total, off_struct, off_strings, off_rsv, version, comp, cpu, nstrings, nstruct = struct.unpack_from(">10I", data[:40])
    if magic != 0xD00DFEED:
        return {}, "// Invalid FDT header magic\n"

    structure = data[off_struct : off_struct + nstruct] if nstruct and off_struct + nstruct <= len(data) else data[off_struct:]
    strings = data[off_strings : off_strings + nstrings] if nstrings and off_strings + nstrings <= len(data) else data[off_strings:] if off_strings < len(data) else b""

    stack, nodes, lines, pos = [], {}, ["/dts-v1/;", "", f"// FDT v{version} (totalsize: {total} B)", "/ {"], 0
    while pos + 4 <= len(structure):
        token = struct.unpack(">I", structure[pos : pos + 4])[0]
        pos += 4
        if token == 1:  # OF_DT_BEGIN_NODE
            try:
                end = structure.index(0, pos)
                name = structure[pos:end].decode("ascii", errors="replace")
                pos = (end + 4) & ~3
                indent = "    " * (len(stack) + 1)
                lines.append(f"{indent}{name or '/'} {{")
                stack.append(name)
                path = "/" + "/".join(s for s in stack if s)
                nodes[path] = {}
            except Exception:
                break
        elif token == 2:  # OF_DT_END_NODE
            if not stack:
                break
            stack.pop()
            indent = "    " * (len(stack) + 1)
            lines.append(f"{indent}}};")
        elif token == 3:  # OF_DT_PROP
            if pos + 8 > len(structure):
                break
            size, nameoff = struct.unpack(">2I", structure[pos : pos + 8])
            pos += 8
            raw = structure[pos : pos + size]
            pos = (pos + size + 3) & ~3
            name = f"prop_{nameoff}"
            if strings and nameoff < len(strings):
                try:
                    end_str = strings.index(0, nameoff)
                    name = strings[nameoff:end_str].decode("ascii", errors="replace")
                except Exception:
                    pass
            prop = {"hex": raw.hex()}
            if raw and raw[-1] == 0 and all(c == 0 or 32 <= c < 127 for c in raw):
                val_str = raw[:-1].decode("ascii", errors="replace")
                value = f'"{val_str}"'
            elif raw and len(raw) % 4 == 0:
                cells = [c[0] for c in struct.iter_unpack(">I", raw)]
                value = "<" + " ".join(f"0x{c:x}" for c in cells) + ">"
            else:
                value = "[" + raw.hex(" ") + "]"
            path = "/" + "/".join(s for s in stack if s)
            if path in nodes:
                nodes[path][name] = prop
            indent = "    " * (len(stack) + 1)
            lines.append(f"{indent}{name} = {value};")
        elif token == 4:  # OF_DT_NOP
            continue
        elif token == 9:  # OF_DT_END
            break
        else:
            indent = "    " * (len(stack) + 1)
            lines.append(f"{indent}// [Encrypted payload continuation at structure offset +0x{pos:x}]")
            break

    while stack:
        stack.pop()
        indent = "    " * (len(stack) + 1)
        lines.append(f"{indent}}};")
    lines.append("};")

    return {
        "version": version,
        "totalsize": total,
        "nodes": nodes,
    }, "\n".join(lines) + "\n"


def decrypt_section_4_consensus(
    zr_data: bytes,
    z6_data: bytes | None = None,
    z8_li_data: bytes | None = None,
    z9_li_data: bytes | None = None,
    dtb_reference: bytes | None = None,
    max_bytes: int | None = None,
) -> tuple[bytes, dict]:
    """Decrypt Section 4 (li2100_011130.b) via cross-camera VR padding bridge and kernel zero-spans.

    Exploits the 0xFF flash erase padding of Z 6 III Section 3 (VR MCU) spanning the first
    468,683 bytes (0x726CB) of Section 4 to recover 100% ground-truth Linux kernel code,
    multi-peer zero-spans across the remainder of the container, inter-subimage zero padding,
    and Device Tree Blob consensus.

    Also recovers the pure NISI multi-image container header at file offset 0x0559F810,
    mapping all 4 sub-images (kernel, CPIO rootfs, and 2 Device Tree Blobs).

    Returns (decrypted_bytes, recovery_stats).
    """
    file_off = 0x0559F930
    nisi_file_off = 0x0559F810
    sec4_size = min(27377560, len(zr_data) - file_off)
    if max_bytes:
        sec4_size = min(sec4_size, max_bytes)

    if dtb_reference is None:
        ref_path = Path("firmware decode/z-series/analysis/z8_history/versions/Z_8_0200/linux/device_tree_1.dtb")
        if ref_path.exists():
            dtb_reference = ref_path.read_bytes()

    decrypted = bytearray(sec4_size)
    keystream = [None] * sec4_size
    lead_recovered = 0
    zero_spans_recovered = 0

    # 1. Lead bridge via Z 6 III VR 0xFF flash padding
    vr_lead = 0
    if z6_data and len(z6_data) > file_off:
        vr_lead = min(0x056120D0 - file_off, sec4_size, len(z6_data) - file_off)
        for i in range(vr_lead):
            ks_b = z6_data[file_off + i] ^ 0xFF
            keystream[i] = ks_b
            decrypted[i] = zr_data[file_off + i] ^ ks_b
            lead_recovered += 1

    # 2. Kernel common zero spans beyond vr_lead
    k_start = 0x6E0
    if z8_li_data and z9_li_data:
        k_len = min(6455296, len(z8_li_data) - 0x800, len(z9_li_data) - 0x800)
        start_idx = max(0, vr_lead - k_start) if z6_data else 0
        for i in range(start_idx, k_len):
            idx = k_start + i
            if idx < sec4_size:
                if z8_li_data[0x800 + i] == 0 and z9_li_data[0x800 + i] == 0:
                    keystream[idx] = zr_data[file_off + idx]
                    decrypted[idx] = 0x00
                    zero_spans_recovered += 1

    # 3. NISI container inter-subimage zero padding spans
    nisi_pad_recovered = 0
    # Span 1: End of Kernel zero padding (2,040 bytes at NISI 6,103,048 .. 6,105,088)
    k_pad_off = 6103048 - 288
    if k_pad_off + 2040 <= sec4_size:
        for i in range(2040):
            idx = k_pad_off + i
            if keystream[idx] is None:
                keystream[idx] = zr_data[file_off + idx]
                decrypted[idx] = 0x00
                nisi_pad_recovered += 1

    # Span 2: End of Rootfs zero padding (1,773 bytes at NISI 27,367,699 .. 27,369,472)
    r_pad_off = 27367699 - 288
    if r_pad_off + 1773 <= sec4_size:
        for i in range(1773):
            idx = r_pad_off + i
            if keystream[idx] is None:
                keystream[idx] = zr_data[file_off + idx]
                decrypted[idx] = 0x00
                nisi_pad_recovered += 1

    # 4. Rootfs header recovery (Gzip RFC 1952 at sector 2981 / payload 6,104,800)
    rootfs_dec_off = 6105088 - 288
    rootfs_recovered = 0
    rootfs_info = {}
    if rootfs_dec_off + 10 <= sec4_size:
        gz_lead = bytes.fromhex("1f8b0800")
        for i in range(4):
            idx = rootfs_dec_off + i
            if keystream[idx] is None:
                keystream[idx] = zr_data[file_off + idx] ^ gz_lead[i]
                decrypted[idx] = gz_lead[i]
                rootfs_recovered += 1
        for i, b in [(8, 0x02), (9, 0x03)]:
            idx = rootfs_dec_off + i
            if keystream[idx] is None:
                keystream[idx] = zr_data[file_off + idx] ^ b
                decrypted[idx] = b
                rootfs_recovered += 1

        rootfs_info = {
            "offset": rootfs_dec_off,
            "byte_size": 21262611,
            "format": "gzip_cpio_archive",
            "compression_method": "deflate",
            "os": "unix",
            "zero_padding_bytes": 1773,
            "header_magic": "1f8b0800",
        }

    # Parse recovered kernel header at 0x6e0 if available
    kernel_info = {}
    if sum(1 for k in keystream if k is not None) >= 0x720:
        raw_hdr = decrypted[0x6E0 : 0x6E0 + 64]
        magic = bytes(raw_hdr[0x38:0x3C])
        if magic == b"ARM\x64":
            img_sz, flags = struct.unpack("<2Q", raw_hdr[0x10:0x20])
            kernel_info = {
                "valid_magic": True,
                "magic": "ARM\\x64",
                "image_size": img_sz,
                "flags": hex(flags),
                "kernel_offset": 0x6E0,
                "stext_offset": 0xEE0,
            }

    # Recover NISI container header at 0x0559F810
    nisi_info = {}
    if z6_data and len(z6_data) >= nisi_file_off + 96 and len(zr_data) >= nisi_file_off + 96:
        nisi_raw = bytes(zr_data[nisi_file_off + i] ^ z6_data[nisi_file_off + i] ^ 0xFF for i in range(96))
        if nisi_raw[:4] == b"NISI":
            from reverse_expeed7_system import parse_nisi_container
            nisi_info = parse_nisi_container(nisi_raw)

    # 5. Device Tree Blob (DTB) zero-padding spans and FDT headers
    dtb_recovered = 0
    dtb_info = {}

    # DTB 1: 3,845 bytes at NISI offset 27,369,472 (decrypted offset 27,369,184)
    dtb1_dec_off = 27369472 - 288
    if dtb1_dec_off + 4096 <= sec4_size:
        # Zero padding after DTB 1 (251 bytes: 3845..4096)
        for i in range(3845, 4096):
            idx = dtb1_dec_off + i
            if keystream[idx] is None:
                keystream[idx] = zr_data[file_off + idx]
                decrypted[idx] = 0x00
                dtb_recovered += 1
                nisi_pad_recovered += 1

        # FDT header magic and totalsize (0xD00DFEED, 0x00000F05)
        dtb1_hdr = bytes.fromhex("d00dfeed00000f05")
        for i in range(len(dtb1_hdr)):
            idx = dtb1_dec_off + i
            if keystream[idx] is None:
                keystream[idx] = zr_data[file_off + idx] ^ dtb1_hdr[i]
                decrypted[idx] = dtb1_hdr[i]
                dtb_recovered += 1

        # FDT structural constants: off_dt_struct=56, off_mem_rsvmap=40, version=17, comp=16, cpu=0
        fdt_consts = struct.pack(">5I", 56, 40, 17, 16, 0)
        # off_dt_struct at 0x08, off_mem_rsvmap at 0x10..0x20
        for i, b in enumerate(struct.pack(">I", 56)):
            idx = dtb1_dec_off + 8 + i
            if keystream[idx] is None:
                keystream[idx] = zr_data[file_off + idx] ^ b
                decrypted[idx] = b
                dtb_recovered += 1
        for i, b in enumerate(struct.pack(">4I", 40, 17, 16, 0)):
            idx = dtb1_dec_off + 16 + i
            if keystream[idx] is None:
                keystream[idx] = zr_data[file_off + idx] ^ b
                decrypted[idx] = b
                dtb_recovered += 1

        # mem_rsvmap (16 bytes of zeros at 0x28..0x38)
        for i in range(0x28, 0x38):
            idx = dtb1_dec_off + i
            if keystream[idx] is None:
                keystream[idx] = zr_data[file_off + idx]
                decrypted[idx] = 0x00
                dtb_recovered += 1

    # DTB 2: 3,168 bytes at NISI offset 27,373,568 (decrypted offset 27,373,280)
    dtb2_dec_off = 27373568 - 288
    if dtb2_dec_off + 4096 <= sec4_size:
        # Zero padding after DTB 2 (928 bytes: 3168..4096)
        for i in range(3168, 4096):
            idx = dtb2_dec_off + i
            if keystream[idx] is None:
                keystream[idx] = zr_data[file_off + idx]
                decrypted[idx] = 0x00
                dtb_recovered += 1
                nisi_pad_recovered += 1

        # If 3,168-byte DTB reference is available, recover complete DTB 2 payload
        if dtb_reference and len(dtb_reference) == 3168:
            for i in range(3168):
                idx = dtb2_dec_off + i
                if keystream[idx] is None:
                    keystream[idx] = zr_data[file_off + idx] ^ dtb_reference[i]
                    decrypted[idx] = dtb_reference[i]
                    dtb_recovered += 1
        else:
            # Fallback to header and rsvmap
            dtb2_hdr = bytes.fromhex("d00dfeed00000c60")
            for i in range(len(dtb2_hdr)):
                idx = dtb2_dec_off + i
                if keystream[idx] is None:
                    keystream[idx] = zr_data[file_off + idx] ^ dtb2_hdr[i]
                    decrypted[idx] = dtb2_hdr[i]
                    dtb_recovered += 1
            for i in range(0x28, 0x38):
                idx = dtb2_dec_off + i
                if keystream[idx] is None:
                    keystream[idx] = zr_data[file_off + idx]
                    decrypted[idx] = 0x00
                    dtb_recovered += 1

    dtb_info = {
        "dtb1": {
            "offset": dtb1_dec_off,
            "byte_size": 3845,
            "zero_padding_bytes": 251,
            "magic": "0xd00dfeed",
            "totalsize": 3845,
        },
        "dtb2": {
            "offset": dtb2_dec_off,
            "byte_size": 3168,
            "zero_padding_bytes": 928,
            "magic": "0xd00dfeed",
            "totalsize": 3168,
            "fully_reconstructed": (dtb_reference is not None and len(dtb_reference) == 3168),
        },
        "total_dtb_recovered_bytes": dtb_recovered,
    }

    recovered_total = sum(1 for k in keystream if k is not None)

    stats = {
        "analyzed_bytes": sec4_size,
        "recovered_bytes": recovered_total,
        "recovery_ratio": recovered_total / sec4_size if sec4_size else 0.0,
        "lead_bridge_recovered_bytes": lead_recovered,
        "kernel_zero_spans_recovered_bytes": zero_spans_recovered,
        "nisi_padding_recovered_bytes": nisi_pad_recovered,
        "rootfs_header_recovered_bytes": rootfs_recovered,
        "dtb_recovered_bytes": dtb_recovered,
        "file_offset": file_off,
        "nisi_file_offset": nisi_file_off,
        "kernel_header": kernel_info,
        "nisi_container": nisi_info,
        "rootfs_info": rootfs_info,
        "device_tree_blobs": dtb_info,
    }
    return bytes(decrypted), stats



def main():
    parser = argparse.ArgumentParser(description="Nikon ZR Modern Container Cryptanalysis & Extraction")
    parser.add_argument("zr_binary", help="Path to ZR firmware binary (e.g. ZR__0111.bin)")
    parser.add_argument("--zr10-binary", help="Path to ZR 1.10 firmware binary for differential comparison", default="firmware decode/z-series/ZR__0110.bin")
    parser.add_argument("--zf-binary", help="Path to reference Z f binary for differential cryptanalysis", default="firmware decode/z-series/Z_f_0301.bin")
    parser.add_argument("--output-dir", help="Directory to save recovered reports and artifacts", default="analysis/ZR_decryption")
    parser.add_argument("--extract-sec0", action="store_true", help="Extract partially decrypted Section 0 binary")
    parser.add_argument("--extract-sec2", action="store_true", help="Extract partially decrypted Section 2 binary")
    parser.add_argument("--extract-sec4", action="store_true", help="Extract partially decrypted Section 4 binary")
    args = parser.parse_args()

    out_dir = Path(args.output_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    with open(args.zr_binary, "rb") as f:
        zr_data = f.read()

    print(f"Loaded ZR firmware: {len(zr_data):,} bytes")
    hdr_info = parse_container_header(zr_data)
    print(f"  Container Magic: {'VALID' if hdr_info['valid_magic'] else 'INVALID'}")
    print(f"  Reverse Guard:   {'VALID' if hdr_info['valid_reverse_guard'] else 'INVALID'}")
    print(f"  Spaces Marker:   {'VALID' if hdr_info['valid_spaces_marker'] else 'INVALID'}")
    print(f"  128 Ints Table:  {len(hdr_info['table_128_integers'])} elements, all 15-bit OK")

    zf_path = Path(args.zf_binary)
    zf_data = zf_path.read_bytes() if zf_path.exists() else None

    modern_dir = parse_modern_directory(zr_data)
    sections = modern_dir["sections"]
    print(f"\nSuccessfully decoded {len(sections)} sections in directory (Model: {modern_dir['platform_model']}):")
    for s in sections:
        print(f"  Sec {s['index']}: {s['name']:<18} File 0x{s['file_offset']:08x} ({s['size']:>10,} B) - {s['description']}")

    # Differential comparison with ZR 1.10 if available
    diff_report = None
    zr10_path = Path(args.zr10_binary)
    if zr10_path.exists():
        zr10_data = zr10_path.read_bytes()
        diff_report = compare_zr_versions(zr10_data, zr_data)
        print(f"\nDifferential Comparison (ZR 1.10 vs ZR 1.11):")
        print(f"  Overall Match: {diff_report['overall_matched_bytes']:,} / {diff_report['total_size']:,} bytes ({diff_report['overall_match_ratio']*100:.2f}%)")
        for sd in diff_report["section_comparisons"]:
            print(f"  Sec {sd['index']} ({sd['name_110']} -> {sd['name_111']}): {sd['match_ratio']*100:.2f}% match ({sd['matched_bytes']:,}/{sd['size']:,} B)")

    # Cryptanalysis of Section 0
    z8_ref_path = Path("firmware decode/z-series/analysis/Z_8_0311/ex2070_030000.bi")
    z8_ref = z8_ref_path.read_bytes() if z8_ref_path.exists() else None
    z9_ref_path = Path("firmware decode/z-series/analysis/Z_9_0532/ex1990_051000.bi")
    z9_ref = z9_ref_path.read_bytes() if z9_ref_path.exists() else None

    # Load peer modern samples
    peer_samples = []
    for peer_name in ["Z5_2_0120.bin", "Z_f_0301.bin", "Z6_3_0200.bin"]:
        p_path = Path("firmware decode/z-series") / peer_name
        if p_path.exists():
            peer_samples.append(p_path.read_bytes()[0x350 : 0x350 + 524290])

    sec0_decrypted, sec0_stats = decrypt_section_0_consensus(zr_data, z8_ref, z9_ref, peer_samples)
    print(f"\nSection 0 (ex2100_010100.b) Cryptanalysis:")
    print(f"  Recovered keystream: {sec0_stats['recovered_bytes']:,} / {sec0_stats['total_bytes']:,} bytes ({sec0_stats['recovery_ratio']*100:.2f}%)")

    if args.extract_sec0:
        sec0_out1 = out_dir / "ex2100_010100.partial.bi"
        sec0_out1.write_bytes(sec0_decrypted)
        sec0_out2 = out_dir / "ex2100_011000.partial.bi"
        sec0_out2.write_bytes(sec0_decrypted)
        print(f"  Saved decrypted Section 0 to {sec0_out1}")

    # Cryptanalysis of Section 2 (Main OS eg2100)
    sec2_stats = None
    z8_eg_path = Path("firmware decode/z-series/analysis/Z_8_0311/eg2070_0311b0.bi")
    z9_eg_path = Path("firmware decode/z-series/analysis/Z_9_0532/eg1990_053200.bi")
    z6_path = Path("firmware decode/z-series/Z6_3_0200.bin")
    z5_path = Path("firmware decode/z-series/Z5_2_0120.bin")

    if zf_data and z8_eg_path.exists():
        z8_eg = z8_eg_path.read_bytes()
        z9_eg = z9_eg_path.read_bytes() if z9_eg_path.exists() else None
        z6_data = z6_path.read_bytes() if z6_path.exists() else None
        z5_data = z5_path.read_bytes() if z5_path.exists() else None

        sec2_decrypted, sec2_stats = decrypt_section_2_cross_offset(
            zr_data, zf_data, z8_eg, z9_eg, z6_data, z5_data
        )
        print(f"\nSection 2 (eg2100_011130.b) Cross-Offset Cryptanalysis:")
        print(f"  Recovered keystream: {sec2_stats['recovered_bytes']:,} / {sec2_stats['analyzed_bytes']:,} bytes ({sec2_stats['recovery_ratio']*100:.2f}%)")
        print(f"    - Code/Data: {sec2_stats['recovered_code_data_bytes']:,} bytes")
        print(f"    - Zero Padding: {sec2_stats['recovered_zero_padding_bytes']:,} bytes")

        if args.extract_sec2:
            sec2_out = out_dir / "eg2100_011130.partial.bi"
            sec2_out.write_bytes(sec2_decrypted)
            print(f"  Saved decrypted Section 2 to {sec2_out}")

    # Cryptanalysis of Section 4 (Linux li2100)
    sec4_stats = None
    z8_li_path = Path("firmware decode/z-series/analysis/Z_8_0311/li2070_0311b0.bi")
    z9_li_path = Path("firmware decode/z-series/analysis/Z_9_0532/li1990_053200.bi")

    if z6_path.exists():
        z6_data = z6_path.read_bytes()
        z8_li = z8_li_path.read_bytes() if z8_li_path.exists() else None
        z9_li = z9_li_path.read_bytes() if z9_li_path.exists() else None

        sec4_decrypted, sec4_stats = decrypt_section_4_consensus(
            zr_data, z6_data, z8_li, z9_li
        )
        print(f"\nSection 4 (li2100_011130.b) VR Bridge & Zero-Spans Cryptanalysis:")
        print(f"  Recovered keystream: {sec4_stats['recovered_bytes']:,} / {sec4_stats['analyzed_bytes']:,} bytes ({sec4_stats['recovery_ratio']*100:.2f}%)")
        print(f"    - Lead Bridge (VR 0xFF): {sec4_stats['lead_bridge_recovered_bytes']:,} bytes")
        print(f"    - Kernel Zero Spans:     {sec4_stats['kernel_zero_spans_recovered_bytes']:,} bytes")
        if sec4_stats.get("kernel_header", {}).get("valid_magic"):
            print(f"    - Linux Kernel Header:   Magic={sec4_stats['kernel_header']['magic']}, ImageSize={sec4_stats['kernel_header']['image_size']:,} B")
        if sec4_stats and sec4_stats.get("dtb_recovered_bytes", 0) > 0:
            print(f"    - DTB Padding & Headers: {sec4_stats['dtb_recovered_bytes']:,} bytes")

        if args.extract_sec4:
            sec4_out = out_dir / "li2100_011130.partial.bi"
            sec4_out.write_bytes(sec4_decrypted)
            print(f"  Saved decrypted Section 4 to {sec4_out}")

            # Also extract the pure NISI container and linux sub-images
            if sec4_stats and sec4_stats.get("nisi_container", {}).get("magic") == "NISI":
                nisi_dir = out_dir / "linux"
                nisi_dir.mkdir(exist_ok=True, parents=True)
                nisi_out = out_dir / "li2100_011130.nisi.partial.bi"
                nisi_off = sec4_stats["nisi_file_offset"]
                # Save NISI container binary (starts at 0x0559F810)
                nisi_data = zr_data[nisi_off : nisi_off + 27377560]
                nisi_lead = bytearray(len(nisi_data))
                vr_len = min(0x056120D0 - nisi_off, len(nisi_data))
                for i in range(vr_len):
                    nisi_lead[i] = nisi_data[i] ^ z6_data[nisi_off + i] ^ 0xFF
                nisi_out.write_bytes(nisi_lead)
                print(f"  Saved NISI multi-image container to {nisi_out}")

                # Extract verified Linux kernel lead (ARM64 Image)
                k_lead = nisi_lead[0x800 : vr_len]
                (nisi_dir / "Image.lead.bin").write_bytes(k_lead)
                (nisi_dir / "subimages_inventory.json").write_text(
                    json.dumps(sec4_stats["nisi_container"]["sub_images"], indent=2) + "\n"
                )

                # Extract Device Tree Blobs and decompile to DTS
                dtb_map = sec4_stats.get("device_tree_blobs", {})
                if dtb_map.get("dtb1"):
                    d1_off = dtb_map["dtb1"]["offset"]
                    d1_sz = dtb_map["dtb1"]["byte_size"]
                    d1_raw = sec4_decrypted[d1_off : d1_off + d1_sz]
                    (nisi_dir / "device_tree_0.dtb.partial").write_bytes(d1_raw)
                    _, dts0 = parse_fdt_resilient(d1_raw)
                    (nisi_dir / "device_tree_0.dts.partial").write_text(dts0)

                if dtb_map.get("dtb2"):
                    d2_off = dtb_map["dtb2"]["offset"]
                    d2_sz = dtb_map["dtb2"]["byte_size"]
                    d2_raw = sec4_decrypted[d2_off : d2_off + d2_sz]
                    (nisi_dir / "device_tree_1.dtb").write_bytes(d2_raw)
                    try:
                        from analyze_z8 import parse_fdt
                        _, dts1 = parse_fdt(d2_raw)
                        (nisi_dir / "device_tree_1.dts").write_text(dts1)
                    except Exception:
                        _, dts1 = parse_fdt_resilient(d2_raw)
                        (nisi_dir / "device_tree_1.dts").write_text(dts1)

                # Save rootfs metadata if recovered
                if sec4_stats.get("rootfs_info"):
                    (nisi_dir / "rootfs_header.json").write_text(
                        json.dumps(sec4_stats["rootfs_info"], indent=2) + "\n"
                    )

                print(f"  Extracted Linux subsystem components to {nisi_dir}")


    report = {
        "target": Path(args.zr_binary).name,
        "target_size": len(zr_data),
        "header": {k: v for k, v in hdr_info.items() if k != "table_128_integers"},
        "platform_model": modern_dir["platform_model"],
        "sections": sections,
        "differential_comparison_110_vs_111": diff_report,
        "section_0_cryptanalysis": sec0_stats,
        "section_2_cross_offset_cryptanalysis": sec2_stats,
        "section_4_consensus_cryptanalysis": sec4_stats,
    }
    report_file = out_dir / "manifest.json"
    with open(report_file, "w") as f:
        json.dump(report, f, indent=2)
    print(f"\nWrote analysis manifest to {report_file}")


if __name__ == "__main__":
    main()
