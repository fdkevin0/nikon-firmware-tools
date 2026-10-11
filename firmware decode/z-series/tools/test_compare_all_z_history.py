#!/usr/bin/env python3
import unittest

from collect_all_z_history import member_record
from compare_all_z_history import compare_sections, component


class HistoryTests(unittest.TestCase):
    def test_archive_revision_keeps_model_and_version(self):
        listing = "Path = wrapper.exe\nSize = 100\n\nPath = Z6IIUpdate/Z6_2_0110_01.bin\nSize = 90\nCRC = 12345678\n"
        self.assertEqual(member_record(listing, "Z6_2_0110.bin")["Path"], "Z6IIUpdate/Z6_2_0110_01.bin")
        for wrong in ["Z7_2_0110.bin", "Z6_2_0120.bin"]:
            with self.assertRaises(ValueError):
                member_record(listing, wrong)
        with self.assertRaises(ValueError):
            member_record(listing + "\n" + listing, "Z6_2_0110.bin")

    def test_master_slave_not_collapsed(self):
        self.assertEqual(component("egmas_0001.bin"), "egmas")
        self.assertEqual(component("egsla_0001.bin"), "egsla")
        self.assertEqual(component("eg1850_mas_0140d"), "eg_mas")
        self.assertEqual(component("eg1850_sla_0140d"), "eg_sla")
        self.assertEqual(component("_tp_1001.bin"), "_tp")
        self.assertEqual(component("eg_0101.bin"), "eg")
        a = [{"component": "egmas", "sha256": "a", "size": 1}, {"component": "egsla", "sha256": "b", "size": 2}]
        b = [{"component": "egmas", "sha256": "a", "size": 1}, {"component": "egsla", "sha256": "c", "size": 3}]
        self.assertEqual([r["change"] for r in compare_sections(a, b)], ["identical", "changed"])
        with self.assertRaises(ValueError):
            compare_sections(a + [a[0]], b)


if __name__ == "__main__":
    unittest.main()
