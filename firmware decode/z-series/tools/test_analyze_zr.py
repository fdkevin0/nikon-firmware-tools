"""Validate the phase search and the boundaries of the recovered prefix check."""

import hashlib
import struct
import unittest

from analyze_zr import directory_header, legacy_phase_probe, normalized_blocks, verify_prefix, xor_at


class ZRProbeTests(unittest.TestCase):
    def test_phase_search_including_table_c_carry_and_wrap(self):
        header = struct.pack(">4I", 5, 0xD0, 0, 0)
        for phase in (32, 0xFFFC, 0xFFFFFC):
            result = legacy_phase_probe(xor_at(header, phase), 1024)
            self.assertIn(phase, [row["phase"] for row in result["plausible_headers"]])

    def test_nonzero_reserved_fields_are_not_a_legacy_header(self):
        self.assertFalse(directory_header(struct.pack(">4I", 5, 0xD0, 1, 0), 1024))
        self.assertFalse(directory_header(struct.pack(">4I", 5, 0xC0, 0, 0), 1024))
        self.assertFalse(directory_header(struct.pack(">4I", 5, 0xD0, 0, 0), 128))
        with self.assertRaisesRegex(ValueError, "complete"):
            legacy_phase_probe(bytes(15), 1024)

    def test_repetition_statistic_ignores_constant_xor_only(self):
        block = bytes(range(256))
        other = bytes(x ^ 0xA5 for x in block)
        different = block[:-1] + bytes([0])
        result = normalized_blocks(block + other + different, 0)
        self.assertEqual(result["blocks"], 3)
        self.assertEqual(result["unique_normalized_blocks"], 2)
        self.assertEqual(result["most_frequent_count"], 2)

    def test_prefix_check_covers_marker_trailer_and_tail(self):
        decoded = b" " * 32 + b"synthetic decoded data" + bytes(16)
        tail = bytes.fromhex("6c12037e6fcec19a")
        encoded = hashlib.sha1(decoded + tail).digest() + bytes(12)
        self.assertTrue(verify_prefix(encoded, decoded, tail)["valid"])
        for offset in (0, 32, len(decoded) - 1):
            altered = bytearray(decoded)
            altered[offset] ^= 1
            self.assertFalse(verify_prefix(encoded, bytes(altered), tail)["valid"])
        self.assertFalse(verify_prefix(encoded, decoded, bytes(8))["valid"])


if __name__ == "__main__":
    unittest.main()
