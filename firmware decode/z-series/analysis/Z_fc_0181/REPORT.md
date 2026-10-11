# Z fc Firmware 1.81 Batch Analysis

Sample: `Z_fc_0181.bin`, 35,578,974 bytes.
Official source: [Download Page](https://downloadcenter.nikonimglib.com/en/download/fw/593.html).

SHA-256: `e4cd838a215c113659416983b31dbdba8896591caacf7309170d4cc3c60bd1b6`.

[All Series Report](../catalog/REPORT.md) · [Batch Manifest](survey/manifest.json)

**Unpacked successfully; all 3 section CRCs, package CRC, and byte-for-byte re-encoding roundtrip passed.**

| Section | Bytes |
| --- | ---: |
| `ex1985_014000.bi` | 524,290 |
| `_tpj04_v10a5.bin` | 32,802 |
| `eg1985_018100.bi` | 35,021,690 |

Section binaries, offset-indexed strings, and entropy statistics are located in this directory; detailed structural inspections are in `survey/`.

Firmware was not executed; no update patches were generated.
