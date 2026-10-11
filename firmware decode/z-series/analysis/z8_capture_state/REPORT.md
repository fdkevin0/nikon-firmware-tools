# Z 8 Open Gate Investigation: N-RAW Resolution Pipeline into CaptureInformationService

This phase connected video mode configurations from the [earlier study](../z8_open_gate/REPORT.md) to active resolution update callbacks and internal capture state structures. **N-RAW resolution setting `0x0500125a` triggers generation of DataID `0x0400211e`, which is written to state structure offset `+0x38c`. This pipeline transmits discrete enumeration IDs rather than arbitrary pixel geometries, and does not execute sensor readout routines.**

Across 80 stock Nikon SDK video modes, resolution configurations route through this pipeline; injected test values `7` and `0x7fffffff` propagate identically. This demonstrates that successful return codes from configuration functions do not guarantee valid video capture. No updater patches were created.

## Connected Control Flow

```text
SDK 0xD0A0 Video Mode Configuration
  └─ N-RAW Size 0x0500125a / ProRes RAW Size 0x0500125b
       └─ CaptureInformationService Settings Snapshot
            └─ Registered Callback 0x40ee0070
                 └─ 0x40ed8f74 Resolution Selector
                      └─ Update Queue: (0x0400211e, resolution_enum)
                           └─ DataID Storage (Committed via Test Harness)
                                └─ 0x40f3911c Update Capture Snapshot +0x38c
                                     └─ ImageInfoService Geometry Input
```

In the sequence above, "Committed via Test Harness" denotes the emulation boundary: callbacks and queue insertions execute authentic instructions, while transaction locks and event notifications are simulated. Downstream DataID reads and capture snapshot updates execute authentic code.

## Memory Mappings and Structural Correspondence

Input sample: Z 8 3.11 EG (`eg2070_0311b0.bi`, SHA-256 `f85e0138e2f5e660ece8560de62e0d12cb795e0e14983e50f20b61dce906c46c`). Addresses represent runtime virtual addresses.

Routine `0x40ed3b14` passes three RAM pointers to `0x40f38e58`, which populates settings snapshot `0xa03b98570` with **763 entries** from ID array `0xa0292a624`, alongside internal state snapshot `0xa03b9915c`. Routine `0x41012cf0` reads each 4-byte DataID sequentially:

| Snapshot Offset | DataID | Identified Role |
|---|---|---|
| `+0x90` | `0x06001206` | Current video container type setting |
| `+0x278` | `0x0700124b` | H.265 8-bit resolution |
| `+0x27c` | `0x0700124d` | H.265 10-bit resolution |
| `+0x280` | `0x0700124f` | ProRes 422 HQ resolution |
| `+0x284` | `0x07001202` | H.264 resolution |
| `+0x288` | `0x0500125b` | ProRes RAW resolution |
| `+0x28c` | `0x0500125a` | N-RAW resolution |
| `+0x38c` | `0x0400211e` | Effective video resolution enum |
| `+0x3a0` | `0x00002171` | Effective frame rate enum (Confirmed via SDK read paths in [Sensor Inputs Survey](../z8_sensor_inputs/REPORT.md)) |

The registration descriptor for `0x0400211e` resides at EG file offset `0x4d343e8` (RAM address `0xa02a293e8`). Offset `+0x20` specifies callback **`0x40ee0070`**; `+0x10` references a 47-entry dependency list including N-RAW/ProRes RAW resolutions and operational flags.

The callback inspects offset `+0x90` and passes resolution values for 6 codecs to `0x40ed8f74`. Under N-RAW, register `w6` is selected (corresponding to snapshot `+0x28c`). Updates are enqueued via **`0x40ed3e24`**.

DataID storage for effective resolution resides at `0x440179d0` (type 9, pointer `0xa03d7c778`). Routine `0x4101553c` reads from this pointer. Capture state updater `0x40f3911c` branches at `0x40f3ebdc`, writing the value to output snapshot `+0x38c` at `0x40f3ec00`.

Routine `0x4105c138..0x4105c188` copies from capture context `+0x38c` to structure offset `+0x20`, invoking resolution constructor `0x41066aa8`. Subsequent [Context Constructor Analysis](../z8_sensor_inputs/REPORT.md) confirmed that settings snapshots and capture contexts are distinct structures with different layouts.

Strings in this region reference `ImageInfoService.c`, reinforcing the conclusion that full-height constants in geometry routines relate to image metadata processing rather than unconstrained sensor readout configurations.

## Isolated Verification Results

Baseline state: Snapshot offset `0x280c` = 1; container type, resolution, and frame rate populated from authentic SDK configuration outputs; initial effective size = `0xffffffff`.

| Test Condition | Result |
|---|---|
| 80 stock SDK video modes | Settings output correctly triggers resolution callback, queueing, DataID read, and snapshot update |
| Injected N-RAW size values `7` and `0x7fffffff` | Propagate unmodified into `0x0400211e` and snapshot `+0x38c` without bounds rejection |
| Existing resolution equals computed result (`6`) | Returns success without redundant queue insertion |
| Queue capacity = 0 | Returns failure without queue corruption |
| Authentic registry lookup | Resolves `0xa02a293e8`, matching extracted descriptor |

Propagation of unlisted enum values indicates lack of early validation rather than the presence of hidden capture modes.

## Registered Dependency Tables

A total of **669 registration entries** beginning at `0xa02a28ff8` were extracted.
**21 entries** explicitly reference N-RAW size `0x0500125a` in their dependency lists.
Field `0x04001dc8` possesses a registration descriptor without callbacks, referencing effective size, frame rate, and multiple capture properties.

Hardware register configuration, sensor timing, and raw buffer allocation remain unmapped.

## Reproduction

Execute:

```sh
uv run python tools/reverse_z8_capture_state.py
uv run pytest
```

Artifacts:

- [manifest.json](manifest.json): Mappings, callback records, 21 N-RAW dependency records, and test results.
- [code_landmarks.asm](code_landmarks.asm): Key functions and disassembly snippets with SHA-256 hashes.
- `registry.json`: Extracted 669 registration records (Git-ignored).

See subsequent report: [CaptureSensor Backend Mode and Parameter Blocks](../z8_sensor_backend/REPORT.md).
