#!/usr/bin/env python3
"""Check differential evidence at boundaries and unequal file lengths."""

import unittest

from analyze_zf import compare_headers, equal_runs, xor_bytes


class ZfComparisonTests(unittest.TestCase):
    def test_equal_runs_cross_chunks_and_ignore_unpaired_tail(self):
        a = bytes(30)
        b = b"x" + bytes(17) + b"x" + bytes(6)
        result = equal_runs(a, b, minimum=2, chunk_size=4)
        self.assertEqual(result["equal_bytes"], 23)
        self.assertEqual(result["compared_bytes"], 25)
        self.assertEqual(result["uncompared_tail_bytes"], [5, 0])
        self.assertEqual(
            result["longest_equal_runs"],
            [{"start": 1, "end_exclusive": 18, "size": 17}, {"start": 19, "end_exclusive": 25, "size": 6}],
        )

    def test_run_ending_at_chunk_boundary_is_not_joined_across_difference(self):
        result = equal_runs(bytes(12), bytes(4) + b"x" + bytes(7), minimum=1, chunk_size=4)
        self.assertEqual([r["size"] for r in result["longest_equal_runs"]], [7, 4])
        self.assertEqual(equal_runs(b"", b"abc")["equal_fraction"], None)

    def test_xor_retains_leading_and_trailing_zero_bytes(self):
        self.assertEqual(xor_bytes(b"\x00\x01\x00", b"\x00\x02\x00"), b"\x00\x03\x00")
        with self.assertRaises(ValueError):
            xor_bytes(b"a", b"")

    def test_region_changes_and_truncation(self):
        a = bytes(0x330)
        b = bytearray(a)
        b[0x240] = 1
        rows = compare_headers(a, b)
        self.assertEqual(sum(r["different_bytes"] for r in rows), 1)
        self.assertEqual(rows[4]["different_bytes"], 1)
        with self.assertRaises(ValueError):
            compare_headers(a, a[:-1])


if __name__ == "__main__":
    unittest.main()
