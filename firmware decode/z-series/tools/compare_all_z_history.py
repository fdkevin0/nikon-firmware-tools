#!/usr/bin/env python3
"""Compare every acquired release, preserving full vs partial decoding evidence."""

import argparse
import csv
import json
import re
import struct
from collections import Counter, defaultdict
from pathlib import Path

from analyze_firmware import decode_container, transform
from analyze_z8 import elf_info, inflate
from analyze_z_catalog import inspect_linux
from analyze_zf import xor_bytes
from compare_ai_modules import network_candidates, profile_elf, sha
from compare_z8_history import dispatch_table, inventory_diff, positional_diff, version_key


def component(name):
    """Retain master/slave roles rather than collapsing both to 'eg'."""
    if name.startswith("eg"):
        for processor in ("mas", "sla"):
            if f"_{processor}_" in name:
                return "eg_" + processor
    return re.sub(r"_?\d.*$", "", name.removesuffix(".bin"))


def compare_sections(before, after):
    a, b = ({s["component"]: s for s in rows} for rows in (before, after))
    if len(a) != len(before) or len(b) != len(after):
        raise ValueError("Ambiguous component roles")
    return [
        {
            "component": k,
            "change": "added"
            if k not in a
            else "removed"
            if k not in b
            else "identical"
            if a[k]["sha256"] == b[k]["sha256"]
            else "changed",
            "before_size": a.get(k, {}).get("size"),
            "after_size": b.get(k, {}).get("size"),
        }
        for k in sorted(a.keys() | b.keys())
    ]


