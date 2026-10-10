#!/usr/bin/env python3
"""Inspect the recorded Z8 C 3.11 sample after analyze_firmware.py.

Extracts the NISI Linux bundle, regular cpio files, DTBs and embedded CEVA ELFs.
Records archive symlinks/devices as metadata without creating them. Does not run
firmware executables or scripts. Standard library; Capstone adds code listings.
"""

import argparse
from collections import Counter
import csv
import hashlib
import json
from pathlib import Path, PurePosixPath
import re
import stat
import struct
import zlib


EXPECTED = {
    "eg2070_0311b0.bi": "f85e0138e2f5e660ece8560de62e0d12cb795e0e14983e50f20b61dce906c46c",
    "li2070_0311b0.bi": "804a55508cd6b323336fbba14034810e4b22fcc5fd1030d3a7dc08d62767cc55",
    "ex2070_030000.bi": "4b7ea2ea40360717ceffd3d8db6fe48f5fae9d5c13b69632dc750bdc41b571c2",
}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def write_json(path, value):
    path.write_text(json.dumps(value, indent=2) + "\n")


def bounded(data, start, size):
    if start < 0 or size < 0 or start + size > len(data):
        raise ValueError(f"Out of bounds: {start:#x}+{size:#x}")
    return data[start:start + size]


def inflate(data, limit=256 * 1024 * 1024):
    decoder = zlib.decompressobj(31)
    result = decoder.decompress(data, limit + 1)
    if len(result) > limit or not decoder.eof or decoder.unconsumed_tail:
        raise ValueError("Truncated or oversized gzip stream")
    return result, len(data) - len(decoder.unused_data)


def parse_nisi(data):
    if len(data) < 2048 or data[:4] != b"NISI":
        raise ValueError("Expected a NISI bundle")
    count = struct.unpack_from("<I", data, 16)[0]
    if count not in (4, 5):
        raise ValueError("Expected a four- or five-entry NISI bundle")
    result = []
    previous_end = 2048
    names = ["Image", "rootfs.cpio.gz"] + [f"device_tree_{i}.dtb" for i in range(count - 2)]
    for i, name in enumerate(names):
        start, blocks, size, reserved = struct.unpack_from("<4I", data, 32 + i * 16)
        offset, allocated = start * 2048, blocks * 2048
        if offset != previous_end or size > allocated or allocated == 0:
            raise ValueError("Invalid or non-contiguous NISI entry")
        content = bounded(data, offset, size)
        padding = bounded(data, offset + size, allocated - size)
        result.append({"name": name, "offset": offset, "size": size,
                       "allocated_size": allocated, "reserved": reserved,
                       "sha256": sha(content), "padding_byte_counts": dict(Counter(padding))})
        previous_end = offset + allocated
    if previous_end != len(data) - 2:
        raise ValueError("NISI allocation does not end at the section CRC")
    return result


def parse_cpio(data):
    entries, offset, names = [], 0, set()
    while True:
        header = bounded(data, offset, 110)
        if header[:6] not in (b"070701", b"070702"):
            raise ValueError("Expected newc/crc cpio header")
        fields = [int(header[6 + i * 8:14 + i * 8], 16) for i in range(13)]
        inode, mode, uid, gid, nlink, mtime, size, devmaj, devmin, rmaj, rmin, ns, check = fields
        raw_name = bounded(data, offset + 110, ns)
        if not raw_name or raw_name[-1] != 0 or b"\0" in raw_name[:-1]:
            raise ValueError("Invalid cpio name")
        name = raw_name[:-1].decode("utf-8")
        start = (offset + 110 + ns + 3) & ~3
        content = bounded(data, start, size)
        offset = (start + size + 3) & ~3
        if header[:6] == b"070702" and sum(content) & 0xFFFFFFFF != check:
            raise ValueError("cpio payload checksum mismatch")
        if name == "TRAILER!!!":
            if size or any(data[offset:]):
                raise ValueError("Nonzero cpio trailer or trailing content")
            return entries
        path = PurePosixPath(name)
        normalized = str(path)
        if not name or path.is_absolute() or ".." in path.parts or normalized in names:
            raise ValueError(f"Unsafe or duplicate cpio path: {name!r}")
        names.add(normalized)
        kind = {stat.S_IFREG: "regular", stat.S_IFDIR: "directory", stat.S_IFLNK: "symlink",
                stat.S_IFCHR: "char_device", stat.S_IFBLK: "block_device",
                stat.S_IFIFO: "fifo"}.get(stat.S_IFMT(mode), "other")
        entry = {"path": normalized, "type": kind, "mode": oct(mode), "uid": uid,
                 "gid": gid, "inode": inode, "nlink": nlink, "mtime": mtime,
                 "size": size, "archive_data_offset": start, "sha256": sha(content),
                 "device": [devmaj, devmin], "rdevice": [rmaj, rmin]}
        if kind == "symlink":
            entry["target"] = content.decode("utf-8")
        entries.append(entry)


