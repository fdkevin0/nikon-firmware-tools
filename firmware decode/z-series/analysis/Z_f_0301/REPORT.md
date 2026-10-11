# Nikon Z f 3.01: Modern Container Cross-Version Differential Analysis

**Status: The container is not fully decrypted or unpacked; section CRCs are unverified, and disassemblable code has not been extracted from Z f.**
This investigation confirms that Z f 1.21, 3.01, Z6III 2.00, Z5II 1.20, and ZR 1.11 share invariant header fields. Ciphertext differentials between the two Z f versions support a position-dependent mask model, but do not yet yield the key generator or verified directory.

## Samples and Reproduction

| Local Sample | File Size (Bytes) | `(Size - 0x280) % 16` |
| --- | ---: | ---: |
| `Z_f_0301.bin` | 107,820,261 | 5 |
| `Z_f_0121.bin` | 90,124,933 | 5 |
| `Z6_3_0200.bin` | 117,641,453 | 13 |
| `Z5_2_0120.bin` | 108,716,229 | 5 |
| `ZR__0111.bin` | 117,159,984 | 0 |

Full SHA-256 hashes are cataloged in [manifest.json](manifest.json). Z f 3.01 SHA-256:
`bfc1ef4ec1588ef10c85e06bf1bf5bcaa7456e49bb2b7160dd4043ab8934d1a6`.

Sample 1.21 originates from the [Nikon Download Page](https://downloadcenter.nikonimglib.com/en/download/fw/545.html) and [Payload URL](https://download.nikonimglib.com/archive7/n0iDd008ZRGu06fP5t0730yBc323/Z_f_0121.bin). It already employs the modern header structure; downgrading to 1.21 does not yield a legacy XOR container.

Execute from `firmware decode/z-series`:

```sh
uv run python tools/analyze_zf.py . --output analysis/Z_f_0301
uv run pytest
# Optional PRNG/stream cipher probes (requires pycryptodome):
uv run python tools/probe_zf_stream.py Z_f_0301.bin > analysis/Z_f_0301/stream_probes.json
```

Outputs include sample digests, regional diffs, candidate directory XORs, matching spans, and full-phase XOR sweeps.

## Shared Invariant Framing Across Five Samples

Offsets represent raw file offsets (right-hand exclusive):

| Byte Range | Observation | Interpretation Boundaries |
| --- | --- | --- |
| `0x000–0x020` | 32 invariant bytes across all 5 samples | Unknown whether magic constant, key material, or identifier |
| `0x020–0x120` | 256 variable bytes per sample | Unverified signature or encrypted block |
| `0x120–0x220` | Byte-identical across all 5 samples; 128 little-endian u16 values (153–32,757) | All values < `0x8000`; not proven to be PRNG output |
| `0x220–0x240` | Exact bitwise reverse of initial 32 bytes | Structural repetition |
| `0x240–0x260` | 32 variable bytes per sample | Unknown checksum or key material |
| `0x260–0x280` | 32 ASCII space bytes | Preserves spacing convention from legacy container |
| `0x280–0x290` | Byte-identical across all 5 samples | Candidate directory header block |
| `0x290–0x330` | Sparse byte differences | Compatible with five 32-byte directory entries |

Invariant initial 32 bytes:

```text
420601f57f69308eab4d2a4ea3f486e256d93c6d8f165c968e99e4d20a029fb3
```

Candidate directory block (`0x280–0x28F`):

```text
e14c9918cd6382668a35f65123f14e4f
```

Discrepant bytes within `0x290–0x330` (160 bytes) relative to Z f 3.01:

| Reference Sample | Discrepant Bytes out of 160 |
| --- | ---: |
| Z f 1.21 | 20 |
| Z6III 2.00 | 28 |
| Z5II 1.20 | 30 |
| ZR 1.11 | 41 |

The invariant framing enables cross-model comparison, but does not prove that payloads share identical encryption keys. Non-16-byte aligned lengths rule out simple ECB/CBC cipher block chaining without padding or stream modes.

## Positional Comparison Between Z f 1.21 and 3.01

Across their 90,124,933 overlapping bytes, 19,306,879 bytes are identical (**21.422350%**).
The extra 17,695,328 bytes in 3.01 are excluded from comparison.

Longest identical ciphertext spans:

| Start Offset | End Offset | Identical Bytes |
| --- | --- | ---: |
| `0x1194ad8` | `0x1578dc5` | 4,080,365 |
| `0x802224` | `0xb2e34c` | 3,326,248 |
| `0xbb432` | `0x12e35e` | 470,828 |
| `0x52018` | `0x80321` | 189,193 |

In the candidate directory, deltas fall on fields corresponding to version strings, lengths, and offsets, while reserved areas remain unchanged.
Sparse differences and large matching spans are consistent with a position-dependent XOR keystream reused across releases. Without plaintext correspondences, matching ciphertext cannot be definitively labeled as zero-fill or identical code.

Assuming the directory header preserves legacy structure (`count=5, header_size=0xd0, reserved=0,0`), the **conditional** XOR mask for the first 16 bytes is:

```text
e14c991dcd6382b68a35f65123f14e4f
```

Under this assumption, Section 0 would begin at `0x260 + 0xd0 = 0x330`.

## Investigated and Excluded Hypotheses

- **Legacy 3-Table XOR**: Evaluated across all `2^24` phases against the candidate directory at `0x280`. Zero phases yielded valid reserved-zero fields. This excludes simple offset shifts of the legacy XOR scheme under the assumed directory format.
- **32-Bit Linear Congruential Generators (LCGs)**: Parameters `(214013, 2531011)`, `(1103515245, 12345)`, and `(1664525, 1013904223)` matched against candidate mask bytes (bits 16..23) and the 128-entry table (bits 16..30) across strides 1..32 yielded zero hits.
- **Direct Cipher Probes**: 1,860 candidate configurations (aligned header keys, MD5/SHA-256 derivations, AES-CTR/CBC/ECB blocks, ChaCha20/Salsa20 nonces) produced zero matches against the 8 reserved-zero bytes.

## Next Steps and Validation Standards

Priority lies in obtaining readable flasher code, bootloader binaries, or authorized RAM/ROM dumps from modern container models to identify routines referencing the 32-byte header or 128-entry table.
Continued known-plaintext attempts must validate section boundaries, section CRCs, package checksums, and re-encoding roundtrips; matching printable strings or 16-byte headers does not constitute decryption.

All 22 unit tests pass; firmware binaries remain unmodified.
