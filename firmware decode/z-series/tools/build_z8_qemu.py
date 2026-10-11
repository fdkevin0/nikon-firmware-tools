#!/usr/bin/env python3
"""Build a version-pinned AArch64 QEMU with the local Z8 board overlay."""

import argparse
import hashlib
import json
import subprocess
import sys
import tarfile
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OVERLAY = ROOT / "qemu/z8"
VERSION = "10.2.4"
ARCHIVE_SHA = "821b545b92f165e57dddccac5077d76d4d436a226595b8813ad59306bbfd0746"
DTC_REVISION = "b6910bec11614980a21e46fbccc35934b671bd81"
OPTIONS = [
    "--target-list=aarch64-softmmu",
    "--without-default-devices",
    "--disable-docs",
    "--disable-tools",
    "--disable-user",
    "--disable-werror",
    "--disable-gtk",
    "--disable-sdl",
    "--disable-vnc",
    "--disable-opengl",
    "--disable-guest-agent",
    "--disable-slirp",
    "--disable-rust",
    "--disable-debug-info",
]


def digest(path):
    h = hashlib.sha256()
    with path.open("rb") as stream:
        while chunk := stream.read(1024 * 1024):
            h.update(chunk)
    return h.hexdigest()


def build(work, archive, jobs):
    if not 1 <= jobs <= 64 or any(c in str(work) for c in (" ", ":")):
        raise ValueError("Use 1..64 jobs and a build path without spaces or colons")
    work.mkdir(parents=True, exist_ok=True)
    archive = archive or work / f"qemu-{VERSION}.tar.xz"
    if not archive.exists():
        urllib.request.urlretrieve(f"https://download.qemu.org/qemu-{VERSION}.tar.xz", archive)
    if digest(archive) != ARCHIVE_SHA:
        raise ValueError("Official QEMU archive SHA-256 mismatch")
    source_hashes = {name: digest(OVERLAY / name) for name in ("nikon-z8.c", "nikon-z8-config.h", "prepare_source.py")}
    source = work / f"qemu-{VERSION}"
    if not (source / "VERSION").exists():

        def safe(member, destination):
            try:
                return tarfile.data_filter(member, destination)
            except (tarfile.AbsoluteLinkError, tarfile.LinkOutsideDestinationError):
                return None

        with tarfile.open(archive) as package:
            package.extractall(work, filter=safe)
    subprocess.run([sys.executable, "-B", str(OVERLAY / "prepare_source.py"), str(source)], check=True)
    if DTC_REVISION not in (source / "subprojects/dtc.wrap").read_text():
        raise ValueError("QEMU dtc dependency revision changed")
    dtc = source / "subprojects/dtc"
    if not (dtc / "meson.build").exists():
        dtc.mkdir(exist_ok=True)
        subprocess.run(["git", "init"], cwd=dtc, check=True)
        subprocess.run(
            ["git", "fetch", "--depth", "1", "https://github.com/qemu/dtc.git", DTC_REVISION], cwd=dtc, check=True
        )
        subprocess.run(["git", "checkout", "--detach", "FETCH_HEAD"], cwd=dtc, check=True)
    revision = subprocess.run(
        ["git", "rev-parse", "HEAD"], cwd=dtc, check=True, capture_output=True, text=True
    ).stdout.strip()
    if revision != DTC_REVISION:
        raise ValueError("Existing dtc checkout does not match the pinned revision")
    target = work / "build"
    target.mkdir(exist_ok=True)
    if not (target / "build.ninja").exists():
        subprocess.run([str(source / "configure"), *OPTIONS], cwd=target, check=True)
    subprocess.run(["ninja", "-j", str(jobs), "qemu-system-aarch64"], cwd=target, check=True)
    if any(digest(OVERLAY / name) != expected for name, expected in source_hashes.items()) or any(
        digest(source / "hw/arm" / name) != source_hashes[name] for name in ("nikon-z8.c", "nikon-z8-config.h")
    ):
        raise ValueError("Sources changed while building; rebuild before running")
    binary = target / "qemu-system-aarch64"
    result = {
        "qemu_version": VERSION,
        "archive_sha256": ARCHIVE_SHA,
        "dtc_revision": DTC_REVISION,
        "binary": str(binary),
        "binary_sha256": digest(binary),
        "configure": OPTIONS,
        "sources": source_hashes,
        "upstream_cpu_core_modified": False,
    }
    destination = OVERLAY / ".local"
    destination.mkdir(exist_ok=True)
    (destination / "build-manifest.json").write_text(json.dumps(result, indent=2) + "\n")
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--work-dir", type=Path, default=Path("/tmp/nikon-z8-qemu-build"))
    parser.add_argument("--archive", type=Path)
    parser.add_argument("--jobs", type=int, default=4)
    args = parser.parse_args()
    result = build(args.work_dir.resolve(), args.archive.resolve() if args.archive else None, args.jobs)
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
