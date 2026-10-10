#!/usr/bin/env python3
"""Recover bounded Z5 II fragments using cross-model XOR and Z8 references.

This is not a complete container decryptor. Every artifact retains provenance;
reference-assisted recovery is distinguished from direct XOR candidates.
Original firmware is never modified or executed. Standard library only.
"""

import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import re

from analyze_zf import SAMPLES, compare_headers, equal_runs, xor_bytes
from analyze_z8 import elf_info, write_elf_symbols
from analyze_zr import Z8_EG_SHA256, legacy_phase_probe


SOURCE = "Z5_2_0120.bin"
PEERS = ["Z_f_0301.bin", "Z6_3_0200.bin", "ZR__0111.bin"]
SECOND_SHA = "de961025902457d6dab9cbb17eb832f9e441c1d685867b109bf354a8b81af2f4"
THIRD_SHA = "c7787ceda602a291dea500b778aefa682a20a7c6345363d33a3b24fa3bfd041f"
FIRST_SHA = "6b89673f8596c4b3f57be3bbe39defe8de2388e624c344bb039a92dbc9f8fca6"
CRIB_OFFSETS = {SOURCE: 0x16C7C14, "Z_f_0301.bin": 0x16FE3A4,
                "Z6_3_0200.bin": 0x18BF8F4, "ZR__0111.bin": 0x192D8B0}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def verified_read(path, expected):
    data = path.read_bytes()
    if sha(data) != expected:
        raise ValueError(f"Input hash mismatch: {path}")
    return data


def merge_masks(spans):
    """Require agreeing overlaps and complete coverage; never invent gap bytes."""
    if not spans or any(start < 0 or not data for start, data in spans):
        raise ValueError("Need nonempty masks at nonnegative offsets")
    start = min(s for s, _ in spans)
    end = max(s + len(d) for s, d in spans)
    mask, support = bytearray(end - start), bytearray(end - start)
    overlaps = []
    for i, (left, data) in enumerate(spans):
        for j, (right, other) in enumerate(spans[:i]):
            lo, hi = max(left, right), min(left + len(data), right + len(other))
            if lo < hi:
                if data[lo - left:hi - left] != other[lo - right:hi - right]:
                    raise ValueError("Conflicting masks in overlap")
                overlaps.append({"span_indices": [j, i], "start": lo,
                                 "end_exclusive": hi, "size": hi - lo, "mismatches": 0})
        lo, hi = left - start, left - start + len(data)
        mask[lo:hi] = data
        support[lo:hi] = bytes(v + 1 for v in support[lo:hi])
    if 0 in support:
        raise ValueError("Gap in mask coverage")
    return start, bytes(mask), {"overlaps": overlaps,
                               "bytes_by_reference_count": dict(sorted(Counter(support).items()))}


def write_strings(path, data, origin=0):
    count = 0
    with path.open("w") as file:
        for match in re.finditer(rb"[ -~]{16,}", data):
            file.write(f"{origin + match.start():08x} {match.group().decode('ascii')}\n")
            count += 1
    return count


def export_elf(output, offset, data, provenance):
    info = elf_info(data)
    data = data[:info["file_extent"]]
    name = f"ceva_{offset:08x}.elf"
    (output / name).write_bytes(data)
    info.update({"artifact": name, "original_file_offset": offset, "sha256": sha(data),
                 "provenance": provenance, "container_crc_verified": False,
                 "symbol_entries": write_elf_symbols(output / (name + ".symbols.csv"), data, info)})
    return info


