# Subject Detection SDK & Protocol Mapping

This document illustrates the relationship between protocol property codes, SDK enumerations, and per-model configuration declarations using AF subject detection as a case study.

---

## Identifier Layers

| Feature | MAID Capability ID | MTP Property Code | Official Source Reference |
| :--- | :--- | :--- | :--- |
| Photo Subject Detection | `AFSubjectDetection`: 34118 / `0x8546` | `0x0001D005` | Z f PDF p. 302; Z8 PDF p. 285 |
| Movie Subject Detection | `MovieAFSubjectDetection`: 34119 / `0x8547` | `0x0001D006` | Z f PDF p. 375; Z8 PDF p. 357 |

Model-specific PDFs are indexed in the [Protocol Index](PROTOCOLS.md); SDK enums are defined in [Maid3d1.h](original/Module/Win/HeaderFile/Maid3d1.h); configuration values are recorded in [range_values.csv](indexes/range_values.csv).

In both Z f and Z8 photo property tables, data type is `UINT8`, Form Flag is Enumeration, access is Get/Set, and default value is 1. The numeric values map to:

| Value | Meaning |
| ---: | :--- |
| 0 | Off |
| 1 | Auto |
| 2 | People |
| 3 | Animal |
| 4 | Vehicle |
| 5 | Birds |
| 6 | Airplanes |

The common header enum also defines `Train` (sequential value 7), but 7 is omitted from both camera property tables.

---

## Configuration Variances Across Firmware Profiles

Extracted from `RangeValue.config`:

| Model Tag | Version Tag | Raw Enumeration | Contains Value 5 (Birds) |
| :--- | :--- | :--- | :--- |
| `Z f` | `1.0` | `1,2,3,4,6,0` | No |
| `Z f` | `2.0`, `3.0` | `1,2,3,5,4,6,0` | Yes |
| `Z 8` | `common` | `1,2,3,4,6,0` | No |
| `Z 8` | `2.0`, `3.0`, `4.0`, `5.0` | `1,2,3,5,4,6,0` | Yes |
| `Z 9` | `2.0`, `3.0` | `1,2,3,4,0` | No |
| `Z 9` | `4.0`, `5.0` | `1,2,3,5,4,6,0` | Yes |
| `Z6_3` | `1.0` | `1,2,3,4,6,0` | No |
| `Z6_3` | `2.0` | `1,2,3,4,5,6,0` | Yes |
| `Z5_2` | `common` | `1,2,3,5,4,6,0` | Yes |
| `ZR` | `1.0`, `2.0` | `1,2,3,5,4,6,0` | Yes |

---

## Relevance to Firmware Research

Protocol property codes allow researchers to identify property dispatch tables, value validation logic, and handler routines in unpacked camera binaries.

The verification chain is: **Model PDF Definition → SDK Configuration Scope → Live Device Property Description → Firmware Handler Routine → Algorithmic Call**.
