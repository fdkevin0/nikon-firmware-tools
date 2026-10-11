# Z8 Official Firmware QEMU Board Emulation

The goal is to boot **unmodified official Z8 C 3.11** firmware in simulation, and subsequently verify diagnostic menu patches.
Currently, official EL3/EL1 bootstrap, DMA initialization data copy, secondary core release, and RTOS multi-core scheduling have executed successfully; **full camera cold boot, native GUI menu rendering, and Linux handoff remain incomplete**. For evidence and current blocking points, see the [Startup Report](../../analysis/z8_qemu_boot/REPORT.md).

This is a custom AArch64 board model added to this repository, inspired by methodology from [`z7-qemu`](../../analysis/z7_qemu_reference/REPORT.md). Note that Z7's 32-bit CPU, GIC, GPU command streams, and startup scripts cannot be directly ported to Z8. The model does not patch QEMU CPU cores, nor does it alter stock firmware instructions or inject code via GDB.

---

## Build & Run

From the repository root:

```sh
cd "firmware decode/z-series"
uv run python3 -B tools/build_z8_qemu.py --jobs 4
uv run python3 -B tools/run_z8_qemu.py --output /tmp/z8-stock-probe --seconds 5
```

### Prerequisites
- Python 3.10+
- C Compiler, Ninja, Git, pkg-config
- GLib development libraries (required by QEMU build)

The build script downloads official QEMU **10.2.4** source, validates its SHA-256, and checks out dtc commit `b6910bec11614980a21e46fbccc35934b671bd81`. Default build directory is `/tmp/nikon-z8-qemu-build` (must not contain colons or spaces).

If you already have the source archive:
```sh
uv run python3 -B tools/build_z8_qemu.py --archive /tmp/qemu-10.2.4.tar.xz
```

The runner only accepts fingerprint-matched `Z_8_0311.bin`, unpacks and verifies container CRC, and loads the stock EG payload at `0x40160000` (excluding trailing container CRC).

---

## Reproducible Bootstrap Checkpoint

```sh
uv run python3 -B tools/run_z8_qemu.py \
  --output /tmp/z8-stock-bootstrap --seconds 1 --breakpoint 0x401691d0
```

`0x401691d0` is the entry point to the official RTOS kernel. At this checkpoint:
- CPU 0 PC is `0x401691d0` in EL1 state.
- Official init data `EG[0x4b13000:0x4dc0000]` matches `RAM[0xa02808000:0xa02ab5000]` across all `0x2ad000` bytes.
- Logs capture real DMA transfers and the firmware releasing CPU 1 and CPU 2 via SRAM mailbox.
- GDB thread enumeration lists 4 cores (CPU 3 remains held offline pending Linux handoff).

---

## Device Contract & Configuration Checks

```sh
uv run pytest
uv run python3 -B tools/check_z8_qemu_devices.py --output /tmp/z8-device-check
```

The second command tests 24 HDMAC channels, DMA strides, reset configurations, I2C/SPI FIFO mocks, and unmapped register termination behaviors.
