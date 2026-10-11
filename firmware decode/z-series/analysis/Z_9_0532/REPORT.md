# Z 9 Firmware 5.32 Batch Analysis

Sample: `Z_9_0532.bin`, 101,846,611 bytes.
Official source: [Download Page](https://downloadcenter.nikonimglib.com/en/download/fw/585.html).

SHA-256: `2f13e75d38cd5b65da5b1f21a7828bc8a65ab17dc4c1b435b040ee62d2ed1d81`.

[All Series Report](../catalog/REPORT.md) · [Batch Manifest](survey/manifest.json)

**Unpacked successfully; all 6 section CRCs, package CRC, and byte-for-byte re-encoding roundtrip passed.**

| Section | Bytes |
| --- | ---: |
| `ex1990_051000.bi` | 524,290 |
| `_tpj01_0210.bin` | 57,346 |
| `eg1990_053200.bi` | 81,823,631 |
| `vr1990_010200.bi` | 838,664 |
| `_gst00_0017.bin` | 661,910 |
| `li1990_053200.bi` | 17,940,482 |

Section binaries, offset-indexed strings, and entropy statistics are located in this directory; detailed structural inspections are in `survey/`.

Detected 3 structurally parseable embedded ELFs; binaries and symbol tables are located in `survey/embedded_elf/`.

Linux CPIO entry count: 1505; regular files extracted only, without creating device nodes or symbolic links.

Kernel banner: `Linux version 4.14.224-ts-aarch64 (n8410@n8410) (gcc version 6.5.0 (Timesys 20200228)) #1 SMP PREEMPT Wed Jul 16 15:23:50 JST 2025`.

Firmware was not executed; no update patches were generated.
