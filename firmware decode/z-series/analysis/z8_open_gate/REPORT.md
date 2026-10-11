# Z 8 3.11 Open Gate: Video Mode Constraints and Full-Height Geometry Analysis

**Status: No Open Gate enabling switch or flashable patch has been found. Expanding the SDK video mode whitelist alone is insufficient; downstream resolution conversion fails.** This phase traced video attributes into internal camera settings, emulating AArch64 routines to examine validation boundaries and analyzing geometry functions containing full-height sensor constants. No firmware was flashed to hardware.

Subsequent investigations connected N-RAW resolutions to capture state structures; see the [Capture Information Service Survey](../z8_capture_state/REPORT.md).

Target sample: Z 8 3.11 EG (`Z_8_0311/eg2070_0311b0.bi`, SHA-256 `f85e0138e2f5e660ece8560de62e0d12cb795e0e14983e50f20b61dce906c46c`). Addresses represent runtime virtual addresses. Reference documentation: [Z 8 USB/MTP Specification](<../../references/remote-sdk-2.0.0/original/Command/English/Z 8UsbMtpE_02.pdf>), pages 295, 299–303.

## 1. Public PTP Properties to Internal Configuration

`MovieRecordScreenSize = 0xD0A0` is a packed UINT64 field containing width, height, frame rate, and operational flags:

```text
Bits 63..48: width  | Bits 47..32: height | Bits 23..16: fps
Bits 15..14: scan   | Bits 13..8:  flags  | Bits 7..0:   extra
```

The property descriptor resides at EG file offset `0x4c9ccb8`. Setter `0x408401ec` calls `0x40841c8c` to fetch the mode whitelist for the active codec, performing full 64-bit comparison. Unmatched values return `0x201c` without updating settings.

Upon matching, the function queries dimension and frame rate conversion tables, selects internal setting IDs, and invokes `0x40856be8` to commit the values. Arbitrary resolutions are not forwarded directly to the sensor:

```text
0xD0A0 UINT64
    → Codec-Specific Mode Whitelist Comparison
    → Resolution Conversion Table + Frame Rate Conversion Table
    → Internal Setting IDs per Codec
    → Setting Service (Intercepted in emulation)
```

`MovieFileType = 0xD0AF` maps to internal format IDs via `0x440f4190`; active format is read from `0x06001206`. Routines `0x40856964` and `0x408568d0` select resolution and frame rate setting IDs respectively:

| Codec | Protocol Value | Format ID | Whitelist Count | Resolution Setting ID | Frame Rate Setting ID |
|---|---|---:|---:|---|---|
| H.264 MP4 | `0x00000801` | 1 | 8 | `0x07001202` | `0x07001203` |
| H.265 8-bit | `0x00010800` | 2 | 17 | `0x0700124b` | `0x0700124c` |
| H.265 10-bit | `0x00010a00` | 3 | 17 | `0x0700124d` | `0x0700124e` |
| ProRes 422 HQ | `0x00100a00` | 4 | 9 | `0x0700124f` | `0x07001250` |
| ProRes RAW | `0x00110c00` | 5 | 10 | `0x0500125b` | `0x0500125d` |
| N-RAW | `0x00020c02` | 6 | 19 | `0x0500125a` | `0x0500125c` |

The 19 N-RAW modes comprise: 8256×4644 and 5392×3032 at 60/50/30/25/24 fps; 4128×2322 at 120/100/60/50/30/25/24 fps; 3840×2160 at 120/100 fps.
The 10 ProRes RAW modes comprise: 5392×3032 at 30/25/24 fps; 4128×2322 at 60/50/30/25/24 fps; 3840×2160 at 60/50 fps.

## 2. Why Modifying Whitelists Alone Fails

Conversion table `0x440f41c0` contains only 7 resolution entries:

| Resolution | Internal Dimension Enum |
|---|---:|
| 1280×720 | 0 |
| 1920×1080 | 1 |
| 3840×2160 | 2 |
| 7680×4320 | 3 |
| 4128×2322 | 4 |
| 5392×3032 | 5 |
| 8256×4644 | 6 |

