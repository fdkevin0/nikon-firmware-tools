# Comprehensive Acquisition and Comparison of Public Nikon Z 8 Firmware Releases

Verification date: 2026-10-05. Scope: **All 8 public update releases (1.01, 2.00, 2.01, 2.10, 3.00, 3.01, 3.10, 3.11)**, totaling **771,494,600 bytes** of binary payload.
All 8 packages utilize legacy 3-table XOR packaging with origin `0x20`; **all 40 section CRCs, 8 package CRCs, and 8 re-encoding roundtrips passed successfully**.

**Factory release 1.00 represents a known gap**: documented in official changelogs, but no public binary updater was located.
Open-source code releases cannot substitute for compiled firmware payloads.
Version histories were cross-referenced against the [Nikon OSS Index](https://imaging.nikon.com/imaging/oss/en/) and the [Current Update History](https://downloadcenter.nikonimglib.com/en/download/fw/606.html).

## Key Discoveries

- **Version 2.00 represents the primary architectural milestone for DSP executables**: Image processing added 29 defined functions; tracking was restructured with modified function signatures; the neural inference ELF kept identical machine code sections, differing by only 9 bytes in its function dispatch table.
- **The three CEVA DSP ELFs are byte-for-byte identical across all seven releases from 2.00 through 3.11**. This reflects full container decodes rather than known-plaintext inferences.
- **Two candidate serialized networks (N1, N2) are identical across all eight releases**, including 1.01 prior to the addition of bird detection. They represent specific network payloads rather than the entirety of on-device AI models.
- **Version 3.00 updated the Linux kernel build and eight rootfs files**, though the banner string remained `4.14.224-ts-aarch64`, with kernel config and dual DTBs identical.
- **Linux components (kernel, rootfs, dual DTBs) are byte-for-byte identical across 3.00, 3.01, 3.10, and 3.11**. Minor LI section differences (4 bytes) reflect container version markers and section CRCs.
- Touch controller sections are identical across all 8 versions; VR changed only between 1.01 and 2.00.

Raw hashes, section offsets, module signatures, and diffs are cataloged in [manifest.json](manifest.json); download sources and HTTP metadata reside in [downloads.json](downloads.json).

## Scope, Provenance, and Integrity

| Version | Official Date | BIN Bytes | Raw SHA-256 (Prefix 12) | Retrieval Method |
| --- | --- | ---: | --- | --- |
| 1.00 | 2023-05-25 | — | — | Documented in OSS index; raw updater binary unobtained |
| 1.01 | 2023-08-23 | 86,319,173 | `a22e229f9dd1` | Static extraction from official Windows EXE wrapper |
| 2.00 | 2024-02-07 | 96,221,253 | `ab98e95fd9ff` | Direct download from official Nikon CDN |
| 2.01 | 2024-04-23 | 96,225,349 | `e6c529847f28` | Direct download from official Nikon CDN |
| 2.10 | 2025-02-26 | 96,524,357 | `73fcde0b7e57` | Direct download from official Nikon CDN |
| 3.00 | 2025-07-01 | 99,051,117 | `a2faa72d15f2` | Direct download from official Nikon CDN |
| 3.01 | 2025-07-16 | 99,051,117 | `1b3223023155` | Direct download from official Nikon CDN |
| 3.10 | 2025-09-17 | 99,051,117 | `34fc0317ede9` | Direct download from official Nikon CDN |
| 3.11 | 2026-09-16 | 99,051,117 | `d67413c2ede6` | Existing official sample, re-verified |

Dates reflect Nikon OSS index listings, matching official CDN `Last-Modified` timestamps. Full 64-character SHA-256 hashes are recorded in manifest files.

Deprecated download pages returning HTTP 404 were resolved via cached official pages and archive indexes; **all payload binaries originate directly from `download.nikonimglib.com`**. Discovery paths are documented in [SOURCES.md](SOURCES.md) and [discovery.json](discovery.json).

Release 1.01 was distributed as self-extracting archive `F-Z8-V101W.exe` (70,578,888 bytes), containing `Z8Update/Z_8_0101.bin` inside a RAR3 stream. It was extracted statically using archive libraries without executing the installer, matching internal RAR CRC32 `AE4E54EE`.

## Evolution Across the Five Firmware Sections

All eight releases contain five sections: EX, Touch, EG, VR, and LI, with valid continuous boundaries and CRCs. "Identical" denotes byte-for-byte equivalence including section CRCs.

| Adjacent Versions | EX | Touch | EG Main | VR | LI Container |
| --- | --- | --- | --- | --- | --- |
| 1.01 → 2.00 | Changed | Identical | Changed | Changed | Changed |
| 2.00 → 2.01 | Changed | Identical | Changed | Identical | 4-byte header diff only |
| 2.01 → 2.10 | Changed | Identical | Changed | Identical | Changed |
| 2.10 → 3.00 | Changed | Identical | Changed | Identical | Changed |
| 3.00 → 3.01 | Identical | Identical | Changed | Identical | 4-byte header diff only |
| 3.01 → 3.10 | Identical | Identical | Changed | Identical | 4-byte header diff only |
| 3.10 → 3.11 | Identical | Identical | Changed | Identical | 4-byte header diff only |

The EG executable expanded from 69,079,863 bytes in 1.01 to 78,979,895 bytes in 2.00, and 81,807,711 bytes in 3.00, remaining constant in size thereafter while varying in content. Across the corpus, EX has 5 variants, Touch has 1, EG has 8, VR has 2, and LI has 8.

## AI and DSP Architecture

### Version Grouping of the Three CEVA Executables

| Module Category | 1.01 | 2.00 / 2.01 / 2.10 / 3.00 / 3.01 / 3.10 / 3.11 |
| --- | --- | --- |
| Image Processing | 644,872 bytes; 532 defined functions; `93c839aef532...` | 692,516 bytes; 561 defined functions; `b3eebaa20c2a...` (Identical across 7 releases) |
| Tracking / Motion Analysis | 437,664 bytes; 337 defined functions; `440d3b1867f0...` | 456,004 bytes; 350 defined functions; `de9610259024...` (Identical across 7 releases) |
| Neural Inference | 5,750,024 bytes; 3,461 defined functions; `a38f6e96513e...` | 5,750,024 bytes; 3,461 defined functions; `c7787ceda602...` (Identical across 7 releases) |

Program roles are classified by defined symbol profiles. The 24 total CEVA instances deduplicate to 6 distinct binaries.

In 2.00, image processing added 29 functions (including `RefCmp`, `refcmp::Line_Ratio`, `refcmp::Init_LutGain`, `frect_calc_dist`, and runtime routines). Dispatch slot 21 shifted from NOP to `RefCmp`, with `NlgCirc` moving from slot 32 to 34.
Tracking added 22 functions and removed 9 older names, introducing `MovingDetector_SmoothImageNoDma`, `MedianFilter5x5`, and modified signatures for `Mvd_StepLmvX/Y` and `CreateLmvBgMap`.

### Neural Inference 9-Byte Difference Located in Dispatch Table

Between 1.01 and 2.00, the neural inference ELF is **identical across 5,750,015 bytes, differing by only 9 bytes**.
All `.text*` code sections, symbol tables, and program headers are identical; differences reside exclusively in `g_NikonDspFrameworkFunctionTable` within `.data.external`.

Located at virtual address `0x4221c808` (256 bytes, 64 32-bit pointers), differences map to file offsets `0x468e98` through `0x468ea9`:

| Slot (0-indexed) | Target in 1.01 | Target in 2.00+ |
| --- | --- | --- |
| 28 | `CCdnnNetwork_Initialize` | `nopFunction` |
| 29 | `CCdnnNetwork_Release` | `CCdnnNetwork_Initialize` |
| 30 | `CAnimalDetectionApi` | `CCdnnNetwork_Release` |
| 31 | `CVehicleDetectionApi` | `CAnimalDetectionApi` |
| 32 | `nopFunction` | `CVehicleDetectionApi` |

This remapping indicates dispatch index realignments between the host processor and DSP.

### Invariant Network Candidates Across All Eight Versions

Both candidate networks N1 and N2 are present in all eight Z 8 EG sections:

| Candidate | Size (Bytes) | SHA-256 |
| --- | ---: | --- |
| N1 | 1,042,864 | `1a14b38f7905898d4de87f477d7ec945f4cbcbdcd28482640f16cffc3e156a76` |
| N2 | 1,083,248 | `418f21fae72c525a7d9b598f0375b520464daeabda8018696e1db69405bb2541` |

Both candidates carry `XM6NeuPro`, `Darkent2Caffe`, `UserInputBuffer`, and convolution/pooling/route layer names.
Nikon introduced dedicated bird detection and auto-capture in version 2.00. Binary analysis indicates **these additions cannot be explained by payload replacements in N1/N2 or machine code modifications in the inference ELF**. New functionality relies on host ARM processing, tracking algorithms, or auxiliary configuration data. See [Nikon 2.00 Press Release](https://www.nikon.com/company/news/2024/0207_firmware_01/).

## Linux Operating System Evolution

All releases report the `4.14.224-ts-aarch64` banner, but contain two distinct kernel binaries:

| Version Range | Kernel Build Date String | Kernel SHA-256 (Prefix 12) |
| --- | --- | --- |
| 1.01 to 2.10 | 2023-03-10 | `948ed21b875a` |
| 3.00 to 3.11 | 2024-12-23 | `6fe644e96fcf` |

Kernel configurations and dual DTBs are identical across all eight releases. CPIO archives contain 820 entries across identical path sets:

| Adjacent Versions | Modified Rootfs Entries |
| --- | --- |
| 1.01 → 2.00 | Six Nikon executables: `LaFtpClient`, `LaIfCtrl`, `LaLiveView`, `LaMainApp`, `LaNetCameraCtrl`, `LaSyncRelease` |
| 2.00 → 2.01 | None; compressed rootfs identical |
| 2.01 → 2.10 | `LaFtpClient`, `LaIfCtrl` |
| 2.10 → 3.00 | The six Nikon executables above, plus `bin/busybox` and `usr/lib/libcrypto.so.1.1` |
| 3.00 → 3.01 → 3.10 → 3.11 | None; kernel, rootfs, and dual DTBs identical |

`LaMainApp` exists in three version groups: 1.01; 2.00–2.10; and 3.00–3.11.

## Reproducible Artifacts and Verification

Execute from `firmware decode/z-series`:

```sh
# Fetch recorded links and extract statically.
uv run python tools/collect_z8_history.py .

# Unpack, verify checksums, extract components, and run adjacent comparisons.
uv run python tools/compare_z8_history.py .
uv run pytest
```

Artifacts generated:

- [discovery.json](discovery.json), [SOURCES.md](SOURCES.md): Version catalog and retrieval provenance.
- [downloads.json](downloads.json): URLs, HTTP headers, content lengths, SHA-256 hashes, and RAR CRC32 checksums.
- [manifest.json](manifest.json): Section layouts, DSP ELFs, network candidates, Linux metadata, and adjacent diffs.
- `analysis/Z_8_<VERSION>/`: Unpacked legacy sections, strings, and checksum manifests.
- `versions/`: Per-version CEVA ELFs, symbol tables, Linux kernel images, DTBs, and root filesystems.
- `modules/`, `networks/`: Deduplicated DSP executables and serialized network candidates.
- `diffs/`: Textual diffs of DTBs and kernel configs (all empty, matching hash identity).

All 24 CEVA ELF instances pass `readelf` verification; all 34 automated unit tests pass.
