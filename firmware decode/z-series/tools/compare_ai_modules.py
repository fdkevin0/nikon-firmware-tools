#!/usr/bin/env python3
"""Compare extracted DSP code and bounded network candidates; never run firmware.

Requires the catalog and Z5 II analysis artifacts. Reference-assisted CEVA
matches are explicitly distinguished from independently recovered data outside
the reference. Network lengths are a tested layout hypothesis, not a full CDNN
parser or a determination of subject classes.
"""

import argparse
import csv
import hashlib
import json
from pathlib import Path
import re
import struct

from analyze_z8 import elf_info, write_elf_symbols
from analyze_zf import xor_bytes
from analyze_z5ii import THIRD_SHA


MAGIC = b"\x09\0\0\0XM6NeuPro\0"
EXTRA = {"Z_f_0110_01.bin": "89aeb3bfb4110f21a1a0ee05244296da52824208d916dc2b53b90202e693a03d"}
MARKERS = [b"FaceDetectServic", b"AnimalDetection.cpp", b"VehicleDetection.cpp",
           b"CDNNManager.cpp", b"XM6NeuPro", b"Darkent2Caffe", b"BirdDetection"]


def sha(data):
    return hashlib.sha256(data).hexdigest()


def offsets(data, needle):
    return [m.start() for m in re.finditer(re.escape(needle), data)]


def network_candidates(data, origin=0):
    result = []
    for start in offsets(data, MAGIC):
        if start + 0x48 > len(data):
            continue
        a, b = struct.unpack_from("<II", data, start + 0x40)
        if not 0x48 <= a <= 0x1000000 or not 0 < b <= 0x4000000:
            continue
        size = 0x40 + a + b
        end = start + size
        content = data[start:min(end, len(data))]
        result.append({"offset": origin + start, "declared_size_hypothesis": size,
                       "length_fields": [a, b], "available_size": len(content),
                       "complete_within_window": end <= len(data), "sha256_available": sha(content),
                       "next_bytes_hex": data[end:end + 32].hex() if end <= len(data) else None,
                       "converter_marker_present": b"Darkent2Caffe\0" in content[:128],
                       "input_marker_present": b"UserInputBuffer\0" in content[:256],
                       "layer_name_strings": sorted({m.group().decode() for m in re.finditer(
                           rb"layer\d+[-A-Za-z0-9_]*", content[:0x40 + a])})})
    return result


def profile_elf(data, target):
    info = elf_info(data)
    if info["machine"] != 245 or info["file_extent"] != len(data):
        raise ValueError("Not an exact CEVA ELF")
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(data)
    symbols_path = target.with_suffix(".symbols.csv")
    write_elf_symbols(symbols_path, data, info)
    symbols = list(csv.DictReader(symbols_path.open()))
    files = sorted({r["name"] for r in symbols if int(r["info"]) & 15 == 4})
    functions = sorted({r["name"] for r in symbols if int(r["info"]) & 15 == 2
                        and int(r["section_index"]) != 0 and r["name"]})
    # STT_FILE entries can survive even when their functions are not linked in.
    role = ("neural_inference" if "CAnimalDetectionApi" in functions else
            "image_processing" if any(n.startswith("_Z14HdrComposition") for n in functions) else
            "tracking" if any(n.startswith("_Z11CskTracking") for n in functions) else "unknown")
    sections = []
    for s in info["sections"]:
        if not s["size"]:
            continue
        sections.append({**s, "sha256": None if s["type"] == 8 else
                         sha(data[s["offset"]:s["offset"] + s["size"]])})
    return {"size": len(data), "role_by_symbols": role, "symbol_entries": len(symbols),
            "unique_function_names": len(functions), "source_files": files,
            "function_names": functions, "sections": sections}


