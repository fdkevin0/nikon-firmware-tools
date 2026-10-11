#!/usr/bin/env python3
"""Download discovered official Z8 historical BINs without executing them.

Discovery is recorded separately because Nikon's live pages omit old links.
An unavailable historical link is retained as a gap, never treated as a download.
"""

import argparse
import hashlib
import json
import os
import subprocess
import urllib.parse
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime, timezone
from pathlib import Path

from collect_z_series import download, open_url


def extract_rar_sfx(wrapper, member):
    """Use the system libarchive when 7-Zip was built without its RAR codec."""
    import ctypes
    import ctypes.util

    library = ctypes.util.find_library("archive")
    if not library:
        raise ValueError("RAR extraction needs libarchive or a 7-Zip RAR codec")
    lib = ctypes.CDLL(library)
    pointer = ctypes.c_void_p
    declarations = [
        ("archive_read_new", [], pointer),
        ("archive_read_support_format_all", [pointer], ctypes.c_int),
        ("archive_read_support_filter_all", [pointer], ctypes.c_int),
        ("archive_read_open_memory", [pointer, pointer, ctypes.c_size_t], ctypes.c_int),
        ("archive_read_next_header", [pointer, ctypes.POINTER(pointer)], ctypes.c_int),
        ("archive_entry_pathname", [pointer], ctypes.c_char_p),
        ("archive_entry_size", [pointer], ctypes.c_longlong),
        ("archive_read_data", [pointer, pointer, ctypes.c_size_t], ctypes.c_longlong),
        ("archive_read_data_skip", [pointer], ctypes.c_int),
        ("archive_error_string", [pointer], ctypes.c_char_p),
        ("archive_read_free", [pointer], ctypes.c_int),
    ]
    for name, args, result in declarations:
        function = getattr(lib, name)
        function.argtypes, function.restype = args, result
    raw = wrapper.read_bytes()
    offset = raw.index(b"Rar!\x1a\x07\x00")
    memory = ctypes.create_string_buffer(raw[offset:])
    archive = lib.archive_read_new()
    try:
        lib.archive_read_support_format_all(archive)
        lib.archive_read_support_filter_all(archive)
        if lib.archive_read_open_memory(archive, memory, len(raw) - offset) != 0:
            raise ValueError(lib.archive_error_string(archive))
        entry = pointer()
        while True:
            status = lib.archive_read_next_header(archive, ctypes.byref(entry))
            if status == 1:
                raise ValueError("Target BIN missing from RAR")
            if status != 0:
                raise ValueError(lib.archive_error_string(archive))
            if lib.archive_entry_pathname(entry).decode() != member:
                lib.archive_read_data_skip(archive)
                continue
            expected = lib.archive_entry_size(entry)
            if not 1024 < expected < 256 * 1024 * 1024:
                raise ValueError("Unexpected RAR member size")
            parts, size = [], 0
            block = ctypes.create_string_buffer(1024 * 1024)
            while True:
                count = lib.archive_read_data(archive, block, len(block))
                if count < 0:
                    raise ValueError(lib.archive_error_string(archive))
                if not count:
                    break
                size += count
                if size > expected:
                    raise ValueError("RAR output exceeds declared size")
                parts.append(block.raw[:count])
            if size != expected:
                raise ValueError("Truncated RAR member")
            return b"".join(parts)
    finally:
        lib.archive_read_free(archive)


