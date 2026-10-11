# Comprehensive Z-Series Historical Firmware Extraction and Comparison

**Key findings are summarized in [Historical Comparison Findings](FINDINGS.md)**, including Z9 DSP evolution, Z f intermediate version validation, and Linux network component changes.

Scope: Known firmware release records across all 15 official Z-series camera models. Missing original packages are listed separately; factory version records do not imply public downloads were ever available.

Analyzed **148** firmware releases totaling **8,785,277,014 bytes** of raw binary files; **16** cataloged packages remain unavailable.

Fully decoded 123 packages across 523 sections, all verified with section CRC, package CRC, and bit-for-bit re-encoding roundtrip. Modern container formats are compared locally within verified windows only and are not counted as fully decoded.

| Model | Acquired Versions | Full Decode / Partial | Missing Packages |
|---|---|---:|---|
| Z 30 | 1.10, 1.11, 1.20 | 3 / 0 | 1.00 |
| Z 5 | 1.01, 1.02, 1.10, 1.11, 1.20, 1.21, 1.40, 1.41, 1.42, 1.43, 1.50 | 11 / 0 | 1.00 |
| Z 50 | 1.10, 1.11, 2.00, 2.01, 2.02, 2.03, 2.10, 2.11, 2.20, 2.30, 2.40, 2.50, 2.51, 2.60 | 14 / 0 | 1.00 |
| Z 6 | 1.01, 2.00, 2.01, 2.10, 2.20, 3.00, 3.10, 3.11, 3.12, 3.20, 3.30, 3.31, 3.40, 3.50, 3.60, 3.70, 3.80 | 17 / 0 | 1.00 |
| Z 6II | 1.01, 1.02, 1.10, 1.20, 1.21, 1.30, 1.40, 1.50, 1.60, 1.61, 1.62, 1.70 | 12 / 0 | 1.00 |
| Z 7 | 1.01, 1.02, 1.03, 2.00, 2.01, 2.10, 2.20, 3.00, 3.10, 3.11, 3.12, 3.20, 3.30, 3.31, 3.40, 3.50, 3.60, 3.70, 3.80 | 19 / 0 | 1.00 |
| Z 7II | 1.01, 1.10, 1.20, 1.21, 1.30, 1.31, 1.40, 1.50, 1.60, 1.61, 1.62, 1.70 | 12 / 0 | 1.00 |
| Z 8 | 1.01, 2.00, 2.01, 2.10, 3.00, 3.01, 3.10, 3.11 | 8 / 0 | 1.00 |
| Z 9 | 1.10, 1.11, 2.00, 2.10, 2.11, 3.00, 3.01, 3.10, 4.00, 4.01, 4.10, 5.00, 5.10, 5.20, 5.30, 5.31, 5.32 | 17 / 0 | 1.00 |
| Z f | 1.10, 1.20, 1.21, 2.00, 2.01, 2.02, 3.00, 3.01 | 0 / 8 | 1.00 |
| Z fc | 1.10, 1.20, 1.30, 1.40, 1.41, 1.50, 1.60, 1.70, 1.80, 1.81 | 10 / 0 | 1.00 |
| Z50II | 1.01, 1.02, 1.03, 1.04, 1.10, 1.11 | 0 / 6 | 1.00 |
| Z5II | 1.01, 1.02, 1.10, 1.11, 1.20 | 0 / 5 | 1.00 |
| Z6III | 1.02, 1.10, 1.11, 2.00 | 0 / 4 | 1.00, 1.01 |
| ZR | 1.10, 1.11 | 0 / 2 | 1.01 |

## DSP and Network Data Version Grouping

Identical groups are determined by full SHA-256 hash. Known DSP modules in newer containers serve as reference anchors rather than independent plaintext discoveries; network data recovered outside that scope is documented separately.

