#!/usr/bin/env python3
"""Automated unit tests for EXPEED 7 architecture & subsystem analyzer."""

import struct
import unittest
from pathlib import Path

from reverse_expeed7_system import (
    analyze_linux_shell_executor,
    extract_property_categories,
    extract_ptp_vendor_table,
    find_bvr_gyro_logging_spec,
    parse_nisi_container,
)


class TestReverseExpeed7System(unittest.TestCase):
    def test_parse_nisi_container_synthetic(self):
        # Create synthetic NISI container
        header = bytearray(32 + 4 * 16)
        header[:4] = b"NISI"
        struct.pack_into("<I", header, 16, 4)  # count = 4
        header[20:26] = b"0111b0"

        # Entry 0: sector 1, count 10, bytes 20000
        struct.pack_into("<4I", header, 32, 1, 10, 20000, 0)
        # Entry 1: sector 11, count 20, bytes 40000
        struct.pack_into("<4I", header, 48, 11, 20, 40000, 0)
        # Entry 2: sector 31, count 2, bytes 3000
        struct.pack_into("<4I", header, 64, 31, 2, 3000, 0)
        # Entry 3: sector 33, count 2, bytes 3000
        struct.pack_into("<4I", header, 80, 33, 2, 3000, 0)

        nisi = parse_nisi_container(bytes(header))
        self.assertEqual(nisi["magic"], "NISI")
        self.assertEqual(nisi["sub_image_count"], 4)
        self.assertEqual(nisi["version"], "0111b0")
        self.assertEqual(len(nisi["sub_images"]), 4)
        self.assertEqual(nisi["sub_images"][0]["offset"], 2048)
        self.assertEqual(nisi["sub_images"][0]["byte_size"], 20000)
        self.assertEqual(nisi["sub_images"][1]["offset"], 11 * 2048)

    def test_parse_nisi_container_invalid_magic(self):
        with self.assertRaisesRegex(ValueError, "Invalid NISI container"):
            parse_nisi_container(b"XXXX" + bytes(30))

    def test_real_z8_eg_binary_subsystems(self):
        eg_path = Path("firmware decode/z-series/analysis/Z_8_0311/eg2070_0311b0.bi")
        if not eg_path.exists():
            self.skipTest("eg2070_0311b0.bi not found")

        eg_data = eg_path.read_bytes()

        # 1. PTP Vendor Commands Table
        ptp_cmds = extract_ptp_vendor_table(eg_data)
        self.assertEqual(len(ptp_cmds), 182)
        subcodes = [c["subcode"] for c in ptp_cmds]
        self.assertIn("0xf001", subcodes)
        self.assertIn("0xf002", subcodes)
        self.assertIn("0xa001", subcodes)
        self.assertIn("0xb002", subcodes)

        # 2. Camera Property Categories Table
        categories = extract_property_categories(eg_data)
        self.assertEqual(len(categories), 124)
        total_props = sum(c["property_count"] for c in categories)
        self.assertGreater(total_props, 4000)

        # 3. BVR Gyro Logging Specification
        bvr_spec = find_bvr_gyro_logging_spec(eg_data)
        self.assertTrue(bvr_spec["found"])
        self.assertIn("YawDiff", bvr_spec["channels"]["gyroscope_3axis"])
        self.assertIn("PitchDiff", bvr_spec["channels"]["gyroscope_3axis"])
        self.assertIn("RollDiff", bvr_spec["channels"]["gyroscope_3axis"])
        self.assertIn("Homo[2][0]", bvr_spec["channels"]["homography_matrix_3x3"])

        # 4. BVR Gyro Activation Trigger
        from reverse_expeed7_system import find_axislog_gyro_task, find_bvr_activation_trigger
        bvr_trigger = find_bvr_activation_trigger(eg_data)
        self.assertEqual(bvr_trigger["status"], "fully_mapped")
        self.assertEqual(bvr_trigger["diagnostic_property_id"], "0x40000100")
        self.assertEqual(bvr_trigger["required_bitmask"], "0x00000010")
        self.assertEqual(bvr_trigger["logging_state_ram"], "0x0A03BC73B8")
        self.assertEqual(bvr_trigger["logging_state_active_value"], 3)

        # 5. AxisLog DevSvP01 Task Specification
        axis_task = find_axislog_gyro_task(eg_data)
        self.assertTrue(axis_task["found"])
        self.assertEqual(axis_task["task_name"], "DevSvP01")
        self.assertEqual(axis_task["csv_filename"], "A:\\AxisLog.csv")
        self.assertEqual(axis_task["event_flag_ram"], "0x0A02E562E8")
        self.assertEqual(axis_task["sample_record_size_bytes"], 36)
        self.assertEqual(axis_task["ring_buffer"]["max_samples"], 1200)
        self.assertIn("0x01", axis_task["event_flags"])
        self.assertIn("0x08", axis_task["event_flags"])
        self.assertIn(90.0, axis_task["calibration_angle_thresholds_deg"])

        # 6. FirmwareChkLib Blowfish & Pre-Shared Auth Keys
        from reverse_expeed7_system import extract_firmware_chk_crypto
        crypto_spec = extract_firmware_chk_crypto(eg_data)
        self.assertTrue(crypto_spec["found"])
        self.assertIn("Blowfish", crypto_spec["cipher"])
        self.assertEqual(len(crypto_spec["pre_shared_auth_keys"]), 8)
        self.assertEqual(crypto_spec["pre_shared_auth_keys"][0]["hex"], "704066e40433d552")
        self.assertEqual(crypto_spec["p_array_init_pi_words"][0], "0x243f6a88")
        self.assertEqual(crypto_spec["sha1_vectors"]["h0"], "0x67452301")


    def test_analyze_linux_shell_executor_synthetic(self):
        synthetic_elf = b"padding" + b"/bin/sh\0" + b"CLaMainAppDebug_ExecuteShellCommand\0" + b"/tmp/LaMainApp_unix_socket\0" + b"/dev/oscom_memhelper\0"
        res = analyze_linux_shell_executor(synthetic_elf)
        self.assertTrue(res["found_shell_path"])
        self.assertTrue(res["found_debug_command_symbol"])
        self.assertTrue(res["found_ipc_socket"])
        self.assertTrue(res["found_oscom_device"])
        self.assertEqual(res["ipc_socket_path"], "/tmp/LaMainApp_unix_socket")
        self.assertEqual(res["oscom_driver_device"], "/dev/oscom_memhelper")


if __name__ == "__main__":
    unittest.main()
