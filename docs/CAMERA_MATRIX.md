# Master Camera Architecture & Reverse Engineering Status Matrix

This matrix consolidates historical Nikon Hacker community records (`camera_matrix.csv`, `FirmwareNotes.md`) and the [Z-Series Camera Release Timeline](../firmware%20decode/z-series/RELEASE_TIMELINE.md), mapping hardware architectures, processor generations, packaging formats, and repository reversing statuses from 1998 DSLRs to modern Z-series mirrorless cameras.

---

## 1. Nikon Z-Series Mirrorless Cameras

| Announcement | Model | Sensor Format | Image Processor | Main CPU Architecture | OS / Runtime | Packaging Format | Reversing Status & Core Deliverables | Reports & Tools |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 2018-08-23 | **Z7** | FX | EXPEED 6 | ARM/Thumb (32-bit) | SMP T-Kernel | Legacy 3-table XOR | Fully decoded, 4-segment and package CRC verified | [Z7 3.80 Report](../firmware%20decode/z-series/analysis/Z_7_0380/REPORT.md) |
| 2018-08-23 | **Z6** | FX | EXPEED 6 | ARM/Thumb (32-bit) | SMP T-Kernel | Legacy 3-table XOR | Fully decoded, 4-segment and roundtrip re-encode verified | [Z6 3.80 Report](../firmware%20decode/z-series/analysis/Z_6_0380/REPORT.md) |
| 2019-10-10 | **Z50** | DX | EXPEED 6 | ARM/Thumb (32-bit) | T-Kernel | Legacy 3-table XOR | Fully decoded, 3-segment CRC verified | [Z50 2.60 Report](../firmware%20decode/z-series/analysis/Z_50_0260/REPORT.md) |
| 2020-07-21 | **Z5** | FX | EXPEED 6 | ARM/Thumb (32-bit) | T-Kernel | Legacy 3-table XOR | Fully decoded, 4-segment CRC verified | [Z5 1.50 Report](../firmware%20decode/z-series/analysis/Z_5_0150/REPORT.md) |
| 2020-10-14 | **Z6II** | FX | Dual EXPEED 6 | ARM/Thumb (32-bit) | Dual-core / dual OS | Legacy 3-table XOR | Fully decoded, separate master (`mas`) and slave (`sla`) binaries verified | [Z6II 1.70 Report](../firmware%20decode/z-series/analysis/Z6_2_0170/REPORT.md) |
| 2020-10-14 | **Z7II** | FX | Dual EXPEED 6 | ARM/Thumb (32-bit) | Dual-core / dual OS | Legacy 3-table XOR | Fully decoded, separate master (`mas`) and slave (`sla`) binaries verified | [Z7II 1.70 Report](../firmware%20decode/z-series/analysis/Z7_2_0170/REPORT.md) |
| 2021-06-29 | **Z fc** | DX | EXPEED 6 | ARM/Thumb (32-bit) | T-Kernel | Legacy 3-table XOR | Fully decoded, 3-segment CRC verified | [Z fc 1.81 Report](../firmware%20decode/z-series/analysis/Z_fc_0181/REPORT.md) |
| 2021-10-28 | **Z9** | FX | EXPEED 7 | AArch64 (64-bit) | TOPPERS + Linux 4.14 | Legacy 3-table XOR | Fully decoded, kernel/rootfs/CEVA DSP extracted across 17 versions | [Z9 5.32 Report](../firmware%20decode/z-series/analysis/Z_9_0532/REPORT.md) |
| 2022-06-29 | **Z30** | DX | EXPEED 6 | ARM/Thumb (32-bit) | T-Kernel | Legacy 3-table XOR | Fully decoded, 3-segment CRC verified | [Z30 1.20 Report](../firmware%20decode/z-series/analysis/Z_30_0120/REPORT.md) |
| 2023-05-10 | **Z8** | FX | EXPEED 7 | AArch64 (64-bit) | TOPPERS + Linux 4.14 | Legacy 3-table XOR | Function-level reversing, CEVA DSP, Open Gate study, QEMU board emulation | [Z8 3.11 Report](../firmware%20decode/z-series/analysis/Z_8_0311/REPORT.md) · [QEMU](../firmware%20decode/z-series/qemu/z8/README.md) |
| 2023-09-20 | **Z f** | FX | EXPEED 7 | AArch64 (64-bit) | - | **0x260 New Prefix** | First new-packaging model; differential ciphertext matching known inference ELF | [Z f 3.01 Report](../firmware%20decode/z-series/analysis/Z_f_0301/REPORT.md) |
| 2024-06-17 | **Z6III** | FX | EXPEED 7 | AArch64 (64-bit) | - | **0x260 New Prefix** | Partial recovery; extracted complete A/B DSP images | [Z6III 2.00 Report](../firmware%20decode/z-series/analysis/Z6_3_0200/REPORT.md) |
| 2024-11-07 | **Z50II** | DX | EXPEED 7 | AArch64 (64-bit) | - | **0x260 New Prefix** | Partial recovery; matches identical class-C inference ELF | [Z50II 1.11 Report](../firmware%20decode/z-series/analysis/Z50_2_0111/REPORT.md) |
| 2025-04-03 | **Z5II** | FX | EXPEED 7 | AArch64 (64-bit) | - | **0x260 New Prefix** | Two differential ELFs; reference-assisted recovery of 8.26 MB window | [Z5II 1.20 Report](../firmware%20decode/z-series/analysis/Z5_2_0120/REPORT.md) |
| 2025-09-10 | **ZR** | FX | EXPEED 7 | AArch64 (64-bit) | - | **0x260 New Prefix** | Z CINEMA body; outer SHA-1 verified via Z8 code; payload remains undecoded | [ZR 1.11 Report](../firmware%20decode/z-series/analysis/ZR__0111/REPORT.md) |