| DSP Fingerprint (SHA-256 First 12) | Role by Symbols | Size (Bytes) | Models and Matching Versions |
|---|---|---:|---|
| `93c839aef532` | image_processing | 644,872 | Z 8: 1.01 |
| `440d3b1867f0` | tracking | 437,664 | Z 8: 1.01; Z 9: 3.00, 3.01, 3.10 |
| `a38f6e96513e` | neural_inference | 5,750,024 | Z 8: 1.01; Z 9: 3.00, 3.01, 3.10 |
| `b3eebaa20c2a` | image_processing | 692,516 | Z 8: 2.00, 2.01, 2.10, 3.00, 3.01, 3.10, 3.11; Z 9: 4.00, 4.01, 4.10, 5.00, 5.10, 5.20, 5.30, 5.31, 5.32 |
| `de9610259024` | tracking | 456,004 | Z 8: 2.00, 2.01, 2.10, 3.00, 3.01, 3.10, 3.11; Z 9: 4.00, 4.01, 4.10, 5.00, 5.10, 5.20; Z6III: 2.00; ZR: 1.10, 1.11 |
| `c7787ceda602` | neural_inference | 5,750,024 | Z 8: 2.00, 2.01, 2.10, 3.00, 3.01, 3.10, 3.11; Z 9: 4.00, 4.01, 4.10, 5.00, 5.10, 5.20, 5.30, 5.31, 5.32; Z f: 1.10, 1.20, 1.21, 2.00, 2.01, 2.02, 3.00, 3.01; Z50II: 1.01, 1.02, 1.03, 1.04, 1.10, 1.11; Z5II: 1.01, 1.02, 1.10, 1.11, 1.20; Z6III: 1.02, 1.10, 1.11, 2.00; ZR: 1.10, 1.11 |
| `578259dd83b1` | image_processing | 551,364 | Z 9: 1.10, 1.11 |
| `0a4134aecee6` | tracking | 383,004 | Z 9: 1.10, 1.11 |
| `322f7dcbd65f` | neural_inference | 5,763,984 | Z 9: 1.10, 1.11 |
| `580a39503ac7` | image_processing | 637,384 | Z 9: 2.00, 2.10, 2.11, 3.00, 3.01, 3.10 |
| `1bc15b1ba640` | tracking | 385,320 | Z 9: 2.00, 2.10, 2.11 |
| `e9436f6fe7e2` | neural_inference | 5,750,024 | Z 9: 2.00, 2.10, 2.11 |
| `dd2e0e44d1cf` | tracking | 473,348 | Z 9: 5.30, 5.31, 5.32 |
| `6b89673f8596` | image_processing | 691,804 | Z6III: 2.00 |
| `195228548d5f` | image_processing | 896,508 | ZR: 1.10, 1.11 |

A total of **2** distinct full network candidates were identified; see `network_identity_groups` in the manifest for full coverage versions and SHA-256 hashes. Versions not covered or only covering prefixes are excluded from full equivalence conclusions.

## Version-by-Version Differences by Model

Section changes are determined by full SHA-256 comparison. 'Identical' denotes byte-for-byte equivalence; changes do not necessarily indicate feature changes. DSP modules are identified by embedded ELF contents; network data represents boundary-verified candidate formats with unparsed layers and operators.

### Z 30

| Version Transition | Changed Sections | Unchanged Sections | DSP / Network Candidate | Linux Rootfs |
|---|---|---|---|---|
| 1.10 -> 1.11 | eg | _tpj, ex | DSP Not covered; Network Not covered | — |
| 1.11 -> 1.20 | eg, ex | _tpj | DSP Not covered; Network Not covered | — |

### Z 5

| Version Transition | Changed Sections | Unchanged Sections | DSP / Network Candidate | Linux Rootfs |
|---|---|---|---|---|
| 1.01 -> 1.02 | eg, ex | _tpt, vr | DSP Not covered; Network Not covered | — |
| 1.02 -> 1.10 | eg, ex | _tpt, vr | DSP Not covered; Network Not covered | — |
| 1.10 -> 1.11 | eg | _tpt, ex, vr | DSP Not covered; Network Not covered | — |
| 1.11 -> 1.20 | eg | _tpt, ex, vr | DSP Not covered; Network Not covered | — |
| 1.20 -> 1.21 | eg, vr | _tpt, ex | DSP Not covered; Network Not covered | — |
| 1.21 -> 1.40 | eg | _tpt, ex, vr | DSP Not covered; Network Not covered | — |
| 1.40 -> 1.41 | eg, ex | _tpt, vr | DSP Not covered; Network Not covered | — |
| 1.41 -> 1.42 | eg, ex | _tpt, vr | DSP Not covered; Network Not covered | — |
| 1.42 -> 1.43 | eg | _tpt, ex, vr | DSP Not covered; Network Not covered | — |
| 1.43 -> 1.50 | eg | _tpt, ex, vr | DSP Not covered; Network Not covered | — |

