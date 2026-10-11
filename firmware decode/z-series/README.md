# Nikon Z-Series Firmware Analysis Hub

Consult the [Z-Series Camera Release Timeline](RELEASE_TIMELINE.md) for announcement dates, SoC generations, and verified container formats across all 15 models.
For model-by-model USB/MTP specifications, MAID capability IDs, and configuration value indices, see the [Remote SDK 2.0.0 Reference Index](references/remote-sdk-2.0.0/README.md).

Collected **148 historical firmware images across 15 Z-series models (totaling 8.79 GB)**:
- **123 legacy XOR packages** fully decoded; all 523 section CRCs, whole-package CRCs, and byte-for-byte re-encoding checks pass.
- **25 modern extended-prefix packages** partially recovered via differential and plaintext reference matching.
- Only 16 packages remain uncollected out of 164 known historical records (15 factory initial 1.00 releases and Z6III 1.01).

---

## Technical Topic & Research Report Index

Over 40 reproducible reverse engineering reports and reference documents are cataloged by research topic:

| Research Domain | Core Focus | Key Reports & Entry Points |
| :--- | :--- | :--- |
| **History & Comparative Evolution** | Cross-version comparisons and container evolution across 15 models & 148 releases | - [All History Key Findings](analysis/all_history/FINDINGS.md)<br>- [Version-by-Version Comparison Table](analysis/all_history/REPORT.md)<br>- [Camera Release Timeline](RELEASE_TIMELINE.md)<br>- [Z8 Historical Versions Analysis](analysis/z8_history/REPORT.md)<br>- [Catalog Survey Report](analysis/catalog/REPORT.md)<br>- [Z f Initial Packaging Survey](analysis/catalog/ZF_PACKAGING_HISTORY.md) |
| **Model Reversing (Legacy 3-Table XOR)** | Full container decode, section CRC validation, and symbol extraction | - [Z6 3.80 Report](analysis/Z_6_0380/REPORT.md) · [Z7 3.80 Report](analysis/Z_7_0380/REPORT.md)<br>- [Z8 3.11 Report](analysis/Z_8_0311/REPORT.md) · [Z9 5.32 Report](analysis/Z_9_0532/REPORT.md)<br>- [Z5 1.50 Report](analysis/Z_5_0150/REPORT.md) · [Z50 2.60 Report](analysis/Z_50_0260/REPORT.md)<br>- [Z30 1.20 Report](analysis/Z_30_0120/REPORT.md) · [Z fc 1.81 Report](analysis/Z_fc_0181/REPORT.md)<br>- [Z6II 1.70 Report](analysis/Z6_2_0170/REPORT.md) · [Z7II 1.70 Report](analysis/Z7_2_0170/REPORT.md) |
| **Model Reversing (0x260 Modern Prefix)** | Dynamic directory decoding, multi-model keystream consensus, and section recovery | - [ZR 1.11 Container Analysis & Decryption Report](analysis/ZR__0111/REPORT.md)<br>- [Z f 3.01 Differential Report](analysis/Z_f_0301/REPORT.md)<br>- [Z5 II 1.20 Partial Recovery Report](analysis/Z5_2_0120/REPORT.md)<br>- [Z50 II 1.11 Analysis Report](analysis/Z50_2_0111/REPORT.md)<br>- [Z6 III 2.00 Analysis Report](analysis/Z6_3_0200/REPORT.md) |
| **AI, DSP & Vision Pipeline** | Embedded CEVA DSP ELFs, serialized neural network candidates, subject detection | - [Cross-Model AI Comparison](analysis/ai_comparison/REPORT.md)<br>- [Z8 Host CPU & DSP Call Interface](analysis/z8_dsp_host/REPORT.md)<br>- [Subject Detection Property to Internal Settings](analysis/z8_sdk_subject/REPORT.md) |
| **Video & Sensor Pipelines** | Open Gate recording feasibility, sensor backend commands, and parameter regions | - [Z8 Open Gate Feasibility Study](analysis/z8_open_gate/REPORT.md)<br>- [N-RAW Resolution to Capture State Flow](analysis/z8_capture_state/REPORT.md)<br>- [CaptureSensor Backend Modes & Command Blocks](analysis/z8_sensor_backend/REPORT.md)<br>- [Parameter Loading & Resolution Translation](analysis/z8_sensor_inputs/REPORT.md)<br>- [EG Flash Updates & Sensor Parameter Area](analysis/z8_flash_layout/REPORT.md) |
| **Protocols, Diagnostics & UI** | Proprietary PTP RAM queries, NFDG diagnostic injection, setup menu extension, BVR gyro | - [EXPEED 7 Dual-OS Architecture & Subsystems Analysis](../../analysis/EXPEED7_architecture/expeed7_system_architecture.json)<br>- [Proprietary PTP Parameter Resource Query](analysis/z8_ptp_resources/REPORT.md)<br>- [Proprietary PTP f001 Handler Analysis](analysis/z8_ptp_f001/REPORT.md)<br>- [Z8 3.11 NFDG Diagnostic Hook Experiment](analysis/z8_diagnostic/REPORT.md)<br>- [Z8 3.11 P Diagnostic Page & UI Extension](analysis/z8_diagnostic_ui/REPORT.md)<br>- [Z8 UI Version Display Analysis](analysis/z8_ui_version/REPORT.md) |
| **Hardware Emulation (QEMU)** | AArch64 board-level emulation, multicore scheduling, and stock firmware boot | - [Z8 QEMU Build & Execution Guide](qemu/z8/README.md)<br>- [Z8 Stock Boot & RTOS Startup Report](analysis/z8_qemu_boot/REPORT.md)<br>- [z7-qemu Reference Analysis Report](analysis/z7_qemu_reference/REPORT.md) |
| **External Specifications** | Remote SDK 2.0.0 protocol documents and configuration indices | - [Remote SDK 2.0.0 Reference Index](references/remote-sdk-2.0.0/README.md)<br>- [Model-by-Model Protocol Specifications](references/remote-sdk-2.0.0/PROTOCOLS.md)<br>- [Configuration Reading Guide](references/remote-sdk-2.0.0/CONFIGURATION.md)<br>- [Subject Detection Reference Mapping](references/remote-sdk-2.0.0/SUBJECT_DETECTION.md) |

