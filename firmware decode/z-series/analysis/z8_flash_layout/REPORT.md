# Z 8 3.11: EG Flashing Boundaries vs Sensor Parameter Storage Partition

The flash programming write boundary for standard EG firmware updates is confirmed as **`[0x40160000, 0x45980000)`**. The sensor parameter resource `0x5c` identified in earlier analysis resides at **`[0x47e80000, 0x47f80000)`**; these regions do not overlap.

This provides definitive evidence that standard EG updates do not overwrite sensor parameter storage: update routines select Resource 2, and the RAM flashing loop traverses only Resource 2's partition span. **Raw bytes for Resource `0x5c` remain unobtained; it cannot be determined whether alternative update channels service this block or whether it represents factory calibration data.**

Input: Z 8 3.11 `eg2070_0311b0.bi` (SHA-256 `f85e0138e2f5e660ece8560de62e0d12cb795e0e14983e50f20b61dce906c46c`).
Artifacts: [Reproduction Script](../../tools/reverse_z8_flash_layout.py), [Manifest](manifest.json), [Disassembly Landmarks](code_landmarks.asm).

## 1. Firmware Management Service Selects Resource 2

Initialization routine `0x41023014` executes:

```text
40d6b460(resource=2, output=0xa03e18da8)
```

In update target structure `0xa03e18da8`, offset `+8` contains base `0x40160000`, and `+0x18` contains partition allocation span `0x5820000`.

EG device update handler `0x41026598` queries Resource 2, verifies buffer alignment, pads inputs smaller than partition size with `0xff`, and invokes the flashing engine in RAM. The update covers the allocated partition span rather than the literal file size.

Resource descriptor parameters:

| Resource ID | Mapped Base Address | Descriptor Content Size | Partition Allocation Span |
| --- | --- | --- | --- |
| 2 (EG Update Target) | `0x40160000` | 0 (Unstated in descriptor) | `0x5820000` |
| `0x5b` | `0x47e80000` | `0x3cc000` | `0x700000` |
| `0x5c` (Sensor Params) | `0x47e80000` | `0xf2000` | `0x100000` |

Descriptors for `0x5b` and `0x5c` share base addresses with differing lengths. The manifest catalogs all 39 resource entries.

## 2. Flasher Code Operates from Relocated RAM

Primary code entry points act as trampolines into initialized RAM:

| Trampoline in ROM | Target in RAM | Purpose |
| --- | --- | --- |
| `0x40c01560` | `0xa02ab3dd4` | Store buffer pointer, callback, progress state |
| `0x40c016f0` | `0xa02ab3ed8` | Return flash loop address `0xa02ab3eec` |

The flash loop `0xa02ab3eec` advances in blocks of **`0x20000` bytes (128 KiB)**. Routine `0xa02ab30bc` processes blocks in units of 32-bit words; `0x8000` words correspond to one 128 KiB flash erase block.

## 3. Emulated Flash Address Trajectory

The flashing loop was emulated offline with hardware calls stubbed:

- 705 erase block invocations (blocks 11 through 715).
- 705 write block invocations (`0x8000` words per block).
- Erase addresses span `0x40160000` through `0x45960000` in 128 KiB strides.
- Programming writes blocks `0x40180000` through `0x45960000`, **writing initial block `0x40160000` last**.
- Termination address is `0x45980000`, stopping **37 MiB (`0x2500000`) before** sensor parameter base `0x47e80000`.

No blocks in Resource 2 overlap Resource `0x5c`.

## 4. Update Device Labeled "Ai" Targets Independent Region

Device update handler `0x41028cb8` invokes `0x40d6b1d0`, resolving target address `0x41273110` to **`0x46480000`**.
Code erases and programs a single 128 KiB block ending at `0x464a0000`, which also does not touch `0x47e80000`.
Filename `FirmwareManagement_Device_Ai.c` documents internal naming, without proving specific subsystem functionality.

## 5. Architectural Implications

Correlating with the [Sensor Inputs Survey](../z8_sensor_inputs/REPORT.md):
Sensor processing routines read parameters from Resource `0x5c`, copied from raw flash `0x47e80000` (`0xf2000` bytes). Standard EG updates write to an independent memory partition.
Standard updater files cannot be treated as full device flash dumps.

Execute:

```sh
uv run python tools/reverse_z8_flash_layout.py
uv run pytest
```
