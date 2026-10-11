#!/usr/bin/env python3
"""Build local, searchable references from the recorded Nikon Remote SDK ZIP.

Uses Python stdlib and pdftotext. Never loads SDK libraries or executes samples.
Generated originals/text/indexes stay in this reference directory.
"""

import bisect
import csv
import hashlib
import json
import re
import shutil
import subprocess
import zipfile
from collections import Counter
from pathlib import Path, PurePosixPath
from urllib.parse import quote

EXPECTED_SHA256 = "d8ff7b10061c3a69ba11c66e2d2cca058b88efd01de346d9152ff34b5202f3fb"
HERE = Path(__file__).resolve().parent
SOURCE = HERE.parents[1] / "S-SDKZ-200BF-ALLIN.zip"
MODELS = {
    "Z 30UsbMtpE_02.pdf": "Z30",
    "Z 50UsbMtpE_04.pdf": "Z50",
    "Z 50_2UsbMtpE_01.pdf": "Z50II",
    "Z 5UsbMtpE_02.pdf": "Z5",
    "Z 6UsbMtpE_04.pdf": "Z6",
    "Z 6_2UsbMtpE_02.pdf": "Z6II",
    "Z 7UsbMtpE_04.pdf": "Z7",
    "Z 7_2UsbMtpE_01.pdf": "Z7II",
    "Z 8UsbMtpE_02.pdf": "Z8",
    "Z 9UsbMtpE_06.pdf": "Z9",
    "Z fcUsbMtpE_180.pdf": "Z fc",
    "Z5_2UsbMtpE_01.pdf": "Z5II",
    "Z6IIIUsbMtpE_02.pdf": "Z6III",
    "ZfUsbMtpE_02.pdf": "Z f",
    "ZRUsbMtpE_100.pdf": "ZR",
}
MODEL_BLOCK = re.compile(r"<model:([^>]+)>(.*?)</model>", re.S)
CAPABILITY = re.compile(r"<capability:([^>]+)>(.*?)</capability>", re.S)
VERSION_BLOCK = re.compile(r"<version:([^>]+)>(.*?)</version>", re.S)
VERSION_LABEL = re.compile(r"<version>([^<]+)</version>|<version(?:Info)?:([^>]+)>")


def digest(data):
    return hashlib.sha256(data).hexdigest()


def write(relative, data):
    target = HERE / relative
    if not target.resolve().is_relative_to(HERE):
        raise ValueError(f"Output escapes reference directory: {relative}")
    target.parent.mkdir(parents=True, exist_ok=True)
    if isinstance(data, str):
        data = data.encode("utf-8")
    target.write_bytes(data)


def write_csv(name, fields, rows):
    path = HERE / "indexes" / name
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as stream:
        writer = csv.DictWriter(stream, fieldnames=fields)
        writer.writeheader()
        writer.writerows(rows)


def selected(name):
    return (
        name == "ReadMe_En.txt"
        or name.startswith(("Command/English/", "Module/Document/English/"))
        and name.endswith(".pdf")
        or "/HeaderFile/" in name
        and name.lower().endswith(".h")
        or "/SampleApp/" in name
        and name.endswith(".cpp")
        or name.startswith("Module/Win/BinaryFile/")
        and name.endswith(".config")
    )


def tags(body, tag):
    return " | ".join(re.findall(r"<" + tag + r">(.*?)</" + tag + r">", body, re.S))


