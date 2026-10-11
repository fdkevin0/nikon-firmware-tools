# Z 8 C 3.11: NFDG Read-Only Diagnostic Entry Point Experiment

A read-only diagnostic entry point returning invariant identity and patch version strings has been implemented. A complete experimental firmware package embedding new AArch64 machine code was built and verified via offline CPU emulation and package checksums. **This binary has not been flashed to hardware or tested on an authentic device boot cycle.**

This experiment applies exclusively to Z 8 C 3.11 (`Z_8_0311.bin`).

## Interface Specification

| PTP Request Field | Value |
|---|---|
| ContainerType | `1` (Command Block) |
| OperationCode | `0x94FD` |
| TransactionID | Assigned by host PTP session; echoed in response |
| Parameters | `[0xF0FF, 0, 0, 0, 0]` |
| Container Length | 32 bytes |
| Data Phase | None |

Sub-opcode `0xF0FF` is custom-defined for this experiment (not present in the stock 182-entry vendor table). The hook intercepts this code at the generic pre-check entry point, leaving stock dispatch tables untouched.

Response: 32-byte PTP Response Block, outer response code `0x2001`:

| Parameter Index | Value | Meaning |
|---|---|---|
| 1 | `0x2001` | Internal Status OK |
| 2 | `0x4744464E` | ASCII string `NFDG` (Little-endian) |
| 3 | `0x00010000` | Patch version 1.0.0 (`major<<16 | minor<<8 | patch`) |
| 4 | `2070` (Decimal) | Model identifier (Z 8) |
| 5 | `0x0311` | Base firmware version (C 3.11) |

Length != 32 returns outer error `0x2006`; ContainerType != Command or non-zero reserved parameters return `0x201D`. Requests matching `0x94FD` + `0xF0FF` are intercepted; all other operations fall through to stock handlers.
The diagnostic command does not require or modify the proprietary service session flag (`0xF001`).

## Implementation and Code Placement

Source files: [AArch64 Assembly](../../tools/patches/z8_0311_diagnostic.S), [Build Tool](../../tools/build_z8_diagnostic.py), [Verification Script](../../tools/verify_z8_diagnostic.py), [Protocol Helper](../../tools/z8_diagnostic_protocol.py).

- Replaces `sub sp, sp, #0x50` at `0x407FE27C` with a direct branch instruction.
- Payload routine (**184 bytes**) resides at EG file offset `0x1143200` (virtual address `0x412A3200`).
- Non-diagnostic requests execute the replaced stack allocation instruction and branch back to `0x407FE280`.
- Diagnostic requests invoke response builder `0x407DF0D4` and return 0 (signaling response ready, suppress downstream handlers).

Placement criteria: The target resides within the code mapping range (`0x8000` length `0x14DEFE4`) in the same 4 KiB page as `RET @ 0x412A31F0`. Disassembly and pointer scanning across the 512-byte padding block revealed zero existing references.

## Container Packaging and Checksums

Only the branch instruction, 184-byte payload, and EG section CRC are modified. The container CRC and header SHA-1 (`SHA1(package || K8)`) are recomputed, followed by standard 3-table XOR re-encoding. Section lengths, directory structure, and the four remaining sections remain byte-identical.

| Binary Artifact | SHA-256 |
|---|---|
| Original `Z_8_0311.bin` | `d67413c2ede6b9ce8887175f20700bd9fbad2a973a4820968c45503d15d80d96` |
| Experimental Package | `b7a80c0ff0cd08eea7bda2c4647f70bb114f60909b53ef877c7deb4605d14e9c` |
| Modified EG Section | `d4d6f68ff25813f72412dea295c39685615ae30f7fbbbe35cfffef37132f9c50` |

Experimental package: `Z_8_0311_diagnostic_EXPERIMENTAL.bin` (99,051,117 bytes). Manifest in [manifest.json](manifest.json); modified opcodes in [code_landmarks.asm](code_landmarks.asm).

## Verification Results

| Test Category | Results |
|---|---|
| 182 stock sub-opcodes across 3 outer opcodes / states | 1,724 differential tests passed |
| Diagnostic command across TransactionIDs and states | 16 test cases passed |
| Malformed requests (lengths, container types) | 21 test cases passed |
| Callee-saved register and stack restoration | Verified |
| Read-only image constraint during emulation | Verified |
| 5 section CRCs, package CRC, header SHA-1 | All passed |
| Automated pytest suite | 46 tests passed (including 6 new test cases) |

Package decoding was independently verified using NumPy decoders and K8 derivation routines.

## Reproduction

Execute:

```sh
uv run python tools/build_z8_diagnostic.py --firmware Z_8_0311.bin --output /tmp/z8-diagnostic-rebuild
uv run pytest
```

Protocol validation (offline):

```sh
uv run python tools/z8_diagnostic_protocol.py request --transaction-id 1
uv run python tools/z8_diagnostic_protocol.py decode   200000000300012001000000012000004e464447000001001608000011030000   --transaction-id 1
```
