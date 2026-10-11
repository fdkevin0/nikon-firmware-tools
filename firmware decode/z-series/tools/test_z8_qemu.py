#!/usr/bin/env python3
"""Input guards and AArch64 debugging protocol; no firmware or QEMU needed."""

import struct
import tempfile
import types
import unittest
from pathlib import Path
from unittest import mock

import build_z8_qemu as builder
from run_z8_qemu import run
from z8_qemu_rsp import Remote


class XMLRemote(Remote):
    def __init__(self):
        self.register_fields = []
        core = "".join(
            f'<reg name="{name}" bitsize="{bits}"/>'
            for name, bits in [(f"x{i}", 64) for i in range(31)] + [("sp", 64), ("pc", 64), ("cpsr", 32)]
        )
        self.files = {
            "target.xml": '<target><xi:include href="aarch64-core.xml"/></target>',
            "aarch64-core.xml": "<feature>" + core + '<reg name="ctr_el0" bitsize="64"/></feature>',
        }
        self.load_xml("target.xml")

    def command(self, command):
        if command.startswith("qXfer:"):
            return "l" + self.files[command.split(":")[3]]
        if command.startswith("Hg"):
            return "OK"
        if command == "g":
            return struct.pack("<33QI", *[0xA02800000 + i for i in range(33)], 0x3C5).hex()
        raise AssertionError(command)


class QEMUChecks(unittest.TestCase):
    def test_source_change_during_build_never_certifies_stale_binary(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            overlay, work = root / "overlay", root / "work"
            overlay.mkdir()
            for name in ("nikon-z8.c", "nikon-z8-config.h", "prepare_source.py"):
                (overlay / name).write_text("original")
            (overlay / ".local").mkdir()
            manifest = overlay / ".local/build-manifest.json"
            manifest.write_text("previous build marker")
            archive = root / "archive"
            archive.write_bytes(b"fixture; no download or extraction")
            source = work / ("qemu-" + builder.VERSION)
            (source / "hw/arm").mkdir(parents=True)
            (source / "VERSION").write_text(builder.VERSION)
            (source / "subprojects/dtc").mkdir(parents=True)
            (source / "subprojects/dtc/meson.build").write_text("fixture")
            (source / "subprojects/dtc.wrap").write_text(builder.DTC_REVISION)
            (work / "build").mkdir()
            (work / "build/build.ninja").write_text("fixture")

            def command(args, **kwargs):
                if args[0] == "git":
                    return types.SimpleNamespace(stdout=builder.DTC_REVISION + "\n")
                if args[0] == "ninja":
                    (overlay / "nikon-z8-config.h").write_text("edited during compilation")
                else:
                    for name in ("nikon-z8.c", "nikon-z8-config.h"):
                        (source / "hw/arm" / name).write_bytes((overlay / name).read_bytes())
                return types.SimpleNamespace(returncode=0)

            with (
                mock.patch.object(builder, "OVERLAY", overlay),
                mock.patch.object(builder, "ARCHIVE_SHA", builder.digest(archive)),
                mock.patch.object(builder.subprocess, "run", side_effect=command),
            ):
                with self.assertRaisesRegex(ValueError, "Sources changed while building"):
                    builder.build(work, archive, 1)
            self.assertEqual(manifest.read_text(), "previous build marker")

    def test_paginated_cpu_threads(self):
        remote = Remote.__new__(Remote)
        replies = iter(["mp01.01", "mp01.02,p01.03", "mp01.04", "l"])
        commands = []

        def command(value):
            commands.append(value)
            return next(replies)

        remote.command = command
        self.assertEqual(remote.threads(), ["p01.01", "p01.02", "p01.03", "p01.04"])
        self.assertEqual(commands, ["qfThreadInfo"] + ["qsThreadInfo"] * 3)
        remote.command = lambda value: "E01"
        with self.assertRaisesRegex(ValueError, "Invalid thread"):
            remote.threads()

    def test_gdb_xml_includes_and_64bit_registers(self):
        remote = XMLRemote()
        regs = remote.registers("p01.01")
        self.assertEqual(regs["pc"], hex(0xA02800000 + 32))
        self.assertEqual(regs["sp"], hex(0xA02800000 + 31))
        self.assertEqual(regs["x30"], hex(0xA02800000 + 30))
        self.assertEqual(regs["cpsr"], "0x3c5")

    def test_checksum_and_escaped_rsp_packet(self):
        for raw, expected in ((b"OK", "OK"), (b"a* ", "aaaa"), (b"}\x04", "$")):
            remote = Remote.__new__(Remote)
            remote.buffer = bytearray(b"$" + raw + b"#" + f"{sum(raw) & 255:02x}".encode())
            remote.sock = types.SimpleNamespace(sendall=lambda packet: self.assertEqual(packet, b"+"))
            self.assertEqual(remote.receive(), expected)
        remote.buffer = bytearray(b"$OK#00")
        with self.assertRaisesRegex(ValueError, "checksum"):
            remote.receive()

    def test_wrong_firmware_and_existing_output_never_publish_or_overwrite(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            source = root / "vendor.bin"
            source.write_bytes(b"wrong or patched firmware")
            out = root / "run"
            with self.assertRaisesRegex(ValueError, "official package"):
                run(source, out, 1, None)
            self.assertFalse(out.exists())
            out.mkdir()
            keep = out / "keep"
            keep.write_bytes(b"keep")
            with self.assertRaisesRegex(ValueError, "fresh output"):
                run(root / "missing", out, 1, None)
            self.assertEqual(keep.read_bytes(), b"keep")


if __name__ == "__main__":
    unittest.main()