def extract_regular_files(data, entries, destination):
    destination.mkdir(parents=True, exist_ok=True)
    root = destination.resolve()
    for entry in entries:
        if entry["type"] != "regular":
            continue
        if entry["nlink"] != 1:
            raise ValueError("Hard-linked regular files need separate reconstruction")
        target = destination / entry["path"]
        if not target.resolve().is_relative_to(root) or target.is_symlink():
            raise ValueError("Output path escapes the regular-files directory")
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(bounded(data, entry["archive_data_offset"], entry["size"]))


def parse_fdt(data):
    magic, total, off_struct, off_strings, off_rsv, version, compatible, cpu, nstrings, nstruct = struct.unpack_from(">10I", data)
    if magic != 0xD00DFEED or total != len(data) or version != 17:
        raise ValueError("Invalid FDT v17 header")
    structure = bounded(data, off_struct, nstruct)
    strings = bounded(data, off_strings, nstrings)
    stack, nodes, lines, pos = [], {}, ["/dts-v1/;", ""], 0
    while pos < len(structure):
        token = struct.unpack(">I", bounded(structure, pos, 4))[0]
        pos += 4
        if token == 1:
            end = structure.index(0, pos)
            name = structure[pos:end].decode()
            pos = (end + 4) & ~3
            lines.append("    " * len(stack) + (name or "/") + " {")
            stack.append(name)
            path = "/" + "/".join(stack[1:])
            if path in nodes:
                raise ValueError("Duplicate FDT node")
            nodes[path] = {}
        elif token == 2:
            if not stack:
                raise ValueError("Unbalanced FDT node")
            stack.pop()
            lines.append("    " * len(stack) + "};")
        elif token == 3:
            size, nameoff = struct.unpack(">2I", bounded(structure, pos, 8))
            pos += 8
            raw = bounded(structure, pos, size)
            pos = (pos + size + 3) & ~3
            if not stack or nameoff >= len(strings):
                raise ValueError("Invalid FDT property")
            name = strings[nameoff:strings.index(0, nameoff)].decode()
            prop = {"hex": raw.hex()}
            if raw and raw[-1] == 0 and any(c >= 32 for c in raw) and all(c == 0 or 32 <= c < 127 for c in raw):
                prop["strings"] = raw[:-1].decode().split("\0")
                value = ", ".join(json.dumps(s) for s in prop["strings"])
            elif raw and len(raw) % 4 == 0:
                prop["cells"] = [v[0] for v in struct.iter_unpack(">I", raw)]
                value = "<" + " ".join(f"0x{c:x}" for c in prop["cells"]) + ">"
            else:
                value = "[" + raw.hex(" ") + "]"
            path = "/" + "/".join(stack[1:])
            nodes[path][name] = prop
            lines.append("    " * len(stack) + name + (" = " + value if raw else "") + ";")
        elif token == 9:
            if stack or pos != len(structure):
                raise ValueError("Incomplete FDT structure")
            return {"version": version, "compatible_version": compatible,
                    "boot_cpuid_phys": cpu, "nodes": nodes}, "\n".join(lines) + "\n"
        elif token != 4:
            raise ValueError(f"Unsupported FDT token {token}")
    raise ValueError("FDT end token missing")


def elf_info(data):
    if data[:4] != b"\x7fELF" or data[5:7] != b"\x01\x01":
        raise ValueError("Expected a little-endian ELF")
    bits = {1: 32, 2: 64}.get(data[4])
    if bits is None:
        raise ValueError("Invalid ELF class")
    fmt = "<HHIIIIIHHHHHH" if bits == 32 else "<HHIQQQIHHHHHH"
    typ, machine, ver, entry, phoff, shoff, flags, ehsize, phsize, phnum, shsize, shnum, shstr = struct.unpack_from(fmt, data, 16)
    if ver != 1 or phnum == 0 or shnum == 0:
        raise ValueError("Unsupported ELF header/counts")
    extent = max(ehsize, phoff + phsize * phnum, shoff + shsize * shnum)
    bounded(data, 0, extent)
    segments = []
    for i in range(phnum):
        row = bounded(data, phoff + phsize * i, phsize)
        if bits == 32:
            pt, off, va, pa, fsize, msize, fl, align = struct.unpack("<8I", row)
        else:
            pt, fl, off, va, pa, fsize, msize, align = struct.unpack("<II6Q", row)
        bounded(data, off, fsize)
        extent = max(extent, off + fsize)
        segments.append({"type": pt, "offset": off, "vaddr": va, "paddr": pa,
                         "file_size": fsize, "memory_size": msize, "flags": fl})
    sections = []
    for i in range(shnum):
        row = bounded(data, shoff + i * shsize, shsize)
        values = struct.unpack("<10I" if bits == 32 else "<II4QII2Q", row)
        name, stype, fl, va, off, size, link, info, align, entsize = values
        if stype != 8:  # SHT_NOBITS occupies memory but no file bytes.
            bounded(data, off, size)
            extent = max(extent, off + size)
        sections.append({"name_offset": name, "type": stype, "vaddr": va,
                         "offset": off, "size": size, "link": link, "entry_size": entsize})
    if shstr >= shnum:
        raise ValueError("Invalid ELF section string table")
    strings = sections[shstr]
    names = bounded(data, strings["offset"], strings["size"])
    for section in sections:
        noff = section.pop("name_offset")
        section["name"] = names[noff:names.index(0, noff)].decode()
    return {"bits": bits, "type": typ, "machine": machine, "entry": entry,
            "file_extent": extent, "segments": segments, "sections": sections}