All entries adhere to approximately 16:9 aspect ratios; 8256×5504 and 4128×2752 (3:2) are absent. Lookup function `0x40811c40` returns **`0x7fffffff`** for unlisted resolutions.

Emulation findings:

- All 80 authentic SDK modes across the 6 codecs return `0x2001`, transmitting expected dimension and frame rate IDs.
- Testing 36 custom 3:2 modes (8256×5504 and 4128×2752 at 24/25/30 fps across 6 codecs) returned error `0x201c` with zero settings committed.
- Patching the N-RAW whitelist in emulator RAM to permit 8256×5504@24 allowed the setter to return `0x2001`, but it transmitted invalid enum **`0x7fffffff`** to dimension setting `0x0500125a`, while sending `6` to frame rate setting `0x0500125c`.

Routines `0x406d2ba4` and `0x406d2c24` near `MovieOptionInfo.c` map dimension enums to width and height fields. When flags are zero, they accept values `0..6` only; inputs `7` and `0x7fffffff` return 0 without updating target fields.

## 3. Full-Height Sensor Geometries Exist in Metadata Routines

Routine `0x41065194` accepts a configuration structure, utilizing jump tables `0xa02a97648` and `0xa02a97700` in initialized RAM to construct a `0x6c`-byte geometry record.
Testing 1,932 input permutations confirms it can generate 8256×5504 and 8280×5520 alongside 8256×4644 and 8280×4688:

| Input Struct `[+0,+4,+8,+c,+10]` | Output u16 Pair `+0` | Output `+0xc` | Output `+0x24` | Output `+0x64` |
|---|---|---|---|---|
| `[0,4,6,1,0]` | 8256×5504 | 8280×5520 | 8256×5504 | 8280×5520 |
| `[0,4,6,0,0]` | 8256×4640 | 8280×5520 | 8256×5504 | 8280×5520 |
| `[12,4,6,0,0]` | 1920×1080 | 8256×4644 | 1920×1080 | 8280×4688 |
| `[10,4,6,0,0]` | 1920×1080 | 4128×2322 | 1920×1080 | 4140×2344 |

Notice row 2 outputs **4640**, differing from video mode 4644. These outputs govern preview coordinate spaces and scaling calculations across callers `0x41055ac0`, `0x410567dc`, `0x41056c20`, `0x41057178`, `0x41057dd8`, `0x41057fb8`, and `0x410584e4`. There is no evidence that altering video mode IDs to 0 or 19 enables full-height continuous sensor readout.

A 68-row resolution/framerate table at `0x44b5110c` is used by display formatting routine `0x4087da40` and does not configure sensor timing registers.

## 4. Missing Infrastructure and Verification Chain

Settings consumer `0x40ed0310` evaluates N-RAW and ProRes RAW settings alongside system state to compute effective capture values; routines `0x40ed8e90` and `0x40ed8f74` select active values.

Prerequisites for enabling Open Gate:

1. Tracing resolution ID `0x0500125a` to sensor timing registers to determine whether the hardware video readout window natively outputs 4644 lines or is cropped downstream.
2. If full-height readout can be activated, verifying buffer strides, RAW encoder pipelines, and container file writers.
3. Overcoming flasher validation checks; successful re-encoding does not imply flasher acceptance.

8256×5504 produces 18.5% more pixel data than 8256×4644 at equivalent framerates. While 24/25/30 fps represent plausible exploration targets, reduced framerates do not guarantee line timing feasibility.

## Reproduction and Emulation Bounds

Execute:

```sh
uv run python tools/reverse_z8_video_modes.py
uv run pytest
```

The harness maps EG at `0x40160000` and initialized RAM at `0xa02808000`, resetting CPU state per call. Setting services at `0x40856be8` and `0x40856bcc` were stubbed. USB sessions, sensor hardware, ISP, and encoders were not emulated.