def analyze(directory, z8_directory, output):
    inputs = [directory / name for name in [SOURCE] + PEERS]
    inputs += [z8_directory / "eg2070_0311b0.bi",
               z8_directory / "embedded_elf/ceva_015c5bd0.elf",
               z8_directory / "embedded_elf/ceva_01635120.elf"]
    # All generated paths stay below output; keep that tree separate from inputs.
    if any(path.resolve().is_relative_to(output.resolve()) for path in inputs):
        raise ValueError("Output directory must not contain source inputs")
    if output.exists() and any(path.is_symlink() for path in output.rglob("*")):
        raise ValueError("Output tree must not contain symlinks")
    output.mkdir(parents=True, exist_ok=True)
    candidates = output / "differential_candidates"
    candidates.mkdir(exist_ok=True)
    data = verified_read(directory / SOURCE, SAMPLES[SOURCE])
    reference2 = verified_read(z8_directory / "embedded_elf/ceva_015c5bd0.elf", SECOND_SHA)
    reference3 = verified_read(z8_directory / "embedded_elf/ceva_01635120.elf", THIRD_SHA)
    z8_eg = verified_read(z8_directory / "eg2070_0311b0.bi", Z8_EG_SHA256)
    summaries = {SOURCE: {"size": len(data), "sha256": sha(data)}}
    pairs, elves, cribs, mask_spans = {}, [], [], []
    first_candidates = None
    markers = [b"FirmwareChkLib.c", b"CFirmwareManagementService_Execute",
               b"4.14.313-ts-aarch64", b"\x7fELF"]
    for name in PEERS:
        peer = verified_read(directory / name, SAMPLES[name])
        summaries[name] = {"size": len(peer), "sha256": sha(peer)}
        size = min(len(data), len(peer))
        delta = b"".join(xor_bytes(data[i:min(i + 65536, size)], peer[i:min(i + 65536, size)])
                         for i in range(0, size, 65536))
        record = {"aligned_comparison": equal_runs(data, peer),
                  "header_regions": compare_headers(data, peer),
                  "xor_strings_min16": write_strings(output / (name + ".xor.strings.txt"), delta),
                  "markers": {needle.decode('ascii'): [m.start() for m in re.finditer(re.escape(needle), delta)]
                              for needle in markers}}
        if name in ("Z6_3_0200.bin", "ZR__0111.bin"):
            fragments = []
            for offset, expected in [(0x15AF864, FIRST_SHA), (0x16586C4, SECOND_SHA)]:
                info = elf_info(delta[offset:])
                fragment = delta[offset:offset + info["file_extent"]]
                if sha(fragment) != expected:
                    raise ValueError("Differential ELF candidate changed")
                fragments.append(fragment)
            if first_candidates is None:
                first_candidates = fragments
            elif first_candidates != fragments:
                raise ValueError("Independent differential candidates disagree")
            record["candidate_elf_sha256"] = [sha(v) for v in fragments]
            if fragments[1] != reference2:
                raise ValueError("Second differential ELF does not match verified Z8 reference")
        if name == "ZR__0111.bin":
            start, end, old_start = 0x4CB7E41, 0x4CB87C4, 0x4A2A111
            fragment = delta[start:end]
            if fragment != z8_eg[old_start:old_start + len(fragment)]:
                raise ValueError("FirmwareChk reference span mismatch")
            (candidates / "firmwarechk_xor_fragment.bin").write_bytes(fragment)
            record["firmwarechk_reference_match"] = {
                "xor_start": start, "xor_end_exclusive": end, "size": len(fragment),
                "z8_eg_offset": old_start, "sha256": sha(fragment),
                "attribution": "Pairwise XOR evidence; not independently assigned to either source"}
        pairs[name] = record
        offset = CRIB_OFFSETS[name]
        mask_spans.append((offset, xor_bytes(peer[offset:offset + len(reference3)], reference3)))
        cribs.append({"source": name, "offset": offset, "size": len(reference3),
                      "reference_sha256": THIRD_SHA})
    offset = CRIB_OFFSETS[SOURCE]
    mask_spans.append((offset, xor_bytes(data[offset:offset + len(reference3)], reference3)))
    cribs.append({"source": SOURCE, "offset": offset, "size": len(reference3),
                  "reference_sha256": THIRD_SHA})
    start, mask, coverage = merge_masks(mask_spans)
    end = start + len(mask)
    window = xor_bytes(data[start:end], mask)
    (output / "shared_position_mask.bin").write_bytes(mask)
    (output / "z5ii_reference_assisted_window.bin").write_bytes(window)
    window_strings = write_strings(output / "z5ii_reference_assisted_window.strings.txt", window, start)
    independent_checks = []
    with (directory / "Z6_3_0200.bin").open("rb") as peer_file:
        for offset, fragment in zip([0x17A7544, 0x18503A4], first_candidates):
            peer_file.seek(offset)
            recovered = xor_bytes(peer_file.read(len(fragment)), mask[offset - start:offset - start + len(fragment)])
            if recovered != fragment:
                raise ValueError("Independent Z6 III window does not reproduce differential ELF")
            independent_checks.append({"source": "Z6_3_0200.bin", "offset": offset,
                                       "size": len(fragment), "sha256": sha(recovered),
                                       "matches_z5ii_differential_candidate": True,
                                       "candidate_used_to_construct_mask": False})
    for offset, fragment in zip([0x15AF864, 0x16586C4], first_candidates):
        elves.append(export_elf(candidates, offset, fragment, {
            "method": "Equal pairwise XOR results from Z5 II/ZR and Z5 II/Z6 III",
            "z8_exact_reference_match": offset == 0x16586C4,
            "attribution": "Z5 II candidate under the shared XOR mask and zero-filled-peer interpretation"}))
    elves.append(export_elf(candidates, start, window, {
        "method": "Known Z8 reference placed at independently shifted offsets in four firmware images",
        "z8_exact_reference_match": True,
        "attribution": "Reference-assisted; do not count the injected reference bytes as an independent discovery"}))
    novel_start = CRIB_OFFSETS[SOURCE] + len(reference3)
    novel = window[novel_start - start:]
    old_novel_start = 0x1635120 + len(reference3)
    old_novel = z8_eg[old_novel_start:old_novel_start + len(novel)]
    matched = next((i for i, (a, b) in enumerate(zip(novel, old_novel)) if a != b),
                   min(len(novel), len(old_novel)))
    result = {
        "source": SOURCE, "status": "partial_reference_assisted_recovery",
        "complete_container_decoded": False, "section_count": None, "crc_verified": False,
        "main_cpu_architecture": None, "embedded_elf_machine": 245,
        "analyzer_sha256": sha(Path(__file__).read_bytes()), "samples": summaries,
        "references": {"z8_eg_sha256": Z8_EG_SHA256, "second_elf_sha256": SECOND_SHA,
                       "third_elf_sha256": THIRD_SHA},
        "pairs": pairs, "differential_candidates": elves,
        "independent_peer_elf_checks": independent_checks,
        "legacy_phase_probe": legacy_phase_probe(data[0x280:0x290], len(data) - 0x260),
        "mask_recovery": {"model": "C[file, offset] = P[file, offset] XOR K[offset]",
                          "start": start, "end_exclusive": end, "size": len(mask),
                          "sha256": sha(mask), "cribs": cribs, **coverage},
        "z5ii_window": {"start": start, "end_exclusive": end, "size": len(window),
                        "sha256": sha(window), "strings_min16": window_strings,
                        "beyond_own_reference": {"start": novel_start, "size": len(novel),
                                                 "sha256": sha(novel),
                                                 "Darkent2Caffe_offsets": [novel_start + m.start()
                                                    for m in re.finditer(b"Darkent2Caffe", novel)],
                                                 "independent_z8_prefix_match": {
                                                     "size": matched, "z8_eg_offset": old_novel_start,
                                                     "end_exclusive": novel_start + matched,
                                                     "sha256": sha(novel[:matched]),
                                                     "used_to_construct_mask": False}}},
        "limitations": [
            "The global keystream generator/key is unknown; only the recorded interval is recovered.",
            "Reference placement and the shared XOR model are strongly overlap-validated, not authenticated by container CRC.",
            "Bytes from a source's own reference placement are not independent plaintext validation.",
            "Pairwise XOR strings can belong to either input; do not attribute them without additional evidence.",
            "CEVA ELF headers describe embedded DSP modules, not the camera main CPU.",
        ],
    }
    (output / "manifest.json").write_text(json.dumps(result, indent=2) + "\n")
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", type=Path)
    parser.add_argument("--z8-directory", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    result = analyze(args.directory, args.z8_directory, args.output)
    region = result["mask_recovery"]
    print(f"Partial recovery only: mask 0x{region['start']:x}..0x{region['end_exclusive']:x}, {region['size']} bytes")
    print(f"Evidence: {args.output / 'manifest.json'}")


if __name__ == "__main__":
    main()
