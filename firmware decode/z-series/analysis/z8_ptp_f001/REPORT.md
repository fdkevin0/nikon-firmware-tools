# Nikon Z 8 3.11: 0xF001 is a Proprietary PTP Sub-Opcode

Analysis date: 2026-10-07. Scope: Z 8 3.11 `eg2070_0311b0.bi` (SHA-256 `f85e0138e2f5e660ece8560de62e0d12cb795e0e14983e50f20b61dce906c46c`), cross-referenced against upstream PTP implementations. No camera was connected, and no USB packets were transmitted.

**In this firmware's private command dispatch architecture, `0xF001` operates as a sub-opcode: transmitted within PTP Parameter 1, dispatched under an outer PTP operation code. Success opens a proprietary service state, while `0xF002` closes it.** "Proprietary session/service mode" is an analytical label; official vendor terminology has not been identified. Evidence resides in [Disassembly Landmarks](code_landmarks.asm), [Manifest](manifest.json), and the [PTP Resources Report](../z8_ptp_resources/REPORT.md).

## 1. Outer PTP Opcodes vs Internal Sub-Opcodes

In standard USB PTP containers, the 16-bit operation `code` sits at offset `+0x06`; 32-bit Parameter 1 sits at `+0x0C`. See libgphoto2 [ptp.h](https://raw.githubusercontent.com/gphoto/libgphoto2/master/camlibs/ptp2/ptp.h) and [ptp_usb_sendreq](https://raw.githubusercontent.com/gphoto/libgphoto2/master/camlibs/ptp2/usb.c).

Z 8 generic pre-check `0x407FE27C` loads the low 16 bits of request offset `+0x0C` as the internal command ID, loading the outer opcode from `+0x06`. Internal lookup `0x407FE078` scans table `0x440EC590` in 48-byte strides; the first entry is `0xF001`.

Outer descriptor table landmarks:

| Outer PTP Opcode | Descriptor Address | Raw Flags | Pre-Check Wrapper | Handler Wrapper |
|---|---|---|---|---|
| `0x94FD` | `0x44DF2820` | `0` | `0x407FE130` | `0x407FE138` |
| `0x94FE` | `0x44DF2860` | `2` | `0x407FE150` | `0x407FE158` |
| `0x94FF` | `0x44DF28A0` | `1` | `0x407FE160` | `0x407FE168` |

All three wrappers dispatch to shared pre-check `0x407FE27C` and handler `0x407FE350`. Internal descriptor `0xF001` has flags 0, handler `0x407FE53C`, and init callback `0x407FE4F0`.

Request framing for `0xF001` (matching flag 0 no-data phase):

```text
OperationCode = 0x94FD
Parameters    = [0x0000F001, 0, 0, 0, 0]
```

In offline emulation, this 5-parameter request passes entry checks; passing a single parameter `[0xF001]` is rejected by parameter count validation with error `0x2006`.

## 2. Behavior of 0xF001 vs 0xF002

Initialization callback `0x407FE4F0` registers state query `0x407FE524`, reading a flag at `0xA047D9FC8`. When flag == 0, `0xF001` is the sole exception allowed to proceed, while other internal commands are rejected with `0xA004`.

Handler `0x407FE53C` writes 1 to `0xA047D9FC8` on success. Handler `0x407FE734` for `0xF002` clears this flag to 0 at `0x407FE83C`.
Re-entering `0xF001` while the flag is already 1 returns outer response `code = 0x2001` with internal status Parameter 1 set to `0x201E`.

This flag is separate from standard PTP `OpenSession (0x1002)`.

## 3. Discrepancies with Older Tooling Definitions

Older Nikon tools (e.g. `PtpCommands.cs`) used top-level opcode `0xFC01` for `EnterServiceMode` and `0xFC02` for exit, matched in Wireshark dictionaries as `ServiceModeStart`/`ServiceModeStop`.
In libgphoto2, `0xF001` appears under Nikon 1 `DeviceProps`.
Therefore, raw hexadecimal IDs cannot be assumed to be universal without confirming camera model, firmware version, and packet field placement.

## 4. Reproducible Emulation

Execute:

```sh
uv run python tools/reverse_z8_ptp_f001.py
uv run pytest
```

Emulation test results across 5 scenarios:

| Initial State Flag | Sub-Opcode | Parameter Count | Validation Result |
|---|---|---|---|
| 0 | `0xF001` | 5 | Accepted (Entry allowed) |
| 0 | `0xF002` | 5 | Rejected (`0xA004`) |
| 0 | `0xF029` | 5 | Rejected (`0xA004`) |
| 0 | `0xF001` | 1 | Rejected (`0x2006` parameter length error) |
| 1 | `0xF001` | 5 | Accepted (Duplicate entry: outer `0x2001`, inner `0x201E`) |
