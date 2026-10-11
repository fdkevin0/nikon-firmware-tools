# Nikon Remote SDK 2.0.0 Reference Index

Compiled on: 2026-10-05. Source archive: `S-SDKZ-200BF-ALLIN.zip`. Used for Z-series feature comparisons, USB/MTP protocol analysis, and locating firmware handler routines. Note: This documentation summarizes desktop SDK specifications; no live cameras were connected and no binaries were executed.

The materials encompass **protocol documents across 15 models plus 3 common specifications, totaling 18 PDFs and 8,423 pages**. Indexed with page numbers and configuration CSVs preserving model and version scopes.

| Target | Entry Point |
| :--- | :--- |
| Model protocol PDFs, cover revisions, and text extracts | [Protocol Documents Index](PROTOCOLS.md) |
| Configuration hierarchy, identifier scopes, and constraints | [Configuration Reading Guide](CONFIGURATION.md) |
| Subject detection codes, SDK enums, and configuration diffs | [Subject Detection Mapping](SUBJECT_DETECTION.md) |
| Operation / Property / Event / Response Code definitions | [Protocol Code Locations CSV](indexes/protocol_code_locations.csv) |
| MAID capabilities & original operation mappings | [MAID Capabilities CSV](indexes/maid_capabilities.csv) |
| PTP property translation table | [PTP Property Mappings CSV](indexes/ptp_property_mappings.csv) |
| Enumerations, ranges, and defaults | [Range Values CSV](indexes/range_values.csv) |
| Model scopes and block sizes | [Model Blocks CSV](indexes/model_blocks.csv) |
| ZIP manifest, sizes, CRC, and SHA-256 | [Sources & Deliverables Manifest](manifest.json) |

---

## Source Archive & Coverage

ZIP size: **88,048,129 bytes**, SHA-256:
```text
d8ff7b10061c3a69ba11c66e2d2cca058b88efd01de346d9152ff34b5202f3fb
```

A total of 94 ZIP entries were inventoried. 39 documents, configs, headers, and sample sources are staged under `original/`. SDK DLLs, executables, and macOS sample project archives are cataloged without execution.

`original/ReadMe_En.txt` states Remote SDK v2.0.0 supports Z9, Z8, Z6III, Z7II, Z6II, Z7, Z6, Z5II, Z5, Z f, Z50II, Z50, Z30, Z fc, and ZR.

| Original Location | Content & Purpose |
| :--- | :--- |
| `Command/English/` | Model-specific USB Still Image Capture Device MTP Specifications (operations, properties, events, sequences, error codes) |
| `Module/Document/English/MAID3(E).pdf` | MAID Base Interface Specification |
| `Module/Document/English/MAID3-COMMON(E).pdf` | Common & Extended Interfaces (`InitializeSDK`, `ConnectDevice`, `EnumCapabilities`, etc.) |
| `Module/Document/English/Sample App Guide(E).pdf` | Sample Application Operational Guide |
| `Module/Win/HeaderFile/`, `Module/Mac/HeaderFile/` | Platform C/C++ headers, types, and capability enums |
| `Module/Win/SampleApp/` | Sample source files (`main.cpp`, `Function.cpp`) |
| `Module/Win/BinaryFile/*.config` | MAID capabilities, device property translations, and range definitions |

---

## Reverse Engineering Applications

1. Locate property codes, data types, Get/Set permissions, and operating mode constraints in model PDFs.
2. Cross-reference configuration headers to distinguish MAID capability IDs, device property codes, and internal configuration indices.
3. Search for corresponding constants and dispatch tables in unpacked firmware to identify verification and handling routines.
