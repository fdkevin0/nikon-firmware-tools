# Z50II Firmware 1.11 Batch Analysis

Sample: `Z50_2_0111.bin`, 107,828,357 bytes.
Official source: [Download Page](https://downloadcenter.nikonimglib.com/en/download/fw/605.html).

SHA-256: `f1e92e1ae982a589000f1bc2bcd9e3e57613886b5b72398024ebc569bb8d7439`.

[All Series Report](../catalog/REPORT.md) · [Batch Manifest](survey/manifest.json)

**Not fully decrypted; firmware section and package CRCs are unverified.**

Reference-assisted recovery window: `0x16c20bc–0x1ea95b8`, 8,287,484 bytes.
Known plaintext reference position: `0x16c20bc`; completely identical across the 5,726,640-byte overlap with the original common mask.

Window dumps and extracted strings are located in `survey/reference_assisted_window.*`; structurally parseable ELFs and symbol tables are located in `survey/expanded_elf/`.
Injected known references do not constitute independently discovered plaintext; local masks cannot be extrapolated to uncovered payload offsets.

Firmware was not executed; no update patches were generated.
