#!/usr/bin/env python3
import struct
import unittest

from compare_ai_modules import MAGIC, network_candidates


class NetworkBoundaryTests(unittest.TestCase):
    def make_blob(self):
        data = bytearray(0x40 + 0x100 + 0x200)
        data[: len(MAGIC)] = MAGIC
        struct.pack_into("<II", data, 0x40, 0x100, 0x200)
        return bytes(data)

    def test_adjacent_networks_keep_separate_bounds(self):
        blob = self.make_blob()
        rows = network_candidates(blob + blob, 0x1234)
        self.assertEqual([r["offset"] for r in rows], [0x1234, 0x1234 + len(blob)])
        self.assertTrue(all(r["complete_within_window"] for r in rows))
        self.assertEqual(rows[0]["sha256_available"], rows[1]["sha256_available"])

    def test_partial_model_is_never_reported_complete(self):
        blob = self.make_blob()
        row = network_candidates(blob[:-1])[0]
        self.assertFalse(row["complete_within_window"])
        self.assertEqual(row["available_size"], len(blob) - 1)
        self.assertIsNone(row["next_bytes_hex"])

    def test_false_magic_or_truncated_header_does_not_make_model(self):
        self.assertEqual(network_candidates(MAGIC), [])
        blob = bytearray(self.make_blob())
        struct.pack_into("<II", blob, 0x40, 0xFFFFFFFF, 0xFFFFFFFF)
        self.assertEqual(network_candidates(blob), [])


if __name__ == "__main__":
    unittest.main()
