# Z 8 3.11: Proprietary PTP Sensor Parameter Resource Read Pipeline

The read dispatch branch for sensor parameter resource `0x5c` has been located and emulated offline through dispatching, session state validation, resource lookup, and handler execution. **The transport send function receives source address `0xa155d78c0`; raw parameter bytes remain unobtained.** No camera hardware was connected, and no write/flash operations were performed.

Input sample: Z 8 3.11 `eg2070_0311b0.bi` (SHA-256 `f85e0138e2f5e660ece8560de62e0d12cb795e0e14983e50f20b61dce906c46c`).
Artifacts: [Reproduction Script](../../tools/reverse_z8_ptp_resources.py), [Probe Manifest](manifest.json), [Disassembly Landmarks](code_landmarks.asm).

## 1. Outer Operations vs Internal Sub-Commands

Beginning at `0x440ec590`, a table contains 182 internal command descriptors (48 bytes each), followed by a zero terminator. Query routine `0x407fe078` searches by 16-bit internal ID.

Internal command `0xf029` resides at `0x440ec830`: pre-check `0x407ffc6c`, handler `0x407ffd54`. **Internal IDs must not be confused with USB PTP opcodes.** The outer read descriptor resides at `0x44df28a0` with PTP opcode `0x94ff`, using wrappers `0x407fe160` and `0x407fe168`. Outer dispatch extracts the internal command ID from offset `+0x0c` of the request structure.

## 2. Resource Read Parameters and Validation Boundaries

Internal command `0xf029` utilizes the following request fields:

| Field | Offset | Verified Function |
|---|---|---|
| Internal Command ID | `+0x0c` | `0xf029` |
| Resource Byte Offset | `+0x10` | 32-bit unsigned offset |
| Read Length | `+0x14` | 32-bit length (pre-check requires non-zero) |
| Resource Selector | `+0x18` | `0..7` |

Jump tables in the pre-check and handler map selectors to resource IDs:

| Selector Index | Resource ID |
|---|---|
| 0 | `0x5c` |
| 1 | `0x52` |
| 2 | `0x4d` |
| 3 | `0x5b` |
| 4 | `0x0b` |
| 5 | `0x0c` |
| 6 | `0x4a` |
| 7 | `0x5a` |

Resource query `0x40d6b460` returns RAM pointer, mapped address, content length, and allocation length. Pre-checks validate against **content length**; the handler passes **RAM pointer + request offset** to transport transmit routine `0x407df2c4`.

Resource `0x5c` reports content length `0xf2000` (991,232 bytes) and allocated span `0x100000`. Offline boundary test results:

| Offset / Length / Selector | Pre-Check Result |
|---|---|
| `0 / 0 / 0` | Rejected |
| `0 / 0xf2000 / 0` | Passed |
| `0xf1fff / 1 / 0` | Passed |
| `0xf2000 / 1 / 0` | Rejected |
| `0 / 1 / 8` | Rejected |
| `0x100 / 0x40 / 0` | Passed (Source: `0xa155d79c0`) |

Passing pre-checks confirms bounds-checking behavior, not that physical USB transfers will succeed in an arbitrary state.

## 3. Session State and Initialization Prerequisites

Initialization routine `0x407fe4f0` registers state query function `0x407fe524`, which inspects a flag at `0xa047d9fc8`:

- If flag == 0: `0xf029` is rejected with response code `0xa004`.
- If flag == 1: Proceeds to command-specific pre-checks.
- Command `0xf001` serves as the entry exception to initialize this flag.

In initial binary state, resource RAM pointers are zero. Executing pointer initialization sequence `0x40d70dbc..0x40d70f88` populates `0xa155d78c0`. In this probe, parameter loaders were not invoked and real parameter content was not mapped. Transport routines were intercepted to record target addresses.

Correlating with the [sensor loader analysis](../z8_sensor_inputs/REPORT.md), the bootloader copies parameters from flash offset `0x47e80000` to this RAM location.

## 4. Constraints on Direct Memory Read Paths

Internal command `0xf032` concatenates two 32-bit fields to construct a memory address. Pre-check `0x408008a4` enforces lengths `1..1024` and invokes range validation `0x40800918`:

| Address / Length | Pre-Check Result |
|---|---|
| `0x47e80000 / 16` | Rejected |
| `0x47f7fffc / 4` | Rejected |
| `0x40160000 / 16` | Rejected |
| `0xa155d78c0 / 16` | Passed |
| `0xa155d78c0 / 1024` | Passed |
| `0xa155d78c0 / 1025` | Rejected |

Directly targeting raw flash addresses is blocked by security boundaries, while targeting RAM resource buffers is permitted.

## 5. Reproduction

Execute:

```sh
uv run python tools/reverse_z8_ptp_resources.py
uv run pytest
```

The script verifies input hashes, tests the 8 selector mappings, closed-session rejection, boundary limits, and address ranges.