### Z 50

| Version Transition | Changed Sections | Unchanged Sections | DSP / Network Candidate | Linux Rootfs |
|---|---|---|---|---|
| 1.10 -> 1.11 | eg, ex | _tpt | DSP Not covered; Network Not covered | — |
| 1.11 -> 2.00 | eg | _tpt, ex | DSP Not covered; Network Not covered | — |
| 2.00 -> 2.01 | eg | _tpt, ex | DSP Not covered; Network Not covered | — |
| 2.01 -> 2.02 | eg | _tpt, ex | DSP Not covered; Network Not covered | — |
| 2.02 -> 2.03 | eg | _tpt, ex | DSP Not covered; Network Not covered | — |
| 2.03 -> 2.10 | eg | _tpt, ex | DSP Not covered; Network Not covered | — |
| 2.10 -> 2.11 | eg | _tpt, ex | DSP Not covered; Network Not covered | — |
| 2.11 -> 2.20 | eg | _tpt, ex | DSP Not covered; Network Not covered | — |
| 2.20 -> 2.30 | eg | _tpt, ex | DSP Not covered; Network Not covered | — |
| 2.30 -> 2.40 | eg | _tpt, ex | DSP Not covered; Network Not covered | — |
| 2.40 -> 2.50 | eg, ex | _tpt | DSP Not covered; Network Not covered | — |
| 2.50 -> 2.51 | eg | _tpt, ex | DSP Not covered; Network Not covered | — |
| 2.51 -> 2.60 | eg, ex | _tpt | DSP Not covered; Network Not covered | — |

### Z 6

| Version Transition | Changed Sections | Unchanged Sections | DSP / Network Candidate | Linux Rootfs |
|---|---|---|---|---|
| 1.01 -> 2.00 | eg, ex, vr | _tpj | DSP Not covered; Network Not covered | — |
| 2.00 -> 2.01 | eg | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 2.01 -> 2.10 | eg | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 2.10 -> 2.20 | eg | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 2.20 -> 3.00 | eg | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 3.00 -> 3.10 | eg, ex | _tpj, vr | DSP Not covered; Network Not covered | — |
| 3.10 -> 3.11 | eg, ex | _tpj, vr | DSP Not covered; Network Not covered | — |
| 3.11 -> 3.12 | eg | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 3.12 -> 3.20 | eg, ex | _tpj, vr | DSP Not covered; Network Not covered | — |
| 3.20 -> 3.30 | eg, ex | _tpj, vr | DSP Not covered; Network Not covered | — |
| 3.30 -> 3.31 | eg | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 3.31 -> 3.40 | eg | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 3.40 -> 3.50 | eg | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 3.50 -> 3.60 | eg | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 3.60 -> 3.70 | eg, ex | _tpj, vr | DSP Not covered; Network Not covered | — |
| 3.70 -> 3.80 | eg | _tpj, ex, vr | DSP Not covered; Network Not covered | — |

### Z 6II

| Version Transition | Changed Sections | Unchanged Sections | DSP / Network Candidate | Linux Rootfs |
|---|---|---|---|---|
| 1.01 -> 1.02 | eg_mas, eg_sla | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 1.02 -> 1.10 | eg_mas, eg_sla | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 1.10 -> 1.20 | eg_mas, eg_sla | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 1.20 -> 1.21 | eg_mas, eg_sla | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 1.21 -> 1.30 | eg_mas, eg_sla | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 1.30 -> 1.40 | eg_mas, eg_sla, vr | _tpj, ex | DSP Not covered; Network Not covered | — |
| 1.40 -> 1.50 | eg_mas, eg_sla, ex | _tpj, vr | DSP Not covered; Network Not covered | — |
| 1.50 -> 1.60 | eg_mas, eg_sla | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 1.60 -> 1.61 | eg_mas, eg_sla, ex | _tpj, vr | DSP Not covered; Network Not covered | — |
| 1.61 -> 1.62 | eg_mas, eg_sla | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 1.62 -> 1.70 | eg_mas, eg_sla | _tpj, ex, vr | DSP Not covered; Network Not covered | — |

