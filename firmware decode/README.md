# Firmware Decode & Analysis

This directory contains tools and reverse engineering artifacts for unpacking, decoding, and analyzing Nikon firmware packages.

## Tool Categories & Usage

Depending on camera generation and packaging format, different toolchains are used:

### 1. Classic DSLR Firmware Unpacking
- **Tools**: [Nikon-Patch LocalUI](../Nikon-Patch/) or [Nikon-Patch-JS (Web version)](../Nikon-Patch-JS/)
- **Usage**:
  - Launch `LocalUI` and use the **"Decode Firmware"** button on encrypted `.bin` files to split them into individual section binaries;
  - Alternatively, compile and run the CLI unpacker from [firmware decode.sln](firmware%20decode.sln).
- **Base Addresses & Memory Maps**: Consult [FirmwareNotes](../FirmwareNotes/FirmwareNotes.md) and [IDA_files](../IDA_files/).

### 2. Nikon Z-Series Mirrorless Unpacking & Deep Analysis (Python)
- **Primary Guide**: [z-series/README.md](z-series/README.md)
- **Coverage**: 15 Z-series models (Z6, Z7, Z50, Z5, Z6II, Z7II, Z fc, Z9, Z30, Z8, Z f, Z6III, Z50II, Z5II, ZR).
- **Key Tools**: Located in `z-series/tools/`:
  - `analyze_firmware.py`: Decodes legacy 3-table XOR containers (Z6, Z8, etc.);
  - `analyze_zf.py` / `analyze_z5ii.py` / `analyze_zr.py`: Differential and plaintext-referenced analysis for `0x260` extended containers;
  - `collect_all_z_history.py` / `compare_all_z_history.py`: History collection and version-by-version comparisons.
- **Emulation & Deep Research**: Includes stock Z8 boot via QEMU 10.2.4, Open Gate recording feasibility, and CEVA DSP ELF analysis.