---

## 2. Nikon Digital SLR Cameras (DSLR)

### 2.1 Modern DSLRs (ARM Era: EXPEED 3 / 4 / 5 / 6)

| Model | Year | Sensor Format | Image Processor | Main CPU Architecture | Load Base Address | Container Format | Reversing & Patch Support | Resources |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **D780** | 2020 | FX | EXPEED 6 | ARM v7 LE | `0x12020000` | Encrypted B | Memory map recorded | [FirmwareNotes](../FirmwareNotes/FirmwareNotes.md) |
| **D850** | 2017 | FX | EXPEED 5 | ARM v7 LE | - | Encrypted B | Patch & unpack supported | [Nikon-Patch](../Nikon-Patch/) |
| **D7500** | 2017 | DX | EXPEED 5 | ARM v7 LE | - | Encrypted B | Patch & unpack supported | [Nikon-Patch](../Nikon-Patch/) |
| **D500** | 2016 | DX | EXPEED 5 | ARM v7 LE | - | Encrypted B | Patch supported | [Nikon-Patch](../Nikon-Patch/) |
| **D5** | 2016 | FX | EXPEED 5 | ARM v7 LE | - | Encrypted B | Patch supported | [Nikon-Patch](../Nikon-Patch/) |
| **D5600** | 2016 | DX | EXPEED 4 | ARM v7 LE | - | Encrypted B | Patch supported | [Nikon-Patch](../Nikon-Patch/) |
| **D3400** | 2016 | DX | EXPEED 4 | ARM v7 LE | - | Encrypted B | Patch supported | [Nikon-Patch](../Nikon-Patch/) |
| **D7200** | 2015 | DX | EXPEED 4 | ARM v7 LE | - | Encrypted B | Patch supported | [Nikon-Patch](../Nikon-Patch/) |
| **D5500** | 2015 | DX | EXPEED 4 | ARM v7 LE | `0x90020000` | Encrypted B | Memory map recorded; patch supported | [FirmwareNotes](../FirmwareNotes/FirmwareNotes.md) · [Nikon-Patch](../Nikon-Patch/) |
| **D750** | 2014 | FX | EXPEED 4 | ARM v7 LE | `0x90020000` | Encrypted B | Memory map analyzed; IDC scripts; patch supported | [FirmwareNotes](../FirmwareNotes/FirmwareNotes.md) · [IDA_files/D750](../IDA_files/D750/) |
| **D810** | 2014 | FX | EXPEED 4 | ARM v7 LE | - | Encrypted B | Patch supported | [Nikon-Patch](../Nikon-Patch/) |
| **D4S** | 2014 | FX | EXPEED 4 | ARM v7 LE | - | Encrypted B | Patch supported | [Nikon-Patch](../Nikon-Patch/) |
| **D3300** | 2014 | DX | EXPEED 4 | ARM v7 LE | `0x90020000` | Encrypted B | Memory map recorded; patch supported | [FirmwareNotes](../FirmwareNotes/FirmwareNotes.md) · [Nikon-Patch](../Nikon-Patch/) |
| **D5300** | 2013 | DX | EXPEED 4 | ARM v7 LE | `0x90020000` | Encrypted B | Memory map recorded; patch supported | [FirmwareNotes](../FirmwareNotes/FirmwareNotes.md) · [Nikon-Patch](../Nikon-Patch/) |
| **D7100** | 2013 | DX | EXPEED 3 | ARM v7 LE | `0x50020000` | Encrypted B | Memory map recorded; patch supported | [FirmwareNotes](../FirmwareNotes/FirmwareNotes.md) · [Nikon-Patch](../Nikon-Patch/) |
| **D610** | 2013 | FX | EXPEED 3 | ARM v7 LE | `0x9E000000` (RAM) | Encrypted B | Video bitrate / clean HDMI patches supported | [Nikon-Patch](../Nikon-Patch/) |
| **D5200** | 2012 | DX | EXPEED 3 | ARM v7 LE | `0x50020000` | Encrypted B | Memory map, RTTI scripts, IDC scripts, patch supported | [FirmwareNotes](../FirmwareNotes/FirmwareNotes.md) · [IDA_files/D5200](../IDA_files/D5200/) |
| **D600** | 2012 | FX | EXPEED 3 | ARM v7 LE | `0x9E000000` (RAM) | Encrypted B | IDC scripts, function dumps, patch supported | [IDA_files/D600](../IDA_files/D600/) · [Nikon-Patch](../Nikon-Patch/) |
| **D800 / D800E** | 2012 | FX | EXPEED 3 | ARM v7 LE | `0x84F00000` (RAM) | Encrypted B | Full IDC scripts, task tables, ExifTables, patch supported | [IDA_files/D800](../IDA_files/D800/) · [Nikon-Patch](../Nikon-Patch/) |
| **D4** | 2012 | FX | EXPEED 3 | ARM v7 LE | `0xBE000000` (RAM) | Encrypted B | IDC scripts, patch supported | [IDA_files/D4](../IDA_files/D4/) · [Nikon-Patch](../Nikon-Patch/) |