### Z 7

| Version Transition | Changed Sections | Unchanged Sections | DSP / Network Candidate | Linux Rootfs |
|---|---|---|---|---|
| 1.01 -> 1.02 | eg | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 1.02 -> 1.03 | eg, ex, vr | _tpj | DSP Not covered; Network Not covered | — |
| 1.03 -> 2.00 | eg, ex, vr | _tpj | DSP Not covered; Network Not covered | — |
| 2.00 -> 2.01 | eg | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 2.01 -> 2.10 | eg | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 2.10 -> 2.20 | eg | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 2.20 -> 3.00 | eg | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 3.00 -> 3.10 | eg, ex | _tpj, vr | DSP Not covered; Network Not covered | — |
| 3.10 -> 3.11 | eg, ex | _tpj, vr | DSP Not covered; Network Not covered | — |
| 3.11 -> 3.12 | eg | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 3.12 -> 3.20 | eg, ex | _tpj, vr | DSP Not covered; Network Not covered | — |
| 3.20 -> 3.30 | eg, ex | _tpj, vr | DSP Not covered; Network Not covered | — |
| 3.30 -> 3.31 | eg | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 3.31 -> 3.40 | eg | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 3.40 -> 3.50 | eg | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 3.50 -> 3.60 | eg | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 3.60 -> 3.70 | eg, ex | _tpj, vr | DSP Not covered; Network Not covered | — |
| 3.70 -> 3.80 | eg | _tpj, ex, vr | DSP Not covered; Network Not covered | — |

### Z 7II

| Version Transition | Changed Sections | Unchanged Sections | DSP / Network Candidate | Linux Rootfs |
|---|---|---|---|---|
| 1.01 -> 1.10 | eg_mas, eg_sla, ex | _tpj, vr | DSP Not covered; Network Not covered | — |
| 1.10 -> 1.20 | eg_mas, eg_sla | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 1.20 -> 1.21 | eg_mas, eg_sla | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 1.21 -> 1.30 | eg_mas, eg_sla | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 1.30 -> 1.31 | eg_mas, eg_sla, vr | _tpj, ex | DSP Not covered; Network Not covered | — |
| 1.31 -> 1.40 | eg_mas, eg_sla | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 1.40 -> 1.50 | eg_mas, eg_sla, ex | _tpj, vr | DSP Not covered; Network Not covered | — |
| 1.50 -> 1.60 | eg_mas, eg_sla | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 1.60 -> 1.61 | eg_mas, eg_sla, ex | _tpj, vr | DSP Not covered; Network Not covered | — |
| 1.61 -> 1.62 | eg_mas, eg_sla | _tpj, ex, vr | DSP Not covered; Network Not covered | — |
| 1.62 -> 1.70 | eg_mas, eg_sla | _tpj, ex, vr | DSP Not covered; Network Not covered | — |

### Z 8

| Version Transition | Changed Sections | Unchanged Sections | DSP / Network Candidate | Linux Rootfs |
|---|---|---|---|---|
| 1.01 -> 2.00 | eg, ex, li, vr | _tpj | DSP Changed/Coverage delta; Network Identical | mod:6 add:0 del:0 |
| 2.00 -> 2.01 | eg, ex, li | _tpj, vr | DSP Identical; Network Identical | mod:0 add:0 del:0 |
| 2.01 -> 2.10 | eg, ex, li | _tpj, vr | DSP Identical; Network Identical | mod:2 add:0 del:0 |
| 2.10 -> 3.00 | eg, ex, li | _tpj, vr | DSP Identical; Network Identical | mod:8 add:0 del:0 |
| 3.00 -> 3.01 | eg, li | _tpj, ex, vr | DSP Identical; Network Identical | mod:0 add:0 del:0 |
| 3.01 -> 3.10 | eg, li | _tpj, ex, vr | DSP Identical; Network Identical | mod:0 add:0 del:0 |
| 3.10 -> 3.11 | eg, li | _tpj, ex, vr | DSP Identical; Network Identical | mod:0 add:0 del:0 |

