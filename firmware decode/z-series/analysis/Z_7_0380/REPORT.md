# Z 7 Firmware 3.80 Batch Analysis

Sample: `Z_7_0380.bin`, 34,472,614 bytes.
Official source: [Download Page](https://downloadcenter.nikonimglib.com/en/download/fw/558.html).

SHA-256: `07cf19513ada5b770caec4cfc3531a6734c48aede28dcec037f0f8374ef441a2`.

[All Series Report](../catalog/REPORT.md) · [Batch Manifest](survey/manifest.json)

**Unpacked successfully; all 4 section CRCs, package CRC, and byte-for-byte re-encoding roundtrip passed.**

| Section | Bytes |
| --- | ---: |
| `ex1610_037000.bi` | 524,290 |
| `_tpj01_v140.bin` | 57,346 |
| `eg1610_038000.bi` | 33,052,090 |
| `vr1610_010200.bi` | 838,664 |

Section binaries, offset-indexed strings, and entropy statistics are located in this directory; detailed structural inspections are in `survey/`.

Firmware was not executed; no update patches were generated.
