#!/usr/bin/env python3
"""Automated unit test suite for EXPEED 7 PTP vendor protocol handler."""

import struct
import unittest

from expeed7_ptp_protocol import (
    BITMASK_BVR_GYRO_LOGGING,
    BVR_STATE_RAM_VA,
    OUTER_OPCODE,
    PROP_DEBUG_FLAGS,
    SUBCODE_GET_PROPERTY,
    SUBCODE_READ_MEMORY,
    SUBCODE_SESSION_CLOSE,
    SUBCODE_SESSION_OPEN,
    SUBCODE_SET_PROPERTY,
    SUBCODE_WRITE_MEMORY,
    SUPPORTED_MODELS,
    build_enable_bvr_gyro_csv,
    build_f001_open_session,
    build_f002_close_session,
    build_get_property,
    build_ptp_command,
    build_read_memory,
    build_set_property,
    build_write_memory_32,
    decode_ptp_response,
)


class TestExpeed7PtpProtocol(unittest.TestCase):
    def test_build_ptp_command_structure(self):
        pkt = build_ptp_command(123, 0xF001, 1, 2, 3)
        self.assertEqual(len(pkt), 32)
        length, c_type, op, tid, sub, p1, p2, p3, p4 = struct.unpack("<IHHI5I", pkt)
        self.assertEqual(length, 32)
        self.assertEqual(c_type, 1)  # COMMAND
        self.assertEqual(op, OUTER_OPCODE)
        self.assertEqual(tid, 123)
        self.assertEqual(sub, 0xF001)
        self.assertEqual(p1, 1)
        self.assertEqual(p2, 2)
        self.assertEqual(p3, 3)
        self.assertEqual(p4, 0)

    def test_build_f001_open_session_zr(self):
        pkt = build_f001_open_session(1, model=2100, fw_ver=0x0111)
        self.assertEqual(len(pkt), 32)
        length, c_type, op, tid, sub, model, ver, _, _ = struct.unpack("<IHHI5I", pkt)
        self.assertEqual(sub, SUBCODE_SESSION_OPEN)
        self.assertEqual(model, 2100)
        self.assertEqual(ver, 0x0111)

    def test_build_f001_all_supported_models(self):
        for model in SUPPORTED_MODELS:
            pkt = build_f001_open_session(10, model=model)
            self.assertEqual(len(pkt), 32)

    def test_build_f001_invalid_model(self):
        with self.assertRaisesRegex(ValueError, "Unsupported model"):
            build_f001_open_session(1, model=9999)

    def test_build_f002_close_session(self):
        pkt = build_f002_close_session(2)
        self.assertEqual(len(pkt), 32)
        _, _, _, tid, sub, _, _, _, _ = struct.unpack("<IHHI5I", pkt)
        self.assertEqual(tid, 2)
        self.assertEqual(sub, SUBCODE_SESSION_CLOSE)

    def test_build_property_access(self):
        set_pkt = build_set_property(3, PROP_DEBUG_FLAGS, BITMASK_BVR_GYRO_LOGGING)
        get_pkt = build_get_property(4, PROP_DEBUG_FLAGS)
        self.assertEqual(len(set_pkt), 32)
        self.assertEqual(len(get_pkt), 32)

        # Verify subcodes
        _, _, _, _, set_sub, set_prop, set_val, _, _ = struct.unpack("<IHHI5I", set_pkt)
        self.assertEqual(set_sub, SUBCODE_SET_PROPERTY)
        self.assertEqual(set_prop, PROP_DEBUG_FLAGS)
        self.assertEqual(set_val, 0x10)

        _, _, _, _, get_sub, get_prop, _, _, _ = struct.unpack("<IHHI5I", get_pkt)
        self.assertEqual(get_sub, SUBCODE_GET_PROPERTY)
        self.assertEqual(get_prop, PROP_DEBUG_FLAGS)

    def test_build_memory_io(self):
        read_pkt = build_read_memory(5, 0x0A03BC73B8, 4)
        write_pkt = build_write_memory_32(6, 0x0A03BC73B8, 3)

        _, _, _, _, r_sub, r_low, r_high, r_len, _ = struct.unpack("<IHHI5I", read_pkt)
        self.assertEqual(r_sub, SUBCODE_READ_MEMORY)
        self.assertEqual(r_low, 0x03BC73B8)
        self.assertEqual(r_high, 0x0A)
        self.assertEqual(r_len, 4)

        _, _, _, _, w_sub, w_low, w_high, w_val, _ = struct.unpack("<IHHI5I", write_pkt)
        self.assertEqual(w_sub, SUBCODE_WRITE_MEMORY)
        self.assertEqual(w_low, 0x03BC73B8)
        self.assertEqual(w_high, 0x0A)
        self.assertEqual(w_val, 3)

    def test_build_enable_bvr_gyro_csv_sequence(self):
        pkts = build_enable_bvr_gyro_csv(100)
        self.assertEqual(len(pkts), 3)
        # Check transaction IDs are sequential
        self.assertEqual(struct.unpack("<I", pkts[0][8:12])[0], 100)
        self.assertEqual(struct.unpack("<I", pkts[1][8:12])[0], 101)
        self.assertEqual(struct.unpack("<I", pkts[2][8:12])[0], 102)

    def test_decode_ptp_response(self):
        # Synthetic response: length 32, type 3 (RESPONSE), code 0x2001 (OK), tid 1, param 0x201E
        resp_raw = struct.pack("<IHHI5I", 32, 3, 0x2001, 1, 0x201E, 0, 0, 0, 0)
        decoded = decode_ptp_response(resp_raw, expected_tid=1)
        self.assertEqual(decoded["status"], "OK")
        self.assertEqual(decoded["response_code"], "0x2001")
        self.assertEqual(decoded["transaction_id"], 1)
        self.assertEqual(decoded["parameters"][0], "0x0000201e")

    def test_decode_ptp_response_tid_mismatch(self):
        resp_raw = struct.pack("<IHHI5I", 32, 3, 0x2001, 1, 0, 0, 0, 0, 0)
        with self.assertRaisesRegex(ValueError, "Transaction ID mismatch"):
            decode_ptp_response(resp_raw, expected_tid=2)


if __name__ == "__main__":
    unittest.main()
