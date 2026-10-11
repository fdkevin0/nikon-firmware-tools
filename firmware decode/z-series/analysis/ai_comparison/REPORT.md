# Comparative Analysis of AI and DSP Modules Across Nikon Z-Series Firmware

Subsequent [comprehensive historical comparison](../all_history/FINDINGS.md) covers 148 firmware packages and completes all eight Z f update releases; this page preserves the comparative snapshot across the earlier 17-sample baseline.

Analysis date: 2026-10-05. Scope: Current releases for all 15 catalog bodies plus historical Z f 1.10 and 1.21 (17 samples total).
This phase incorporated the raw official package for Z f 1.10; for retrieval provenance and container timeline analysis, see the [Packaging History Survey](../catalog/ZF_PACKAGING_HISTORY.md).
Comparisons evaluate concrete byte sequences, ELF sections, and symbol tables without assuming binary identity from camera specifications.

## Key Conclusions

1. Extracted CEVA DSP binaries partition into three functional groups based on symbol profiles: **Image Processing, Object Tracking, and Neural Inference**. Not all DSP executables are AI models. The analysis identifies 6 unique full CEVA binaries across the corpus.
2. The neural inference ELF in Z 8 3.11 and Z 9 5.32 is identical. Modern container samples match this reference within their recovery window, though their recovery relies on known-plaintext anchors.
3. Outside the inference ELF, two **serialized network candidate payloads** carrying `XM6NeuPro`, `Darkent2Caffe`, and convolution layer names were recovered. In Z 8, Z 9, Z50II, Z5II, and Z f (1.10, 1.21, 3.01), both candidates are byte-for-byte identical. They reside outside the known reference ELF and represent genuine extracted payloads.
4. Identifiable software deltas exist: Z 9 tracking includes focus peaking functions; ZR image processing contains dehazing and color-space conversion routines. These differences do not indicate relative performance or accuracy between models.
5. **The Z f has utilized modern packaging at least since its first public update 1.10 (2023-11-16).** Without a 1.00 updater binary, it cannot be asserted that the transition occurred at 1.10, nor can packaging changes be attributed to later 2.00 cloud features or bird detection.

All findings are cross-verifiable via the [machine-readable manifest](manifest.json), documenting sample hashes, module hashes, offsets, section sizes, symbol sets, and data boundaries.

## Evidence Hierarchy and Scope

- **Direct Extraction from Legacy Packaging**: 10 firmware packages (including Z 8 and Z 9) passed section/package CRC verification and bit-for-bit re-encoding.
- **Reference-Assisted Recovery from Modern Packaging**: Evaluated within the established position mask window `[0x16c20bc, 0x1ea95b8)` (8,287,484 bytes). All 7 modern format samples match the known reference ELF in this window. Full container decoding and container CRC verification remain unresolved.
- **Reference Constraints**: The third CEVA ELF served as the known-plaintext anchor for mask derivation; matching results for this module do not constitute independent discoveries. The Z f 1.10 sample did not contribute to initial mask generation and serves as an independent validation sample.
- **Payloads Beyond Reference**: Modules A and B in Z6III / ZR and serialized network candidates across all models originate from identical absolute positions in the recovered stream rather than pre-seeded templates.
- **Z5II Modules A and B**: Reconstructed via dual-ciphertext differential recovery, as detailed in the [Z5II Report](../Z5_2_0120/REPORT.md).

No parseable CEVA DSP ELFs were detected in Z 30, Z 5, Z 50, Z 6, Z 6II, Z 7, Z 7II, or Z fc.
Their EG executables retain the string `FaceDetectServic` (present in both EG binaries of Z 6II / Z 7II).
The absence of CEVA DSP ELFs in these models indicates architectural differences rather than an absence of face/eye detection or neural network algorithms.

## Tri-Modular Program Taxonomy and Cross-Model Matrix

Labels A, B, and C represent taxonomy categories defined in this report, not official vendor designations. Identical labels denote identical full SHA-256 hashes.

