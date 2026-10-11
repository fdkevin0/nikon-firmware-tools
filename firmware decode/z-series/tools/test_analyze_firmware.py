#!/usr/bin/env python3
"""Check corrupt-container rejection and the XOR 16 MiB index wrap."""

import binascii
import struct
import unittest

from analyze_firmware import TABLES, decode_container, transform


def fixture():
    body = b"synthetic firmware\0" * 5
    body += struct.pack(">H", binascii.crc_hqx(body, 0))
    decoded = b" " * 32 + struct.pack(">4I", 1, 80, 0, 0)
    decoded += struct.pack(">16s4I", b"test.bin", 80, len(body), 0, 0) + body
    decoded += struct.pack(">H", binascii.crc_hqx(decoded, 0)) + bytes(14)
    return decoded


class ContainerTests(unittest.TestCase):
    def test_crc_reference(self):
        self.assertEqual(binascii.crc_hqx(b"123456789", 0), 0x31C3)

    def test_both_header_offsets(self):
        plain = fixture()
        for prefix in [b"", bytes(range(32))]:
            decoded, metadata = decode_container(prefix + transform(plain))
            self.assertEqual(decoded, plain)
            self.assertEqual(metadata["xor_origin"], len(prefix))
            self.assertTrue(metadata["package_crc16"]["valid"])

    def test_corrupted_section(self):
        encoded = bytearray(transform(fixture()))
        encoded[85] ^= 1
        with self.assertRaisesRegex(ValueError, "Section CRC mismatch"):
            decode_container(encoded)

    def test_corrupted_package_crc(self):
        encoded = bytearray(transform(fixture()))
        encoded[-16] ^= 1
        with self.assertRaisesRegex(ValueError, "Package CRC mismatch"):
            decode_container(encoded)

    def test_truncated_container(self):
        with self.assertRaises(ValueError):
            decode_container(transform(fixture())[:-20])

    def test_directory_bounds_and_filename(self):
        for offset, replacement in [
            (32, struct.pack(">I", 0xFFFFFFFF)),
            (64, struct.pack(">I", 0xFFFFFFFF)),
            (48, b"../test.bin\0\0\0\0\0\0"),
        ]:
            decoded = bytearray(fixture())
            decoded[offset : offset + len(replacement)] = replacement
            with self.assertRaises(ValueError):
                decode_container(transform(decoded))

    def test_xor_known_bytes_and_wrap(self):
        a, b, c = TABLES
        self.assertEqual(a[0] ^ b[0] ^ c[0], 0xB1)
        self.assertEqual(a[32] ^ b[0] ^ c[0], 0x50)
        self.assertEqual(c[10], 0)  # C# converts the upstream 0x100 to byte.
        plain = b" " * 32 + bytes(0x1000020 - 32)
        encoded = transform(plain)
        self.assertEqual(encoded[32], encoded[0x1000020 - 1] ^ a[31] ^ a[32])
        self.assertEqual(encoded[0x1000000], 0xB1)
        self.assertEqual(transform(encoded), plain)


if __name__ == "__main__":
    unittest.main()
