# Z 8 C 3.11 P: Setup Menu Diagnostic Page Experiment

An experimental firmware package has been generated that appends **NFDG diagnostics** to the setup menu list. Accessing this item renders diagnostic identity information; on the standard firmware version page, line C renders as **3.11 P** without parentheses. All 44 original setup entries and handlers are preserved, expanding the menu list to 45 items.

Experimental binary: `Z_8_0311_diagnostic_UI_3.11_P_EXPERIMENTAL.bin`. Applicable strictly to Z 8 C 3.11.

**Has not been flashed to camera hardware; authentic display rendering and menu scrolling remain unverified.**

## Intended User Interface Behavior

1. Navigate to the setup menu (wrench icon) and scroll to the end: `NFDG diagnostics`.
2. Press OK, Right, or tap to enter the diagnostic page (which reuses the firmware version screen layout).
3. The page displays four read-only lines; pressing Done, Back, OK, Right, or tapping Done returns to the menu list.
4. The standard "Firmware version" entry remains intact, displaying `3.11 P` on line C.

```text
NFDG diagnostics

ID    NFDG
P     1.0.0
M     Z8 2070
C     3.11 P

Done
```

Line P reflects the diagnostic protocol version (1.0.0); Line C reflects the base firmware version with the patch marker. Diagnostic content is static and does not query real-time sensor parameters, logs, or private session states.

## Implementation Architecture

Source files: [Build Tool](../../tools/build_z8_diagnostic_ui.py), [AArch64 Assembly](../../tools/patches/z8_0311_diagnostic_ui.S), [Verification Script](../../tools/verify_z8_diagnostic_ui.py). Incorporates the [PTP Diagnostic Patch](../z8_diagnostic/REPORT.md).

| Subsystem | Modifications |
|---|---|
| Setup Menu Node (Group 2 / `0x297`) | Expands row count from 44 to 45; points to new 45-item row table and event pointer table |
| New Menu Row Item | Text ID `0x7FF0`, local object ID `0x4FFE`, cloning flags from standard version item |
| Diagnostic Node (Group 2 / `0x600`) | Hook at `0x403DB694` handles this pair, passing other requests to stock CMP logic |
| Diagnostic Page | Clones version screen schema, retaining Done; draw callback invokes text helpers and hides version fields/buttons |
| Navigation: Enter | OK / Right / Tap route to `0x600`, removing update-preparation callbacks |
| Navigation: Exit | Done / Back / OK / Tap route to `0x297`, decoupling firmware update events |
| C Version Getter | Tail call at `0x405AB454` routed to trampoline that writes `3.11 P` into the 10-byte buffer |
| String Resources | Text normalizer at `0x4032DB6C` accepts new ID; `0x4032E130` supplies UTF-16 title |
| Diagnostic Page Title | Displays custom title when active node is `0x600`, preserving stock titles elsewhere |

Writable node data (96 bytes) resides in zero-fill padding at RAM address `0xA02AB4500` (file offset `0x4DBF500`).
The primary code payload (**4,496 bytes**) resides at virtual address `0x412A3200`, with code terminating before `0x412A3618` in the same 4 KiB page as `RET @ 0x412A31F0`.

Internal string `Ver.03.11.b0` and update comparison logic remain unmodified.

## Verification Matrix

| Validation Step | Result |
|---|---|
| Stock 44 rows and event pointers comparison | Byte-identical match |
| Node lookup checks | 35 test cases passed |
| 36 language text fallback routines | 325 test cases passed |
| 8 font / metadata getters | 1,728 test cases passed |
| Text object builder `0x4032B648` | 144 test cases passed |
| Menu navigation: 4 entry & 4 exit actions | Verified |
| C version getter (states 0, 2, 4; buffer boundaries) | Verified |
| 182 PTP sub-opcode pre-checks | 1,724 test cases passed |
| PTP diagnostic commands | 16 valid / 21 malformed cases passed |
| Pytest test suite | 46 tests passed |
| Section CRCs, package CRC, SHA-1 checksums | All passed |

Machine-readable evidence: [manifest.json](manifest.json), [independent_checks.json](independent_checks.json).

| Binary Artifact | SHA-256 |
|---|---|
| Original Package | `d67413c2ede6b9ce8887175f20700bd9fbad2a973a4820968c45503d15d80d96` |
| UI Experimental Package | `6117ea4d880b46a785b1e94119a2e3bba3491f1737847d6795903d234472f997` |
| Modified EG Section | `91e15901b8cd5c1055855ae0735babfaca7811704419e8438a11f813f06c1b37` |

Length: 99,051,117 bytes.

## Reproduction

Execute:

```sh
uv run python tools/build_z8_diagnostic_ui.py --firmware Z_8_0311.bin --output /tmp/z8-diagnostic-ui-rebuild
uv run pytest
```
