# Z 30 Firmware 1.20 Batch Analysis

Sample: `Z_30_0120.bin`, 34,496,798 bytes.
Official source: [Download Page](https://downloadcenter.nikonimglib.com/en/download/fw/556.html).

SHA-256: `1a5449ef505f1f347ed4e066a6a3f588ea542240680e83f4ebcae3b16da3434a`.

[All Series Report](../catalog/REPORT.md) · [Batch Manifest](survey/manifest.json)

**Unpacked successfully; all 3 section CRCs, package CRC, and byte-for-byte re-encoding roundtrip passed.**

| Section | Bytes |
| --- | ---: |
| `ex2090_012000.bi` | 524,290 |
| `_tpj04_v10a5.bin` | 32,802 |
| `eg2090_0120a0.bi` | 33,939,514 |

Section binaries, offset-indexed strings, and entropy statistics are located in this directory; detailed structural inspections are in `survey/`.

Firmware was not executed; no update patches were generated.
