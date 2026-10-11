# Z 8 3.11: Sensor Parameter Loading and Capture Dimension Translation

This phase verified the RAM destination address and memory copy parameters for Resource `0x5c`, and traced the active dimension from capture contexts into backend mode selection. **Raw parameter bytes remain unobtained, full-height video readout remains unproven, and no Open Gate patch has been established.**

Key constraint: In the tested video request pipeline, out-of-bounds resolution values propagate through capture snapshot updates, but are converted to sub-mode 0 at the service adaptation layer, selecting backend mode 0. Expanding SDK whitelists or injecting unlisted dimension enums does not generate new readout windows.

Input: Z 8 3.11 `eg2070_0311b0.bi` (SHA-256 `f85e0138e2f5e660ece8560de62e0d12cb795e0e14983e50f20b61dce906c46c`).
Artifacts: [Reproduction Script](../../tools/reverse_z8_sensor_inputs.py), [Manifest](manifest.json), [Disassembly Landmarks](code_landmarks.asm). Full trace logs in `probes.json` (Git-ignored).

## 1. Resource Loading: Copy Parameters Verified, Payload Missing

The [Sensor Backend Survey](../z8_sensor_backend/REPORT.md) established that Resource `0x5c` spans `0xf2000` bytes under Group 38 base address `0x47e80000`. Executing the initialization prefix `0x40d70dbc` confirms that it writes fallback pointer **`0xa155d78c0`** into the resource descriptor.

Loading call chain:

```text
40d6bff4(0x5c)
  → 40d6c320 (Prepare load descriptor)
  → 40d702bc → 40d70370 (Verify group end marker)
  → 40ca95fc(destination, source, length)
```

Verified parameters:

| Parameter | Value |
| --- | --- |
| Destination RAM Address | `0xa155d78c0` |
| Source Flash Address | `0x47e80000` |
| Copy Length | `0xf2000` (991,232 bytes) |

The partition allocates `0x100000` bytes; the group end marker address is computed by `0x40d70b4c` as **`0x47f7fffc`** (differing from payload termination `0x47f72000`). The verification routine expects magic constant `ENDM`.

Emulation results:

1. Leaving the source unmapped triggers an unmapped access fault at `PC=0x40d70468` when reading `0x47f7fffc`.
2. Mapping the trailer page with synthetic constant `ENDM` and stubbing the copy routine allows the loader to return 1, after which resource queries return the populated RAM pointer.

This confirms the loader parameter sequence, without obtaining the raw parameter payload.

## 2. Active Dimension to Backend Request Translation

In the capture context, active dimension resides at `+0x38c`, sourced from DataID `0x0400211e`. The context constructor `0x40f28488` is called via `0x40f79348 → 0x40ec78cc`.

**Settings snapshots and active capture contexts are separate structures.** While both store active dimension at `+0x38c`, adjacent offsets diverge:

| DataID | Settings Snapshot Offset | Construction Cache Offset | Active Capture Context Offset |
| --- | --- | --- | --- |
| `0x0400211e` (Active Dimension) | `+0x38c` | `+0x168` | `+0x38c` |
| `0x04002120` | `+0x39c` | `+0x16c` | `+0x390` |
| `0x2171` (Framerate Enum) | `+0x3a0` | `+0x170` | `+0x394` |
| `0x0400211b` | Unused here | `+0x174` | `+0x398` |
| `0x2124` | `+0x3b4` | `+0x180` | `+0x388` |
| `0x2869` | Unused here | `+0x3f8` | `+0x3a0` |

List `0xa02a4c360` contains 11 DataIDs: `218c, 2124, 2167, 0400211e, 04002120, 2171, 0400211b, 2312, 2869, 286a, 286b`. Constructor `0x40f28488` reads these via transaction helper `0x40f23658`, buffers them, and writes them to context offsets.

Control flow:

```text
DataID 0x0400211e
  → 40f28488 Buffering and field reordering → Context ctx+0x38c
Capture Context ctx
  ├─ 40f88a78 → 40f889a8 → 410666f8 → ctx+8 (Derived selector)
  └─ 40f81cc4 → 41034fa4
       → 41031da0: ctx+0x38c → source+0x3c
       → 40f4e108 → 40f5bfd8
       → 40f5c18c…40f5c22c: source → request
       → 41158850: request → 411717f4 → working_config+0
```

