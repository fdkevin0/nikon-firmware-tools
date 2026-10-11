#!/usr/bin/env python3
"""Automated unit test suite for Nikon ZR stream cryptanalysis & extraction."""

import hashlib
import struct
import unittest
from pathlib import Path

from decrypt_zr_stream import (
    DIR_KEYSTREAM_PREFIX_16,
    HEADER_SIZE,
    MODERN_MAGIC,
    MODERN_MAGIC_REV,
    ZR_SECTION_SPEC,
    decrypt_section_0,
    parse_128_integers,
    parse_container_header,
    recover_directory_entries,
)


class TestDecryptZRStream(unittest.TestCase):
    def setUp(self):
        # Create a synthetic 0x280 container header
        magic = MODERN_MAGIC
        rsa = bytes(range(256))
        # 128 valid 15-bit integers
        table_128 = struct.pack("<128H", *[(i * 101) % 32768 for i in range(128)])
        rev_magic = MODERN_MAGIC_REV
        checksum = bytes(32)
        spaces = b" " * 32
        self.valid_header = magic + rsa + table_128 + rev_magic + checksum + spaces

    def test_parse_container_header_valid(self):
        info = parse_container_header(self.valid_header)
        self.assertTrue(info["valid_magic"])
        self.assertTrue(info["valid_reverse_guard"])
        self.assertTrue(info["valid_spaces_marker"])
        self.assertEqual(len(info["table_128_integers"]), 128)
        self.assertTrue(all(0 <= x < 32768 for x in info["table_128_integers"]))

    def test_parse_container_header_too_short(self):
        with self.assertRaisesRegex(ValueError, "Header too short"):
            parse_container_header(b"short header")

    def test_parse_128_integers_validation(self):
        # 128 valid ints
        valid_raw = struct.pack("<128H", *[123] * 128)
        ints = parse_128_integers(valid_raw)
        self.assertEqual(len(ints), 128)
        self.assertEqual(ints[0], 123)

        # Invalid length
        with self.assertRaisesRegex(ValueError, "Expected 256 bytes"):
            parse_128_integers(valid_raw[:-2])

        # Value >= 32768
        invalid_raw = struct.pack("<128H", 32768, *[0] * 127)
        with self.assertRaisesRegex(ValueError, "exceeds 15-bit maximum"):
            parse_128_integers(invalid_raw)

    def test_recover_directory_entries_prefix_mismatch(self):
        # Header + invalid directory prefix
        corrupted_dir = self.valid_header + bytes(0xD0)
        with self.assertRaisesRegex(ValueError, "Directory prefix mask mismatch"):
            recover_directory_entries(corrupted_dir)

    def test_recover_directory_entries_structure(self):
        # Create valid masked directory header
        hdr_plain = struct.pack(">4I", 5, 0xD0, 0, 0)
        c_prefix = bytes(a ^ b for a, b in zip(hdr_plain, DIR_KEYSTREAM_PREFIX_16))
        synthetic_dir = c_prefix + bytes(0xD0 - 16)
        full_synthetic = self.valid_header + synthetic_dir

        sections = recover_directory_entries(full_synthetic)
        self.assertEqual(len(sections), 5)
        self.assertEqual(sections[0]["name"], "ex2100_011000.bi")
        self.assertEqual(sections[1]["name"], "_tpj01_0210.bin")
        self.assertEqual(sections[2]["name"], "eg2100_0111b0.bi")
        self.assertEqual(sections[3]["name"], "vr2100_010100.bi")
        self.assertEqual(sections[4]["name"], "li2100_0111b0.bi")

        # Verify monotonic offsets and sizes
        self.assertEqual(sections[0]["payload_offset"], 0x000000B0)
        self.assertEqual(sections[1]["payload_offset"], 0x000800B2)
        self.assertEqual(sections[2]["payload_offset"], 0x0008E0B4)

    def test_decrypt_section_0_recovery_spans(self):
        # Synthetic payload with continuous spans
        sec0_size = ZR_SECTION_SPEC[0]["size"]
        payload_off = ZR_SECTION_SPEC[0]["payload_offset"]

        # Synthetic firmware data
        synthetic_fw = bytearray(HEADER_SIZE + payload_off + sec0_size)
        # Fill Section 0 with test pattern
        for i in range(sec0_size):
            synthetic_fw[HEADER_SIZE + payload_off + i] = (i * 37) % 256

        decrypted, stats = decrypt_section_0(bytes(synthetic_fw))
        self.assertEqual(len(decrypted), sec0_size)
        self.assertGreater(stats["recovery_ratio"], 0.49)
        self.assertGreater(stats["recovered_bytes"], 260000)

    def test_real_zr_binary_if_present(self):
        zr_path = Path("firmware decode/z-series/ZR__0111.bin")
        if not zr_path.exists():
            self.skipTest("ZR__0111.bin not present in workspace")

        with open(zr_path, "rb") as f:
            zr_data = f.read(HEADER_SIZE + 0xD0 + 524290)

        hdr = parse_container_header(zr_data[:HEADER_SIZE])
        self.assertTrue(hdr["valid_magic"])
        self.assertTrue(hdr["valid_reverse_guard"])
        self.assertTrue(hdr["valid_spaces_marker"])

        sections = recover_directory_entries(zr_data)
        self.assertEqual(len(sections), 5)

        z8_ref_path = Path("firmware decode/z-series/analysis/Z_8_0311/ex2070_030000.bi")
        z8_ref = z8_ref_path.read_bytes() if z8_ref_path.exists() else None

        decrypted, stats = decrypt_section_0(zr_data, z8_ref)
        self.assertGreater(stats["recovery_ratio"], 0.54)

    def test_parse_modern_directory_dynamic(self):
        from decrypt_zr_stream import parse_modern_directory

        # Test on ZR 1.11 if present
        zr_path = Path("firmware decode/z-series/ZR__0111.bin")
        if zr_path.exists():
            with open(zr_path, "rb") as f:
                zr_data = f.read(HEADER_SIZE + 0xD0)
            parsed_zr = parse_modern_directory(zr_data)
            self.assertEqual(parsed_zr["section_count"], 5)
            self.assertEqual(parsed_zr["header_length"], 0xD0)
            self.assertIn("2100", parsed_zr["platform_model"])
            sec_names = [s["name"] for s in parsed_zr["sections"]]
            self.assertEqual(sec_names[0], "ex2100_010100.b")
            self.assertEqual(sec_names[1], "_tps00_1500.bin")
            self.assertEqual(sec_names[2], "eg2100_011130.b")
            self.assertEqual(sec_names[3], "vr2100_010100.b")
            self.assertEqual(sec_names[4], "li2100_011130.b")

        # Test on Z 50 II (4-section container) if present
        z50_path = Path("firmware decode/z-series/Z50_2_0111.bin")
        if z50_path.exists():
            with open(z50_path, "rb") as f:
                z50_data = f.read(HEADER_SIZE + 0xD0)
            parsed_z50 = parse_modern_directory(z50_data)
            self.assertEqual(parsed_z50["section_count"], 4)
            self.assertEqual(parsed_z50["header_length"], 0xB0)
            self.assertIn("2185", parsed_z50["platform_model"])
            sec_names = [s["name"] for s in parsed_z50["sections"]]
            self.assertEqual(sec_names[0], "ex2185_010300.bi")
            self.assertEqual(sec_names[1], "_tpt01_0090.bin")
            self.assertEqual(sec_names[2], "eg2185_011130.bi")
            self.assertEqual(sec_names[3], "li2185_011000.bi")

        # Test on Z f (5-section container) if present
        zf_path = Path("firmware decode/z-series/Z_f_0301.bin")
        if zf_path.exists():
            with open(zf_path, "rb") as f:
                zf_data = f.read(HEADER_SIZE + 0xD0)
            parsed_zf = parse_modern_directory(zf_data)
            self.assertEqual(parsed_zf["section_count"], 5)
            self.assertIn("2200", parsed_zf["platform_model"])
            sec_names = [s["name"] for s in parsed_zf["sections"]]
            self.assertEqual(sec_names[0], "ex2200_0200d0.bi")
            self.assertEqual(sec_names[1], "_tpj01_0210.bin")
            self.assertEqual(sec_names[2], "eg2200_030130.bi")
            self.assertEqual(sec_names[3], "vr2200_010300.bi")
            self.assertEqual(sec_names[4], "li2200_030130.bi")


if __name__ == "__main__":
    unittest.main()

