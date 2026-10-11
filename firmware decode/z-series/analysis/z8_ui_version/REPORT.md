# Z 8 C 3.11 On-Camera Firmware Version UI Indicator

The dedicated C-version getter for the standard "Firmware version" menu page has been located. By hooking its tail call, the C-line display on the in-camera page can be modified to render as `3.11 P`, while preserving authentic version data in memory and returning authentic status codes. This conclusion is based on static analysis and local Unicorn CPU emulation; on-device LCD rendering remains unverified.

## Inputs and Scope

- Input file: `analysis/Z_8_0311/eg2070_0311b0.bi`
- SHA-256: `f85e0138e2f5e660ece8560de62e0d12cb795e0e14983e50f20b61dce906c46c`
- EG base mapping address: `0x40160000`; code addresses below represent runtime virtual addresses.
- Target: C-version entry on the standard in-camera firmware version menu page, not package container metadata, PTP identity descriptors, upgrade comparison logic, or debug menu screens.
- This probe does not modify the raw firmware binary and does not generate installable flash images.

## Call Chain and Hooking Landmarks

| Virtual Address | Identified Function / Structure |
|---|---|
| `0x405A259C` | Firmware version page builder; invokes `0x403EC384(0x111)` to choose standard vs debug branch |
| `0x42B252A0` | Standard page 7-element visibility/getter function table; entry 0 is the C version |
| `0x405AB414` | C version visibility check (returns 1) |
| `0x405AB41C` | C version getter: `x0` = 10-byte version buffer, `x1` = 3-byte label buffer |
| `0x42B2F6F4` | `C\0` label string |
| `0x405AB454` | Getter tail-call branch `b 0x403EDDAC`; original opcode bytes `56 0a f9 17` |
| `0x403EDDAC` | Version query wrapper; C getter supplies `w0=13, x1=buf, w2=10` |
| `0x405A7A88` | Version formatting helper; replaces leading `0` with a space before committing string |
| `0x403F2920` | ASCII text conversion/dispatch; copies up to 50 bytes with no 5-character truncation |

The standard builder indirectly calls the getter at `0x405A2808` (`sp+0x20` for version buffer, `sp+0x2c` for label buffer), and invokes the display formatting helper at `0x405A2868`. Because the formatting helper is shared with update confirmation screens, hooking must target the dedicated tail call of the C getter.

Recommended 36-byte payload routine, redirected from the `b` instruction at `0x405AB454`. Because the original getter restores `x19` and `LR` before its tail call, the trampoline preserves these registers:

```asm
ui_version:
    stp x19, x30, [sp, #-16]!
    mov x19, x1
    bl  stock_version              // 0x403EDDAC
    movz x8, #0x2e33
    movk x8, #0x3131, lsl #16
    movk x8, #0x5020, lsl #32
    str x8, [x19]                  // "3.11 P\0\0"
    ldp x19, x30, [sp], #16
    ret
```

This routine overwrites only the temporary display buffer. It preserves `w0` and leaves the global system string `Ver.03.11.b0` intact. The indicator string is statically compiled: even if the underlying query returns an error, the display buffer receives the label while returning the original error code.

## Reproducible Local Emulation

Execute:

```sh
uv run python tools/reverse_z8_ui_version.py
```

Requires `unicorn`, `capstone`, `clang`, `ld.lld`, and `llvm-objcopy`. The script validates input hashes and emulates the getter and display helper. Low-level routine `0x41022748` is stubbed with synthetic version `03.11` and specified return codes.

| Test Scenario | Return Code | Rendered Text Committed |
|---|---:|---|
| Stock getter, backend success | 0 | ` 3.11` |
| Hooked getter, backend success | 0 | `3.11 P` |
| Hooked getter, backend error 2 | 2 | `3.11 P` |
| Hooked getter, backend error 4 | 4 | `3.11 P` |

All scenarios verify invariant C label, callee-saved registers (`x19–x29`/SP), and guard bytes beyond the 10-byte buffer. Manifest output is saved to `manifest.json`; disassembly resides in `code_landmarks.asm`.

Address `0x412A3800` is used solely as an emulation harness address and is not certified as deployment free space. Full production integration requires the flasher builder to select safe payload space and re-link branches.

## Landmarks for Standalone Diagnostic Pages

`0x403F2920` accepts an ASCII pointer, slot ID, and font descriptor; the version helper binds the text object via `0x403F645C` and activates it via `0x403F621C`. Given existing page objects, this represents a reference path for read-only diagnostic text.
Static pointer references to the firmware version page builder reside at EG file offset `0x4BF8970` (`0xA028ED970` in RAM). Navigation routines: `0x403AD6A4` handles menu navigation; `w0=2, w1=379` at `0x4054D3E0` denotes Menu Group 2 / Menu ID 379.
