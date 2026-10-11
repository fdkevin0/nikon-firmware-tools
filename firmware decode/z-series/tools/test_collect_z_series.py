#!/usr/bin/env python3
"""Protect camera scope, official sources and existing firmware inputs."""

import unittest
from io import BytesIO
from pathlib import Path
from tempfile import TemporaryDirectory
from unittest.mock import patch

from collect_z_series import download, firmware_details, official_url, product_list


class CollectorTests(unittest.TestCase):
    def test_camera_catalog_excludes_lenses_and_teleconverters(self):
        xml = (
            "<products><category>"
            + "".join(
                f'<product name="{name}" href="/en/products/1/test.html"/>'
                for name in ["Z 6II", "Z6III", "Z50II", "Z f", "Z fc", "ZR", "Z TELECONVERTER TC-2.0x", "NIKKOR Z 50mm"]
            )
            + "</category></products>"
        )
        self.assertEqual(len(product_list(xml)), 6)

    def test_html_entities_duplicate_platform_links_and_history(self):
        html = """<p>Z7_2_0170.bin</p><p>Firmware Version 1.62 to 1.70</p>
        <a href="https://crossgate.nikonimglib.com/dsd_redirect/x?P=1&amp;R=2">Download</a>
        <p>Z7_2_0170.bin</p>"""
        result = firmware_details(html)
        self.assertEqual(result["versions_named_in_changelog"], ["1.62", "1.70"])
        self.assertIn("&R=2", result["download_links"][0])
        with self.assertRaises(ValueError):
            firmware_details(html + "<p>Z_6_0380.bin</p>")

    def test_official_url_checks_hostname_boundary(self):
        official_url("https://download.nikonimglib.com/file.bin")
        for url in ["https://nikonimglib.com.example.org/x", "http://download.nikonimglib.com/x", "file:///tmp/a"]:
            with self.assertRaises(ValueError):
                official_url(url)

    def test_conflicting_remote_length_does_not_replace_input(self):
        with TemporaryDirectory() as temp:
            root = Path(temp)
            target = root / "Z_5_0150.bin"
            target.write_bytes(b"original")
            response = BytesIO(b"new")
            response.url = "https://download.nikonimglib.com/Z_5_0150.bin"
            response.headers = {"Content-Length": "3"}
            row = {"filename": target.name, "download_links": [response.url]}
            with patch("collect_z_series.open_url", return_value=response):
                with self.assertRaisesRegex(ValueError, "conflicts"):
                    download(row, root)
            self.assertEqual(target.read_bytes(), b"original")


if __name__ == "__main__":
    unittest.main()