def config_indexes(name, text):
    newlines = [m.start() for m in re.finditer("\n", text)]
    def line(offset):
        return bisect.bisect_left(newlines, offset) + 1
    blocks, caps, selectors, ranges = [], [], [], []
    matches = list(MODEL_BLOCK.finditer(text))
    if len(matches) != len(re.findall(r"<model:[^>]+>", text)) or len(matches) != text.count("</model>"):
        raise ValueError(f"Unbalanced model blocks in {name}")
    for ordinal, match in enumerate(matches, 1):
        model, body = match.groups()
        versions = list(dict.fromkeys(a or b for a, b in VERSION_LABEL.findall(body)))
        base = {"file": name, "model_block": ordinal, "model_label": model}
        blocks.append(
            {
                **base,
                "line": line(match.start()),
                "version_labels": " | ".join(versions),
                "capability_records": len(CAPABILITY.findall(body)),
                "property_selector_records": body.count("<usPropSel:"),
            }
        )
        if name == "MaidLayer.config":
            if len(versions) != 1:
                raise ValueError(f"Expected one version per MAID model block: {model}")
            for cap in CAPABILITY.finditer(body):
                label, content = cap.groups()
                symbol, code = label.rsplit("-", 1)
                caps.append(
                    {
                        **base,
                        "version_label": versions[0],
                        "line": line(match.start(2) + cap.start()),
                        "capability": symbol,
                        "maid_id_decimal": code,
                        "maid_id_hex": hex(int(code)),
                        "description_raw": tags(content, "description"),
                        "allowedoperation_raw": " | ".join(re.findall(r"<allowedoperation:([^>]+)>", content)),
                        "device_command_raw": tags(content, "DeviceCommand"),
                    }
                )
        elif name == "DC_PTP_Config.config":
            for prop in re.finditer(r"<usPropSel:([^>]+)>(.*?)</usPropSel>", body, re.S):
                selectors.append(
                    {
                        **base,
                        "version_labels": " | ".join(versions),
                        "line": line(match.start(2) + prop.start()),
                        "selector_header_raw": prop.group(1),
                        "property_conversion_raw": tags(prop.group(2), "PropConv"),
                    }
                )
        else:
            covered = 0
            for version in VERSION_BLOCK.finditer(body):
                for cap in CAPABILITY.finditer(version.group(2)):
                    symbol, code = cap.group(1).rsplit("-", 1)
                    value_tags = re.findall(r"<(value|default):([^>]+)>(.*?)</\1>", cap.group(2), re.S)
                    ranges.append(
                        {
                            **base,
                            "version_label": version.group(1),
                            "line": line(match.start(2) + version.start(2) + cap.start()),
                            "capability": symbol,
                            "maid_id_decimal": code,
                            "values_raw": " | ".join(f"{t}:{v.strip()}" for k, t, v in value_tags if k == "value"),
                            "defaults_raw": " | ".join(f"{t}:{v.strip()}" for k, t, v in value_tags if k == "default"),
                        }
                    )
                    covered += 1
            if covered != len(CAPABILITY.findall(body)):
                raise ValueError(f"Range capability outside version scope: {model}")
    return blocks, caps, selectors, ranges