| Model / Firmware | A: Image Processing | B: Tracking & Vision | C: Neural Inference |
| --- | --- | --- | --- |
| Z 8 3.11 | A1 | B1 | C1 (Direct extraction) |
| Z 9 5.32 | A1 | B2 | C1 (Direct extraction) |
| Z5II 1.20 | A2 (Differential candidate) | B1 (Differential candidate) | C1 (Reference-assisted) |
| Z6III 2.00 | A2 (Window recovery) | B1 (Window recovery) | C1 (Reference-assisted) |
| ZR 1.11 | A3 (Window recovery) | B1 (Window recovery) | C1 (Reference-assisted) |
| Z50II 1.11 | Truncated by window | Truncated by window | C1 (Reference-assisted) |
| Z f 1.10 / 1.21 / 3.01 | Truncated by window | Truncated by window | C1 (Reference-assisted) |

| Label | ELF Bytes | `.text` Bytes | Unique Defined Functions | SHA-256 (Prefix 12) |
| --- | ---:| ---:| ---:| --- |
| A1 | 692,516 | 320,416 | 561 | `b3eebaa20c2a` |
| A2 | 691,804 | 319,424 | 561 | `6b89673f8596` |
| A3 | 896,508 | 504,896 | 638 | `195228548d5f` |
| B1 | 456,004 | 283,264 | 350 | `de9610259024` |
| B2 | 473,348 | 296,288 | 355 | `dd2e0e44d1cf` |
| C1 | 5,750,024 | 4,263,456 | 3,461 | `c7787ceda602` |

Function counts include C++ templates and runtime helpers; `.text` size does not represent neural network parameter count.

### Category A: Image Processing Deltas

A1, A2, and A3 all define `HdrComposition` and `ImageComposition`.
A1 is deployed in Z 8 / Z 9; A2 in recovered Z5II / Z6III. A1 and A2 differ in two function signatures relating to `refcmp::Line_Ratio` and `Init_LutGain` vs `Init_LutGain2`.
While symbol profiles are closely aligned, machine code section hashes differ.

In ZR, executable A3 adds 77 defined functions relative to A2 (retaining all A2 symbols), introducing `HazeRemoval`, `HazeRemoval_DSP`, `ConvertLabToRGB`, `ConvertYUV420toRGBCore`, and `vnloglut_line`. Its `.text` section is 184,480 bytes larger than A1.

### Category B: Focus Peaking Extensions in Z 9 Tracking

B1 contains `CskTracking`, `KLTTrack_runTracking`, `MovingDetector`, and RANSAC routines, classifying it as tracking/motion analysis.
Z 9 module B2 preserves all 350 symbols from B1 and adds five peaking functions:

```text
CCvPeaking_Execute
CCvPeaking_LowPass
CCvPeaking_HiPassFilt
CCvPeaking_MovingSum
CCvPeaking_MovingSumRoi
```

B2 expands `.text` by 13,024 bytes. This confirms the presence of focus-peaking routines in this DSP module in Z 9, but does not imply that Z 8 lacks focus peaking (which may be implemented in other subsystems).

### Category C: Shared Neural Inference Architecture

