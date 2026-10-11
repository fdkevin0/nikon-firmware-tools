# Z 7II Firmware 1.70 Batch Analysis

Sample: `Z7_2_0170.bin`, 48,494,024 bytes.
Official source: [Download Page](https://downloadcenter.nikonimglib.com/en/download/fw/561.html).

SHA-256: `fc0e94f57500a1f0e287c6b9a036c81a5ffceccb8432a377d645b3fa35a19b6a`.

[All Series Report](../catalog/REPORT.md) · [Batch Manifest](survey/manifest.json)

**Unpacked successfully; all 5 section CRCs, package CRC, and byte-for-byte re-encoding roundtrip passed.**

| Section | Bytes |
| --- | ---: |
| `ex1840_013000.bi` | 524,290 |
| `_tpj01_v140.bin` | 57,346 |
| `eg1840_mas_01700` | 38,239,098 |
| `vr1840_010100.bi` | 838,664 |
| `eg1840_sla_01700` | 8,834,370 |

Section binaries, offset-indexed strings, and entropy statistics are located in this directory; detailed structural inspections are in `survey/`.

Firmware was not executed; no update patches were generated.
