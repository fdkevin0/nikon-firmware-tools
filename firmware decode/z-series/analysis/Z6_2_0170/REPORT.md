# Z 6II Firmware 1.70 Batch Analysis

Sample: `Z6_2_0170.bin`, 49,002,888 bytes.
Official source: [Download Page](https://downloadcenter.nikonimglib.com/en/download/fw/560.html).

SHA-256: `5a9640b4c07abe1ecbf5a52655cbec6b893bba045bb2a1a1d21055b9f8f9d06d`.

[All Series Report](../catalog/REPORT.md) · [Batch Manifest](survey/manifest.json)

**Unpacked successfully; all 5 section CRCs, package CRC, and byte-for-byte re-encoding roundtrip passed.**

| Section | Bytes |
| --- | ---: |
| `ex1850_012000.bi` | 524,290 |
| `_tpj01_v140.bin` | 57,346 |
| `eg1850_mas_01700` | 38,750,138 |
| `vr1850_010100.bi` | 838,664 |
| `eg1850_sla_01700` | 8,832,194 |

Section binaries, offset-indexed strings, and entropy statistics are located in this directory; detailed structural inspections are in `survey/`.

Firmware was not executed; no update patches were generated.