def write_strings(path, data):
    with path.open("w") as f:
        for match in re.finditer(rb"[ -~]{6,}", data):
            f.write(f"{match.start():08x} {match.group().decode()}\n")


def write_elf_symbols(path, data, info):
    count = 0
    with path.open("w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["table", "index", "name", "value", "size", "info", "section_index"])
        for section in info["sections"]:
            if section["type"] not in (2, 11):
                continue
            strings = info["sections"][section["link"]]
            names = bounded(data, strings["offset"], strings["size"])
            record_size = 16 if info["bits"] == 32 else 24
            if section["entry_size"] != record_size or section["size"] % record_size:
                raise ValueError("Invalid ELF symbol table size")
            for i in range(section["size"] // record_size):
                record = bounded(data, section["offset"] + i * record_size, record_size)
                if info["bits"] == 32:
                    name, value, size, si, other, shndx = struct.unpack("<IIIBBH", record)
                else:
                    name, si, other, shndx, value, size = struct.unpack("<IBBHQQ", record)
                label = names[name:names.index(0, name)].decode("utf-8")
                writer.writerow([section["name"], i, label, hex(value), size, si, shndx])
                count += 1
    return count


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", type=Path)
    args = parser.parse_args()
    root = args.directory
    samples = {name: (root / name).read_bytes() for name in EXPECTED}
    if any(sha(samples[name]) != digest for name, digest in EXPECTED.items()):
        parser.error("This analysis is specific to the recorded Z8 3.11 sample")
    eg, li, ex = (samples[name] for name in EXPECTED)
    out = root / "linux"
    out.mkdir(exist_ok=True)
    nisi = parse_nisi(li)
    for entry in nisi:
        (out / entry["name"]).write_bytes(bounded(li, entry["offset"], entry["size"]))
    archive, consumed = inflate((out / "rootfs.cpio.gz").read_bytes())
    if consumed != nisi[1]["size"]:
        raise ValueError("Unexplained bytes after rootfs gzip")
    (out / "rootfs.cpio").write_bytes(archive)
    entries = parse_cpio(archive)
    extract_regular_files(archive, entries, out / "rootfs_files")
    write_json(out / "rootfs_inventory.json", entries)
    trees = []
    for name in ["device_tree_0", "device_tree_1"]:
        parsed, dts = parse_fdt((out / (name + ".dtb")).read_bytes())
        write_json(out / (name + ".json"), parsed)
        (out / (name + ".dts")).write_text(dts)
        trees.append(parsed)
    kernel = (out / "Image").read_bytes()
    if kernel[56:60] != b"ARM\x64":
        raise ValueError("Missing AArch64 Linux Image magic")
    banner = re.search(rb"Linux version[^\0]+", kernel).group().decode().strip()
    cfg_start = kernel.index(b"IKCFG_ST") + 8
    config, used = inflate(kernel[cfg_start:], 4 * 1024 * 1024)
    if kernel[cfg_start + used:cfg_start + used + 8] != b"IKCFG_ED":
        raise ValueError("Invalid embedded kernel config boundary")
    (out / "kernel_config.txt").write_bytes(config)

    elf_dir = root / "embedded_elf"
    elf_dir.mkdir(exist_ok=True)
    elves = []
    for offset in [0x151CAA0, 0x15C5BD0, 0x1635120]:
        info = elf_info(eg[offset:])
        content = bounded(eg, offset, info["file_extent"])
        name = f"ceva_{offset:08x}.elf"
        (elf_dir / name).write_bytes(content)
        info["symbol_entries"] = write_elf_symbols(elf_dir / (name + ".symbols.csv"), content, info)
        info.update({"name": name, "eg_offset": offset, "sha256": sha(content)})
        elves.append(info)
    write_json(elf_dir / "manifest.json", elves)

    app_path = out / "rootfs_files/usr/bin/LaMainApp"
    app = app_path.read_bytes()
    app_info = elf_info(app)
    app_info["symbol_entries"] = write_elf_symbols(out / "LaMainApp.symbols.csv", app, app_info)
    write_strings(out / "LaMainApp.strings.txt", app)
    write_json(out / "LaMainApp.elf.json", app_info)
    # Entry targets at two exception levels independently establish this base.
    base = struct.unpack_from("<Q", eg, 0x670)[0] - 0x250
    if base != 0x40160000 or struct.unpack_from("<Q", eg, 0x678)[0] - 0x1C0 != base:
        raise ValueError("EG base evidence no longer agrees")
    boot_header = [struct.unpack_from("<Q", eg, 0x8000 + i)[0] for i in range(0, 0x160, 8)]
    if boot_header[0x128 // 8] != base:
        raise ValueError("EG boot descriptor disagrees with base")
    mapping = {"boot_base": base, "main_entry": boot_header[0],
               "descriptor_offset": 0x8000, "descriptor_qwords": boot_header,
               "initialized_data": {"file_offset": boot_header[0x148 // 8],
                                    "destination": boot_header[0xD8 // 8],
                                    "size": boot_header[0xD0 // 8]},
               "bss": {"destination": boot_header[0xF0 // 8], "size": boot_header[0xE8 // 8]},
               "note": "Data copy follows descriptor use at EG offsets 0x138c-0x13a8; not a complete memory map"}
    markers = [b"Ver.03.11.b0", b"SOLID CS ENTRY.", b"toppers_fmp/fmp_1.4.0",
               b"FirmwareManagement_Device_Linux.c", b"FirmwareManagement_Device_Ai.c",
               b"NISI", b"MovieRecord", b"ProRes", b"N-RAW", b"NikonTask_RTOS_TaskSwitchIn"]
    marker_hits = {needle.decode(): [m.start() for m in re.finditer(re.escape(needle), eg)] for needle in markers}
    result = {"sample_sha256": "d67413c2ede6b9ce8887175f20700bd9fbad2a973a4820968c45503d15d80d96",
              "analyzer_sha256": sha(Path(__file__).read_bytes()),
              "nisi": {"version": li[20:32].split(b"\0")[0].decode(), "block_size": 2048, "entries": nisi},
              "linux": {"banner": banner, "image_header_text_offset": struct.unpack_from("<Q", kernel, 8)[0],
                        "image_header_memory_size": struct.unpack_from("<Q", kernel, 16)[0],
                        "cpio_size": len(archive), "cpio_sha256": sha(archive),
                        "inventory_counts": dict(Counter(e["type"] for e in entries)),
                        "kernel_config_sha256": sha(config), "LaMainApp_sha256": sha(app)},
              "eg": mapping, "eg_markers": marker_hits,
              "ex": {"base": 0x08000000, "initial_sp": struct.unpack_from("<I", ex)[0],
                     "reset_vector_thumb": struct.unpack_from("<I", ex, 4)[0]},
              "embedded_elf_count": len(elves)}
    try:
        from capstone import Cs, CS_ARCH_ARM64, CS_ARCH_ARM, CS_MODE_THUMB, CS_MODE_MCLASS
    except ImportError:
        result["disassembly"] = "Not generated: capstone is unavailable"
    else:
        lines = []
        ranges = [("EG exception-level startup", eg, base, 0, 0x2B4, CS_ARCH_ARM64, 0),
                  ("EG core role selector", eg, base, 0xEB0, 0xEC4, CS_ARCH_ARM64, 0),
                  ("EG descriptor and memory setup", eg, base, 0x1144, 0x1514, CS_ARCH_ARM64, 0),
                  ("EX reset", ex, 0x08000000, 0x2B4, 0x2E6, CS_ARCH_ARM, CS_MODE_THUMB | CS_MODE_MCLASS),
                  ("LaMainApp ELF entry", app, 0x400000, 0x21CC, 0x2220, CS_ARCH_ARM64, 0)]
        for title, data, origin, start, end, arch, mode in ranges:
            lines.append(f"\n{title} (file offset 0x{start:x}, mapping 0x{origin:x})")
            for insn in Cs(arch, mode).disasm(data[start:end], origin + start):
                lines.append(f"{insn.address:012x} {insn.bytes.hex():10} {insn.mnemonic:10} {insn.op_str}")
        (root / "code_landmarks.asm").write_text("\n".join(lines) + "\n")
        result["disassembly"] = "code_landmarks.asm"
    write_json(root / "deep_manifest.json", result)
    print(banner)
    print(f"NISI: {len(nisi)} objects; cpio: {len(entries)} entries, {len(archive)} bytes")
    print(f"CEVA ELFs: {len(elves)}; EG boot base: 0x{base:x}; main entry: 0x{mapping['main_entry']:x}")


if __name__ == "__main__":
    main()
