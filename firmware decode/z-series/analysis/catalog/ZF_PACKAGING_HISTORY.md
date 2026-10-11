# Earliest Verifiable Release of the Z f Modern Container Format

Subsequent [comprehensive historical acquisition](../all_history/FINDINGS.md) has acquired all eight public update releases of the Z f, confirming all of them use the modern container format; factory version 1.00 remains unobtained. The status in the table below reflects this complete historical collection.

Verification date: 2026-10-05 (Asia/Shanghai). Scope: Official release records, official CDN raw updater binaries, and byte-for-byte header comparisons; no firmware was flashed to hardware.

**Firmware Z f C 1.10, released on 2023-11-16, has been acquired and verified: it already employs the same modern container family as 1.21 and 3.01 in this repository.** Consequently, the temporal upper bound previously established by the 1.21 sample is pushed back to 1.10. Release 1.10 is the earliest update cataloged in Nikon's public changelog (updating from 1.00 to 1.10); however, without an original 1.00 updater binary, it cannot be asserted that the packaging format changed precisely at 1.10. The rigorous conclusion is: **the modern packaging format has been in use at least since the first public update C 1.10; the container format of the factory 1.00 release remains unconfirmed.** See the [Nikon 1.10 Download Page](https://downloadcenter.nikonimglib.com/en/download/fw/507.html) and [Nikon Official Release & Date Records](https://www.nikon.com.sg/zf-firmware-updates).

## Version Boundaries

| Version | Official Record / Sample Status | Packaging Conclusion |
|---|---|---|
| 1.00 | Listed on official 1.10 page as supported base version; original updater not found | Container format cannot be determined; existence of on-device version does not imply availability of public updater |
| **1.10 (2023-11-16)** | Downloaded directly from official CDN: `Z_f_0110_01.bin` | **Verified modern container family; earliest verified sample** |
| 1.20 | Acquired and verified in full historical collection | Modern container; fixed header identical |
| 1.21 | Previously archived official sample: `Z_f_0121.bin` | Modern container; identical fixed header region to 1.10 |
| 2.00, 2.01, 2.02, 3.00 | Acquired and verified in full historical collection | All modern containers; fixed header regions identical |
| 3.01 (2026-03-31) | Previously archived official sample: `Z_f_0301.bin` | Modern container; identical fixed header region to 1.10 |

