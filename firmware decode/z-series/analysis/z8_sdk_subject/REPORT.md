# Z 8 x Remote SDK 2.0.0: Subject Detection Properties to In-Camera Settings

This study cross-references [Remote SDK 2.0.0 specifications](../../references/remote-sdk-2.0.0/README.md) with all eight decoded Z 8 firmware releases, locating host handlers for subject detection properties. No camera hardware was connected, and no firmware was altered.

**Core Finding: Introduction of dedicated bird detection in firmware 2.00 has been traced from SDK properties into internal setting handlers.** In firmware 1.01, photo and video handlers reject value `5`; from 2.00 onward, both forward `5` to internal settings services. Because networks N1 and N2 are identical between 1.01 and 2.00, the new option coexists with existing network models. Downstream dispatch from settings services to DSP execution queues remains under investigation.

## Four Disconnected Identifier Spaces

| Layer | Photo Subject Detection | Video Subject Detection | Evidence Source |
|---|---|---|---|
| SDK MAID Capability | `34118 / 0x8546` | `34119 / 0x8547` | SDK header files and Z 8 capability configuration blocks |
| MTP Property Code | `0x0001D005` | `0x0001D006` | Z 8 Protocol Spec (pp. 285, 357); firmware property records |
| Internal Setting ID | **`0x0600069A`** | **`0x06001254`** | Argument values in setter routines across all 8 firmware releases |
| DSP Program 2 API | Unified across modes | Unified across modes | Slot 31 (Animal), Slot 32 (Vehicle) in firmware 3.11 ([Host Study](../z8_dsp_host/REPORT.md)) |

Properties are represented as UINT8. Protocol values `0..6` denote: Off, Auto, People, Animal, Vehicles, Birds, Airplanes. Header files define `Train=7`, but value 7 is rejected across all eight firmware versions.

Property codes exceed 16 bits. Z 8 documentation specifies `GetDevicePropDescEx=0x943A`, `GetDevicePropValueEx=0x943B`, and `SetDevicePropValueEx=0x943C`, passing full 32-bit property codes in Parameter 1.

## Firmware Evidence: Descriptors, Tables, and Setters

Taking **Z 8 3.11** as reference:

| Structure | Photo | Video |
|---|---|---|
| Property Record EG Offset | `0x4c9f750` | `0x4c9f7e0` |
| Descriptor Constructor | `0x4084cc30` | `0x4084cf1c` |
| Setter Function | **`0x4084cd58`** | **`0x4084d044`** |
| Enum Conversion Table Address | `0x440f4d84` | `0x440f4dd8` |
| Setting Service Wrapper | `0x40856bcc` | `0x40856bcc` |
| Internal Setting ID Committed | `0x0600069A` | `0x06001254` |

Routines reference source file `PtpSubjectDetection.c`.
In firmware 3.11, the conversion table contains pairs `(0,0), (1,1), ..., (6,6)`. The conversion layer does not remap Birds (`5`) to Animal (`3`), nor Airplanes (`6`) to Vehicles (`4`).

Setter control flow:

```text
Load UINT8 property value
Search protocol-to-internal value lookup table
If not found: return 0x201C (Invalid_DeviceProp_Value)
If found: invoke setting service (Setting ID, converted value)
          update local property cache, return 0x2001 (OK)
```

Returning `0x2001` locally does not guarantee acceptance by the camera, as upstream permissions and downstream hardware configuration services were stubbed in emulation.

## Verification of the 1.01 to 2.00 Transition

| Firmware Release | Photo Setter | Video Setter | Accepted Values in Conversion Layer |
|---|---|---|---|
| 1.01 | `0x407fa2b4` | `0x407fa550` | `0, 1, 2, 3, 4, 6` |
| 2.00 | `0x4081b88c` | `0x4081bb28` | `0, 1, 2, 3, 4, 5, 6` |
| 2.01 | `0x4081b764` | `0x4081ba00` | Identical |
| 2.10 | `0x40823040` | `0x408232dc` | Identical |
| 3.00, 3.01 | `0x4084ca84` | `0x4084cd70` | Identical |
| 3.10 | `0x4084cd54` | `0x4084d040` | Identical |
| 3.11 | `0x4084cd58` | `0x4084d044` | Identical |

In 1.01, conversion tables include `(6,6)` while omitting `(5,5)`. Descriptor constructors expanded from 6 to 7 accepted values in 2.00. Internal setting IDs remained invariant.

In `RangeValue.config`, Z 8 `common` declares `1,2,3,4,6,0`; version `2.0` declares `1,2,3,5,4,6,0`, matching firmware observations.

## Correlation with Networks N1 and N2

Two stages are confirmed:

```text
PTP Properties 0x1D005 / 0x1D006
  → Property Validation & Value Mapping
  → Internal Settings 0x0600069A / 0x06001254

Model Loading & Dispatch
  → Vehicle Interface uses N1
  → Animal Interface uses N2
```

The bridge connecting active subject detection settings to runtime parameter generation remains unmapped. Bird detection (`5`) cannot be asserted to route to N2, nor Airplanes (`6`) to N1. Identical network hashes indicate that new recognition modes involve host processing, tracking policies, or auxiliary parameters.

Setting ID consumers in 3.11:

- `0x40da41b4–0x40da4278`: Reads photo/video settings in `CalcFaceBrightness.c` (brightness calculation).
- `0x40f3ead4–0x40f3eafc`: Reads video settings, writing to object `+0x464` in `CapabilityDataTable.c`.

## LiveView Output Structures

Z 8 documentation specifies `GetLiveViewImageEx=0x9428`, returning versioned metadata and JPEG frames. Versioned dataset fields:

| Offset (Bytes) | Length | Field Content |
|---:|---:|---|
| 0 / 2 | 2 each | Major / Minor version (2 / 1 in specification) |
| 8 / 12 | 4 each | Metadata length / Image data length |
| 16 / 18 | 2 each | Coordinate reference width / height |
| 20–26 | 4 × 2 | Display rect dimensions, center coordinates |
| 28 / 30 | 2 each | JPEG image width / height |
| 43 | 1 | AF Status (1 = Subject Detection AF active) |
| 44 / 45 | 1 each | AF target box count / Selected target index |
| 46 | 1 | Tracking Status |
| 48 + 8×i | 8 each | Target bounding box: width, height, center x, center y (4 × u16) |
| 1024 | Variable | Start of JPEG image payload |

Bounding box counts report `0..64` with 96 allocated box slots; selected target indices report `0..34`. These fields provide detection feedback rather than raw DSP tensor outputs.

## Reproduction and Emulation Bounds

Execute:

```sh
uv run python tools/reverse_z8_sdk_subject.py . --emulate-setters
uv run pytest
```

Across 8 releases × 2 properties × 256 UINT8 values, **all 4,096 test cases passed**.
Setting services were intercepted; USB sessions, hardware DSPs, and detection pipelines were not emulated.
