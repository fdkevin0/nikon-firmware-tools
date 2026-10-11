#!/usr/bin/env python3
"""Decode and compare downloaded Z8 releases without executing firmware.

Reports container checks, component identities, CEVA code/symbols, bounded
network candidates, Linux kernel/rootfs/DTB changes, and adjacent-release diffs.
Byte identity and symbol differences are not runtime performance measurements.
"""

import argparse
import csv
import difflib
import hashlib
import json
import re
import struct
from collections import defaultdict
from pathlib import Path

from analyze_firmware import analyze as decode
from analyze_z8 import inflate
from analyze_z_catalog import inspect_linux, scan_elf
from compare_ai_modules import network_candidates, profile_elf, sha


def version_key(text):
    return tuple(map(int, text.split(".")))


def component(name):
    return "touch" if name.startswith("_tp") else name[:2]


def inventory_diff(before, after):
    """Compare archive content/type/mode; omit build-time inode and timestamps."""
    a, b = ({r["path"]: r for r in rows} for rows in (before, after))
    common = a.keys() & b.keys()
    keys = ("type", "mode", "sha256", "target", "rdevice")
    changed = [p for p in sorted(common) if any(a[p].get(k) != b[p].get(k) for k in keys)]
    return {
        "added": sorted(b.keys() - a.keys()),
        "removed": sorted(a.keys() - b.keys()),
        "changed": changed,
        "unchanged_count": len(common) - len(changed),
        "compared_fields": keys,
    }


def positional_diff(a, b):
    """Exact byte comparison at equal offsets; relocation is not normalized."""
    common = min(len(a), len(b))
    changed, blocks, first, last = 0, 0, None, None
    examples = []
    for offset in range(0, common, 4096):
        x, y = a[offset : min(offset + 4096, common)], b[offset : min(offset + 4096, common)]
        if x == y:
            continue
        different = [i for i, (u, v) in enumerate(zip(x, y)) if u != v]
        changed += len(different)
        blocks += 1
        if first is None:
            first = offset + different[0]
        last = offset + different[-1]
        if len(examples) < 12:
            examples.append({"block_offset": offset, "differing_bytes": len(different)})
    return {
        "compared_bytes": common,
        "differing_bytes": changed,
        "equal_bytes": common - changed,
        "before_uncompared_tail": len(a) - common,
        "after_uncompared_tail": len(b) - common,
        "changed_4096_byte_blocks": blocks,
        "first_difference": first,
        "last_difference": last,
        "first_changed_blocks": examples,
        "interpretation": "Equal offsets only; linker relocation and layout changes are not code-semantic changes",
    }


def dispatch_table(data, profile, symbols_path):
    with symbols_path.open() as file:
        symbols = list(csv.DictReader(file))
    table = next((r for r in symbols if r["name"] == "g_NikonDspFrameworkFunctionTable"), None)
    if table is None:
        return None
    address, size = int(table["value"], 16), int(table["size"])
    section = next(
        s
        for s in profile["sections"]
        if s["type"] != 8 and s["vaddr"] <= address and address + size <= s["vaddr"] + s["size"]
    )
    offset = section["offset"] + address - section["vaddr"]
    if size % 4:
        raise ValueError("Unaligned DSP function-pointer table")
    names = defaultdict(list)
    for symbol in symbols:
        if int(symbol["info"]) & 15 == 2:
            names[int(symbol["value"], 16)].append(symbol["name"])
    return {
        "symbol": table["name"],
        "vaddr": address,
        "elf_file_offset": offset,
        "entries": [
            {"slot": i, "target": target, "function_names": sorted(names[target])}
            for i, (target,) in enumerate(struct.iter_unpack("<I", data[offset : offset + size]))
        ],
    }


