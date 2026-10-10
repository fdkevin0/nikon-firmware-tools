"""Integrity checks for the nested formats used in the Z8 analysis."""

import gzip
from pathlib import Path
import struct
import tempfile
import unittest

from analyze_z8 import parse_nisi, parse_cpio, parse_fdt, extract_regular_files, inflate, elf_info


def cpio_record(name, data=b"", mode=0o100644):
    filename = name.encode() + b"\0"
    fields = [1, mode, 0, 0, 1, 0, len(data), 0, 0, 0, 0, len(filename), 0]
    header = b"070701" + b"".join(f"{v:08x}".encode() for v in fields)
    prefix = header + filename
    prefix += bytes(-len(prefix) % 4)
    return prefix + data + bytes(-len(data) % 4)


class NestedFormatTests(unittest.TestCase):
    def test_gzip_integrity_and_size_limit(self):
        compressed = gzip.compress(b"example data")
        self.assertEqual(inflate(compressed), (b"example data", len(compressed)))
        for data, limit in [(compressed[:-2], 100), (compressed, 2)]:
            with self.assertRaises(ValueError):
                inflate(data, limit)

    def test_cpio_files_links_and_devices(self):
        archive = cpio_record("etc/info", b"sample")
        archive += cpio_record("bin/sh", b"../bin/busybox", 0o120777)
        archive += cpio_record("dev/console", mode=0o020600)
        archive += cpio_record("TRAILER!!!", mode=0)
        entries = parse_cpio(archive)
        self.assertEqual([e["type"] for e in entries], ["regular", "symlink", "char_device"])
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            extract_regular_files(archive, entries, root)
            self.assertEqual((root / "etc/info").read_bytes(), b"sample")
            self.assertFalse((root / "bin/sh").exists())
            self.assertFalse((root / "dev/console").exists())

    def test_cpio_rejects_unsafe_or_truncated_paths(self):
        for name in ["../escape", "/absolute"]:
            with self.assertRaises(ValueError):
                parse_cpio(cpio_record(name) + cpio_record("TRAILER!!!", mode=0))
        with self.assertRaises(ValueError):
            parse_cpio(cpio_record("file", b"data")[:-4])

    def test_output_symlink_cannot_escape(self):
        archive = cpio_record("directory/file", b"data") + cpio_record("TRAILER!!!", mode=0)
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory) / "root"
            root.mkdir()
            (root / "directory").symlink_to(Path(directory))
            with self.assertRaises(ValueError):
                extract_regular_files(archive, parse_cpio(archive), root)
            self.assertFalse((Path(directory) / "file").exists())

    def test_fdt_structure(self):
        strings = b"model\0"
        structure = struct.pack(">I", 1) + bytes(4)
        structure += struct.pack(">3I", 3, 5, 0) + b"test\0" + bytes(3)
        structure += struct.pack(">2I", 2, 9)
        off_strings = 56 + len(structure)
        header = struct.pack(">10I", 0xD00DFEED, off_strings + len(strings), 56,
                             off_strings, 40, 17, 16, 0, len(strings), len(structure))
        blob = header + bytes(16) + structure + strings
        parsed, rendered = parse_fdt(blob)
        self.assertEqual(parsed["nodes"]["/"]["model"]["strings"], ["test"])
        self.assertIn('model = "test";', rendered)
        with self.assertRaises(ValueError):
            parse_fdt(blob[:-1])

    def test_nisi_rejects_overlapping_ranges(self):
        blob = bytearray(2048 * 5 + 2)
        blob[:4] = b"NISI"
        struct.pack_into("<I", blob, 16, 4)
        for i in range(4):
            struct.pack_into("<4I", blob, 32 + i * 16, i + 1, 1, 8, 0)
        self.assertEqual(len(parse_nisi(blob)), 4)
        struct.pack_into("<I", blob, 48, 1)
        with self.assertRaises(ValueError):
            parse_nisi(blob)

    def test_false_elf_magic(self):
        with self.assertRaises(ValueError):
            elf_info(b"\x7fELF\x00\x01\x33vDSO is not a valid ELF object!" + bytes(64))

    def test_nisi_early_z9_fifth_entry(self):
        blob = bytearray(2048 * 6 + 2)
        blob[:4] = b"NISI"
        struct.pack_into("<I", blob, 16, 5)
        for i in range(5):
            struct.pack_into("<4I", blob, 32 + i * 16, i + 1, 1, 8, 0)
        self.assertEqual(parse_nisi(blob)[-1]["name"], "device_tree_2.dtb")
        for bad in (blob[:16], blob[:-2048]):
            with self.assertRaises(ValueError):
                parse_nisi(bad)
        struct.pack_into("<I", blob, 16, 6)
        with self.assertRaises(ValueError):
            parse_nisi(blob)


if __name__ == "__main__":
    unittest.main()
