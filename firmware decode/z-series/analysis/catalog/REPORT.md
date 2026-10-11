# Nikon Z-Series Firmware Corpus and Batch Analysis

This phase has acquired the **current publicly available firmware for all 15 Z-series camera bodies in Nikon's official product catalog**.
Combined with previously archived Z f 1.21, the dataset comprises **16 firmware samples totaling 1,155,141,671 bytes (~1.16 GB)**.
Among them, 10 legacy-format firmware images are fully decoded, with **all 42 section CRCs, 10 package CRCs, and 10 bit-for-bit re-encoding roundtrips verified**;
the remaining 6 modern container format samples have undergone structural analysis and local reference-assisted recovery, but cannot yet be fully re-encoded or flashed.

Subsequent AI comparative studies separately acquired Z f 1.10 and later completed all eight public update releases of the Z 8, bringing the working sample set to 24 at that stage. Subsequent [comprehensive historical acquisition](../all_history/REPORT.md) expanded this to 148 releases.
This report and its manifests preserve the findings from this 16-sample baseline.
For expanded samples, AI modules, and serialized network data comparisons, see the [subsequent comparison report](../ai_comparison/REPORT.md).
The earliest verified occurrence of the modern Z f container has been traced to 1.10 in the [version survey](ZF_PACKAGING_HISTORY.md);
per-version analysis of the Z 8 is detailed in the [historical firmware report](../z8_history/REPORT.md).

Full model coverage in this catalog phase does not imply that every historical release has been downloaded. Official change logs reference 164 model/version combinations, of which 16 were locally held in this batch; the remaining 148 had no corresponding active download links on the queried official pages.
Some of these records correspond to factory-installed versions never made available for standalone download and cannot be categorized simply as deprecated links.

## Sources, Scope, and Download Status

Model targets were extracted from Nikon's [official product XML](https://downloadcenter.nikonimglib.com/en/1/product_data.xml), covering Z-series mirrorless bodies and the separately classified ZR, while excluding NIKKOR Z lenses, teleconverters, and accessories.
Product and download pages were crawled sequentially, following official `crossgate.nikonimglib.com` redirects to the Nikon download CDN.
Final URLs, content lengths, HTTP metadata, and local SHA-256 hashes were recorded; because Nikon servers do not provide standalone authoritative SHA-256 signatures, local hashes establish sample provenance without purporting to represent official signature verification.