---

## Quick Reproduction Commands

> [!TIP]
> **Recommended runtime [`uv`](../../docs/PYTHON_UV_GUIDE.md)**: Run `uv sync` at the repository root to automatically install `capstone`, `pycryptodome`, and `unicorn` dependencies. All commands can be executed with `uv run python3 ...`.

```sh
cd "firmware decode/z-series"
uv run python3 tools/discover_z_history.py
uv run python3 tools/collect_all_z_history.py .
uv run python3 tools/compare_all_z_history.py .
```

To fetch current official download catalog entries only:

```sh
cd "firmware decode/z-series"
uv run python3 tools/collect_z_series.py . --through-year 2026 --download
uv run python3 tools/analyze_z_catalog.py .
```

---

## Directory Organization

- `tools/`: Python unpackers, analysis scripts, XOR table definitions, and unit tests.
- `analysis/<sample_or_topic>/`: Reports, manifests, disassembly excerpts, and generated artifacts.
- `*.bin`: Local raw firmware binaries.
- `references/`: Remote SDK documentation and configuration mappings.
- `qemu/z8/`: Custom board-level AArch64 QEMU emulation sources.

Raw firmware binaries, SDK archives, extracted rootfs trees, and QEMU build artifacts remain local and are excluded by `.gitignore`. Reports, manifests, and assembly excerpts are tracked in Git.

---

## Verified Offline Reverse Engineering Samples

| Sample | Sections | Major Highlights | Report |
| :--- | ---: | :--- | :--- |
| `Z_6_0380.bin` | 4 | ARM/Thumb, SMP T-Kernel, main image load base `0x10020000` | [Z6 Report](analysis/Z_6_0380/REPORT.md) |
| `Z_8_0311.bin` | 5 | AArch64, SOLID/TOPPERS, Linux 4.14.224, 3 CEVA DSP ELFs | [Z8 Report](analysis/Z_8_0311/REPORT.md) |
| `ZR__0111.bin` | Undecoded | Modern prefix; legacy XOR yields no valid header; algorithm under research | [ZR Report](analysis/ZR__0111/REPORT.md) |
| `Z_f_0301.bin` | Undecoded | 5 samples share fixed prefix & tables; Z f 1.21/3.01 ciphertext diff complete | [Z f Report](analysis/Z_f_0301/REPORT.md) |
| `Z5_2_0120.bin` | Partial | Two differential ELFs; reference-assisted recovery of 8,264,100-byte window | [Z5 II Report](analysis/Z5_2_0120/REPORT.md) |

All section CRCs, package CRCs, and byte-for-byte re-encoding match for Z6 and Z8. ZR and Z f containers remain under active research.