---

### 2.2 Classic DSLRs (Fujitsu FR / Toshiba TX Era: EXPEED 1 / 2)

| Model | Year | Sensor Format | Image Processor | Main CPU Architecture | Coprocessor | Container Format | Reversing & Patch Support | Resources |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **D3200** | 2012 | DX | EXPEED 3 | Fujitsu FR BE | - | Encrypted B | IDC scripts, patch supported | [IDA_files/D3200](../IDA_files/D3200/) · [Nikon-Patch](../Nikon-Patch/) |
| **D5100** | 2011 | DX | EXPEED 2 | Fujitsu FR BE | - | Encrypted B | Core community target; dfr disassembler, IDC scripts, patch supported | [dfr](../dfr/) · [IDA_files/D5100](../IDA_files/D5100/) · [Nikon-Patch](../Nikon-Patch/) |
| **D7000** | 2010 | DX | EXPEED 2 | Fujitsu FR BE | - | Encrypted B | IDC scripts, menu dumps, system tables, patch supported | [IDA_files/D7000](../IDA_files/D7000/) · [Nikon-Patch](../Nikon-Patch/) |
| **D3100** | 2010 | DX | EXPEED 2 | Fujitsu FR BE | - | Encrypted B | IDC scripts, patch supported | [IDA_files/D3100](../IDA_files/D3100/) · [Nikon-Patch](../Nikon-Patch/) |
| **D3000** | 2009 | DX | EXPEED 1 | Fujitsu FR BE | - | Classic Format | IDC scripts, RAM setup & clear scripts | [IDA_files/D3000](../IDA_files/D3000/) |
| **D300S** | 2009 | DX | EXPEED 1 | Fujitsu FR BE | - | Classic Format | IDC scripts, menu names & language fix | [IDA_files/D300S](../IDA_files/D300S/) |
| **D3S** | 2009 | FX | EXPEED 1 | Fujitsu FR BE | - | Classic Format | IDC scripts, RAM setup & JPEG fix | [IDA_files/D3S](../IDA_files/D3S/) |
| **D90** | 2008 | DX | EXPEED 1 | Fujitsu FR BE | TX19A (MIPS) | Classic Format | System architecture topology (YAML); first video DSLR | [arch/d90.yaml](../arch/d90.yaml) · [Tx19a Plugin](../Tx19a%20IDA%20Plugin/) |
| **D700** | 2008 | FX | EXPEED 1 | Fujitsu FR BE | - | Classic Format | IDC scripts, menu & language fix | [IDA_files/D700](../IDA_files/D700/) |
| **D300** | 2007 | DX | EXPEED 1 | Fujitsu FR BE | - | Classic Format | Patch supported | [Nikon-Patch](../Nikon-Patch/) |
| **D3** | 2007 | FX | EXPEED 1 | Fujitsu FR BE | - | Classic Format | Early full-frame flagship analysis | [wiki/cameras/](../wiki/cameras/) |

