# Z 8 In-Depth Reverse Engineering: Host Processor and DSP Model Loading Interface

Target: Nikon Z 8 C 3.11, cross-validated across all eight acquired Z 8 firmware releases. Full SHA-256 hashes of raw binaries and EG sections were verified. Analysis advances from binary hash comparisons to **AArch64 host-side resource loading, model dispatch tables, initialization structures, and inference request submission**.

## Key Findings

1. **Serialized network N1 corresponds to the host vehicle detection API; N2 corresponds to the animal detection API.** This mapping is demonstrated by consistent dataflow across resource loaders, query functions, initialization descriptors, and DSP symbol tables.
2. **Network payload sizes are independently confirmed by host executable constants**: Memory copy routines receive lengths `0xfe9b0` (N1) and `0x108770` (N2), matching the candidate boundaries deduced from network headers.
3. **Dispatch slot renumbering from 1.01 to 2.00 occurred synchronously across both the host CPU and DSP**: Animal detection shifted 30→31, vehicle detection 31→32, and initialization 28→29.
4. **The 0x48-byte initialization structure and DSP request framing were reconstructed for Z 8 3.11**, identifying submission queues and completion callbacks for animal/vehicle detection.
5. **144 isolated AArch64 emulation runs validated selector behaviors.** DMA and ELF loader calls were intercepted without running camera hardware.

## Mapping and Methodological Rules

The EG boot base address `0x40160000` was validated from boot literals and descriptor tables. Initialized data copies from file offset `0x4b13000` to RAM address `0xa02808000`.

The host executable constructs 64-bit absolute pointers via 4-instruction `MOVZ/MOVK` sequences. A specialized scanner reconstructed these constants, using Capstone to verify that intermediate instructions do not clobber target registers or span unconditional branches.

Function names are analytical labels, while DSP API names reflect authentic symbol strings in embedded ELFs. Artifacts are cataloged in [manifest.json](manifest.json) and [code_landmarks.asm](code_landmarks.asm).

## Resource Loader: 3 DSP Executables, 2 Active Networks

The resource loader resides at **`0x40c91f3c`**, dispatched via a 6-entry jump table at `0x4167ca68`. Initialization routine `0x40c91f08` sets global base pointer `0xa02e803e0` to **`B = 0xa01800000`**, followed by 6 completion flags.

| Resource ID | Source EG Offset | Execution / Target Buffer |
|---:|---:|---|
| 0 | `0x151caa0` | Image Processing ELF; Execution base B, Data base B+`0x10000` |
| 1 | `0x15c5bd0` | Tracking ELF; Execution base B+`0x250000`, Data base B+`0x260000` |
| 2 | `0x1635120` | Neural Inference ELF; Execution base B+`0x4a0000`, Data base B+`0x4b0000` |
| 3 | `0x1bb0e30` | Points to N1 origin but specifies length **0**; Target B+`0xaf0000` |
| 4 | `0x1bb0e30` | N1; Copies `0xfe9b0` bytes to **`0xa02470000`** |
| 5 | `0x1caf7e0` | N2; Copies `0x108770` bytes to **`0xa025f0000`** |

Network copies validate that destination buffers fall within range `[0xa01800000, 0xa02800000)`. Memory copies use routine `0x40ca95fc`.

ELF loading helper **`0x40c92194`** parses ELF32 program headers, processing `PT_LOAD` segments: reading file offsets, virtual addresses, file sizes, memory sizes, and executable flags. Segments with memory size exceeding file size are zero-filled.

## Query Function Associates Networks with API Identifiers

Routine **`0x40c9233c`** accepts an API ID and output buffer pointers, returning the network RAM address and u32 length:

