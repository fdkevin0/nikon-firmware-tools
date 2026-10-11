# Nikon Z5 II 1.20: Partial Payload Recovery and Shared Position Mask

**Status: Partial recovery achieved; full-package decryption and CRC verification remain unresolved.**
Cross-model ciphertext XOR revealed two structurally complete CEVA DSP ELFs. Combined with verified Z 8 plaintext anchors, this reconstructed a position-dependent XOR keystream across raw file range **`0x16c7c14–0x1ea95b8` (8,264,100 bytes)**.
Within this window, 2,514,076 bytes beyond the Z5 II reference module were derived from other models' anchors rather than copied directly from Z 8; the first ~2.1 MB of this span matches Z 8 plaintext that was excluded from mask construction, validating the recovery.

## Samples and Reproduction

Target: [Official Nikon Z5II 1.20 Firmware](https://downloadcenter.nikonimglib.com/en/download/fw/601.html), local file `Z5_2_0120.bin`, 108,716,229 bytes, SHA-256:

```text
96fa8c2d735864c4c612dee498818f2e3b6911458b13ad55befcfe9ffdf35af9
```

Comparison baselines: `Z_f_0301.bin`, `Z6_3_0200.bin`, `ZR__0111.bin`, and CRC-verified Z 8 extraction artifacts. Sample hashes are listed in [manifest.json](manifest.json).

Execute from `firmware decode/z-series`:

```sh
uv run python tools/analyze_z5ii.py . --z8-directory analysis/Z_8_0311 --output analysis/Z5_2_0120
uv run pytest
```

Artifacts generated include recovered window binaries, offset-indexed strings, extracted ELFs, and symbol tables.

## Differential Analysis to Recovered Content

Z5 II shares the modern container framing (32-byte header, 128-entry table, reverse header, candidate directory) with comparison samples. Positional comparison yields:

| Baseline | Overlapping Bytes | Identical Bytes | Percentage | Longest Matching Span |
| --- | ---:| ---:| ---:| ---:|
| Z f 3.01 | 107,820,261 | 21,503,751 | 19.944072% | 4,007,164 |
| Z6III 2.00 | 108,716,229 | 15,013,802 | 13.810083% | 3,086,187 |
| ZR 1.11 | 108,716,229 | 12,683,627 | 11.666728% | 1,214,316 |

Pairwise XOR reveals structured content:

- `Z5 II XOR ZR` exposes string `..\SRC\FirmwareChkLib.c` at `0x4cb8140`. Surrounding region `0x4cb7e41–0x4cb87c4` (**2,435 bytes**) matches Z 8 EG `0x4a2a111–0x4a2aa94` byte-for-byte, including two Nikon lookup tables.
- `Z5 II XOR Z f` exposes firmware update, lens update, and logging strings near `0x28bd6ee`.
- `Z5 II XOR ZR` and `Z5 II XOR Z6III` reveal two structurally intact, identical ELFs at matching offsets.

These results validate the local model `C[file, offset] = P[file, offset] XOR K[offset]`.
Under this model, ciphertext XOR yields the difference between plaintexts; zero-fill in one file exposes the other. Unverified differential strings cannot be definitively assigned to Z5 II versus the baseline model.

## CEVA DSP ELF Artifacts

Saved in [differential_candidates](differential_candidates) alongside symbol CSVs:

| Raw Offset | Size (Bytes) | Symbols | Validation Basis |
| --- | ---:| ---:| --- |
| `0x15af864` | 691,804 | 4,059 | Pairwise diffs match; cross-checked against Z6III mask recovery |
| `0x16586c4` | 456,004 | 2,739 | Pairwise diffs match; identical to verified Z 8 second CEVA ELF |
| `0x16c7c14` | 5,750,024 | 34,678 | Reference-assisted recovery via Z 8 third CEVA ELF |

All three ELFs are ELF32, little-endian, `e_machine=245` (CEVA); `readelf -h -l -S -s` completes with zero errors. They represent embedded DSP executables, not host CPU code.

SHA-256 for the first two ELFs:

```text
6b89673f8596c4b3f57be3bbe39defe8de2388e624c344bb039a92dbc9f8fca6
de961025902457d6dab9cbb17eb832f9e441c1d685867b109bf354a8b81af2f4
```

In Z6III, these correspond to raw offsets `0x17a7544` and `0x18503a4`.

## Shared Position Mask Recovery and Scope

Using the verified third CEVA ELF from Z 8 (`c7787ceda602...`) as a known-plaintext anchor, candidate keystreams were calculated as `K = C XOR reference`:

| Model | Anchor Start | Anchor End (Exclusive) |
| --- | --- | --- |
| Z5 II | `0x16c7c14` | `0x1c4391c` |
| Z f | `0x16fe3a4` | `0x1c7a0ac` |
| Z6III | `0x18bf8f4` | `0x1e3b5fc` |
| ZR | `0x192d8b0` | `0x1ea95b8` |

Across the six overlapping spans (3,235,948 to 5,526,904 bytes), **all comparisons showed zero discrepancies**.
The merged keystream covers 8,264,100 bytes:

| Contributing Anchor Sources per Byte | Span Length (Bytes) |
| ---:| ---:|
| 1 | 673,612 |
| 2 | 3,680,928 |
| 3 | 673,612 |
| 4 | 3,235,948 |

Single-source edges depend on the assumption that the anchor module matches the Z 8 reference. The mask applies strictly to these fixed raw offsets and cannot be translated across other file regions.

Artifacts:

- `shared_position_mask.bin`: Keystream starting at raw offset `0x16c7c14`.
- `z5ii_reference_assisted_window.bin`: Decrypted window for Z5 II across this span.
- `z5ii_reference_assisted_window.strings.txt`: Extracted strings labeled with raw offsets.

Beyond the third ELF (`0x1c4391c–0x1ea95b8`), the mask was derived entirely from other models, recovering 2,514,076 bytes.
Within this, **2,126,137 bytes** (`0x1c4391c–0x1e4aa55`) match Z 8 EG continuously; this Z 8 region was **not used during mask construction**, serving as an independent validation check.
Strings in this window include `Darkent2Caffe`, `UserInputBuffer`, and convolution/pooling layer names.

## Open Problems

- Keystream generation algorithm and cryptographic keys remain unknown; complete unpacking is not yet possible.
- The candidate directory block cannot be decoded via legacy 3-table XOR across any phase.
- Section names, section boundaries, host CPU entry points, and container CRCs remain unverified.

All 24 unit tests pass; raw binaries remain unmodified.
