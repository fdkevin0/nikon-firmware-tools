# Z 5 Firmware 1.50 Batch Analysis

Sample: `Z_5_0150.bin`, 36,011,790 bytes.
Official source: [Download Page](https://downloadcenter.nikonimglib.com/en/download/fw/562.html).

SHA-256: `efc0ce70dcafdd96c64e95d8d50f6b7f0509fc0c2840b28d12b6f9e4877ee776`.

[All Series Report](../catalog/REPORT.md) · [Batch Manifest](survey/manifest.json)

**Unpacked successfully; all 4 section CRCs, package CRC, and byte-for-byte re-encoding roundtrip passed.**

| Section | Bytes |
| --- | ---: |
| `ex1650_013000.bi` | 524,290 |
| `_tpt01_0010.bin` | 45,034 |
| `eg1650_015001.bi` | 34,603,578 |
| `vr1650_010100.bi` | 838,664 |

Section binaries, offset-indexed strings, and entropy statistics are located in this directory; detailed structural inspections are in `survey/`.

Firmware was not executed; no update patches were generated.