| Query Function ID | DSP ELF Symbol Target | Required Resource Flag | Returned Address | Returned Length |
|---:|---|---:|---:|---:|
| 31 | `CAnimalDetectionApi` | ID 5 | `0xa025f0000` | `0x108770` (N2) |
| 32 | `CVehicleDetectionApi` | ID 4 | `0xa02470000` | `0xfe9b0` (N1) |
| 23 | NOP in all 3 DSPs | ID 3 | B+`0xaf0000` | 0 |
| Unrecognized ID | — | — | 0 | 0 |

The host executable binds N1 to vehicle detection and N2 to animal detection.

Network SHA-256 hashes:

- N1: `1a14b38f7905898d4de87f477d7ec945f4cbcbdcd28482640f16cffc3e156a76`
- N2: `418f21fae72c525a7d9b598f0375b520464daeabda8018696e1db69405bb2541`

## Initialization Descriptor and Request Submission

Routine **`0x40fe85e4`** formats the initialization block: zeroing a `0x48`-byte structure, resolving both network buffers via the query function, and submitting function slot 29 (`CCdnnNetwork_Initialize`) under program index 2.

| Structure Offset | Populated Content |
|---:|---|
| `+0x00` | Constant `0x00010800` |
| `+0x08` / `+0x10` | N1 Address / Length (u64 each) |
| `+0x18` / `+0x20` | N2 Address / Length (u64 each) |
| `+0x28` / `+0x30` | Zero-initialized reserved fields |
| `+0x38` / `+0x40` | Workspace Address / Size (`0x384d00`) |

The workspace address applies alias function `0x41186780` (subtracting `0x400000000` for addresses > `0xc40000000`).

DSP request structures specify: program index `+0x00`, function slot `+0x08`, input/output pointers `+0x10/+0x18`, queue selection `+0x20`, completion callback `+0x28`, status `+0x30`. See [host_interface.h](host_interface.h).

Request submission paths:

- **Animal Detection: `0x40fe73c8`**: When parameter 3 == 1, builds program 2 / slot 31 request, dispatching to queue entry `0x40fe7508`.
- **Vehicle Detection: `0x40fe7b84`**: Under matching conditions, builds program 2 / slot 32 request, dispatching to queue entry `0x40fe7cbc`.
- **Queue Submission: `0x40c909a8`**: Selects state objects by program index and enqueues requests.
- **Completion Callback: `0x40fe86f8`**: Verifies message code `0x42180003`, dispatching completion events for slots 29, 31, and 32.

## Eight-Release Cross-Validation

| Firmware Release | Resource Loader | Network Query Function | Init / Release / Animal / Vehicle Slot IDs |
|---|---|---|---|
| 1.01 | `0x40a91560` | `0x40a91960` | 28 / 29 / 30 / 31 |
| 2.00 | `0x40c91ac8` | `0x40c91ec8` | 29 / 30 / 31 / 32 |
| 2.01 | `0x40c91b34` | `0x40c91f34` | 29 / 30 / 31 / 32 |
| 2.10 | `0x40c91bd4` | `0x40c91fd4` | 29 / 30 / 31 / 32 |
| 3.00, 3.01, 3.10, 3.11 | `0x40c91f3c` | `0x40c9233c` | 29 / 30 / 31 / 32 |

Resource mappings, lengths, and IDs are identical across all eight releases. The slot shift in the DSP was paired with an identical shift in the host CPU, reflecting API realignment rather than a weight update.

## Extracted Post-Processing Threshold Arrays

DSP symbols expose two `ClassEffectiveTh_Table` arrays (u16 little-endian):

- Animal Table: `941, 941, 801, 801, 801, 801, 941, 941, 801, 801`
- Vehicle Table: 8 entries, all `981`
- `OutmapSet_Table` (both instances): `24, 16, 2, 12, 8, 2`

Fixed-point scaling, class assignments, and runtime overrides remain unverified.

## Reproduction

Execute:

```sh
uv run python tools/reverse_z8_dsp_host.py . --emulate-selectors
uv run pytest
```

The script runs 144 emulation test cases (13 loader scenarios, 4 query scenarios, and 1 invalid scenario per release). All 40 unit tests pass.