def analyze(root):
    out = root / "analysis/all_history"
    downloads = json.loads((out / "downloads.json").read_text())
    catalog = json.loads((root / "analysis/catalog/deep_manifest.json").read_text())
    mask_info = catalog["expanded_shared_mask"]
    mask = (root / "analysis/catalog/shared_position_mask.bin").read_bytes()
    if sha(mask) != mask_info["sha256"]:
        raise ValueError("Mask changed")
    start, end = mask_info["start"], mask_info["end_exclusive"]
    z8 = json.loads((root / "analysis/z8_history/manifest.json").read_text())
    references = {
        key: (root / "analysis/z8_history/modules" / (key + ".elf")).read_bytes()
        for key, p in z8["unique_dsp_modules"].items()
        if p["role_by_symbols"] == "neural_inference"
    }
    fixed = (root / "Z_f_0301.bin").read_bytes()[:0x280]
    profiles = {}
    rows, unavailable, errors = [], [], []
    tool_sha = sha(Path(__file__).read_bytes())

    def modules(data, origin=0):
        found = []
        for match in re.finditer(b"\x7fELF", data):
            pos = match.start()
            try:
                info = elf_info(data[pos:])
                if info["machine"] != 245:
                    continue
                blob = data[pos : pos + info["file_extent"]]
                key = sha(blob)
                target = out / "modules" / (key + ".elf")
                profile_path = target.with_suffix(".json")
                if key not in profiles:
                    if profile_path.exists() and target.exists() and sha(target.read_bytes()) == key:
                        profiles[key] = json.loads(profile_path.read_text())
                    else:
                        p = profile_elf(blob, target)
                        p["dispatch_table"] = dispatch_table(blob, p, target.with_suffix(".symbols.csv"))
                        profiles[key] = p
                        profile_path.write_text(json.dumps(p, indent=2) + "\n")
                found.append(
                    {"offset": origin + pos, "size": len(blob), "sha256": key, "role": profiles[key]["role_by_symbols"]}
                )
            except (ValueError, IndexError, struct.error, UnicodeError):
                continue
        return found

    def networks(data, origin=0):
        found = [
            n for n in network_candidates(data, origin) if n["converter_marker_present"] and n["input_marker_present"]
        ]
        for n in found:
            if n["complete_within_window"]:
                p = out / "networks" / (n["sha256_available"] + ".bin")
                p.parent.mkdir(exist_ok=True)
                if not p.exists():
                    pos = n["offset"] - origin
                    p.write_bytes(data[pos : pos + n["available_size"]])
        return found

    for entry in sorted(downloads["versions"], key=lambda r: (r["model"], version_key(r["version"]))):
        d = entry.get("download", {})
        if d.get("status") not in ("existing", "downloaded"):
            unavailable.append(
                {"model": entry["model"], "version": entry["version"], "status": d.get("status", "pending")}
            )
            continue
        filename = d.get("path", entry["filename"])
        raw = (root / filename).read_bytes()
        if sha(raw) != d["sha256"]:
            raise ValueError(f"Raw source changed: {filename}")
        survey = out / "versions" / Path(filename).stem
        survey.mkdir(parents=True, exist_ok=True)
        cache = survey / "manifest.json"
        row = json.loads(cache.read_text()) if cache.exists() else {}
        if row.get("tool_sha256") == tool_sha and row.get("sha256") == d["sha256"]:
            rows.append(row)
            for m in row["dsp_modules"]:
                key = m["sha256"]
                profiles[key] = json.loads((out / "modules" / (key + ".json")).read_text())
            continue
        row = {
            "model": entry["model"],
            "version": entry["version"],
            "filename": filename,
            "sha256": d["sha256"],
            "size": len(raw),
            "release_date": entry.get("release_date"),
            "date_provenance": entry.get("release_date_provenance"),
            "download_url": d["url"],
            "sections": [],
            "dsp_modules": [],
            "networks": [],
            "tool_sha256": tool_sha,
        }
        try:
            if raw[:32] == b" " * 32 or raw[32:64] == b" " * 32:
                decoded, manifest = decode_container(raw)
                if raw[: manifest["xor_origin"]] + transform(decoded) != raw:
                    raise ValueError("Round-trip failure")
                row.update(
                    format="legacy_xor",
                    status="fully_decoded_crc_roundtrip",
                    package_crc16=manifest["package_crc16"],
                    round_trip_exact=True,
                    decoded_sha256=sha(decoded),
                    xor_origin=manifest["xor_origin"],
                )
                for section in manifest["sections"]:
                    off, size = section["container_offset"], section["size"]
                    data = decoded[off : off + size]
                    key = sha(data)
                    role = component(section["name"])
                    (survey / section["name"]).write_bytes(data)
                    row["sections"].append({**section, "component": role, "sha256": key})
                    if role.startswith("eg"):
                        ms = modules(data)
                        for m in ms:
                            m.update(section=section["name"], basis="legacy_crc_verified")
                        row["dsp_modules"].extend(ms)
                        ns = networks(data)
                        for n in ns:
                            n.update(section=section["name"], basis="legacy_crc_verified")
                        row["networks"].extend(ns)
                        row.setdefault("feature_markers", {})[role] = {
                            s.decode(): data.count(s)
                            for s in [
                                b"FaceDetectServic",
                                b"AnimalDetection",
                                b"VehicleDetection",
                                b"BirdDetection",
                                b"AutoCapture",
                                b"CDNN",
                                b"XM6NeuPro",
                            ]
                        }
                    if data.startswith(b"NISI"):
                        folder = out / "linux" / key
                        cached_linux = folder / "manifest.json"
                        if cached_linux.exists():
                            linux = json.loads(cached_linux.read_text())
                        else:
                            linux = inspect_linux(data, folder)
                            kernel = (folder / "Image").read_bytes()
                            linux["kernel_sha256"] = sha(kernel)
                            p = kernel.find(b"IKCFG_ST")
                            if p >= 0:
                                config, used = inflate(kernel[p + 8 :], 4 * 1024 * 1024)
                                if kernel[p + 8 + used : p + 16 + used] != b"IKCFG_ED":
                                    raise ValueError("Bad kernel config delimiter")
                                (folder / "kernel_config.txt").write_bytes(config)
                                linux["kernel_config_sha256"] = sha(config)
                            linux["cpio_manifest"] = str(folder / "cpio_manifest.json")
                            linux["dtb_hashes"] = {p.name: sha(p.read_bytes()) for p in folder.glob("*.dtb")}
                            cached_linux.write_text(json.dumps(linux, indent=2) + "\n")
                        row["linux"] = linux
                del decoded
            elif raw[0x260:0x280] == b" " * 32:
                row.update(
                    format="extended_0x260",
                    status="partial_no_container_crc",
                    mask=mask_info,
                    fixed_fields_match=all(
                        raw[a:b] == fixed[a:b] for a, b in [(0, 32), (0x120, 0x240), (0x260, 0x280)]
                    ),
                )
                window = xor_bytes(raw[start:end], mask)
                intervals = []
                for key, ref in references.items():
                    pos = window.find(ref[:64])
                    if pos >= 0 and window[pos : pos + len(ref)] == ref:
                        intervals.append({"start": start + pos, "end_exclusive": start + pos + len(ref), "sha256": key})
                row["reference_matches"] = intervals
                row["window_sha256"] = sha(window)
                if intervals:
                    (survey / "reference_assisted_window.bin").write_bytes(window)
                    row["dsp_modules"] = modules(window, start)
                    for m in row["dsp_modules"]:
                        m["basis"] = (
                            "reference_assisted_known_plaintext"
                            if m["sha256"] in references
                            else "outside_known_reference"
                        )
                    row["networks"] = networks(window, start)
                    for n in row["networks"]:
                        n["outside_own_reference"] = all(
                            n["offset"] + n["available_size"] <= x["start"] or n["offset"] >= x["end_exclusive"]
                            for x in intervals
                        )
                else:
                    row["status"] = "new_format_mask_not_validated"
            else:
                row.update(format="unknown", status="not_decoded")
            cache.write_text(json.dumps(row, indent=2) + "\n")
            rows.append(row)
            print(
                f"Compared {row['model']} {row['version']}: {row['status']}; {len(row['sections'])} sections, {len(row['dsp_modules'])} DSP",
                flush=True,
            )
        except Exception as error:
            errors.append({"model": entry["model"], "version": entry["version"], "error": str(error)})
            print("ERROR", errors[-1], flush=True)
    comparisons = []
    module_differences = {}
    for model in sorted({r["model"] for r in rows}):
        versions = [r for r in rows if r["model"] == model]
        for a, b in zip(versions, versions[1:]):
            delta = {
                "model": model,
                "from": a["version"],
                "to": b["version"],
                "format_changed": a["format"] != b["format"],
                "sections": compare_sections(a["sections"], b["sections"]),
                "dsp_before": [m["sha256"] for m in a["dsp_modules"]],
                "dsp_after": [m["sha256"] for m in b["dsp_modules"]],
                "networks_before": [n["sha256_available"] for n in a["networks"] if n["complete_within_window"]],
                "networks_after": [n["sha256_available"] for n in b["networks"] if n["complete_within_window"]],
            }
            ma, mb = ({m["role"]: m["sha256"] for m in r["dsp_modules"]} for r in (a, b))
            delta["dsp_changes"] = []
            for role in sorted(ma.keys() | mb.keys()):
                x, y = ma.get(role), mb.get(role)
                item = {
                    "role": role,
                    "before": x,
                    "after": y,
                    "change": "coverage_changed" if x is None or y is None else "identical" if x == y else "changed",
                }
                if x and y and x != y:
                    pair = x + ":" + y
                    item["difference_key"] = pair
                    if pair not in module_differences:
                        pa, pb = profiles[x], profiles[y]
                        fa, fb = set(pa["function_names"]), set(pb["function_names"])
                        def text_hashes(p):
                            return {t["name"]: t["sha256"] for t in p["sections"] if t["name"].startswith(".text")}
                        change = {
                            "role": role,
                            "before": x,
                            "after": y,
                            "function_names_added": sorted(fb - fa),
                            "function_names_removed": sorted(fa - fb),
                            "all_text_sections_identical": text_hashes(pa) == text_hashes(pb),
                            "same_offset_bytes": positional_diff(
                                (out / "modules" / (x + ".elf")).read_bytes(),
                                (out / "modules" / (y + ".elf")).read_bytes(),
                            ),
                        }
                        ta, tb = pa.get("dispatch_table"), pb.get("dispatch_table")
                        if ta and tb:
                            da = {r["slot"]: r["function_names"] for r in ta["entries"]}
                            db = {r["slot"]: r["function_names"] for r in tb["entries"]}
                            change["dispatch_name_changes"] = [
                                {"slot": i, "before": da.get(i), "after": db.get(i)}
                                for i in sorted(da.keys() | db.keys())
                                if da.get(i) != db.get(i)
                            ]
                        module_differences[pair] = change
                delta["dsp_changes"].append(item)
            if "linux" in a and "linux" in b:
                la, lb = a["linux"], b["linux"]
                delta["linux"] = {
                    k + "_identical": la.get(k) == lb.get(k)
                    for k in ["kernel_sha256", "kernel_config_sha256", "dtb_hashes", "LaMainApp"]
                }
                delta["linux"]["rootfs"] = inventory_diff(
                    json.loads(Path(la["cpio_manifest"]).read_text()), json.loads(Path(lb["cpio_manifest"]).read_text())
                )
            comparisons.append(delta)
    module_groups, network_groups = defaultdict(list), defaultdict(list)
    for r in rows:
        for m in r["dsp_modules"]:
            module_groups[m["sha256"]].append({"model": r["model"], "version": r["version"], "basis": m["basis"]})
        for n in r["networks"]:
            if n["complete_within_window"]:
                network_groups[n["sha256_available"]].append({"model": r["model"], "version": r["version"]})
    summary = {
        "versions": rows,
        "adjacent_comparisons": comparisons,
        "unavailable_versions": unavailable,
        "errors": errors,
        "unique_dsp_modules": profiles,
        "dsp_identity_groups": module_groups,
        "network_identity_groups": network_groups,
        "dsp_differences": module_differences,
        "tool_sha256": tool_sha,
    }
    (out / "manifest.json").write_text(json.dumps(summary, indent=2) + "\n")
    report(out, summary)
    print("TOTAL", len(rows), dict(Counter(r["status"] for r in rows)), "errors", errors, flush=True)