def main():
    if not shutil.which("pdftotext"):
        raise SystemExit("pdftotext is required (Poppler); no SDK binary will be run")
    raw = SOURCE.read_bytes()
    if digest(raw) != EXPECTED_SHA256:
        raise SystemExit("Archive differs from the documented SDK; review before importing another version")
    inventory, documents, codes = [], [], []
    blocks, caps, selectors, ranges = [], [], [], []
    with zipfile.ZipFile(SOURCE) as archive:
        entries = archive.infolist()
        if len({item.filename for item in entries}) != len(entries):
            raise ValueError("Duplicate ZIP member names")
        for entry in entries:
            name = entry.filename
            if PurePosixPath(name).is_absolute() or ".." in PurePosixPath(name).parts or "\\" in name:
                raise ValueError("Unexpected ZIP path")
            data = b"" if entry.is_dir() else archive.read(entry)  # zipfile verifies CRC on read.
            keep = not entry.is_dir() and selected(name)
            inventory.append(
                {
                    "path": name,
                    "size": entry.file_size,
                    "compressed_size": entry.compress_size,
                    "directory": entry.is_dir(),
                    "zip_crc32": f"{entry.CRC:08x}",
                    "sha256": None if entry.is_dir() else digest(data),
                    "extracted": keep,
                }
            )
            if not keep:
                continue
            write("original/" + name, data)
            if name.endswith(".pdf"):
                proc = subprocess.run(
                    ["pdftotext", "-layout", "-", "-"],
                    input=data,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    check=True,
                )
                text = proc.stdout.decode("utf-8")
                pages = text.split("\f")
                if not pages[-1].strip():
                    pages.pop()
                if not pages or not any(p.strip() for p in pages):
                    raise ValueError(f"No searchable text: {name}")
                target = "text/" + str(PurePosixPath(name).with_suffix(".txt"))
                write(target, text)
                rev = re.search(r"Rev\.\s*([\d.]+)", pages[0])
                model = MODELS.get(PurePosixPath(name).name, "Common")
                documents.append(
                    {
                        "archive_path": name,
                        "model": model,
                        "revision_on_cover": rev.group(1) if rev else "not stated",
                        "pages": len(pages),
                        "pdf": "original/" + name,
                        "text": target,
                        "sha256": digest(data),
                        "conversion_stderr": proc.stderr.decode("utf-8", errors="replace"),
                    }
                )
                for page_number, page in enumerate(pages, 1):
                    section_hint = ""
                    for number, row in enumerate(page.splitlines(), 1):
                        heading = re.match(r"^\s*(\d+(?:\.\d+)+)\s+([A-Za-z][A-Za-z0-9_()/ -]{1,100})\s*$", row)
                        if heading:
                            section_hint = heading.group(1) + " " + heading.group(2).strip()
                        hit = re.search(
                            r"\b(Operation|Property|Event|Response)\s+Code\s*:?\s*(0x[0-9A-Fa-f]{4,8})\b", row
                        )
                        if hit:
                            codes.append(
                                {
                                    "model": model,
                                    "pdf": "original/" + name,
                                    "page": page_number,
                                    "page_line": number,
                                    "kind": hit.group(1),
                                    "code": hit.group(2),
                                    "section_hint": section_hint,
                                    "source_line": row.strip(),
                                }
                            )
            elif name.endswith(".config"):
                b, c, s, r = config_indexes(PurePosixPath(name).name, data.decode("utf-8-sig"))
                blocks.extend(b)
                caps.extend(c)
                selectors.extend(s)
                ranges.extend(r)
    if Counter(d["model"] for d in documents) != Counter(list(MODELS.values()) + ["Common"] * 3):
        raise ValueError("Expected 15 camera PDFs and three common PDFs")
    columns = {
        "model_blocks.csv": (
            [
                "file",
                "model_block",
                "model_label",
                "line",
                "version_labels",
                "capability_records",
                "property_selector_records",
            ],
            blocks,
        ),
        "maid_capabilities.csv": (
            [
                "file",
                "model_block",
                "model_label",
                "version_label",
                "line",
                "capability",
                "maid_id_decimal",
                "maid_id_hex",
                "description_raw",
                "allowedoperation_raw",
                "device_command_raw",
            ],
            caps,
        ),
        "ptp_property_mappings.csv": (
            [
                "file",
                "model_block",
                "model_label",
                "version_labels",
                "line",
                "selector_header_raw",
                "property_conversion_raw",
            ],
            selectors,
        ),
        "range_values.csv": (
            [
                "file",
                "model_block",
                "model_label",
                "version_label",
                "line",
                "capability",
                "maid_id_decimal",
                "values_raw",
                "defaults_raw",
            ],
            ranges,
        ),
        "protocol_code_locations.csv": (
            ["model", "pdf", "page", "page_line", "kind", "code", "section_hint", "source_line"],
            codes,
        ),
    }
    for name, (fields, rows) in columns.items():
        write_csv(name, fields, rows)
    summary = {
        "source": "../../S-SDKZ-200BF-ALLIN.zip",
        "source_sha256": EXPECTED_SHA256,
        "source_size": len(raw),
        "zip_entries": len(inventory),
        "extracted_files": sum(i["extracted"] for i in inventory),
        "all_member_crcs_verified": True,
        "pdf_count": len(documents),
        "pdf_page_count": sum(d["pages"] for d in documents),
        "index_rows": {name: len(rows) for name, (_, rows) in columns.items()},
        "documents": documents,
        "archive_inventory": inventory,
        "limits": [
            "No SDK executable or library executed",
            "No camera connected",
            "Config scopes preserved; inheritance and runtime support not resolved",
            "PDF code locations are matching explicit Code lines, not an exhaustive protocol parser",
        ],
    }
    write("manifest.json", json.dumps(summary, ensure_ascii=False, indent=2) + "\n")
    lines = [
        "# Remote SDK Protocol Document Index",
        "",
        "Generated by `build_reference.py` from the local ZIP package. Revisions reflect PDF cover markings rather than firmware versions; filenames do not strictly track cover revisions. Page counts include blank pages based on sequential PDF numbering.",
        "",
        "| Model / Scope | Document | Cover Revision | Pages | Local PDF | Searchable Text |",
        "| --- | --- | --- | ---: | --- | --- |",
    ]
    for doc in documents:
        lines.append(
            f"| {doc['model']} | `{PurePosixPath(doc['archive_path']).name}` | {doc['revision_on_cover']} | {doc['pages']} | [PDF]({quote(doc['pdf'])}) | [Text]({quote(doc['text'])}) |"
        )
    lines.extend(
        [
            "",
            "## Protocol Code Location Index",
            "",
            "[protocol_code_locations.csv](indexes/protocol_code_locations.csv) captures text lines explicitly defining Operation, Property, Event, and Response codes alongside PDF filepaths and page numbers.",
            "",
            "This index is for navigational reference. Definitions spanning multiple lines or layout tables may not be matched. Always consult the original PDF for complete definitions, valid ranges, mode prerequisites, and error conditions.",
            "",
        ]
    )
    write("PROTOCOLS.md", "\n".join(lines))
    print(
        json.dumps(
            {k: summary[k] for k in ["extracted_files", "pdf_count", "pdf_page_count", "index_rows"]},
            ensure_ascii=False,
        )
    )


if __name__ == "__main__":
    main()
