# Remote SDK Configuration Reading Guide

Source configuration files are located under `Module/Win/BinaryFile/` in the original SDK archive, mirrored in [original/Module/Win/BinaryFile](original/Module/Win/BinaryFile). These files describe how the desktop SDK organizes and converts camera capabilities. They do not directly represent internal camera firmware variables or raw hardware specs.

---

## Three-Layer Configuration Structure

| File | Raw Structure & Readable Information | Index |
| :--- | :--- | :--- |
| `MaidLayer.config` | Capabilities defined within `<model:…>` and `<version>…</version>` blocks; names, IDs, operation bitmasks, observer dependencies, and `DeviceCommand` | [8,373 Capability Records](indexes/maid_capabilities.csv) |
| `DC_PTP_Config.config` | `usPropSel` and `PropConv` selectors grouped by model and versionInfo; device property selectors and value converters | [12,278 Property Selector Records](indexes/ptp_property_mappings.csv) |
| `RangeValue.config` | Model blocks partitioned by `<version:…>`; capability enumerations, valid ranges, and default values | [4,767 Value Records](indexes/range_values.csv) |

All three files list `ProfileVersion` as `9.0.3000` and `AppCompatibilityVersion` as `5` (configuration metadata, not firmware versions). The files feature 38, 39, and 23 model blocks respectively (100 total), with recurring entries for identical camera models across configuration profiles.

---

## Identifiers and Command Mappings

Taking photo subject detection as a concrete example:

| Layer | Identifier / Name | Evidence |
| :--- | :--- | :--- |
| MAID Capability | `kNkMAIDCapability_AFSubjectDetection`, Decimal `34118`, Hex `0x8546` | `MaidLayer.config` / `RangeValue.config` and `Maid3d1.h` |
| Camera Protocol Property | `AFSubjectDetection`, `0x0001D005` | Z f PDF p. 302; Z8 PDF p. 285 |
| Configuration Mapping | In Z f `1.0` block, capability `DeviceCommand` is `219,0,0,0,0`; mapped via `usPropSel` starting with `293,118789,…` | Preserved as raw mapping fields |

Decimal `118789` equals `0x1D005`. However, capability ID, `usPropSel` index, `DeviceCommand` parameters, and protocol property codes occupy distinct namespaces.

[Maid3.h](original/Module/Win/HeaderFile/Maid3.h) defines capability operation bitmasks: `Start=0x01`, `Get=0x02`, `Set=0x04`, `GetArray=0x08`, `GetDefault=0x10`. The value `allowedoperation:14` matches `Get | Set | GetArray`.
