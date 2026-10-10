#!/usr/bin/env python3
"""Analyze the collected Nikon Z corpus, preserving existing detailed reports.

Legacy packages must pass section/package CRC and exact re-encoding. New-format
packages remain opaque except for explicitly bounded reference-assisted windows.
Never executes firmware. Standard library only.
"""

import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import re
import struct

from analyze_firmware import analyze as analyze_legacy, all_offsets
from analyze_zf import xor_bytes
from analyze_z8 import elf_info, extract_regular_files, inflate, parse_cpio, parse_fdt, parse_nisi, write_elf_symbols
from analyze_zr import legacy_phase_probe
from analyze_z5ii import THIRD_SHA, merge_masks


def sha(data):
    return hashlib.sha256(data).hexdigest()


def save(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(data)


def scan_elf(data, output, origin=0):
    found, rejected = [], []
    for offset in all_offsets(data, b"\x7fELF"):
        try:
            info = elf_info(data[offset:])
            if info["machine"] not in (40, 183, 245):
                raise ValueError("Unexpected ELF machine")
            content = data[offset:offset + info["file_extent"]]
            name = f"elf_{origin + offset:08x}.elf"
            save(output / name, content)
            symbols = write_elf_symbols(output / (name + ".symbols.csv"), content, info)
            found.append({"offset": origin + offset, "size": len(content), "sha256": sha(content),
                          "machine": info["machine"], "bits": info["bits"], "entry": info["entry"],
                          "section_count": len(info["sections"]), "symbol_entries": symbols,
                          "artifact": str(output / name)})
        except (ValueError, IndexError, UnicodeError, struct.error) as error:
            rejected.append({"offset": origin + offset, "reason": str(error)})
    return {"validated_structures": found, "rejected_magic_hits": rejected}


def inspect_linux(data, output):
    entries = parse_nisi(data)
    output.mkdir(parents=True, exist_ok=True)
    details = {"nisi_entries": entries}
    for entry in entries:
        content = data[entry["offset"]:entry["offset"] + entry["size"]]
        save(output / entry["name"], content)
        if entry["name"] == "Image":
            details["version_strings"] = [m.group().decode() for m in re.finditer(rb"Linux version [ -~]{1,200}", content)]
            details["aarch64_image_magic"] = content[0x38:0x3C] == b"ARM\x64"
        elif entry["name"] == "rootfs.cpio.gz":
            archive, consumed = inflate(content)
            if consumed != len(content):
                raise ValueError("Trailing bytes after rootfs gzip stream")
            files = parse_cpio(archive)
            save(output / "rootfs.cpio", archive)
            extract_regular_files(archive, files, output / "rootfs_files")
            details["cpio_entry_count"] = len(files)
            details["cpio_types"] = dict(Counter(row["type"] for row in files))
            (output / "cpio_manifest.json").write_text(json.dumps(files, indent=2) + "\n")
            app = output / "rootfs_files/usr/bin/LaMainApp"
            if app.exists():
                info = elf_info(app.read_bytes())
                details["LaMainApp"] = {"sha256": sha(app.read_bytes()), "machine": info["machine"],
                                         "bits": info["bits"], "entry": info["entry"]}
        elif entry["name"].endswith(".dtb"):
            tree, dts = parse_fdt(content)
            (output / (entry["name"] + ".dts")).write_text(dts)
            details.setdefault("device_tree_roots", {})[entry["name"]] = tree["nodes"].get("/", {})
    return details


def inspect_legacy(directory, manifest, survey, new_magic, new_table):
    result = {"sections": [], "embedded_elf_count": 0}
    for section in manifest["sections"]:
        data = (directory / section["name"]).read_bytes()
        if sha(data) != section["sha256"]:
            raise ValueError("Extracted section hash mismatch")
        row = {"name": section["name"], "size": len(data), "sha256": section["sha256"],
               "os_strings": {marker.decode(): list(all_offsets(data, marker)) for marker in
                              [b"SMP T-Kernel", b"SOLID", b"TOPPERS", b"FirmwareChkLib.c"]},
               "new_format_constants": {"first32": list(all_offsets(data, new_magic)),
                                        "u16_table": list(all_offsets(data, new_table))}}
        if section["name"].startswith("eg"):
            row["embedded_elf"] = scan_elf(data, survey / "embedded_elf")
            result["embedded_elf_count"] += len(row["embedded_elf"]["validated_structures"])
        if data.startswith(b"NISI"):
            try:
                row["linux"] = inspect_linux(data, survey / "linux")
            except (ValueError, IndexError, UnicodeError) as error:
                row["linux_inspection_error"] = str(error)
        result["sections"].append(row)
    return result


def inspect_new(data, survey, reference_header, mask_info, mask):
    same_prefix = data[:32] == reference_header[:32]
    same_table = data[0x120:0x220] == reference_header[0x120:0x220]
    result = {"first32_equal_z5ii": same_prefix, "u16_table_equal_z5ii": same_table,
              "reversed_prefix_valid": data[0x220:0x240] == data[:32][::-1],
              "candidate_directory_header_equal_z5ii": data[0x280:0x290] == reference_header[0x280:0x290],
              "legacy_phase_probe": legacy_phase_probe(data[0x280:0x290], len(data) - 0x260),
              "complete_decoding": False, "crc_verified": False}
    if same_prefix and same_table and mask is not None:
        start, end = mask_info["start"], mask_info["end_exclusive"]
        if len(data) >= end:
            window = xor_bytes(data[start:end], mask)
            save(survey / "reference_assisted_window.bin", window)
            strings = list(re.finditer(rb"[ -~]{16,}", window))
            with (survey / "reference_assisted_window.strings.txt").open("w") as file:
                for match in strings:
                    file.write(f"{start + match.start():08x} {match.group().decode()}\n")
            result["window"] = {"start": start, "end_exclusive": end, "size": len(window),
                                "sha256": sha(window), "mask_sha256": sha(mask),
                                "strings_min16": len(strings),
                                "elf": scan_elf(window, survey / "embedded_elf", start),
                                "status": "reference_assisted_candidate",
                                "limitation": "Shared prefix is not proof of the mask; inspect ELF/reference matches separately"}
    return result


def expand_mask(root, summary):
    """Use held-out samples to validate/extend the existing interval, then export it.

    Anchor matches propose reference positions; complete overlapping masks must
    agree before any expansion is accepted. An injected reference is not a new
    independent plaintext discovery.
    """
    original_info = json.loads((root / "analysis/Z5_2_0120/manifest.json").read_text())["mask_recovery"]
    original = (root / "analysis/Z5_2_0120/shared_position_mask.bin").read_bytes()
    if sha(original) != original_info["sha256"]:
        raise ValueError("Baseline mask hash mismatch")
    reference = (root / "analysis/Z_8_0311/embedded_elf/ceva_01635120.elf").read_bytes()
    if sha(reference) != THIRD_SHA:
        raise ValueError("CEVA reference hash mismatch")
    base, old_end = original_info["start"], original_info["end_exclusive"]
    spans, placements, rows = [], [], []
    for row in summary["samples"]:
        window_info = row.get("inspection", {}).get("window")
        if row["format"] != "extended_0x260" or not window_info:
            continue
        source = root / row["filename"]
        with source.open("rb") as file:
            if hashlib.file_digest(file, "sha256").hexdigest() != row["sha256"]:
                raise ValueError("Corpus source changed during mask expansion")
            file.seek(base)
            window = xor_bytes(file.read(len(original)), original)
        votes = Counter()
        for off in range(0, len(reference) - 64, 65536):
            needle = reference[off:off + 64]
            if len(set(needle)) < 12:
                continue
            found = window.find(needle)
            if found >= 0 and window.find(needle, found + 1) < 0:
                votes[base + found - off] += 1
        if not votes:
            continue
        start, anchors = votes.most_common(1)[0]
        if anchors < 3 or start < 0 or start + len(reference) > row["size"]:
            continue
        with source.open("rb") as file:
            file.seek(start)
            candidate = xor_bytes(file.read(len(reference)), reference)
        lo, hi = max(start, base), min(start + len(candidate), old_end)
        if hi - lo < len(reference) // 2:
            raise ValueError("Reference overlap too small for expansion")
        if candidate[lo - start:hi - start] != original[lo - base:hi - base]:
            raise ValueError(f"Reference mask disagrees: {source.name}")
        spans.append((start, candidate))
        placements.append({"source": source.name, "start": start, "size": len(candidate),
                           "matching_unique_64byte_anchors": anchors, "reference_sha256": THIRD_SHA,
                           "baseline_overlap_bytes": hi - lo, "baseline_overlap_mismatches": 0})
        rows.append(row)
    if not spans:
        return summary
    start, mask, coverage = merge_masks(spans)
    end = start + len(mask)
    if start > base or end < old_end or mask[base - start:old_end - start] != original:
        raise ValueError("Expanded mask does not retain the full baseline")
    save(root / "analysis/catalog/shared_position_mask.bin", mask)
    for row, placement in zip(rows, placements):
        survey = root / "analysis" / Path(row["filename"]).stem / "survey"
        with (root / row["filename"]).open("rb") as file:
            file.seek(start)
            window = xor_bytes(file.read(len(mask)), mask)
        save(survey / "reference_assisted_window.bin", window)
        count = 0
        with (survey / "reference_assisted_window.strings.txt").open("w") as file:
            for match in re.finditer(rb"[ -~]{16,}", window):
                file.write(f"{start + match.start():08x} {match.group().decode()}\n")
                count += 1
        row["inspection"]["window"] = {
            "start": start, "end_exclusive": end, "size": len(window), "sha256": sha(window),
            "mask_sha256": sha(mask), "strings_min16": count,
            "elf": scan_elf(window, survey / "expanded_elf", start),
            "reference_placement": placement, "status": "reference_assisted_overlap_validated",
            "limitation": "Full overlapping masks agree; the reference itself is not independent recovered plaintext. No container CRC."}
        (survey / "manifest.json").write_text(json.dumps(row, indent=2) + "\n")
    summary["expanded_shared_mask"] = {"start": start, "end_exclusive": end, "size": len(mask),
                                        "sha256": sha(mask), "added_bytes": len(mask) - len(original),
                                        "baseline_sha256": sha(original), "placements": placements, **coverage}
    summary["analysis_tool_sha256"] = sha(Path(__file__).read_bytes())
    (root / "analysis/catalog/deep_manifest.json").write_text(json.dumps(summary, indent=2) + "\n")
    print(f"Expanded mask: {len(mask)} bytes, {len(placements)} samples, {len(mask) - len(original)} added bytes", flush=True)
    return summary


def analyze(root):
    catalog = json.loads((root / "analysis/catalog/manifest.json").read_text())
    header = (root / "Z5_2_0120.bin").read_bytes()[:0x330]
    mask_path = root / "analysis/Z5_2_0120/shared_position_mask.bin"
    mask, mask_info = None, {}
    if mask_path.exists():
        mask_info = json.loads((root / "analysis/Z5_2_0120/manifest.json").read_text())["mask_recovery"]
        mask = mask_path.read_bytes()
        if sha(mask) != mask_info["sha256"] or len(mask) != mask_info["size"]:
            raise ValueError("Reference mask hash or length mismatch")
    files = {}
    for page in catalog["firmware_pages"]:
        if page.get("download", {}).get("status") in ("existing", "downloaded"):
            files[page["filename"]] = {"models": page["models"], "source_page": page["page_url"],
                                       "expected_sha256": page["download"]["sha256"], "current": True}
    for retained in catalog.get("retained_unlisted_samples", []):
        files.setdefault(retained["filename"], {"models": [], "expected_sha256": retained["sha256"], "current": False})
    results = []
    for filename, metadata in files.items():
        source = root / filename
        data = source.read_bytes()
        row = {"filename": filename, **metadata, "size": len(data), "sha256": sha(data)}
        if row["sha256"] != metadata["expected_sha256"]:
            raise ValueError(f"Corpus source hash changed: {filename}")
        output = root / "analysis" / source.stem
        survey = output / "survey"
        survey.mkdir(parents=True, exist_ok=True)
        marker = data[:0x400].find(b" " * 32)
        row["space_marker_offset"] = marker
        print(f"Analyze: {filename}, marker {marker:#x}", flush=True)
        try:
            if marker in (0, 0x20):
                row["format"] = "legacy_xor"
                existing = output / "manifest.json"
                manifest = json.loads(existing.read_text()) if existing.exists() else {}
                decoded = output / "decoded_package.bin"
                reusable = (manifest.get("input_sha256") == row["sha256"] and manifest.get("round_trip_exact")
                            and decoded.exists() and sha(decoded.read_bytes()) == manifest.get("decoded_sha256"))
                if not reusable:
                    manifest = analyze_legacy(source, output)
                row.update(status="decoded_crc_and_roundtrip_verified", section_count=manifest["section_count"],
                           package_crc16=manifest["package_crc16"], decoded_sha256=manifest["decoded_sha256"])
                row["inspection"] = inspect_legacy(output, manifest, survey, header[:32], header[0x120:0x220])
                print(f"Verified: {filename}, {manifest['section_count']} sections", flush=True)
            elif marker == 0x260:
                row.update(format="extended_0x260", status="not_fully_decoded")
                row["inspection"] = inspect_new(data, survey, header, mask_info, mask)
            else:
                row.update(format="unknown", status="unrecognized")
        except Exception as error:
            row.update(status="analysis_failed", error=f"{type(error).__name__}: {error}")
            print(f"Analysis failed: {filename}: {error}", flush=True)
        (survey / "manifest.json").write_text(json.dumps(row, indent=2) + "\n")
        results.append(row)
        # Checkpoint after each package; a stopped run retains completed evidence.
        summary = {"catalog_models": len(catalog["models"]), "sample_count": len(files),
                   "completed": len(results), "format_counts": dict(Counter(r["format"] for r in results)),
                   "status_counts": dict(Counter(r["status"] for r in results)), "samples": results}
        (root / "analysis/catalog/deep_manifest.json").write_text(json.dumps(summary, indent=2) + "\n")
    return expand_mask(root, summary) if mask is not None else summary


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", type=Path)
    parser.add_argument("--expand-mask-only", action="store_true", help="Reuse the completed corpus survey and revalidate its mask expansion")
    args = parser.parse_args()
    if args.expand_mask_only:
        summary = json.loads((args.directory / "analysis/catalog/deep_manifest.json").read_text())
        result = expand_mask(args.directory, summary)
    else:
        result = analyze(args.directory)
    print(json.dumps(result["status_counts"], ensure_ascii=False), flush=True)


if __name__ == "__main__":
    main()