Routine `0x41031da0` copies `ctx+0x38c` to `source+0x3c`. The service layer converts it via 6-entry table `0xa029d8ed0`:

| Active Dimension Enum | Sub-Mode Written to Request `+0x1c` |
| --- | --- |
| 1 | 1 |
| 2 | 2 |
| 3 | 3 |
| 4 | 2 |
| 5 | 2 |
| 6 | 3 |
| 0 or > 6 | 0 |

Dimension enums are not passed raw as backend modes. The service combines request fields `+0` and `+4` with this sub-mode in selector `0x411717f4` to determine the working mode.

Under `ctx+0=1`, request `+0=5`. Sub-mode 0 in this branch causes `0x411717f4` to return backend mode 0.
Testing 1,134 permutations across DataIDs `0x2869` (0..6), `0x2124` (0..8), `0x04002120` (0/6), and dimension enums (0..7, `0x7fffffff`) confirmed that dimension values 0, 7, and `0x7fffffff` universally resolve to sub-mode 0 and backend mode 0.

## 3. Generating Backend Modes from Stock SDK Video Configurations

Executing authentic SDK setters and forwarding settings snapshots to registered callbacks:

| Registered Node | Callback | Target Data |
| --- | --- | --- |
| `0x06001206` | `0x40f1ae50` | File type `0x2312`, codec family `0x2869` |
| `0x0400211e` | `0x40ee0070` | Active dimension |
| `0x04002120` | `0x40ee02bc` | Backend framerate selector and output framerate `0x2171` |
| `0x07001201` | `0x40ee1924` | Crop area selectors `0x2124`, `0x219f` |

Internal file types map to codec families as follows:

| Internal File Type | Codec Family `0x2869` / Context `+0x3a0` |
| --- | --- |
| H.264 MP4 (1) | 0 |
| H.265 8-bit (2) | 1 |
| H.265 10-bit (3) | 1 |
| ProRes 422 HQ (4) | 2 |
| ProRes RAW (5) | 3 |
| N-RAW (6) | 4 |

Results across the 19 authentic N-RAW modes:

| N-RAW Resolution | Framerate Labels | Crop `0x2124` | Derived Selector `ctx+8` | Backend Mode |
| --- | --- | --- | --- | --- |
| 8256×4644 | 60, 50, 30, 25, 24 | 4 | 4 | 7 |
| 5392×3032 | 60, 50, 30, 25, 24 | 5 | 5 | 13 |
| 4128×2322 | 120, 100, 60, 50 | 4 | 8 | 15 |
| 4128×2322 | 30, 25, 24 | 4 | 4 | 9 |
| 3840×2160 | 120, 100 | 7 | 6 | 16 |

Framerates operate at two levels: `0x04002120 → ctx+0x390` and `0x2171 → ctx+0x394` match in standard modes, but diverge in H.264 slow-motion modes (where output framerate labels 30/25/24 correspond to sensor capture enums 0/1/0, denoting 120/100/120 fps).

## 4. Correction to Framerate Field Interpretation

Earlier documentation misidentified DataID `0x2171` / Settings Snapshot `+0x3a0` as a video container type. **This field represents the active framerate enumeration.** In the active capture context, the corresponding offset is `+0x394`.

Evidence:

- Snapshot updater `0x40f3f3e0` stores `0x2171` to snapshot `+0x3a0`.
- SDK getter `0x40841bfc` reads `0x0400211e`, `0x2171`, and `0x2170`, passing them to packager `0x40811da4`.
- Packager `0x40811da4` converts parameter 2 via table `0x440f0398`, writing it to bits 16..23:

| Internal Framerate Enum | SDK Framerate Label |
| --- | --- |
| 0 | 120 |
| 1 | 100 |
| 2 | 60 |
| 3 | 50 |
| 4 | 30 |
| 5 | 25 |
| 6 | 24 |

All 7 mappings were validated against stock functions.

## 5. Reproduction

Execute:

```sh
uv run python tools/reverse_z8_sensor_inputs.py
uv run python tools/reverse_z8_capture_state.py
uv run pytest
```

Requires `capstone` and `unicorn`. The script verifies firmware SHA-256 before running bounded emulation test cases.
Standard EG firmware updates do not overwrite the flash partition for Resource `0x5c` ([Flash Layout Report](../z8_flash_layout/REPORT.md)).
