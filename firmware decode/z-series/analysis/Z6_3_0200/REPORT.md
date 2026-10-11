# Z6III Firmware 2.00 Batch Analysis

Sample: `Z6_3_0200.bin`, 117,641,453 bytes.
Official source: [Download Page](https://downloadcenter.nikonimglib.com/en/download/fw/571.html).

SHA-256: `b5c08335dc79d3d36d7bad0976434134db8ce160886d1c8c2935f3b185bcdbc9`.

[All Series Report](../catalog/REPORT.md) · [Batch Manifest](survey/manifest.json)

**Not fully decrypted; firmware section and package CRCs are unverified.**

Reference-assisted recovery window: `0x16c20bc–0x1ea95b8`, 8,287,484 bytes.
Known plaintext reference position: `0x18bf8f4`; completely identical across the 5,750,024-byte overlap with the original common mask.

Window dumps and extracted strings are located in `survey/reference_assisted_window.*`; structurally parseable ELFs and symbol tables are located in `survey/expanded_elf/`.
Injected known references do not constitute independently discovered plaintext; local masks cannot be extrapolated to uncovered payload offsets.

Firmware was not executed; no update patches were generated.
