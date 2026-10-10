import unittest

from compare_z8_history import inventory_diff, positional_diff


class ArchiveComparisonTests(unittest.TestCase):
    def test_byte_comparison_separates_changes_and_uncompared_tail(self):
        a = b"a" * 4096 + b"123"
        b = b"a" * 4096 + b"1x3extra"
        result = positional_diff(a, b)
        self.assertEqual(result["differing_bytes"], 1)
        self.assertEqual(result["first_difference"], 4097)
        self.assertEqual(result["last_difference"], 4097)
        self.assertEqual(result["after_uncompared_tail"], 5)
        self.assertEqual(result["changed_4096_byte_blocks"], 1)

    def test_build_metadata_alone_is_not_content_change(self):
        a = {"path": "usr/bin/app", "type": "regular", "mode": "0o100755",
             "sha256": "same", "mtime": 1, "inode": 10}
        b = {**a, "mtime": 2, "inode": 11}
        result = inventory_diff([a], [b])
        self.assertEqual(result["changed"], [])
        self.assertEqual(result["unchanged_count"], 1)

    def test_symlink_modes_and_file_membership_are_compared(self):
        a = [{"path": "link", "type": "symlink", "target": "old"},
             {"path": "script", "type": "regular", "mode": "0o100644", "sha256": "same"},
             {"path": "removed"}]
        b = [{"path": "link", "type": "symlink", "target": "new"},
             {"path": "script", "type": "regular", "mode": "0o100755", "sha256": "same"},
             {"path": "added"}]
        result = inventory_diff(a, b)
        self.assertEqual(result["changed"], ["link", "script"])
        self.assertEqual(result["added"], ["added"])
        self.assertEqual(result["removed"], ["removed"])


if __name__ == "__main__":
    unittest.main()
