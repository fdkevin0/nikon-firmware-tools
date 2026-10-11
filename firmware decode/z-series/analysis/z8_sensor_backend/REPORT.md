# Z 8 3.11: CaptureSensor Backend Mode and Parameter Command Blocks

This investigation advances to backend mode selection and command byte-stream entry points within the CaptureSensor subsystem, identifying parameter resource block `0x5c`. **Full-height video readout configurations remain unconfirmed, and no Open Gate patch has been established.**

Unlike the [Capture State Survey](../z8_capture_state/REPORT.md), this analysis provides dataflow evidence from event callback registrations, parameter binding, and transport routines, definitively identifying backend sensor modules. However, the complete mapping from high-level video configurations to this backend mode representation remains unresolved. Dimension enumerations or ImageInfo geometry mode IDs from earlier phases cannot be mapped directly to backend mode IDs.

## Samples and Generated Artifacts

- Input: Z 8 3.11 `eg2070_0311b0.bi`
- SHA-256: `f85e0138e2f5e660ece8560de62e0d12cb795e0e14983e50f20b61dce906c46c`
- [Reproduction Script](../../tools/reverse_z8_sensor_backend.py), [Manifest & Selection Tables](manifest.json), [Disassembly Landmarks](code_landmarks.asm)
- `probes.json` contains full local execution trace logs (Git-ignored).

Code mappings use EG file offset plus `0x40160000`; initialized RAM follows previously validated mappings. All results derive from isolated AArch64 emulation without camera connections, firmware modification, or hardware packet transmission.

## 1. Module Identification Landmarks

In the module descriptor table, EG file offset `0x4ccb5e0` (runtime `0xa029c05e0`) begins with `0x02010000`, labeled `CaptureSensorSer`. Dataflow landmarks confirm its role:

1. Service initialization at `0x40f588bc–0x40f588cc` registers routine `0x40f58a44` with backend handler `0x411540ac`.
2. The backend stores this callback at `0xa0496f258`; routine `0x41151b50` formats event `0x0201000a` and invokes the service callback through this pointer.
3. Callback `0x40f58a44` dispatches events `0x02010001…0x0201000e`, configuring internal state flags and signaling OS tasks.
4. Initialization at `0x40f5893c–0x40f58944` queries resource `0x5c` and calls `0x411540f4 → 0x41166d54`, saving the returned pointer to `0xa0496f6a0`. Both backend timing calculations and command construction read from this pointer.

Service-level invocations of configuration entry `0x41158850` originate from `0x40f54544`, `0x40f5a880`, `0x40f5c3b8`, and `0x40f5e8e0`, populating working configuration structure `0xa029bdce8`. Application routine `0x41158c04` then executes timing calculations and command dispatch over this configuration.

## 2. Request Structure to Backend Mode Mapping

Routine `0x41158850` constructs a transient structure from the request block, calling pure selector function `0x411717f4`, and writing the return value to working configuration `+0` at `0x411588f8`:

| Request Block Offset | Selector Input Offset | Verified Role |
| --- | --- | --- |
| `+0x00` | `+0x00` | Top-level branch selector (handles values 0..8) |
| `+0x04` | `+0x04` | Secondary selector parameter |
| `+0x1c` | `+0x0c` | Sub-branch selector under top-level branch 5 |
| Unset (zero-initialized) | `+0x20`, `+0x2c`, `+0x2d` | Extended selector flags available to other callers |

Selector function output examples (with extended flags set to zero):

| Input `+0` | Input `+0xc` | Input `+4` Condition | Returned Backend Mode |
| --- | --- | --- | --- |
| 0 | Any | Equal to 2 | 4 |
| 0 | Any | Other | 0 |
| 2 | Any | Any | 20 |
| 5 | 1 | 5 / 6 / 7 / 8 | 18 / 16 / 17 / 17 |
| 5 | 2 | 4 / 5 / 6 / 7 / 8 | 9 / 13 / 16 / 14 / 15 |
| 5 | 3 | Equal to 8 / Other | 15 / 7 |
| 6 | Any | Any | 21 |
| 7 | Any | Any | 22 |
| 8 | Any | 0 / 4 / Other | 2 / 7 / 14 |