def analyze(root):
    catalog = json.loads((root / "analysis/catalog/deep_manifest.json").read_text())
    out = root / "analysis/ai_comparison"
    out.mkdir(parents=True, exist_ok=True)
    mask_info = catalog["expanded_shared_mask"]
    mask = (root / "analysis/catalog/shared_position_mask.bin").read_bytes()
    if sha(mask) != mask_info["sha256"]:
        raise ValueError("Mask changed")
    start, end = mask_info["start"], mask_info["end_exclusive"]
    reference = (root / "analysis/Z_8_0311/embedded_elf/ceva_01635120.elf").read_bytes()
    if sha(reference) != THIRD_SHA:
        raise ValueError("Reference changed")
    samples = list(catalog["samples"])
    for filename, digest in EXTRA.items():
        samples.append({"filename": filename, "sha256": digest, "format": "extended_0x260"})
    result = {"mask": mask_info, "samples": [], "unique_modules": {}, "module_differences": [],
              "limitations": ["No new-format container CRC", "Reference ELF equality is not independent discovery",
                              "No complete CDNN network parser or subject-class assignment",
                              "Missing markers/ELFs do not prove absent AI capability"]}
    networks_by_hash = {}
    known_networks = []

    def record_module(data, sample, position, basis):
        digest = sha(data)
        if digest not in result["unique_modules"]:
            result["unique_modules"][digest] = profile_elf(data, out / "modules" / (digest + ".elf"))
        sample["modules"].append({"offset": position, "size": len(data), "sha256": digest,
                                  "basis": basis,
                                  "role_by_symbols": result["unique_modules"][digest]["role_by_symbols"]})

    for source in samples:
        filename = source["filename"]
        raw = (root / filename).read_bytes()
        if sha(raw) != source["sha256"]:
            raise ValueError(f"Source hash mismatch: {filename}")
        row = {"filename": filename, "sha256": source["sha256"], "format": source["format"],
               "modules": [], "scanned_regions": [], "networks": []}
        regions = []
        if source["format"] == "legacy_xor":
            for section in source["inspection"]["sections"]:
                if not section["name"].startswith("eg"):
                    continue
                data = (root / "analysis" / Path(filename).stem / section["name"]).read_bytes()
                if sha(data) != section["sha256"]:
                    raise ValueError("Section changed")
                regions.append((section["name"], 0, data))
                for entry in section.get("embedded_elf", {}).get("validated_structures", []):
                    blob = data[entry["offset"]:entry["offset"] + entry["size"]]
                    if sha(blob) != entry["sha256"]:
                        raise ValueError("ELF source changed")
                    record_module(blob, row, entry["offset"], "legacy_crc_verified")
        else:
            window = xor_bytes(raw[start:end], mask)
            regions.append(("reference_assisted_window", start, window))
            # Pin the known reference location before using data outside it.
            ref_start = window.find(reference[:64])
            if ref_start < 0 or window[ref_start:ref_start + len(reference)] != reference:
                raise ValueError(f"Reference overlap validation failed: {filename}")
            row["reference_interval"] = [start + ref_start, start + ref_start + len(reference)]
            for off in offsets(window, b"\x7fELF"):
                try:
                    info = elf_info(window[off:])
                    if info["machine"] != 245:
                        continue
                    blob = window[off:off + info["file_extent"]]
                except (ValueError, IndexError, struct.error, UnicodeError):
                    continue
                basis = "known_plaintext_reference" if sha(blob) == THIRD_SHA else "recovered_outside_own_reference"
                record_module(blob, row, start + off, basis)
            if filename == "Z5_2_0120.bin":
                # These earlier ELFs were independently exposed by two pairwise XORs.
                manifest = json.loads((root / "analysis/Z5_2_0120/manifest.json").read_text())
                for p in sorted((root / "analysis/Z5_2_0120/differential_candidates").glob("*.elf")):
                    data = p.read_bytes()
                    if sha(data) == THIRD_SHA:
                        continue
                    digest = sha(data)
                    entry = next((r for r in manifest["differential_candidates"] if r["sha256"] == digest), None)
                    if entry is None:
                        raise ValueError("Unrecorded differential ELF")
                    record_module(data, row, entry["original_file_offset"], "two_peer_differential_candidate")
        for name, origin, data in regions:
            row["scanned_regions"].append({"name": name, "origin": origin, "size": len(data),
                                           "sha256": sha(data), "markers": {
                                               m.decode(): [origin + i for i in offsets(data, m)] for m in MARKERS}})
            for candidate in network_candidates(data, origin):
                s = candidate["offset"] - origin
                blob = data[s:s + candidate["available_size"]]
                candidate["region"] = name
                candidate["outside_own_reference"] = source["format"] == "legacy_xor" or (
                    candidate["offset"] >= row["reference_interval"][1])
                if candidate["complete_within_window"]:
                    digest = candidate["sha256_available"]
                    networks_by_hash.setdefault(digest, []).append(filename)
                    destination = out / "network_candidates" / (digest + ".bin")
                    destination.parent.mkdir(exist_ok=True)
                    destination.write_bytes(blob)
                    if filename == "Z_8_0311.bin":
                        known_networks.append(blob)
                else:
                    candidate["matching_reference_prefixes"] = [sha(r) for r in known_networks if r.startswith(blob)]
                row["networks"].append(candidate)
        result["samples"].append(row)
    result["identical_complete_network_candidates"] = networks_by_hash
    profiles = result["unique_modules"]
    keys = list(profiles)
    for i, a in enumerate(keys):
        for b in keys[i + 1:]:
            pa, pb = profiles[a], profiles[b]
            if pa["role_by_symbols"] != pb["role_by_symbols"]:
                continue
            sa, sb = set(pa["source_files"]), set(pb["source_files"])
            fa, fb = set(pa["function_names"]), set(pb["function_names"])
            result["module_differences"].append({"a": a, "b": b, "role": pa["role_by_symbols"],
                "file_names_only_a": sorted(sa - sb), "file_names_only_b": sorted(sb - sa),
                "function_names_only_a": sorted(fa - fb), "function_names_only_b": sorted(fb - fa)})
    result["tool_sha256"] = sha(Path(__file__).read_bytes())
    (out / "manifest.json").write_text(json.dumps(result, indent=2) + "\n")
    print(f"Compared {len(samples)} samples, {len(profiles)} distinct CEVA binaries, "
          f"{len(networks_by_hash)} distinct complete network candidates")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", type=Path)
    analyze(parser.parse_args().directory)
