# Z_6_0380.bin Structural and Code Analysis

Analysis date: 2026-10-04. Subject: Raw firmware sample in `firmware decode/z-series/`.

## Key Conclusions

The Z 6 C 3.80 updater package can be completely decoded. The outer format consists of a **32-byte prefix + legacy 3-table XOR container**, without requiring AES decryption. All four extracted sections pass CRC-16 validation, the full-package CRC matches, and the reconstructed binary matches the input byte-for-byte.

The primary firmware is 32-bit little-endian ARM code mixing ARM and Thumb instructions, suitable for analysis using Ghidra's `ARM:LE:32:v7` language module. Strong static evidence confirms a memory mapping base address of `0x10020000`, with the initial reset entry point at `0x1002BC88`.
The operating system identifies as `SMP T-Kernel Version 1.00.01`. The exact SoC model and flasher authentication protocol remain unverified.

This corrects an earlier misconception: **the absence of public patcher support does not imply that firmware packages are undecodable**. Unpacking success does not guarantee that modified firmware can be flashed simply by updating CRC checksums.

## Sample Identification

| Parameter | Value |
| --- | --- |
| File | `Z_6_0380.bin` |
| Length | 34,923,366 bytes (`0x0214E366`, ~33.3055 MiB) |
| SHA-256 | `ff978ffdf77c58c0b861a06e16d432d5886969f3cdd05d62f6c8e82e8a4cea54` |
| Global Entropy | 7.9999963656 bits/byte |
| Internal Version String | Section offset `0x20`: `Ver.03.80.00` |