Out-of-range top-level inputs return 0. **Mode 0 represents a valid operational branch output; returning 0 must not be assumed to indicate an error state.**

Routine `0x411679dc` maps backend mode IDs (0..22) to command table column indices (values >= 23 return `0xffff`):

```text
Mode:   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22
Column: 0  1  1  1  2  3  4  5  4  5  6  7  8  9  6  7 10  7  9 11 12 13 14
```

A separate routine `0x41167e40` selects timing parameter rows, with outputs diverging from the column indices above. Mode 0 is additionally modulated by a second parameter.

## 3. Parameter Resource Block 0x5c

Resource resolution sequence:

```text
40f58940: get_resource(0x5c)
  → 40d6b4f4
  → 40d6cc6c or 40d6cc94 (runtime dependent)
  → 40d712c8 (Resource Descriptor) / 40d712ac (Partition Descriptor)
40f58944: bind_parameter_pointer(result)
  → 411540f4 → 41166d54 → [a0496f6a0]
```

Resource descriptor `0xa0291da88` specifies: ID `0x5c`, Group 38, Group Offset 0, Content Length **`0xf2000` (991,232 bytes)**, fallback pointer 0. Group descriptor `0xa0291e0a8` assigns base address **`0x47e80000`**.

Under zero-initialized baseline state, the authentic query resolves to `0x47e80000`, copied to the backend pointer. This validates descriptor resolution, without proving that physical hardware always uses this address.
This address lies outside the EG direct mapping and initialized RAM regions. Parameter storage payload remains unobtained.

## 4. Command Selection Pipeline

Dispatch sequence in `0x41166d6c(command, working_config)`:

1. Translates working configuration `+0` mode to column index.
2. Reads byte at `0xa02a99e70 + command × 15 + column`. A value of `0xff` indicates the combination is inactive (function returns 1).
3. For commands 0..46, dispatches via jump table `0xa02a990b0`.
4. Derives pointers to command byte-stream data, length arrays, or dynamic packet buffers from the parameter block.
5. Routine `0x41167b7c` reads the 16-bit length array and streams byte buffers sequentially to transport handler `0x41177e0c`, terminating when length is zero.

For example, Command 5 resolves to `parameter_base + 0xe5810 + matrix_value × 0x1b0`, with length array at `parameter_base + 0xe79d0`:

| Backend Mode | Matrix Value | Command 5 Data Offset | Length Array Offset |
| --- | --- | --- | --- |
| 0 | 0 | `0xe5810` | `0xe79d0` |
| 9 | 5 | `0xe6080` | `0xe79d0` |
| 16 | 10 | `0xe68f0` | `0xe79d0` |
| 21 | 13 | `0xe6e00` | `0xe79d0` |
| 22 | 14 | `0xe6fb0` | `0xe79d0` |

These offsets point to unpopulated parameter buffers. Specific register commands controlling vertical readout windows remain unmapped.

Routine `0x41171e88` calculates `u16(config+0xea) × u16(config+0xf6) / 72`, representing internal timing ratios rather than pixel spatial dimensions.

## 5. Emulation Verification Matrix

Execute:

```sh
uv run python tools/reverse_z8_sensor_backend.py
uv run pytest
```

- 500 request mappings (top-level 0..9, secondary 0..9, sub-branch 0..4).
- 7 extended flag branches (verifying table boundaries and direct return paths).
- 24 backend IDs (0..22 valid, 23 out-of-bounds) verified against static column tables.
- 864 command permutations (36 address-calculation commands × 24 modes): 784 reached transport dispatch, 80 skipped by selection logic.
- Transport entry points intercepted; zero return reflects stub success rather than physical hardware acknowledgement.
- All derived data/length array offsets fall within descriptor-declared span (`0xf2000`).

## Next Steps

See [Sensor Inputs and Geometry Adaptation](../z8_sensor_inputs/REPORT.md) for parameter loading and dimension translation analysis:

1. Trace Group 38 / Resource `0x5c` bootloader copying to recover parameter data.
2. Bridge CaptureInformation dimensions to service requests (e.g., via entry point `0x40f5bfd8 → 0x40f5c18c → 0x40f5c3b8`).
3. Evaluate vertical window, line timing, and buffer constraints against RAW encoders.
