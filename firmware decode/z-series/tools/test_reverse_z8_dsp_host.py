#!/usr/bin/env python3
"""The large-code-model scanner must not invent pointers across clobbers/calls."""

import struct
import unittest

from reverse_z8_dsp_host import locate_lookup, wide_constants


def movz(reg, value, half=0):
    return 0xD2800000 | (half << 21) | (value << 5) | reg


def movk(reg, value, half):
    return 0xF2800000 | (half << 21) | (value << 5) | reg


def packed(words):
    return struct.pack("<" + "I" * len(words), *words)


class HostReferenceTests(unittest.TestCase):
    def test_interleaved_full_address(self):
        data = packed([movz(0, 0x1234), movz(1, 7), movk(0, 0x4167, 1), movk(0, 0xA, 2), movk(0, 0, 3)])
        refs = wide_constants(data)
        self.assertEqual(len(refs), 1)
        self.assertEqual(refs[0]["value"], 0xA41671234)
        self.assertEqual(refs[0]["instruction_offsets"], [0, 8, 12, 16])

    def test_clobbers_and_control_flow_rejected(self):
        for middle in [0xAA0103E0, 0x2A0103E0, 0x94000000, 0x14000001]:
            data = packed([movz(0, 0x1234), movk(0, 0x4167, 1), middle, movk(0, 0xA, 2), movk(0, 0, 3)])
            self.assertEqual(wide_constants(data), [])

    def test_incomplete_address_not_accepted(self):
        self.assertEqual(wide_constants(packed([movz(0, 1), movk(0, 2, 1), movk(0, 0, 3)])), [])
        with self.assertRaises(ValueError):
            locate_lookup(bytes(256), 256)


if __name__ == "__main__":
    unittest.main()