Nikon lists this binary as Z 6 C 3.80 firmware, released on 2025-05-13. See the [Official Firmware Page](https://downloadcenter.nikonimglib.com/en/download/fw/557.html) and [Product Page](https://downloadcenter.nikonimglib.com/en/products/493/Z_6.html). The SHA-256 hash serves as a local fingerprint.

Heuristic tools such as `file` misidentified the binary as a DOS COM executable due to early bytes; high entropy alone cannot differentiate XOR obfuscation from compression or modern encryption.

## Container Layout and Decoding

Raw file offsets `0x00–0x1F` contain an unverified 32-byte prefix:

```text
e923255226716973dac53401c67d173dba1886ddd5a56e931663ed3325aee20b
```

Raw file offsets `0x20–0x3F` consist of 32 ASCII space bytes (`0x20`), marking the container origin.
Defining `i = raw_offset - 0x20`, decoding proceeds from container offset `0x20`:

```text
plain[i] = input[0x20 + i]
         XOR table1[i & 0xff]
         XOR table2[(i >> 8) & 0xff]
         XOR table3[(i >> 16) & 0xff]
```

The keystream repeats every `2^24` bytes (16 MiB). This repeating XOR mask does not provide cryptographic one-time-pad security.
The three tables match those documented in [Package.cs](https://github.com/simeonpilgrim/nikon-firmware-tools/blob/main/Nikon-Patch/LocalUI/Package.cs), with `0x100` in the third table truncated to `0x00` per C# cast semantics.
The upstream [LocalUI decoder](https://github.com/simeonpilgrim/nikon-firmware-tools/blob/main/Nikon-Patch/LocalUI/Form1.cs) already checked for space headers at offsets 0 and `0x20`; hence, recognizing the 32-byte offset does not constitute a new cryptanalytic break.

This toolchain preserves the leading 32 spaces. Upstream `Package.LoadData` applies XOR to this header, yielding corrupted header bytes; while section payloads are unaffected, full-package CRC verification requires preserving the original spaces.

Directory headers use big-endian integers, in contrast to the little-endian ARM instructions in the firmware:

| Container Offset | Description |
| --- | --- |
| `0x00–0x1F` | 32-byte ASCII space marker |
| `0x20` | Section count: `4` (u32 big-endian) |
| `0x24` | Header length: `0xB0` (u32 big-endian) |
| `0x28–0x2F` | Two reserved u32 words (zero in this sample) |
| `0x30–0xAF` | Four directory entries, 32 bytes each |
| Each entry `+0x00` | 16-byte filename string |
| Each entry `+0x10` | Section start offset (relative to container origin) |
| Each entry `+0x14` | Section size (including 2-byte CRC) |
| Each entry `+0x18` | Two reserved u32 words (zero in this sample) |

## The Four Firmware Sections

Filenames are preserved verbatim from the directory table; `.bi` extensions are not renamed.

| Filename | Container Offset | Raw Offset | Size (Bytes) | CRC-16 | Entropy |
| --- | --- | --- | ---: | --- | ---: |
| `ex1620_037000.bi` | `0x000000B0` | `0x000000D0` | 524,290 | `A2C1` (Pass) | 3.130746 |
| `_tpj01_v140.bin` | `0x000800B2` | `0x000800D2` | 57,346 | `A0F2` (Pass) | 6.230169 |
| `eg1620_038000.bi` | `0x0008E0B4` | `0x0008E0D4` | 33,502,842 | `F92D` (Pass) | 6.338325 |
| `vr1620_010200.bi` | `0x0208172E` | `0x0208174E` | 838,664 | `9BB9` (Pass) | 1.759876 |

Sections are contiguous without gaps or overlaps. The trailing CRC uses CRC-16/XMODEM (polynomial `0x1021`, initial `0x0000`, unreflected, no final XOR, big-endian), matching [upstream CRC.cs](https://github.com/simeonpilgrim/nikon-firmware-tools/blob/main/Nikon-Patch/LocalUI/CRC.cs).
Each CRC covers the section up to its final two bytes.

The full-package CRC `0x3679` resides at container offset `0x0214E336` (raw offset `0x0214E356`), followed by 14 zero bytes.
It covers decoded data across `[0, 0x0214E336)`.
The decoded package has SHA-256: `f08b1d1280c1264933748ceafb77f597df69c6077f6e508115f6420faf21c580`.

Section hashes are recorded in [manifest.json](manifest.json).

## Primary Firmware Mapping and Boot Sequence

The initial instruction of `eg1620_038000.bi` is:

```text
File Offset 0x00000000: 20 2f 00 ea    b  File Offset 0x0000BC88
```

At `0xBC88`, initialization zeroes general-purpose registers, configures CP15, MMU, caches, VBAR, and stacks for different exception modes.
It inspects MPIDR to differentiate boot cores from auxiliary cores, corroborating the presence of an SMP operating system.

Verification of base address:

1. Startup code at `0xBD20` loads `0x10034140` from literal pool `0xBFD4` and writes it to VBAR.
2. File offset `0x14140` contains an ARM exception vector table; hence base address = `0x10034140 - 0x14140 = 0x10020000`.
3. The reset vector in this table loads `0x1002BC88` from file offset `0x14160`, matching base address + startup offset.
4. Absolute address references in `FirmwareManagement.c` confirm this mapping.

The reset vector cannot be read from offset `0x20` (which stores version text).
While Simeon Pilgrim's [D3300 Disassembly Guide](https://simeonpilgrim.com/blog/2021/08/07/getting-started-disassembling-nikon-firmware/) provides workflow insights, header layouts differ.

Startup code performs two memory copies:

| ROM Source | File Offset in EG | RAM Target | Length |
| --- | --- | --- | --- |
| `0x11E94DD4` | `0x01E74DD4` | `0xC1800000` | `0x00101400` |
| `0x11F96200` | `0x01F76200` | `0xC2A10000` | `0x00000FF8` |

A zero-length copy template `0x11F97200 → 0xC2A11000` requires no initialized block. Source, target, and loop registers are visible in [code_landmarks.asm](code_landmarks.asm).

Recommended Ghidra setup:

1. Import EG as Raw Binary, `ARM:LE:32:v7`, base address `0x10020000`.
2. Exclude trailing 2-byte CRC; disassemble ARM code at `0x10020000`, `0x1002BC88`, and `0x10034140`.
3. Map the two RAM blocks above as initialized memory; treat the base image as read-only.
4. Switch to Thumb mode where branch instructions dictate.
5. Apply manual labels based on function landmarks and source filenames.

## Auxiliary Sections

Section `ex1620_037000.bi` has initial SP `0x20000C08` and reset vector `0x080001C5`.
Disassembly at base `0x08000000`, offset `0x1C4` yields Cortex-M Thumb boot code that copies `[0x08000000, 0x080001C4)` to `0x20000000` and configures VTOR (`0xE000ED08`).
Offset `0x3709` carries string `Z 6 Firmware Ex Copyright Nikon Corp.`. This represents an independent MCU subsystem with its own versioning (`03.70.00`).

Section `vr1620_010200.bi` contains string `NikonBVR` at `0x0A`, pointing to vibration reduction firmware.
Section `_tpj01_v140.bin` represents touch panel firmware, though architecture and controller models remain unverified.

## Landmarks for Ongoing Analysis

Offsets relative to EG section (mapped address = offset + `0x10020000`):

| Offset in EG | Symbol / String Landmark | Description |
| --- | --- | --- |
| `0x00032F45` | `SMP T-Kernel Version 1.00.01` | Operating system kernel banner |
| `0x00197498`, `0x0019A228` | `FirmwareManagement.c` | Firmware management routines |
| `0x001A2E54`, `0x001A3CDC` | `FirmwareChkLib.c` | Verification and checksum module |
| `0x001D5BF0` | `FirmwareManagementService.c` | Upper firmware management service |
| `0x0023EE64` | `MovieRecordApplicationService.c` | Video recording subsystem |
| `0x0031021C` | `PtpMemoryControl.c` | PTP memory control routines |
| `0x0050F130` | `A:\HDMIRAW.KEY` | HDMI RAW license path |
| `0x01BABB6C` | `Booted ARM926 Firmware...` | Embedded ARM926 coprocessor firmware |

At `0x101C3BBA`, a Thumb routine initializes SHA-1 state constants (`0x5A827999`), processes blocks, and compares a 20-byte digest. Tracing callers will clarify its relationship to package verification and the 32-byte container prefix.

File operations near `0x1052F156` handle length `0x30` records close to HDMI RAW paths. The literal string `LvRaw` was not found in EG.

## Verified vs Unverified

Verified: File hashes, section boundaries, 4 section CRCs, package CRC, bit-for-bit re-encoding roundtrip, base address and vector table consistency, and error handling tests (corrupted CRC, truncated headers, traversal rejection, 16 MiB keystream wrapping).

Unverified: Outer 32-byte prefix semantics, flasher signature verification, exact SoC hardware identifiers, TPJ/VR instruction sets, video recording time limit routines, HDMI RAW activation mechanisms, and flasher acceptance.

The most productive next step is tracing calls from `FirmwareManagement` to `FirmwareChkLib` to analyze prefix verification, or diffing against another decoded Z 6 firmware version.