def report(out, s):
    rows = s["versions"]
    lines = [
        "# Comprehensive Z-Series Historical Firmware Extraction and Comparison",
        "",
        "**Key findings are summarized in [Historical Comparison Findings](FINDINGS.md)**, including Z9 DSP evolution, Z f intermediate version validation, and Linux network component changes.",
        "",
        "Scope: Known firmware release records across all 15 official Z-series camera models. Missing original packages are listed separately; factory version records do not imply public downloads were ever available.",
        "",
        f"Analyzed **{len(rows)}** firmware releases totaling **{sum(r['size'] for r in rows):,} bytes** of raw binary files; **{len(s['unavailable_versions'])}** cataloged packages remain unavailable.",
        "",
        f"Fully decoded {sum(r['status'] == 'fully_decoded_crc_roundtrip' for r in rows)} packages across {sum(len(r['sections']) for r in rows)} sections, all verified with section CRC, package CRC, and bit-for-bit re-encoding roundtrip. Modern container formats are compared locally within verified windows only and are not counted as fully decoded.",
        "",
        "| Model | Acquired Versions | Full Decode / Partial | Missing Packages |",
        "|---|---|---:|---|",
    ]
    for model in sorted({r["model"] for r in rows}):
        group = [r for r in rows if r["model"] == model]
        full = sum(r["status"] == "fully_decoded_crc_roundtrip" for r in group)
        missing = [r["version"] for r in s["unavailable_versions"] if r["model"] == model]
        lines.append(
            f"| {model} | {', '.join(r['version'] for r in group)} | {full} / {len(group) - full} | {', '.join(missing) or '—'} |"
        )
    lines += [
        "",
        "## DSP and Network Data Version Grouping",
        "",
        "Identical groups are determined by full SHA-256 hash. Known DSP modules in newer containers serve as reference anchors rather than independent plaintext discoveries; network data recovered outside that scope is documented separately.",
        "",
        "| DSP Fingerprint (SHA-256 First 12) | Role by Symbols | Size (Bytes) | Models and Matching Versions |",
        "|---|---|---:|---|",
    ]
    for key, members in s["dsp_identity_groups"].items():
        groups = defaultdict(list)
        for member in members:
            groups[member["model"]].append(member["version"])
        p = s["unique_dsp_modules"][key]
        labels = "; ".join(model + ": " + ", ".join(versions) for model, versions in groups.items())
        lines.append(f"| `{key[:12]}` | {p['role_by_symbols']} | {p['size']:,} | {labels} |")
    lines += [
        "",
        f"A total of **{len(s['network_identity_groups'])}** distinct full network candidates were identified; see `network_identity_groups` in the manifest for full coverage versions and SHA-256 hashes. Versions not covered or only covering prefixes are excluded from full equivalence conclusions.",
        "",
        "## Version-by-Version Differences by Model",
        "",
        "Section changes are determined by full SHA-256 comparison. 'Identical' denotes byte-for-byte equivalence; changes do not necessarily indicate feature changes. DSP modules are identified by embedded ELF contents; network data represents boundary-verified candidate formats with unparsed layers and operators.",
        "",
    ]
    for model in sorted({r["model"] for r in rows}):
        lines += [
            f"### {model}",
            "",
            "| Version Transition | Changed Sections | Unchanged Sections | DSP / Network Candidate | Linux Rootfs |",
            "|---|---|---|---|---|",
        ]
        for d in s["adjacent_comparisons"]:
            if d["model"] != model:
                continue
            changed = ", ".join(
                x["component"] + (f"({x['change']})" if x["change"] in ("added", "removed") else "")
                for x in d["sections"]
                if x["change"] != "identical"
            )
            same = ", ".join(x["component"] for x in d["sections"] if x["change"] == "identical")
            ai = []
            for name, key in [("DSP", "dsp"), ("Network", "networks")]:
                old, new = d[key + "_before"], d[key + "_after"]
                ai.append(name + (" Not covered" if not old and not new else " Identical" if old == new else " Changed/Coverage delta"))
            linux = d.get("linux", {}).get("rootfs")
            fs = (
                "—" if linux is None else f"mod:{len(linux['changed'])} add:{len(linux['added'])} del:{len(linux['removed'])}"
            )
            lines.append(
                f"| {d['from']} -> {d['to']} | {changed or 'Not fully decoded' if not d['sections'] else changed or '—'} | {same or '—'} | {'; '.join(ai)} | {fs} |"
            )
        lines.append("")
    lines += [
        "## Evidence and Reproduction",
        "",
        "- [Official Source URL History and Discovery Process](SOURCES.md); [Download Manifest and SHA-256](downloads.json); [Full Machine-Readable Comparison](manifest.json).",
        "- `coverage.csv` lists per-version status; `versions/<BIN_NAME>/manifest.json` provides section, DSP, network, and Linux evidence.",
        "- Modern format analysis relies on fixed-offset masks cross-validated across overlapping camera models, requiring a full match of the known DSP ELF before analyzing the window. Matching ELF instances should not be considered independent discoveries; regions outside the window, the full modern container, and container CRCs remain undecoded.",
        "- Equivalence in network candidates applies strictly to extracted regions and does not imply identity across all models, full AI pipelines, or camera features. The absence of ELF/markers does not imply absence of AI functionality.",
        "- Static unpacking and inspection only; no firmware or installers were executed, and no raw firmware was modified. All downloads originate from official Nikon CDNs; release dates are estimated from HTTP Last-Modified headers when unstated.",
        "",
        "```sh",
        "uv run python tools/discover_z_history.py",
        "uv run python tools/collect_all_z_history.py .",
        "uv run python tools/compare_all_z_history.py .",
        "uv run pytest",
        "```",
        "",
    ]
    if s["errors"]:
        lines += ["Analysis errors: `" + json.dumps(s["errors"], ensure_ascii=False) + "`", ""]
    (out / "REPORT.md").write_text("\n".join(lines))
    with (out / "coverage.csv").open("w", newline="") as file:
        fields = ["model", "version", "status", "filename", "size", "sha256"]
        writer = csv.DictWriter(file, fieldnames=fields, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows + s["unavailable_versions"])


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", type=Path)
    analyze(parser.parse_args().directory)
