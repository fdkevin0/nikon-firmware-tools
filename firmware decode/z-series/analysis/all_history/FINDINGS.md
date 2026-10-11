# Z-Series Historical Firmware: Key Comparative Findings

Analysis date: 2026-10-05. Scope: **15 camera bodies, 148 acquired official firmware packages, 8,785,277,014 bytes (8.79 GB)**.
Completed 133 adjacent release comparisons within identical models. See [All Versions & Section Differences](REPORT.md), [Download Sources & Checksums](downloads.json), and [Detailed Machine-Readable Manifest](manifest.json).

## Coverage & Gaps

| Metric | Result |
|---|---:|
| Known model/version records in official history | 164 |
| Acquired and analyzed in this study | 148 |
| Fully decoded with package CRC, section CRC, and re-encoding roundtrip | 123 packages, 523 sections |
| Modern packaging with reference-assisted local recovery | 25 packages |
| Extracted full CEVA DSP ELFs | 106 instances, 15 distinct binaries |
| Fully covered serialized network candidates | 2 distinct contents, each identical across 47 versions |
| Cataloged packages remaining unobtained | 16 records |

The 16 missing items comprise **14 launch-day 1.00 factory releases, ZR initial release 1.01, and Z6III 1.01**. The first 15 may never have been distributed as public updaters; Z6III 1.01 is cataloged in official changelogs, but no public binary download was located during this crawl. This corpus represents all currently discoverable public releases, not every release ever compiled. See [Sources Survey](SOURCES.md).

All binaries originate from official Nikon CDN servers; legacy self-extracting EXE files were extracted statically without executing installers. Two early packages contained `Z6_2_0110_01.bin` and `Z7_2_0110_01.bin`, preserving original revision filenames. Raw BIN files and extracted payloads were never flashed to hardware.

## Packaging Formats Did Not Switch Within Acquired Model Histories

| Packaging Format | Models & Verified Release Ranges |
|---|---|
| Legacy 3-table XOR, fully validated | Z30 1.10–1.20; Z5 1.01–1.50; Z50 1.10–2.60; Z6 1.01–3.80; Z6II 1.01–1.70; Z7 1.01–3.80; Z7II 1.01–1.70; Z8 1.01–3.11; Z9 1.10–5.32; Zfc 1.10–1.81 |
| Extended `0x260` header, modern container | Z f 1.10–3.01; Z50II 1.01–1.11; Z5II 1.01–1.20; Z6III 1.02–2.00; ZR 1.10–1.11 |

Ranges represent discrete acquired versions; see the master report for full lists. **All acquired Z f releases (1.10, 1.20, 1.21, 2.00, 2.01, 2.02, 3.00, 3.01) are verified to use modern packaging**, filling previous gaps in intermediate versions. Because version 1.00 remains unobtained, the verified boundary remains "at least since 1.10".

Across all 25 modern container samples, the 32-byte fixed header, 128-entry table, and reverse header regions are identical. Each matches the known neural inference ELF within the established position mask window `[0x16c20bc, 0x1ea95b8)` (8,287,484 bytes). **This does not represent a full decryption of modern containers**; section directories and package CRCs remain undecoded.

## AI: Long-Term Network Stability vs Evolving DSP Executables

Two candidate serialized networks, designated N1 and N2, measure 1,042,864 and 1,083,248 bytes, featuring strings such as `XM6NeuPro`, `Darkent2Caffe`, `UserInputBuffer`, and convolution layer names.

| Model | Versions with Complete and Pairwise-Identical Candidates |
|---|---|
| Z 8 | All 8 acquired versions, 1.01–3.11 |
| Z 9 | All 17 acquired versions, 1.10–5.32 |
| Z f | All 8 acquired versions, 1.10–3.01 |
| Z50II | All 6 acquired versions, 1.01–1.11 |
| Z5II | All 5 acquired versions, 1.01–1.20 |
| Z6III | 1.02, 1.10, 1.11 |

Full SHA-256 hashes:

- N1: `1a14b38f7905898d4de87f477d7ec945f4cbcbdcd28482640f16cffc3e156a76`
- N2: `418f21fae72c525a7d9b598f0375b520464daeabda8018696e1db69405bb2541`

In modern containers, these payloads reside outside the known reference ELF, confirming they are genuine recoveries rather than injected references. In Z6III 2.00, only the first 450,484 bytes of N1 fall within the recovery window, matching the N1 prefix; remaining content and N2 have shifted outside the window. Both candidates also fall outside the recovery window in ZR 1.10 and 1.11. **Window truncation does not imply model removal.**

Because proprietary CDNN layer structures, classes, and operators have not been reverse-engineered, candidate identity does not imply identical AI algorithms, detection accuracy, or camera feature states.

### Z 9 DSP Version Milestones

Modules A, B, and C correspond to image processing, tracking, and neural inference based on symbol profiles (not official vendor names). Fingerprints represent the first 12 characters of full SHA-256 hashes.