def compare(root):
    out = root / "analysis/z8_history"
    downloads = json.loads((out / "downloads.json").read_text())
    summary = {
        "versions": [],
        "adjacent_comparisons": [],
        "unique_dsp_modules": {},
        "unavailable_versions": [],
        "tool_sha256": sha(Path(__file__).read_bytes()),
    }
    net_members = defaultdict(list)
    component_members = defaultdict(list)

    def checkpoint():
        (out / "manifest.json").write_text(json.dumps(summary, indent=2) + "\n")

    for entry in sorted(downloads["versions"], key=lambda r: version_key(r["version"])):
        if entry.get("download", {}).get("status") not in ("existing", "downloaded"):
            summary["unavailable_versions"].append(entry)
            continue
        filename, ver = entry["filename"], entry["version"]
        source = root / filename
        with source.open("rb") as file:
            digest = hashlib.file_digest(file, "sha256").hexdigest()
        if digest != entry["download"]["sha256"]:
            raise ValueError(f"Raw source changed: {filename}")
        directory = root / "analysis" / source.stem
        manifest_path = directory / "manifest.json"
        manifest = json.loads(manifest_path.read_text()) if manifest_path.exists() else {}
        decoded = directory / "decoded_package.bin"
        reusable = (
            manifest.get("input_sha256") == digest
            and manifest.get("round_trip_exact")
            and manifest.get("package_crc16", {}).get("valid")
            and decoded.exists()
            and sha(decoded.read_bytes()) == manifest.get("decoded_sha256")
        )
        if not reusable:
            print(f"Decode and validate {ver}: {filename}", flush=True)
            manifest = decode(source, directory)
        row = {
            "version": ver,
            "filename": filename,
            "release_date": entry.get("release_date"),
            "source_page": entry.get("page_url"),
            "download_url": entry["download"]["url"],
            "sha256": digest,
            "size": source.stat().st_size,
            "xor_origin": manifest["xor_origin"],
            "round_trip_exact": manifest["round_trip_exact"],
            "package_crc16": manifest["package_crc16"],
            "sections": [],
            "dsp_modules": [],
            "network_candidates": [],
        }
        survey = out / "versions" / source.stem
        survey.mkdir(parents=True, exist_ok=True)
        seen_roles = set()
        for section in manifest["sections"]:
            data = (directory / section["name"]).read_bytes()
            if sha(data) != section["sha256"] or not section["crc16"]["valid"]:
                raise ValueError("Section changed or invalid CRC")
            role = component(section["name"])
            if role in seen_roles:
                raise ValueError("Ambiguous component role")
            seen_roles.add(role)
            row["sections"].append({**section, "component": role})
            component_members[role + ":" + section["sha256"]].append(ver)
            if role == "eg":
                elfs = scan_elf(data, survey / "embedded_elf")
                row["rejected_elf_magic_hits"] = elfs["rejected_magic_hits"]
                for elf in elfs["validated_structures"]:
                    if elf["machine"] != 245:
                        continue
                    key = elf["sha256"]
                    blob = data[elf["offset"] : elf["offset"] + elf["size"]]
                    if key not in summary["unique_dsp_modules"]:
                        target = out / "modules" / (key + ".elf")
                        profile = profile_elf(blob, target)
                        profile["dispatch_table"] = dispatch_table(blob, profile, target.with_suffix(".symbols.csv"))
                        summary["unique_dsp_modules"][key] = profile
                    row["dsp_modules"].append(
                        {**elf, "role_by_symbols": summary["unique_dsp_modules"][key]["role_by_symbols"]}
                    )
                for net in network_candidates(data):
                    if not (net["converter_marker_present"] and net["input_marker_present"]):
                        continue
                    net["offset_basis"] = "decoded EG section"
                    row["network_candidates"].append(net)
                    if net["complete_within_window"]:
                        key = net["sha256_available"]
                        dest = out / "networks" / (key + ".bin")
                        dest.parent.mkdir(exist_ok=True)
                        dest.write_bytes(data[net["offset"] : net["offset"] + net["available_size"]])
                        net_members[key].append(ver)
                row["feature_strings"] = [
                    {"offset": m.start(), "text": m.group().decode()}
                    for m in re.finditer(rb"[ -~]{8,}", data)
                    if re.search(
                        rb"AutoCapture|SubjectDetection|BirdDetection|HighIsoNr|FilmGrain|FirmwareManagement_Device_Ai",
                        m.group(),
                    )
                ]
            if data.startswith(b"NISI"):
                row["linux"] = inspect_linux(data, survey / "linux")
                kernel = (survey / "linux/Image").read_bytes()
                pos = kernel.find(b"IKCFG_ST")
                if pos >= 0:
                    config, used = inflate(kernel[pos + 8 :], 4 * 1024 * 1024)
                    if kernel[pos + 8 + used : pos + 16 + used] != b"IKCFG_ED":
                        raise ValueError("Bad kernel config delimiter")
                    (survey / "linux/kernel_config.txt").write_bytes(config)
                    row["linux"]["kernel_config_sha256"] = sha(config)
                row["linux"]["kernel_sha256"] = sha(kernel)
                row["linux"]["cpio_manifest"] = str(survey / "linux/cpio_manifest.json")
        row["section_count"] = len(row["sections"])
        summary["versions"].append(row)
        (survey / "manifest.json").write_text(json.dumps(row, indent=2) + "\n")
        print(
            f"Verified {ver}: {row['section_count']} sections, {len(row['dsp_modules'])} CEVA, "
            f"{len(row['network_candidates'])} networks",
            flush=True,
        )
        checkpoint()

    for before, after in zip(summary["versions"], summary["versions"][1:]):
        delta = {"from": before["version"], "to": after["version"], "sections": [], "dsp": [], "networks": []}
        old = {s["component"]: s for s in before["sections"]}
        new = {s["component"]: s for s in after["sections"]}
        for role in sorted(old.keys() | new.keys()):
            a, b = old.get(role), new.get(role)
            section_delta = {
                "component": role,
                "before_name": a["name"] if a else None,
                "after_name": b["name"] if b else None,
                "identical": bool(a and b and a["sha256"] == b["sha256"]),
                "before_size": a["size"] if a else None,
                "after_size": b["size"] if b else None,
            }
            if a and b and not section_delta["identical"]:
                pa = root / "analysis" / Path(before["filename"]).stem / a["name"]
                pb = root / "analysis" / Path(after["filename"]).stem / b["name"]
                section_delta["same_offset_byte_comparison"] = positional_diff(pa.read_bytes(), pb.read_bytes())
            delta["sections"].append(section_delta)
        # Keep slot identity explicit; do not silently match differently placed programs by size.
        for index in range(max(len(before["dsp_modules"]), len(after["dsp_modules"]))):
            a = before["dsp_modules"][index] if index < len(before["dsp_modules"]) else None
            b = after["dsp_modules"][index] if index < len(after["dsp_modules"]) else None
            item = {
                "slot": index + 1,
                "before_sha256": a["sha256"] if a else None,
                "after_sha256": b["sha256"] if b else None,
                "identical": bool(a and b and a["sha256"] == b["sha256"]),
            }
            if a and b and not item["identical"]:
                pa, pb = (summary["unique_dsp_modules"][x["sha256"]] for x in (a, b))
                fa, fb = set(pa["function_names"]), set(pb["function_names"])
                item.update(function_names_removed=sorted(fa - fb), function_names_added=sorted(fb - fa))
                def text_hashes(p):
                    return {s["name"]: s["sha256"] for s in p["sections"] if s["name"].startswith(".text")}
                item["all_text_sections_identical"] = text_hashes(pa) == text_hashes(pb)
                item["same_offset_byte_comparison"] = positional_diff(
                    (out / "modules" / (a["sha256"] + ".elf")).read_bytes(),
                    (out / "modules" / (b["sha256"] + ".elf")).read_bytes(),
                )
                ta, tb = pa.get("dispatch_table"), pb.get("dispatch_table")
                if ta and tb:
                    da = {r["slot"]: r["function_names"] for r in ta["entries"]}
                    db = {r["slot"]: r["function_names"] for r in tb["entries"]}
                    item["dispatch_name_changes"] = [
                        {"slot": n, "before": da.get(n), "after": db.get(n)}
                        for n in sorted(da.keys() | db.keys())
                        if da.get(n) != db.get(n)
                    ]
            delta["dsp"].append(item)
        delta["networks"] = {
            "before": [n["sha256_available"] for n in before["network_candidates"]],
            "after": [n["sha256_available"] for n in after["network_candidates"]],
        }
        if "linux" in before and "linux" in after:
            la, lb = before["linux"], after["linux"]
            delta["linux"] = {
                "kernel_identical": la["kernel_sha256"] == lb["kernel_sha256"],
                "config_identical": la.get("kernel_config_sha256") == lb.get("kernel_config_sha256"),
                "LaMainApp_identical": la.get("LaMainApp") == lb.get("LaMainApp"),
                "rootfs": inventory_diff(
                    json.loads(Path(la["cpio_manifest"]).read_text()), json.loads(Path(lb["cpio_manifest"]).read_text())
                ),
            }
            changes = out / "diffs" / (before["version"] + "_to_" + after["version"])
            changes.mkdir(parents=True, exist_ok=True)
            for name in ["device_tree_0.dtb.dts", "device_tree_1.dtb.dts", "kernel_config.txt"]:
                pa = Path(la["cpio_manifest"]).parent / name
                pb = Path(lb["cpio_manifest"]).parent / name
                if pa.exists() and pb.exists():
                    diff = "".join(
                        difflib.unified_diff(
                            pa.read_text().splitlines(True),
                            pb.read_text().splitlines(True),
                            fromfile=before["version"] + "/" + name,
                            tofile=after["version"] + "/" + name,
                        )
                    )
                    (changes / (name + ".diff")).write_text(diff)
        summary["adjacent_comparisons"].append(delta)
    summary["component_identity_groups"] = dict(component_members)
    summary["network_identity_groups"] = dict(net_members)
    checkpoint()
    print(f"Compared {len(summary['versions'])} Z8 releases", flush=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", type=Path)
    compare(parser.parse_args().directory)
