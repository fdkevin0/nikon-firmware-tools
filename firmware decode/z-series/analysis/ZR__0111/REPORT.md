# ZR__0111.bin Container Reverse Engineering: Phase 1

Analysis date: 2026-10-04 to 2026-10-05. Subject: Raw local firmware sample. No firmware was flashed, no camera hardware was accessed, and no patches were generated.

## Current Conclusions

**ZR 1.11 remains undecoded. Unlike Z 6 and Z 8, its directory cannot be recovered simply by adjusting the origin offset in the legacy 3-table XOR algorithm.**
This phase established the framing layout, evaluated the full phase space of legacy algorithms, analyzed block entropy patterns, and reverse-engineered the outer SHA-1 prefix verification routine from Z 8 code.

Confirmed structural features of ZR:

- The sole 32-byte sequence of ASCII spaces resides at raw offset `0x260` (contrasting with `0x20` in Z 6/Z 8).
- Offsets `0x220–0x23F` are the **exact bitwise reverse** of `0x00–0x1F`.
- Offsets `0x120–0x21F` contain 128 distinct little-endian 15-bit integers, all < `0x8000`.
- Treating `0x280` as a directory offset and testing all `2^24` phases of the legacy 3-table XOR scheme yields **zero valid phases** recovering expected reserved-zero fields.
- 457,653 aligned 256-byte blocks from `0x260` are all distinct even after subtracting per-block byte constants.

This refutes the assumption that the package can be unpacked simply by updating the header skip offset to `0x260`. However, **it does not determine specific ciphers (AES, RSA), key sizes, or operational modes**. Section names, CRCs, entry points, and filesystems remain unobtained.

## Sample Provenance and Metrics

| Parameter | Value |
| --- | --- |
| Local File | `ZR__0111.bin` |
| Length | 117,159,984 bytes (`0x06FBB830`) |
| SHA-256 | `de1eb5af56568e4921a0eb5e50942f06a6c00205f76dd9d2a4e42364d7476e93` |
| Global Entropy | 7.9999984259 bits/byte |
| Candidate Prefix Length | `0x260` (608 bytes) |
| Post-Space Length | `0x06FBB5B0` (117,159,344 bytes, divisible by 16) |
| Unpacking / CRC Status | Incomplete (container undecoded) |

