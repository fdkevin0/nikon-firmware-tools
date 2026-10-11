# Z 50 Firmware 2.60 Batch Analysis

Sample: `Z_50_0260.bin`, 31,972,272 bytes.
Official source: [Download Page](https://downloadcenter.nikonimglib.com/en/download/fw/555.html).

SHA-256: `69745c9e8f3156e936918e62a4a1fad18e7078e9ea3b95d8b8e08144b1542e49`.

[All Series Report](../catalog/REPORT.md) · [Batch Manifest](survey/manifest.json)

**Unpacked successfully; all 3 section CRCs, package CRC, and byte-for-byte re-encoding roundtrip passed.**

| Section | Bytes |
| --- | ---: |
| `ex1630_021000.bi` | 524,290 |
| `_tpt01_0091.bin` | 43,700 |
| `eg1630_026000.bi` | 31,404,090 |

Section binaries, offset-indexed strings, and entropy statistics are located in this directory; detailed structural inspections are in `survey/`.

Firmware was not executed; no update patches were generated.