C1 defines `CAnimalDetectionApi`, `CVehicleDetectionApi`, associated initialization/postprocessing routines, CDNN, XM6, NeuPro, convolution, pooling, quantization, and NMS routines.
CEVA documentation describes CDNN as a software framework interfacing XM6, NeuPro, and custom neural processing units; this contextualizes naming conventions without determining specific hardware NPU clock rates or TOPS ratings. See [CEVA CDNN / XM6 / NeuPro Architecture](https://www.ceva-ip.com/press/ceva-introduces-new-ai-inference-processor-architecture-for-edge-devices-with-co-processing-support-for-custom-neural-network-engines/).

## Beyond the Inference Executable: Serialized Network Candidates

Adjacent to C1 in memory lie two candidate serialized network payloads:

| Metric | Candidate N1 | Candidate N2 |
| --- | --- | --- |
| File Size (under boundary hypothesis) | 1,042,864 bytes | 1,083,248 bytes |
| Header Length Fields | `0x30c0`, `0xfb8b0` | `0x3380`, `0x1053b0` |
| Full SHA-256 | `1a14b38f7905898d4de87f477d7ec945f4cbcbdcd28482640f16cffc3e156a76` | `418f21fae72c525a7d9b598f0375b520464daeabda8018696e1db69405bb2541` |
| Representative Layer Names | `layer19-conv` | `layer19-actlayer19-conv`, `layer20-conv` |

Both candidates contain `XM6NeuPro`, `Darkent2Caffe`, `UserInputBuffer`, `layer*-conv`, `layer*-maxpool`, and `layer15-route`.
Candidate boundaries start at byte pattern `09 00 00 00 58 4d 36 4e 65 75 50 72 6f 00`, reading little-endian u32 fields at `+0x40` and `+0x44` to compute length as `0x40 + A + B`.
N1 terminates immediately before the header of N2; N2 terminates immediately before structure `ef be ad de ... DSPRMFL`.

| Sample | N1 Absolute Offset | N2 Absolute Offset | Result |
| --- | --- | --- | --- |
| Z 8 3.11 | EG `0x1bb0e30` | EG `0x1caf7e0` | Full reference match |
| Z 9 5.32 | EG `0x1b6ef40` | EG `0x1c6d8f0` | Full pairwise match |
| Z50II 1.11 | Raw `0x1c3ddcc` | Raw `0x1d3c77c` | Full pairwise match |
| Z5II 1.20 | Raw `0x1c43924` | Raw `0x1d422d4` | Full pairwise match |
| Z f 1.10 | Raw `0x1c435e4` | Raw `0x1d41f94` | Full pairwise match |
| Z f 1.21 | Raw `0x1c43614` | Raw `0x1d41fc4` | Full pairwise match |
| Z f 3.01 | Raw `0x1c7a0b4` | Raw `0x1d78a64` | Full pairwise match |
| Z6III 2.00 | Raw `0x1e3b604` | Beyond window | First 450,484 bytes of N1 recovered (prefix match) |
| ZR 1.11 | Beyond window | Beyond window | Outside current recovery window |

The Z f comparison spans major updates where dedicated bird detection was introduced:

| Model | Official Introduction of Dedicated Bird Option | Official Release Date |
| --- | --- | --- |
| Z 9 | Version 4.10 | 2023-10-04 |
| Z 8 | Version 2.00 | 2024-02-07 |
| Z f | Version 2.00 | 2025-04-08 |
| Z6III | Version 2.00 | 2025-08-27 |

Sources: [Z 9 Announcement](https://www.nikonusa.com/press-room/z9-firmware-4-10), [Z 8 Announcement](https://www.nikon.com/company/news/2024/0207_firmware_01/), [Z f Announcement](https://www.nikonusa.com/press-room/zf-fw-2-point-0), [Z6III Announcement](https://www.nikon.com/company/news/2025/0827_imaging_01/).

**Binary comparison excludes the hypothesis that functional differences between Z f 1.10/1.21 and 3.01 stem from payload changes in C1, N1, or N2.**
Functional divergence may originate from auxiliary models, host mode selection, threshold parameters, preprocessing, or tracking logic.

## Temporal Boundaries of Modern Packaging in Z f

Acquisition of the raw 1.10 package (`Z_f_0110_01.bin`, 90,124,933 bytes, SHA-256 `89aeb3bfb4110f21a1a0ee05244296da52824208d916dc2b53b90202e693a03d`) demonstrates identical framing across the initial 32 bytes, `0x120:0x220` table, `0x220:0x240` reverse header, `0x260:0x280` whitespace padding, and `0x280:0x290` candidate directory header compared to 1.21 and 3.01.
This shifts the verified baseline to **1.10 (2023-11-16)**. Full analysis is available in the [Z f Packaging Report](../catalog/ZF_PACKAGING_HISTORY.md).

## Reproduction

Execute from `firmware decode/z-series`:

```sh
uv run python tools/compare_ai_modules.py .
uv run pytest
```

Artifacts generated:

- `manifest.json`: Scan coverage, module hashes, section hashes, symbol diffs, and network boundaries.
- `modules/`: Deduplicated CEVA DSP ELFs and symbol CSVs.
- `network_candidates/`: Deduplicated candidate serialized network payloads.