| Z 9 Version | A: Image Processing | B: Tracking | C: Neural Inference |
|---|---|---|---|
| 1.10, 1.11 | `578259dd83b1` | `0a4134aecee6` | `322f7dcbd65f` |
| 2.00, 2.10, 2.11 | `580a39503ac7` | `1bc15b1ba640` | `e9436f6fe7e2` |
| 3.00, 3.01, 3.10 | `580a39503ac7` | `440d3b1867f0` | `a38f6e96513e` |
| 4.00, 4.01, 4.10, 5.00, 5.10, 5.20 | `b3eebaa20c2a` | `de9610259024` | `c7787ceda602` |
| 5.30, 5.31, 5.32 | `b3eebaa20c2a` | `dd2e0e44d1cf` | `c7787ceda602` |

Confirmed code transitions:

- **1.11 → 2.00**: All three DSP modules changed. The neural inference ELF removed 36 defined functions (including scheduler calls like `vTaskStartScheduler` and `xTaskGenericCreate`) while adding `NikonTask_SetRequest` and `NikonTask_NonOsWorker`. This reflects internal execution framework changes, not a full operating system swap.
- **2.11 → 3.00**: The neural inference ELF differs by **only 9 bytes**; all `.text*` machine code sections and defined function names are identical, with differences confined to function dispatch table slot mappings. Tracking code contains functional changes.
- **3.10 → 4.00**: The neural inference ELF again differs by **only 9 bytes**, representing dispatch table slot remappings; image processing and tracking programs underwent machine code updates.
- **5.20 → 5.30**: Tracking added 5 defined functions belonging to the `CCvPeaking` family (Execute, LowPass, HiPassFilt, MovingSum, MovingSumRoi); image processing and neural inference ELFs remained unchanged.

Consequently, **the machine code of the neural inference module in Z 9 remained identical from 2.00 to 5.32**, across three minor dispatch-table revisions. Serialized network candidates N1 and N2 remained byte-identical from 1.10 onward. New subject detection features reflect updates in main host processor code, tracking logic, or preprocessing pipelines rather than a simple hidden toggle.

### Z 8 and Newer Models

In Z 8, all three DSPs changed from 1.01 to 2.00, and remained completely identical from 2.00 through 3.11. The post-2.00 ELFs match those in Z 9 4.00–5.20 exactly. Detailed dispatch table shifts are documented in the [Z 8 Report](../z8_history/REPORT.md).

Acquired releases of Z f, Z50II, and Z5II share the same Class C reference within the recovery window; modules A and B fall outside this window in those models. Z6III 2.00 and ZR 1.10/1.11 recover complete A and B modules. Across both ZR releases, all three DSPs are identical; additional image processing functions in ZR are detailed in [Cross-Model AI Comparison](../ai_comparison/REPORT.md).

## Linux: Z 9 Milestones at 5.00 and 5.30

All acquired releases of Z 8 and Z 9 report the `4.14.224-ts-aarch64` kernel banner string, but kernel binaries vary across build dates and compiler configurations.

| Model & Update | Observed Changes |
|---|---|
| Z 8 2.10 → 3.00 | Kernel binary changed; 8 rootfs entries modified |
| Z 8 (All 8 Releases) | Kernel configuration and dual DTBs identical; NISI payloads identical across 3.00–3.11 |
| Z 9 1.11 → 2.00 | Kernel changed; DTB count reduced from 3 to 2; rootfs added 1 entry, modified 34 |
| Z 9 2.11 → 3.00 | Kernel changed; rootfs added 11 entries, modified 19 |
| Z 9 4.10 → 5.00 | Kernel changed; rootfs added 632 entries, deleted 17, modified 67 |
| Z 9 5.00 → 5.10 | Kernel unchanged; 48 rootfs entries modified, focused on web control CGI/JS |
| Z 9 5.20 → 5.30 | Kernel changed; added 71 entries, modified 36, including D-Bus, Avahi, and networking tools |
| Z 9 (All 17 Releases) | Extracted kernel configs identical; dual DTBs identical from 2.00 onward |

Rootfs diffs evaluate content, type, permissions, symlink targets, and device IDs (ignoring build timestamps and inode numbers). Entry counts include directories and symlinks.

Z 9 5.00 introduced web-control components including `home/htdocs`, `home/htdocs/cgi`, and `usr/bin/LaHttpServer`, modified further in 5.10. Outer section containers in Z 9 also varied: 1.10–2.00 contained `_gnt00_0007.bin`; 2.10–4.10 omitted this section; 5.00 introduced `_gst00_0017.bin`.

## Legacy and Dual-Processor Bodies

Touch controller sections remained identical across all acquired versions for each of the 10 legacy-format models. EG main executable sections varied in every release; EX and VR sections changed intermittently.

Z 6II and Z 7II carry dual `eg..._mas_...` and `eg..._sla_...` executables. Each model includes 12 acquired versions, representing 12 distinct builds per processor. They were tracked as separate execution paths.

First-generation bodies (Z 30, Z 5, Z 50, Z 6, Z 6II, Z 7, Z 7II, Z fc) did not yield CEVA DSP ELFs under the current extraction pipeline; this reflects architecture differences rather than an absence of face/eye detection or machine-learning capabilities, which reside in ARM/Thumb binaries.

## Verification

All 148 raw binaries match documented sizes and SHA-256 hashes; 523 section outputs, 25 recovery windows, and 15 unique DSP ELFs were verified. All DSP ELFs pass `readelf -h -l -S -s` validation with zero errors. 37 automated tests pass.

Reproducible tool pipelines are detailed in the [Master Report](REPORT.md).
