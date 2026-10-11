# Nikon Firmware Reverse Engineering Notes

This document summarizes processor architectures, load base addresses, memory maps, and research entry points across Nikon DSLRs and mirrorless cameras.

---

## Model Quick Index

| Model | Processor Architecture | Load Base Address | IDA Scripts / Resources | Section Link |
| :--- | :--- | :--- | :--- | :--- |
| **D750** | ARM v7 LE | `0x90020000` | [IDA_files/D750/](../IDA_files/D750/) | [Details](#d750) |
| **D780** | ARM v7 LE | `0x12020000` | - | [Details](#d780) |
| **D7100** | ARM v7 LE | `0x50020000` | - | [Details](#d7100) |
| **D7000** | Fujitsu FR BE | `0x8F800000` (RAM) | [IDA_files/D7000/](../IDA_files/D7000/) | [Details](#d7000) |
| **D5500** | ARM v7 LE | `0x90020000` | - | [Details](#d5500) |
| **D5300** | ARM v7 LE | `0x90020000` | - | [Details](#d5300) |
| **D5200** | ARM v7 LE | `0x50020000` | [IDA_files/D5200/](../IDA_files/D5200/) | [Details](#d5200) |
| **D5100** | Fujitsu FR BE | - | [IDA_files/D5100/](../IDA_files/D5100/) · [dfr](../dfr/) | [Details](#d5100) |
| **D3300** | ARM v7 LE | `0x90020000` | - | [Details](#d3300) |
| **D3200** | Fujitsu FR BE | `0x9D000000` (RAM) | [IDA_files/D3200/](../IDA_files/D3200/) | [Details](#d3200) |
| **D3100** | Fujitsu FR BE | `0x8FA00000` (RAM) | [IDA_files/D3100/](../IDA_files/D3100/) | [Details](#d3100) |
| **D3000** | Fujitsu FR BE | `0x800000` (RAM) | [IDA_files/D3000/](../IDA_files/D3000/) | [Details](#d3000) |
| **D800** | ARM v7 LE | `0x84F00000` (RAM) | [IDA_files/D800/](../IDA_files/D800/) | [Details](#d800--d800e) |
| **D600** | ARM v7 LE | `0x9E000000` (RAM) | [IDA_files/D600/](../IDA_files/D600/) | [Details](#d600--d610) |
| **Z-Series** | AArch64 / ARM | See Topic Reports | [firmware decode/z-series/](../firmware%20decode/z-series/) | [Details](#z-series-mirrorless-overview) |

---

## DSLR Memory Maps & Base Addresses

### D750
- **Firmware Binary**: B Firmware (`b1010_nnnd.bin`)
- **Processor Architecture**: ARM v7 LE
- **Load Base**: `0x90020000`
- **Memory Map (v1.10)**:
  | Src | Dst | Len | Status |
  | :--- | :--- | :--- | :--- |
  | `0x912bec08` | `0x10000000` | `0x30344` | rwx |
  | `0x912eef4c` | `0x10030344` | `0xf95c` | rw |
  | `0x9135fc40` | `0x100a1400` | `0x5340c` | rw |
- **IDA Resources**: See [IDA_files/D750/](../IDA_files/D750/) (includes Setup RAM 1.02/1.10, PTP, Services, and RTTI analysis scripts).

### D780
- **Firmware Binary**: B Firmware (`eg1510_nnnnb0.bi`)
- **Processor Architecture**: ARM v7 LE
- **Load Base**: `0x12020000`

### D7100
- **Firmware Binary**: B Firmware (`b760nnnn.bin`)
- **Processor Architecture**: ARM v7 LE
- **Load Base**: `0x50020000`
- **Memory Map (v1.04)**:
  | Src | Dst | Len | Status |
  | :--- | :--- | :--- | :--- |
  | `0x516c6388` | `0x10000000` | `0x3b284` | rwx |
  | `0x5170160c` | `0x1003b284` | `0x1670` | rw |
  | `0x517d0c80` | `0x1010ac80` | `0x1890c` | rw |

### D7000
- **Firmware Binary**: B Firmware (`b750nnnn.bin`)
- **Processor Architecture**: Fujitsu FR BE
- **RAM Setup Base**: `0x8F800000`
- **IDA Resources**: See [IDA_files/D7000/](../IDA_files/D7000/) (includes 1.05 menu dumps, ExifTables, system task tables, PTP names, and RAM setup scripts).

### D5500
- **Firmware Binary**: B Firmware (`b1120_nnn.bin`)
- **Processor Architecture**: ARM v7 LE
- **Load Base**: `0x90020000`
- **Memory Map (v1.02)**:
  | Src | Dst | Len | Status |
  | :--- | :--- | :--- | :--- |
  | `0x9109dd3c` | `0x10000000` | `0x30ac4` | rwx |
  | `0x910ce800` | `0x10030ac4` | `0xd718` | rw |
  | `0x9113e060` | `0x100a0700` | `0x5cbfc` | rw |
  | `0x9113e048` | `0x100a0308` | `0x4` | rw |

### D5300
- **Firmware Binary**: B Firmware (`b930_nnn.bin`)
- **Processor Architecture**: ARM v7 LE
- **Load Base**: `0x90020000`
- **Memory Map (v1.03)**:
  | Src | Dst | Len | Status |
  | :--- | :--- | :--- | :--- |
  | `0x91498e24` | `0x10000000` | `0x3b5b4` | rwx |
  | `0x914d43d8` | `0x1003b5b4` | `0x1834` | rw |
  | `0x915b26a0` | `0x10119c60` | `0x1cd4c` | rw |
  | `0x915b2688` | `0x10119868` | `0x4` | rw |
- **Segment Layout**:
  | Address | Length | Status | Notes |
  | :--- | :--- | :--- | :--- |
  | `0x10000000` | ? | rwx | Kernel |
  | `0x90020000` | ? | rx | B Firmware |
  | `0xA2000000` | ? | rwv | A Firmware shared memory window |

### D5200
- **Firmware Binary**: B Firmware (`b970nnna.bin`)
- **Processor Architecture**: ARM v7 LE
- **Load Base**: `0x50020000`
- **Memory Map (v1.03)**:
  | Src | Dst | Len | Status |
  | :--- | :--- | :--- | :--- |
  | `0x51494220` | `0x10000000` | `0x3c758` | rwx |
  | `0x514d0978` | `0x1003c758` | `0x10e4` | rw |
  | `0x515a6280` | `0x101123e0` | `0x1a60c` | rw |
- **IDA Resources**: See [IDA_files/D5200/](../IDA_files/D5200/) (includes RTTI script, function tables, resource tables, and language tables).

### D5100
- **Firmware Binary**: B Firmware (`b640nnnb.bin`)
- **Processor Architecture**: Fujitsu FR BE
- **Tools & Scripts**:
  - [dfr/d5100.txt](../dfr/d5100.txt): Code and memory map ranges.
  - [IDA_files/D5100/](../IDA_files/D5100/): ROM loaders, RAM setup, menu fix, and symbol table scripts.

### D3300
- **Firmware Binary**: B Firmware (`b860_nnn.bin`)
- **Processor Architecture**: ARM v7 LE
- **Load Base**: `0x90020000`
- **Memory Map (v1.02)**:
  | Src | Dst | Len | Status |
  | :--- | :--- | :--- | :--- |
  | `0x9158a358` | `0x10000000` | `0x0003b5b4` | rwx |
  | `0x915c590c` | `0x1003b5b4` | `0x0000179c` | rw |
  | `0x916a73a0` | `0x1011d420` | `0x00028b3c` | rw |
  | `0x916a739c` | `0x1011d03c` | 4 | rw |

### D3200
- **Firmware Binary**: B Firmware (`b830nnna.bin`)
- **Processor Architecture**: Fujitsu FR BE
- **IDA Scripts**: See [IDA_files/D3200/](../IDA_files/D3200/).

### D3100
- **Firmware Binary**: B Firmware
- **Processor Architecture**: Fujitsu FR BE
- **IDA Scripts**: See [IDA_files/D3100/](../IDA_files/D3100/).

### D3000
- **Firmware Binary**: B Firmware
- **Processor Architecture**: Fujitsu FR BE
- **IDA Scripts**: See [IDA_files/D3000/](../IDA_files/D3000/).

### D800 / D800E
- **Firmware Binary**: B Firmware
- **Processor Architecture**: ARM v7 LE
- **IDA Scripts**: See [IDA_files/D800/](../IDA_files/D800/).

### D600 / D610
- **Firmware Binary**: B Firmware
- **Processor Architecture**: ARM v7 LE
- **IDA Scripts**: See [IDA_files/D600/](../IDA_files/D600/).

---

## Z-Series Mirrorless Overview

Z-series cameras adopt modern EXPEED 6 / EXPEED 7 SoC architectures, transitioning from a single monolithic firmware image to heterogeneous multicore systems with separate real-time OS, Linux runtimes, and dedicated CEVA DSP vision coprocessors:

- **Z6 / Z7 (EXPEED 6)**: ARM/Thumb, SMP T-Kernel RTOS, main image load base `0x10020000`.
  - [Z6 3.80 Report](../firmware%20decode/z-series/analysis/Z_6_0380/REPORT.md)
  - [Z7 3.80 Report](../firmware%20decode/z-series/analysis/Z_7_0380/REPORT.md)
- **Z8 / Z9 (EXPEED 7)**: AArch64, SOLID-OS / TOPPERS/FMP, Linux 4.14.224 runtime, and 3 embedded CEVA DSP ELFs (image processing, tracking, neural inference).
  - [Z8 3.11 Report](../firmware%20decode/z-series/analysis/Z_8_0311/REPORT.md)
  - [Z9 5.32 Report](../firmware%20decode/z-series/analysis/Z_9_0532/REPORT.md)
  - [Z8 QEMU Board Emulation](../firmware%20decode/z-series/qemu/z8/README.md)
- **Z f / Z50 II / Z5 II / Z6 III / ZR (New Packaging)**: Extended `0x260` prefix format introduced starting with Z f in 2023.
  - [Z f 3.01 Report](../firmware%20decode/z-series/analysis/Z_f_0301/REPORT.md)
  - [Z5 II 1.20 Partial Recovery Report](../firmware%20decode/z-series/analysis/Z5_2_0120/REPORT.md)
  - [ZR 1.11 Container Analysis Report](../firmware%20decode/z-series/analysis/ZR__0111/REPORT.md)
- **Complete Z-Series Tools & Reproduction**: See [firmware decode/z-series/README.md](../firmware%20decode/z-series/README.md).