### Z 9

| Version Transition | Changed Sections | Unchanged Sections | DSP / Network Candidate | Linux Rootfs |
|---|---|---|---|---|
| 1.10 -> 1.11 | eg, li | _gnt, _tpj, ex, vr | DSP Identical; Network Identical | mod:0 add:0 del:0 |
| 1.11 -> 2.00 | eg, ex, li | _gnt, _tpj, vr | DSP Changed/Coverage delta; Network Identical | mod:34 add:1 del:0 |
| 2.00 -> 2.10 | _gnt(removed), eg, ex, li, vr | _tpj | DSP Identical; Network Identical | mod:0 add:0 del:0 |
| 2.10 -> 2.11 | eg, ex, li | _tpj, vr | DSP Identical; Network Identical | mod:0 add:0 del:0 |
| 2.11 -> 3.00 | eg, ex, li | _tpj, vr | DSP Changed/Coverage delta; Network Identical | mod:19 add:11 del:0 |
| 3.00 -> 3.01 | eg, li | _tpj, ex, vr | DSP Identical; Network Identical | mod:1 add:0 del:0 |
| 3.01 -> 3.10 | eg, li | _tpj, ex, vr | DSP Identical; Network Identical | mod:0 add:0 del:0 |
| 3.10 -> 4.00 | eg, ex, li | _tpj, vr | DSP Changed/Coverage delta; Network Identical | mod:6 add:0 del:0 |
| 4.00 -> 4.01 | eg, li | _tpj, ex, vr | DSP Identical; Network Identical | mod:0 add:0 del:0 |
| 4.01 -> 4.10 | eg, li | _tpj, ex, vr | DSP Identical; Network Identical | mod:0 add:0 del:0 |
| 4.10 -> 5.00 | _gst(added), eg, ex, li, vr | _tpj | DSP Identical; Network Identical | mod:67 add:632 del:17 |
| 5.00 -> 5.10 | eg, ex, li | _gst, _tpj, vr | DSP Identical; Network Identical | mod:48 add:0 del:0 |
| 5.10 -> 5.20 | eg, li | _gst, _tpj, ex, vr | DSP Identical; Network Identical | mod:0 add:0 del:0 |
| 5.20 -> 5.30 | eg, li | _gst, _tpj, ex, vr | DSP Changed/Coverage delta; Network Identical | mod:36 add:71 del:0 |
| 5.30 -> 5.31 | eg, li | _gst, _tpj, ex, vr | DSP Identical; Network Identical | mod:0 add:0 del:0 |
| 5.31 -> 5.32 | eg, li | _gst, _tpj, ex, vr | DSP Identical; Network Identical | mod:0 add:0 del:0 |

### Z f

| Version Transition | Changed Sections | Unchanged Sections | DSP / Network Candidate | Linux Rootfs |
|---|---|---|---|---|
| 1.10 -> 1.20 | Not fully decoded | — | DSP Identical; Network Identical | — |
| 1.20 -> 1.21 | Not fully decoded | — | DSP Identical; Network Identical | — |
| 1.21 -> 2.00 | Not fully decoded | — | DSP Identical; Network Identical | — |
| 2.00 -> 2.01 | Not fully decoded | — | DSP Identical; Network Identical | — |
| 2.01 -> 2.02 | Not fully decoded | — | DSP Identical; Network Identical | — |
| 2.02 -> 3.00 | Not fully decoded | — | DSP Identical; Network Identical | — |
| 3.00 -> 3.01 | Not fully decoded | — | DSP Identical; Network Identical | — |

### Z fc

