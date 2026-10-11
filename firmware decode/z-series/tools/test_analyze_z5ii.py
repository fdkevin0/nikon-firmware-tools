#!/usr/bin/env python3
"""Never turn conflicting or missing keystream evidence into recovered bytes."""

import unittest

from analyze_z5ii import merge_masks


class MaskEvidenceTests(unittest.TestCase):
    def test_shifted_overlaps_preserve_offsets_and_support(self):
        start, mask, evidence = merge_masks([(12, b"cdef"), (10, b"abcd"), (13, b"defg")])
        self.assertEqual(start, 10)
        self.assertEqual(mask, b"abcdefg")
        self.assertEqual(evidence["bytes_by_reference_count"], {1: 3, 2: 3, 3: 1})
        self.assertEqual(sum(row["size"] for row in evidence["overlaps"]), 6)

    def test_reject_conflicts_and_gaps(self):
        with self.assertRaisesRegex(ValueError, "Conflicting"):
            merge_masks([(10, b"abc"), (12, b"Xd")])
        with self.assertRaisesRegex(ValueError, "Gap"):
            merge_masks([(10, b"abc"), (14, b"ef")])
        with self.assertRaises(ValueError):
            merge_masks([])


if __name__ == "__main__":
    unittest.main()