def download_wrapper(row, root):
    """Read the SFX with 7-Zip; never launch the downloaded executable."""
    name = row["wrapper_filename"]
    if name != "F-Z8-V101W.exe" or row["filename"] != "Z_8_0101.bin":
        raise ValueError("Unexpected historical wrapper")
    folder = root / "analysis/z8_history/wrappers"
    folder.mkdir(parents=True, exist_ok=True)
    wrapper = folder / name
    with open_url(row["download_links"][0]) as response:
        if Path(urllib.parse.urlsplit(response.url).path).name != name:
            raise ValueError("Wrapper redirect filename mismatch")
        expected = int(response.headers["Content-Length"])
        metadata = {
            "url": response.url,
            "content_length": expected,
            "last_modified": response.headers.get("Last-Modified"),
        }
        if not wrapper.exists():
            part = folder / (name + ".part")
            with part.open("wb") as file:
                while chunk := response.read(1024 * 1024):
                    file.write(chunk)
            if part.stat().st_size != expected:
                raise ValueError("Truncated SFX download")
            os.link(part, wrapper)
            part.unlink()
        if wrapper.is_symlink() or wrapper.stat().st_size != expected:
            raise ValueError("Existing wrapper conflicts with download")
    metadata["sha256"] = hashlib.sha256(wrapper.read_bytes()).hexdigest()
    listing = subprocess.run(["7z", "l", "-slt", str(wrapper)], capture_output=True, text=True, check=True).stdout
    (folder / (name + ".listing.txt")).write_text(listing)
    members = [
        line.removeprefix("Path = ")
        for line in listing.splitlines()
        if line.startswith("Path = ") and line.endswith(row["filename"])
    ]
    if len(members) != 1:
        raise ValueError("Expected exactly one target BIN in SFX")
    extracted = subprocess.run(["7z", "e", "-so", str(wrapper), members[0]], capture_output=True)
    method = "7z e -so"
    if extracted.returncode:
        data = extract_rar_sfx(wrapper, members[0])
        method = "libarchive RAR3 reader (7-Zip RAR codec unavailable)"
    else:
        data = extracted.stdout
    import binascii

    crc = binascii.crc32(data)
    if f"CRC = {crc:08X}" not in listing:
        raise ValueError("Extracted BIN failed RAR CRC32 check")
    if not 1024 < len(data) < 256 * 1024 * 1024 or data[32:64] != b" " * 32:
        raise ValueError("Extracted data is not a bounded legacy firmware")
    dest = root / row["filename"]
    status = "existing" if dest.exists() else "downloaded"
    if dest.exists():
        if dest.is_symlink() or dest.read_bytes() != data:
            raise ValueError("Existing BIN differs from official wrapper")
    else:
        part = folder / (row["filename"] + ".part")
        part.write_bytes(data)
        os.link(part, dest)
        part.unlink()
    return {
        "status": status,
        "url": metadata["url"],
        "size": len(data),
        "sha256": hashlib.sha256(data).hexdigest(),
        "wrapper": metadata,
        "archive_member": members[0],
        "archive_crc32": f"{crc:08X}",
        "extraction": method + "; executable never launched",
    }


def collect(root):
    out = root / "analysis/z8_history"
    discovery = json.loads((out / "discovery.json").read_text())
    prior_path = out / "downloads.json"
    prior = json.loads(prior_path.read_text()) if prior_path.exists() else {"versions": []}
    existing = {r["version"]: r for r in prior["versions"]}
    rows = []

    def job(row):
        row = dict(row)
        if row.get("download_links") and row.get("filename", "").startswith("Z_8_"):
            try:
                row["download"] = download_wrapper(row, root) if row.get("wrapper_filename") else download(row, root)
            except Exception as error:
                row["download"] = {"status": "failed", "error": str(error)}
        else:
            row["download"] = existing.get(row["version"], {}).get("download", {"status": "no_verified_link"})
        print(row["version"], row["download"]["status"], flush=True)
        return row

    with ThreadPoolExecutor(max_workers=3) as pool:
        for row in pool.map(job, discovery["versions"]):
            rows.append(row)
            # Write completed evidence even if a later network operation fails.
            temporary = out / "downloads.json.tmp"
            temporary.write_text(
                json.dumps({"collected_at_utc": datetime.now(timezone.utc).isoformat(), "versions": rows}, indent=2)
                + "\n"
            )
            temporary.replace(prior_path)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", type=Path)
    collect(parser.parse_args().directory)