Annual update indexes from [2018](https://downloadcenter.nikonimglib.com/en/update/index/2018.html) through [2026](https://downloadcenter.nikonimglib.com/en/update/index/2026.html) were scanned.
A total of 15 current Z-body firmware links were located in active HTML, matching active versions on product pages; page "More" buttons expand embedded HTML without hidden paginated requests.
The earlier Z f 1.21 download page returned HTTP 404 during this crawl; the previously archived raw binary is retained.

- [Download Manifest & Official Sources](manifest.json): 15 catalog products, download pages, final URLs, file hashes, index history, and error states.
- [Historical Version Coverage Matrix](history_coverage.csv): Itemized accounting of current downloads, retained legacy files, and changelog-only versions.
- [Batch Analysis Manifest](deep_manifest.json): Checksum validations, section layouts, Linux components, ELF structures, and local mask evidence.

## Per-Model Results for Current Public Releases

| Model | Version | Packaging | Result | Local Report |
| --- | --- | --- | --- | --- |
| Z 30 | 1.20 | Legacy XOR, marker `0x20` | 3 sections, all checksums passed | [Report](../Z_30_0120/REPORT.md) |
| Z 5 | 1.50 | Legacy XOR, marker `0x20` | 4 sections, all checksums passed | [Report](../Z_5_0150/REPORT.md) |
| Z 50 | 2.60 | Legacy XOR, marker `0x20` | 3 sections, all checksums passed | [Report](../Z_50_0260/REPORT.md) |
| Z 6 | 3.80 | Legacy XOR, marker `0x20` | 4 sections, all checksums passed | [Report](../Z_6_0380/REPORT.md) |
| Z 6II | 1.70 | Legacy XOR, marker `0x20` | 5 sections, all checksums passed | [Report](../Z6_2_0170/REPORT.md) |
| Z 7 | 3.80 | Legacy XOR, marker `0x20` | 4 sections, all checksums passed | [Report](../Z_7_0380/REPORT.md) |
| Z 7II | 1.70 | Legacy XOR, marker `0x20` | 5 sections, all checksums passed | [Report](../Z7_2_0170/REPORT.md) |
| Z 8 | 3.11 | Legacy XOR, marker `0x20` | 5 sections, all checksums passed | [Report](../Z_8_0311/REPORT.md) |
| Z 9 | 5.32 | Legacy XOR, marker `0x20` | 6 sections, all checksums passed | [Report](../Z_9_0532/REPORT.md) |
| Z fc | 1.81 | Legacy XOR, marker `0x20` | 3 sections, all checksums passed | [Report](../Z_fc_0181/REPORT.md) |
| Z f | 3.01 | Modern container, marker `0x260` | Local reference-assisted recovery; full container undecoded | [Report](../Z_f_0301/REPORT.md) |
| Z50II | 1.11 | Modern container, marker `0x260` | Common mask validated on new sample; full container undecoded | [Report](../Z50_2_0111/REPORT.md) |
| Z5II | 1.20 | Modern container, marker `0x260` | Local reference-assisted recovery; full container undecoded | [Report](../Z5_2_0120/REPORT.md) |
| Z6III | 2.00 | Modern container, marker `0x260` | 3 parseable ELFs in recovery window; full container undecoded | [Batch Manifest](../Z6_3_0200/survey/manifest.json) |
| ZR | 1.11 | Modern container, marker `0x260` | 3 parseable ELFs in recovery window; full container undecoded | [Batch Manifest](../ZR__0111/survey/manifest.json) |

The separately preserved Z f 1.21 is likewise a modern container sample, included in cross-validation of the local mask.
Earlier single-model reports record findings from their respective analysis sessions; the cross-model comparative findings here and in the batch manifests supersede earlier single-model snapshots.

## Key Discoveries in the Decodable Group

The EG main executable sections of Z 30, Z 5, Z 50, Z 6, Z 6II, Z 7, Z 7II, and Z fc all feature the `SMP T-Kernel` operating system identifier.
Z 6II and Z 7II each contain two EG images labeled `mas` (master) and `sla` (slave), both carrying this identifier; this architecture represents dual T-Kernel execution cores rather than a single primary image coupled with a Linux container.

Z 8 and Z 9 contain SOLID OS identifiers, three embedded CEVA DSP ELFs, and an independent `NISI` Linux payload section.
Z 9 contains six sections: EX, Touch, EG, VR, `_gst00_0017.bin`, and Linux.
No specific processor or subsystem role is assigned to `_gst00_0017.bin` purely on the basis of its filename.

| Item | Z 8 3.11 | Z 9 5.32 |
| --- | --- | --- |
| Linux Kernel Banner | `4.14.224-ts-aarch64` | `4.14.224-ts-aarch64` |
| Kernel Build Timestamp String | 2024-12-23 | 2025-07-16 |
| CPIO Archive Entries | 820 | 1,505 |
| LaMainApp | ELF64, AArch64 | ELF64, AArch64 |
| Embedded CEVA DSP ELFs | 3 | 3 |

The primary user-space application `/usr/bin/LaMainApp` is byte-for-byte identical between Z 8 3.11 and Z 9 5.32, with matching SHA-256:
`d9abc0aac413318fbf0076347b160414779e424987f9d68b26c1c8cb0ba61428`.
Their third CEVA DSP ELF is also identical, serving as the known plaintext anchor used for local recovery of modern containers.
Gzip streams, CPIO archives, and dual Device Tree Blobs in the Linux sections passed structural validation; extracted root filesystems write regular files only, while symlinks and device nodes are cataloged as metadata rather than constructed into a bootable host filesystem.

Direct byte searches across all sections of the 10 decoded legacy firmware images revealed neither the full 32-byte fixed header nor the 256-byte u16 table found in modern containers.
This literal search does not exclude the possibility that these constants are generated, permuted, or indirectly stored.

## Cross-Model Local Recovery of the Modern Container Format

This phase leveraged the position-dependent mask derived from earlier Z5 II analysis as a baseline, using a 64-byte unique reference snippet to locate the CEVA module in new samples.
Candidate positions require byte-for-byte consistency across a large overlapping mask window; sharing a fixed header or containing printable strings alone is insufficient.

| Sample | Third CEVA ELF Raw Offset | Overlapping Identical Bytes with Baseline |
| --- | --- | ---: |
| Z50II 1.11 | `0x16c20bc` | 5,726,640 |
| Z f 1.21 | `0x16c7904` | 5,749,240 |
| Z5II 1.20 | `0x16c7c14` | 5,750,024 |
| Z f 3.01 | `0x16fe3a4` | 5,750,024 |
| Z6III 2.00 | `0x18bf8f4` | 5,750,024 |
| ZR 1.11 | `0x192d8b0` | 5,750,024 |

Across the 6 derived masks, **all 15 pairwise overlapping regions exhibit zero discrepancy**, merging into a unified window:

```text
Raw File Offset Range: [0x16c20bc, 0x1ea95b8)
Length: 8,287,484 bytes (an expansion of 23,384 bytes over the previous run)
```

The shared position mask is archived in `analysis/catalog/shared_position_mask.bin`.
Each of the 6 firmware samples has its recovered window, offset-indexed strings, and extracted ELFs in `analysis/<SAMPLE_DIR>/survey/`.
A total of 10 structurally valid ELF instances were exported, containing duplicate modules; the instance count should not be conflated with 10 distinct programs.

Z50 II and the earlier Z f sample represent newly added mask validation targets. These results confirm that all 6 samples reuse a position-dependent XOR keystream within this window, but do not reconstruct the global keystream generator or cryptographic key. The reference module itself constitutes an injected known-plaintext anchor rather than an independently discovered payload; outer boundaries rely on reference consistency assumptions, and none of the modern format samples have passed full-package CRC verification.

## Reproduction and Generated Artifacts

Execute from `firmware decode/z-series`:

```sh
# Fetch active firmware from product catalog and annual indexes (static download only).
uv run python tools/collect_z_series.py . --through-year 2026 --download

# Unpack, verify, inspect nested structures, and perform mask validation/extension.
uv run python tools/analyze_z_catalog.py .
uv run pytest
```

Metadata pages are cached in `analysis/catalog/pages/`; repeated runs reuse cached HTML.
To perform clean discovery against Nikon's servers, relocate or delete the cache directory before running the collection tool.
Existing binary files are not overwritten; length mismatches trigger errors.
New downloads stream to temporary files and are promoted to their final filename only upon verifying expected Content-Length.

Local recovery relies on verified reference artifacts from earlier Z 8 and Z5 II reports.
When working solely from raw binaries, generate these references following the instructions in the [Z 8](../Z_8_0311/REPORT.md) and [Z5 II](../Z5_2_0120/REPORT.md) reports.
Analysis scripts verify mask and reference SHA-256 hashes; in the absence of a mask, legacy format decoding and modern container structural analysis proceed unaffected.

Unpacked files for each legacy firmware reside in `analysis/<SAMPLE_DIR>/`, with detailed inspection artifacts in `survey/`.
Raw firmware binaries, extracted payloads, Linux rootfs files, and symbol tables remain local and are Git-ignored; reports, download records, and top-level manifests are version-controlled.
No camera firmware was executed on hardware, no camera commands were transmitted, and no updater patches were generated.
