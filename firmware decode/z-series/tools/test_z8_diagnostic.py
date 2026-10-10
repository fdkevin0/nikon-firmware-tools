"""Protocol and build guards; proprietary firmware is not needed for these tests."""
import binascii
from pathlib import Path
import struct
import tempfile
import unittest

from analyze_firmware import decode_container, transform
from build_z8_diagnostic import branch, build, read_stock
from reverse_z8_dsp_host import disassembler
from z8_diagnostic_protocol import request, decode_response


class DiagnosticTests(unittest.TestCase):
    def test_request_matches_documented_wire_layout(self):
        self.assertEqual(request(0x12345678).hex(),
                         '200000000100fd9478563412fff0000000000000000000000000000000000000')
        for tid in (-1, 1 << 32):
            with self.assertRaises(ValueError):
                request(tid)

    def test_response_checks_transaction_type_status_and_identity(self):
        response = bytes.fromhex(
            '200000000300012078563412012000004e464447000001001608000011030000')
        self.assertEqual(decode_response(response, 0x12345678),
                         {'identity': 'NFDG', 'patch_version': '1.0.0', 'model_id': 2070,
                          'base_firmware': '0x0311', 'transaction_id': 0x12345678})
        with self.assertRaisesRegex(ValueError, 'transaction'):
            decode_response(response, 1)
        for offset in (0, 4, 6, 12, 16):
            damaged = bytearray(response)
            damaged[offset] ^= 1
            with self.subTest(offset=offset), self.assertRaises(ValueError):
                decode_response(bytes(damaged), 0x12345678)
        with self.assertRaises(ValueError):
            decode_response(response[:-1], 0x12345678)

    def test_branch_range_and_disassembled_destination(self):
        for source, target in ((0x407FE27C, 0x412A3200), (0x412A32A0, 0x407FE280)):
            instruction = next(disassembler().disasm(branch(source, target), source))
            self.assertEqual((instruction.mnemonic, instruction.op_str), ('b', f'#{target:#x}'))
        for source, target in ((0, 2), (0, 1 << 27), (1 << 27, -4)):
            with self.assertRaises(ValueError):
                branch(source, target)

    def test_names_precede_their_own_extents_including_final_module(self):
        # Independent byte-level fixture guards the exact name/extent mismatch
        # found in nikon-fw-key-tool. No special package-name or unnamed module.
        contents = [b'EX payload', b'EG payload', b'LI payload']
        names = ['ex2070_test.bi', 'eg2070_test.bi', 'li2070_test.bi']
        modules = [data + struct.pack('>H', binascii.crc_hqx(data, 0)) for data in contents]
        count, directory_size = 3, 48 + 32 * 3
        body = bytearray(b' ' * 32 + struct.pack('>4I', count, directory_size, 0, 0))
        start = directory_size
        for name, module in zip(names, modules):
            body.extend(name.encode().ljust(16, b'\0'))
            body.extend(struct.pack('>4I', start, len(module), 0, 0))
            start += len(module)
        body.extend(b''.join(modules))
        body.extend(struct.pack('>H', binascii.crc_hqx(body, 0)) + bytes(14))
        decoded, metadata = decode_container(bytes(32) + transform(body))
        self.assertEqual([s['name'] for s in metadata['sections']], names)
        for section, expected in zip(metadata['sections'], contents):
            a, n = section['container_offset'], section['size']
            self.assertEqual(decoded[a:a + n - 2], expected)

    def test_wrong_version_or_modified_input_is_rejected_before_output(self):
        with self.assertRaisesRegex(ValueError, 'pinned'):
            read_stock(b'not the pinned vendor image')
        with tempfile.TemporaryDirectory() as temp:
            source, output = Path(temp) / 'source.bin', Path(temp) / 'output'
            source.write_bytes(b'wrong firmware')
            with self.assertRaisesRegex(ValueError, 'pinned'):
                build(source, output)
            self.assertFalse(output.exists())
            self.assertEqual(source.read_bytes(), b'wrong firmware')

    def test_existing_output_is_never_overwritten(self):
        with tempfile.TemporaryDirectory() as temp:
            output = Path(temp) / 'existing'
            output.mkdir()
            sentinel = output / 'keep.bin'
            sentinel.write_bytes(b'keep')
            with self.assertRaisesRegex(ValueError, 'already exists'):
                build(Path(temp) / 'absent.bin', output)
            self.assertEqual(sentinel.read_bytes(), b'keep')


if __name__ == '__main__':
    unittest.main()