| Version Transition | Changed Sections | Unchanged Sections | DSP / Network Candidate | Linux Rootfs |
|---|---|---|---|---|
| 1.10 -> 1.20 | eg | _tpj, ex | DSP Not covered; Network Not covered | — |
| 1.20 -> 1.30 | eg | _tpj, ex | DSP Not covered; Network Not covered | — |
| 1.30 -> 1.40 | eg, ex | _tpj | DSP Not covered; Network Not covered | — |
| 1.40 -> 1.41 | eg | _tpj, ex | DSP Not covered; Network Not covered | — |
| 1.41 -> 1.50 | eg, ex | _tpj | DSP Not covered; Network Not covered | — |
| 1.50 -> 1.60 | eg, ex | _tpj | DSP Not covered; Network Not covered | — |
| 1.60 -> 1.70 | eg | _tpj, ex | DSP Not covered; Network Not covered | — |
| 1.70 -> 1.80 | eg, ex | _tpj | DSP Not covered; Network Not covered | — |
| 1.80 -> 1.81 | eg | _tpj, ex | DSP Not covered; Network Not covered | — |

### Z50II

| Version Transition | Changed Sections | Unchanged Sections | DSP / Network Candidate | Linux Rootfs |
|---|---|---|---|---|
| 1.01 -> 1.02 | Not fully decoded | — | DSP Identical; Network Identical | — |
| 1.02 -> 1.03 | Not fully decoded | — | DSP Identical; Network Identical | — |
| 1.03 -> 1.04 | Not fully decoded | — | DSP Identical; Network Identical | — |
| 1.04 -> 1.10 | Not fully decoded | — | DSP Identical; Network Identical | — |
| 1.10 -> 1.11 | Not fully decoded | — | DSP Identical; Network Identical | — |

### Z5II

| Version Transition | Changed Sections | Unchanged Sections | DSP / Network Candidate | Linux Rootfs |
|---|---|---|---|---|
| 1.01 -> 1.02 | Not fully decoded | — | DSP Identical; Network Identical | — |
| 1.02 -> 1.10 | Not fully decoded | — | DSP Identical; Network Identical | — |
| 1.10 -> 1.11 | Not fully decoded | — | DSP Identical; Network Identical | — |
| 1.11 -> 1.20 | Not fully decoded | — | DSP Identical; Network Identical | — |

### Z6III

| Version Transition | Changed Sections | Unchanged Sections | DSP / Network Candidate | Linux Rootfs |
|---|---|---|---|---|
| 1.02 -> 1.10 | Not fully decoded | — | DSP Identical; Network Identical | — |
| 1.10 -> 1.11 | Not fully decoded | — | DSP Identical; Network Identical | — |
| 1.11 -> 2.00 | Not fully decoded | — | DSP Changed/Coverage delta; Network Changed/Coverage delta | — |

### ZR

| Version Transition | Changed Sections | Unchanged Sections | DSP / Network Candidate | Linux Rootfs |
|---|---|---|---|---|
| 1.10 -> 1.11 | Not fully decoded | — | DSP Identical; Network Not covered | — |

## Evidence and Reproduction

- [Official Source URL History and Discovery Process](SOURCES.md); [Download Manifest and SHA-256](downloads.json); [Full Machine-Readable Comparison](manifest.json).
- `coverage.csv` lists per-version status; `versions/<BIN_NAME>/manifest.json` provides section, DSP, network, and Linux evidence.
- Modern format analysis relies on fixed-offset masks cross-validated across overlapping camera models, requiring a full match of the known DSP ELF before analyzing the window. Matching ELF instances should not be considered independent discoveries; regions outside the window, the full modern container, and container CRCs remain undecoded.
- Equivalence in network candidates applies strictly to extracted regions and does not imply identity across all models, full AI pipelines, or camera features. The absence of ELF/markers does not imply absence of AI functionality.
- Static unpacking and inspection only; no firmware or installers were executed, and no raw firmware was modified. All downloads originate from official Nikon CDNs; release dates are estimated from HTTP Last-Modified headers when unstated.

```sh
uv run python tools/discover_z_history.py
uv run python tools/collect_all_z_history.py .
uv run python tools/compare_all_z_history.py .
uv run pytest
```
