#!/usr/bin/env python3
"""Execute the pinned official Z8 EG in QEMU and retain startup observations."""

import argparse
import hashlib
import json
import socket
import subprocess
import time
from pathlib import Path

from analyze_firmware import decode_container
from analyze_zr import Z8_EG_SHA256, Z8_SHA256
from build_z8_qemu import OVERLAY, ROOT, digest
from z8_qemu_rsp import Remote


class QMP:
    def __init__(self, process):
        self.process = process
        self.events = []
        self.read()
        self.command("qmp_capabilities")

    def read(self):
        line = self.process.stdout.readline()
        if not line:
            raise EOFError("QEMU exited")
        return json.loads(line)

    def command(self, name):
        self.process.stdin.write(json.dumps({"execute": name}) + "\n")
        self.process.stdin.flush()
        while True:
            reply = self.read()
            if "event" in reply:
                self.events.append(reply)
            elif "error" in reply:
                raise ValueError(reply["error"])
            elif "return" in reply:
                return reply["return"]


def run(firmware, output, seconds, breakpoint):
    if output.exists() or not 0 < seconds <= 300:
        raise ValueError("Use a fresh output directory and 0 < seconds <= 300")
    encoded = firmware.read_bytes()
    if hashlib.sha256(encoded).hexdigest() != Z8_SHA256:
        raise ValueError("Only the pinned, unmodified Z8 C 3.11 official package is accepted")
    body, directory = decode_container(encoded)
    section = next(s for s in directory["sections"] if s["name"] == "eg2070_0311b0.bi")
    a, n = section["container_offset"], section["size"]
    eg = body[a : a + n]
    if hashlib.sha256(eg).hexdigest() != Z8_EG_SHA256:
        raise ValueError("Official EG fingerprint mismatch")
    build = json.loads((OVERLAY / ".local/build-manifest.json").read_text())
    if digest(Path(build["binary"])) != build["binary_sha256"]:
        raise ValueError("QEMU binary changed; rebuild it")
    for name, expected in build["sources"].items():
        if digest(OVERLAY / name) != expected:
            raise ValueError("Z8 board source changed; rebuild it")
    with socket.socket() as temporary:
        temporary.bind(("127.0.0.1", 0))
        port = temporary.getsockname()[1]
    output.mkdir(parents=True)
    image = output / "official-eg.bi"
    image.write_bytes(eg)
    command = [
        build["binary"],
        "-M",
        "nikon-z8",
        "-smp",
        "4",
        "-display",
        "none",
        "-serial",
        "none",
        "-monitor",
        "none",
        "-nic",
        "none",
        "-bios",
        str(image.resolve()),
        "-S",
        "-gdb",
        f"tcp:127.0.0.1:{port}",
        "-qmp",
        "stdio",
        "-d",
        "guest_errors,int",
        "-D",
        str((output / "exceptions.log").resolve()),
        "-accel",
        "tcg,thread=single",
        "-icount",
        "shift=3,align=off,sleep=off",
    ]
    result = {
        "official_package_sha256": Z8_SHA256,
        "eg_sha256": Z8_EG_SHA256,
        "loaded_payload_bytes": len(eg) - 2,
        "loaded_payload_sha256": hashlib.sha256(eg[:-2]).hexdigest(),
        "excluded_container_crc_hex": eg[-2:].hex(),
        "firmware_code_patched": False,
        "host_guest_ram_fixtures": [],
        "command": command,
        "build": build,
        "requested_seconds": seconds,
        "requested_breakpoint": hex(breakpoint) if breakpoint else None,
        "scope": "Startup probe, not certification of complete camera/menu boot",
    }
    remote = process = None
    with (output / "guest.log").open("w") as log:
        try:
            process = subprocess.Popen(
                command, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=log, text=True, bufsize=1
            )
            qmp = QMP(process)
            remote = Remote(port)
            threads = remote.threads()
            result["initial_registers"] = {t: remote.registers(t) for t in threads}
            if breakpoint:
                assert remote.command(f"Z1,{breakpoint:x},4") == "OK"
            qmp.command("cont")
            print("Official Z8 guest started", flush=True)
            deadline = time.monotonic() + seconds
            while time.monotonic() < deadline and process.poll() is None:
                time.sleep(0.1)
            if process.poll() is None:
                qmp.command("stop")
                # Consume any asynchronous stop packet before the next command.
                remote.sock.settimeout(0.3)
                try:
                    result["stop_packet"] = remote.receive()
                except socket.timeout:
                    pass
                remote.sock.settimeout(10)
                result["status"] = qmp.command("query-status")
                result["final_registers"] = {t: remote.registers(t) for t in threads}
                result["startup_descriptor_copy_hex"] = remote.memory(0xA02800048, 0x160).hex()
                result["eg_crc_trailer_unmapped"] = remote.memory(0x40160000 + len(eg) - 2, 2) == b"\xff\xff"
                result["initialized_ram_copy_exact"] = remote.memory(0xA02808000, 0x2AD000) == eg[0x4B13000:0x4DC0000]
                result["initialized_ram_comparison_note"] = (
                    "Exact at 0x401691d0 before kernel entry; normal RTOS execution later modifies initialized globals"
                )
                qmp.command("quit")
                process.wait(timeout=5)
            else:
                result["guest_exit"] = process.returncode
            result["qmp_events"] = qmp.events
        except Exception as error:
            result["error"] = repr(error)
        finally:
            if remote:
                remote.close()
            if process and process.poll() is None:
                process.terminate()
                try:
                    process.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    process.kill()
                    process.wait()
            result["process_exit"] = process.returncode if process else None
    result["guest_log"] = (output / "guest.log").read_text(errors="replace")
    exceptions = output / "exceptions.log"
    if exceptions.exists():
        result["exception_log_sha256"] = digest(exceptions)
        result["exception_log_bytes"] = exceptions.stat().st_size
        trace = exceptions.read_text(errors="replace")
        result["irq_exceptions_by_cpu"] = {
            str(cpu): trace.count(f"Taking exception 5 [IRQ] on CPU {cpu}\n") for cpu in range(4)
        }
    (output / "manifest.json").write_text(json.dumps(result, indent=2) + "\n")
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--firmware", type=Path, default=ROOT / "Z_8_0311.bin")
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--seconds", type=float, default=5)
    parser.add_argument("--breakpoint", type=lambda s: int(s, 0))
    args = parser.parse_args()
    result = run(args.firmware, args.output, args.seconds, args.breakpoint)
    print(
        json.dumps(
            {k: result[k] for k in ("error", "guest_exit", "status", "final_registers") if k in result}, indent=2
        )
    )
    return int("error" in result or result.get("guest_exit", 0) != 0)


if __name__ == "__main__":
    raise SystemExit(main())