---

### 2.3 Early Digital SLRs (Pre-EXPEED Era: 1998-2006)

| Model | Year | Sensor Type | Resolution | Hardware Documentation | Resources |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **D1 / D1H / D1X** | 1998-2001 | 2.7MP / 5.4MP CCD | 2012x1324 / 3008x1960 | Subsystem breakdown, schematics | [wiki/cameras/camera_matrix.csv](../wiki/cameras/camera_matrix.csv) |
| **D100** | 2002 | 6.1MP CCD | 3008x2000 | EEPROM data tables, block diagrams | [wiki/cameras/camera_matrix.csv](../wiki/cameras/camera_matrix.csv) |
| **D2H / D2Hs** | 2003-2005 | 4.1MP JFET LBCAST | 2464x1632 | Wiring diagrams, PCB photos | [wiki/cameras/camera_matrix.csv](../wiki/cameras/camera_matrix.csv) |
| **D2X / D2Xs** | 2004-2006 | 12.4MP CMOS (Sony IMX038) | 4288x2848 | Schematics, sensor characteristics | [wiki/cameras/camera_matrix.csv](../wiki/cameras/camera_matrix.csv) |
| **D70 / D70s** | 2004-2005 | 6.1MP CCD | 3008x2000 | Flash RAM description, wiring diagrams | [wiki/cameras/camera_matrix.csv](../wiki/cameras/camera_matrix.csv) |
| **D50** | 2005 | 6.1MP CCD | 3008x2000 | Wiring diagram | [wiki/cameras/camera_matrix.csv](../wiki/cameras/camera_matrix.csv) |
| **D200** | 2005 | 10.2MP CCD | 3872x2592 | Japanese wiring diagrams, CAM2000 AF module | [wiki/cameras/camera_matrix.csv](../wiki/cameras/camera_matrix.csv) |
| **D40 / D40X** | 2006-2007 | 6.1MP / 10.2MP CCD | 3008x2000 / 3872x2592 | Wiring diagram, CAM530 module | [wiki/cameras/camera_matrix.csv](../wiki/cameras/camera_matrix.csv) |
| **D80** | 2006 | 10.2MP CCD | 3872x2592 | CAM1000 AF module analysis | [wiki/cameras/camera_matrix.csv](../wiki/cameras/camera_matrix.csv) |

---

## 3. Firmware Container Packaging Evolution

| Generation | Typical Models | Header Signature | Encryption / Encoding | Checksum | Reversing Support |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Classic Encrypted DSLR** | D5100, D7000, D800, D750, etc. | Proprietary magic & section table | AES / XOR proprietary cipher | CRC-16 / MD5 | **Supported** ([Nikon-Patch](../Nikon-Patch/), [firmware decode](../firmware%20decode/)) |
| **Legacy 3-Table XOR** | Z6, Z7, Z50, Z5, Z6II, Z7II, Z fc, Z9, Z30, Z8 | 32-byte space padding at offset `0x20` | Three 64 KiB XOR tables, origin `0x20`, big-endian directory | CRC-16/XMODEM (sections & package) | **Supported** (`tools/analyze_firmware.py`, 123 packages verified 100%) |
| **0x260 Extended Prefix** | Z f, Z6III, Z50II, Z5II, ZR | Fixed `0x00` prefix, space marker at `0x260` | Stream cipher (legacy XOR scan yields no valid directory) | Outer SHA-1 with derived 8-byte trailer | **Partial Recovery** (differential & plaintext reference recovery; full payload pending) |