The [Nikon Download Page](https://downloadcenter.nikonimglib.com/en/download/fw/584.html) lists this binary as ZR C 1.11; the [Nikon OSS Index](https://imaging.nikon.com/imaging/oss/en/) marks it with date 2026-03-17. The SHA-256 hash reflects the local file.

## Header Partitioning

Observed header boundaries:

| Raw Byte Range | Length | Observations & Context |
| --- | ---:| --- |
| `0x000–0x020` | 32 | Non-plaintext prefix; semantics unknown |
| `0x020–0x120` | 256 | Uninterpreted byte region; cannot be assumed to be an RSA signature based on length alone |
| `0x120–0x220` | 256 | 128 little-endian 15-bit integers (range 153 to 32,757) |
| `0x220–0x240` | 32 | Bitwise reverse of initial 32 bytes |
| `0x240–0x260` | 32 | Uninterpreted byte region; unverified key/IV/hash semantics |
| `0x260–0x280` | 32 | ASCII spaces (`0x20`), matching legacy container marker |
| `0x280–EOF` | 117,159,344 | High-entropy payload; directory undecoded |

Initial 32 bytes:

```text
420601f57f69308eab4d2a4ea3f486e256d93c6d8f165c968e99e4d20a029fb3
```

Reversed copy at `0x220`:

```text
b39f020ad2e4998e965c168f6d3cd956e286f4a34e2a4dab8e30697ff5010642
```

The 128 u16 integers comprise 66 even and 62 odd values; all values fall below `0x8000`. Tests against standard linear congruential generators (`214013*s+2531011` and `1103515245*s+12345` with `(state>>16)&0x7fff`) yielded no direct sequential matches.

## Evaluation of Legacy XOR Hypotheses

Legacy tools reject the file because spaces do not appear at offset `0x00` or `0x20`.
Decoding the region following `0x260` with legacy XOR tables yields:

```text
b13ea8e9b0efcba249b506772ae3ca88
```

This does not match a valid directory structure (`count, header_size, reserved_0, reserved_1`).
A complete sweep across all `16,777,216` phases of the legacy XOR tables against candidate directory `0x280–0x28F` yielded **zero matches** meeting the condition that reserved fields must equal zero. When applied to Z 8, the identical search locates the verified phase `0x20`.

Normalizing 256-byte blocks as `block[i] XOR block[0]` to remove constant offsets:

| Sample | Block Start | Full Blocks | Distinct Normalized Blocks | Max Repetitions |
| --- | --- | ---:| ---:| ---:|
| ZR 1.11 | `0x260` | 457,653 | 457,653 | 1 |
| Z 8 3.11 | `0x20` | 386,918 | 332,889 | 44,541 |

ZR exhibits no repeating block patterns of the type observed in Z 8.
The raw binary contains no unencrypted `ELF`, `NISI`, or DTB magic markers.

## Findings from Z 8 Reference Code

To investigate the new header, `FirmwareManagement` and `FirmwareChkLib` in the decoded Z 8 3.11 EG section were reverse-engineered. **Code in this section is extracted from Z 8, not decrypted from ZR.**

### The In-Firmware Legacy XOR Routine

The 3-table XOR loop resides at file offset `0x00EC49F4` (virtual address `0x410249F4`) in Z 8 EG. It skips the initial 32 bytes and uses the low, middle, and high bytes of the offset to index three tables located at `0x03F63CB0`. These tables differ from the repository tables by constant XOR offsets:

```text
Table A offset: 0x40
Table B offset: 0xCB
Table C offset: 0x8B
0x40 XOR 0xCB XOR 0x8B = 0
```

Combined, they yield an identical keystream, explaining why direct searches for 256-byte table sequences failed.

### The Outer 20-Byte Prefix Verification

The update check caller at file offset `0x00EC7730` (virtual address `0x41027730`) executes the following sequence:

1. Skips the outer 32 bytes and invokes the 3-table XOR decoder.
2. Sets the initial 20 bytes of the raw package as the expected digest.
3. Derives 8 bytes using constant `0x451` and camera model string `Z_8`.
4. Computes SHA-1 over the decoded package concatenated with these 8 bytes, comparing the 20-byte digest.
5. On success, proceeds to CRC and section processing.

The seed for digest derivation resides at `0x04A2A3F0`: `138c3f279ade6b59`.
The transformation function is at `0x01032BDC`; state initialization and digest comparison reside at `0x01032DE4–0x010330E0`.
Translating parameters yields suffix `6c12037e6fcec19a`:

```python
sha1(decoded_package + bytes.fromhex("6c12037e6fcec19a")).hexdigest()
# Output: 61060072cc6f4032491ef95570e1e7e9e053b8fd
```

This matches raw Z 8 bytes `0x00–0x13` **identically**.
The remaining 12 bytes (`0x14–0x1F`) remain unverified.

Applying this directly to raw ZR bytes across offsets `0x20` to `0x280` with 65,536 candidate seeds did not match ZR's initial 20 bytes. Without decrypted ZR payload, this does not exclude the possibility that a similar digest is verified post-decryption.

## Reproduction and Generated Files

Execute from repository root:

```sh
cd "firmware decode/z-series"
uv run python tools/analyze_zr.py ZR__0111.bin --output analysis/ZR__0111   --z8-firmware Z_8_0311.bin --z8-directory analysis/Z_8_0311
uv run pytest
```

Artifacts:

- [manifest.json](manifest.json): ZR observations, full-phase probe results, and Z 8 validation data.
- [code_landmarks.asm](code_landmarks.asm): Documented Z 8 reference disassembly.
- `header.hex.txt`: Raw initial `0x300` bytes (Git-ignored).
- `entropy.csv`: Block entropy per 64 KiB (Git-ignored).
- `tools/analyze_zr.py`: Reproducible analysis script (does not provide ZR decryption).

All 18 automated tests pass.

## Priority Next Steps (Completed in Phase 2)

1. [x] **Acquire second ZR firmware release**: `ZR__0110.bin` analyzed against `ZR__0111.bin`. 73.72% of the payload ciphertext is byte-for-byte identical, confirming position-dependent stream cipher keystream reuse ($C_1 \oplus C_2 = P_1 \oplus P_2$).
2. [x] **Full 208-Byte Directory Keystream Recovery**: Solved `DIR_KEYSTREAM_208` across multi-camera fleet (ZR, Z f, Z 6 III, Z 5 II, Z 50 II).
3. [x] **Section Decryption**: Section 0 (`ex2100_010100.b`) 54.77% decrypted via zero-padding spans (114.7 KB + 147.2 KB).
4. [x] **Subsystem Reverse Engineering**: Mapped Linux NISI multi-image packaging, PTP vendor dispatch gateway (`0x94FD`), Camera Property Manager (4,427 properties), and BVR gyro CSV logging activation.

---

## Phase 2 Breakthroughs & Full Directory Recovery

### Recovered Section Manifest (Nikon ZR 1.11)

| Index | Section Name | Description | Payload Offset | File Offset | Size (Bytes) | Size (MiB) |
|---|---|---|---|---|---|---|
| **0** | `ex2100_010100.b` | Socionext ARM Thumb MCU firmware | `0x000000D0` | `0x00000350` | 524,290 | 0.50 MiB |
| **1** | `_tps00_1500.bin` | Touch panel controller firmware | `0x000800E0` | `0x00080360` | 261,122 | 0.25 MiB |
| **2** | `eg2100_011130.b` | EXPEED 7 AArch64 Main OS (μITRON) | `0x000BFCF0` | `0x000BFF70` | 88,157,708 | 84.07 MiB |
| **3** | `vr2100_010100.b` | Vibration Reduction MCU firmware | `0x054D29BC` | `0x054D2C3C` | 838,664 | 0.80 MiB |
| **4** | `li2100_011130.b` | Linux kernel + CPIO rootfs + DTBs (NISI) | `0x0559F6B0` | `0x0559F930` | 27,377,560 | 26.11 MiB |

### Tooling Reference

- [`decrypt_zr_stream.py`](file:///home/fdkevin/Workspaces/nikon-firmware-tools/firmware%20decode/z-series/tools/decrypt_zr_stream.py): Header validation, dynamic multi-model directory recovery (`parse_modern_directory`), and Section 0 cryptanalysis.
- [`reverse_expeed7_system.py`](file:///home/fdkevin/Workspaces/nikon-firmware-tools/firmware%20decode/z-series/tools/reverse_expeed7_system.py): PTP vendor table, Property categories, BVR gyro activation trigger, NISI container parser, and Linux shell command gateway.
- [`expeed7_ptp_protocol.py`](file:///home/fdkevin/Workspaces/nikon-firmware-tools/firmware%20decode/z-series/tools/expeed7_ptp_protocol.py): Universal PTP vendor frame builder and gyro CSV activation generator.