Version progression is cataloged on the [current Nikon download page](https://downloadcenter.nikonimglib.com/en/download/fw/586.html); the 3.01 release date is recorded in [product download records](https://downloadcenter.nikonimglib.com/en/products/624/Z_f.html).

This evidence refutes the hypothesis that this container format was introduced in version 2.00 to support Nikon Imaging Cloud: the 1.10 package already exhibits identical packaging characteristics, predating 2.00. Packaging format changes are not causally attributed to cloud connectivity or AI features.

## Raw Samples and Provenance Chain

All paths are relative to `firmware decode/z-series/`.

| Version | File | Bytes | SHA-256 |
|---|---|---:|---|
| 1.10 | `Z_f_0110_01.bin` | 90,124,933 | `89aeb3bfb4110f21a1a0ee05244296da52824208d916dc2b53b90202e693a03d` |
| 1.21 | `Z_f_0121.bin` | 90,124,933 | `0c6ea7c59659bade5c8ca08d1275451e592b2b87e3482373008e63583ab9deda` |
| 3.01 | `Z_f_0301.bin` | 107,820,261 | `bfc1ef4ec1588ef10c85e06bf1bf5bcaa7456e49bb2b7160dd4043ab8934d1a6` |

The provenance of version 1.10 is independently verifiable:

1. The cached [official download page fw/507.html](https://downloadcenter.nikonimglib.com/en/download/fw/507.html) documents version 1.10, supported upgrade from 1.00, original filename `Z_f_0110_01.bin`, ~85.95 MB, and retains the download link. Direct HTTP requests to the old URL now return 404; cached pages must not be represented as active live pages.
2. The retained [crossgate download redirect](https://crossgate.nikonimglib.com/dsd_redirect/redirect.do?L=STc7F06&O=5pA4G00&P=FVGG968&R=KRmgA31) still responds with HTTP 302.
3. The redirect targets the [official CDN payload for 1.10](https://download.nikonimglib.com/archive6/v7Z7l00GsKkB06Lz6BL31fXyzd72/Z_f_0110_01.bin): HTTP 200, `Content-Length: 90124933`, `Last-Modified: Thu, 16 Nov 2023 00:18:08 GMT`, `ETag: "f80324167a1b4c1e3f9f73b77646d9a6:1700093884.053734"`. The downloaded size matches headers exactly, with the SHA-256 confirmed above.

Version 1.21 origin: [Archived Page](https://downloadcenter.nikonimglib.com/en/download/fw/545.html), [Official BIN](https://download.nikonimglib.com/archive7/n0iDd008ZRGu06fP5t0730yBc323/Z_f_0121.bin), documented in the [Z f Analysis Report](../Z_f_0301/REPORT.md). Version 3.01 origin: [Official BIN](https://download.nikonimglib.com/archive8/5iAlW002osm707LL35I60VUlT357/Z_f_0301.bin), with metadata in `manifest.json`.

The Windows package `F-Zf-V110_01W.exe` is a self-extracting delivery wrapper; the official BIN was retrieved directly without executing the EXE. Analysis evaluates the internal structure of camera-ingested BIN files without confusing wrapper distribution differences with firmware packaging. See [Official 1.10 Installation Guide](https://downloadcenter.nikonimglib.com/en/download/fw/507.html).

## File Header Evidence

"Modern packaging" in this report designates the opaque container family observed across Z f, Z6III, Z5II, and ZR, and **does not represent an official Nikon format designation, nor does it imply a determined cipher or signature scheme**. Analysis compares the following byte regions across 1.10, 1.21, and 3.01 without relying on filenames or marketing claims.

All three samples exhibit identical content across `0x000–0x01f`:

```text
420601f57f69308eab4d2a4ea3f486e256d93c6d8f165c968e99e4d20a029fb3
```

All three samples are byte-for-byte identical across `0x120–0x21f`, with SHA-256:

```text
c0b167b8b9ee0ff4706f4239ee5b18932d9bad71425330cb385c227446d386f4
```

All three satisfy `data[0x220:0x240] == data[:32][::-1]`, `data[0x260:0x280] == b" " * 32`, and are identical across `0x280–0x28f`:

```text
e14c9918cd6382668a35f65123f14e4f
```

| Region (End Exclusive) | Length | 1.10 ↔ 1.21 Discrepant Bytes | 1.10 ↔ 3.01 Discrepant Bytes |
|---|---:|---:|---:|
| `0x000:0x020` | 32 | 0 | 0 |
| `0x020:0x120` | 256 | 255 | 256 |
| `0x120:0x220` | 256 | 0 | 0 |
| `0x220:0x240` | 32 | 0 | 0 |
| `0x240:0x260` | 32 | 32 | 32 |
| `0x260:0x280` | 32 | 0 | 0 |
| `0x280:0x290` | 16 | 0 | 0 |
| `0x290:0x330` | 160 | 8 | 23 |

These findings demonstrate that the invariant framing structure was present as early as version 1.10; the lengths of variable regions alone do not prove RSA signatures, keys, or any specific cryptographic scheme. The directory table and global payload require separate verification; matching header structures do not constitute a full decode.

Verification script (executed from repository root using Python standard library):

```bash
python3 - <<'PY'
from pathlib import Path
import hashlib

root = Path('firmware decode/z-series')
names = ['Z_f_0110_01.bin', 'Z_f_0121.bin', 'Z_f_0301.bin']
data = {name: (root / name).read_bytes() for name in names}
regions = [(0, 0x20), (0x20, 0x120), (0x120, 0x220),
           (0x220, 0x240), (0x240, 0x260), (0x260, 0x280),
           (0x280, 0x290), (0x290, 0x330)]
for name, blob in data.items():
    print(name, len(blob), hashlib.sha256(blob).hexdigest())
    print('first32', blob[:32].hex())
    print('reverse', blob[0x220:0x240] == blob[:32][::-1])
    print('spaces', blob[0x260:0x280] == b' ' * 32)
baseline = data[names[0]]
for name in names[1:]:
    print(name, [(hex(lo), hex(hi), sum(a != b for a, b in
                  zip(baseline[lo:hi], data[name][lo:hi])))
                 for lo, hi in regions])
PY
```

## Unresolved Boundaries

Searches across archived pages, active changelogs, and target filenames like `Z_f_0100.bin` / `F-Zf-V100` yielded no official 1.00 updater binary. This constitutes an evidence gap, **not evidence that 1.00 did not exist or that 1.00 necessarily used legacy packaging**. On-device flash dumps from 1.00 factory units do not necessarily preserve the outer packaging of an updater file. Determining the exact format transition point requires an authentic 1.00 updater binary or build-system artifacts documenting when the format was deployed.
