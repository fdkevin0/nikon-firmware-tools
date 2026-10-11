# Reference Analysis of z7-qemu: Validation Pathways for Z 8 Diagnostic Menu Patches

Analysis date: 2026-10-10. Reference repository: `/home/fdkevin/Workspaces/z7-qemu` (Commit `97abf0b81cd3211f8374a38987a0beaf4549b90f`, clean working tree). Neither repository was modified during this review.

## Conclusions

The `z7-qemu` implementation provides **architectural patterns for assisted boot sequences, peripheral modeling, and menu validation**, but cannot execute Z 8 C 3.11 or the `3.11 P` experimental firmware directly. It is designed for 32-bit ARMv7 MAIN binaries on Z 7 C 3.80; Z 8 uses an AArch64 EG executable with distinct boot, interrupt, memory, RTOS, and display driver interfaces.

The current repository already contains the exact Z 7 input required: stripping the trailing 2-byte CRC from `analysis/Z_7_0380/eg1610_038000.bi` yields a binary whose length and SHA-256 **match the launcher requirements exactly**:

| Binary Stream | Size (Bytes) | SHA-256 |
|---|---:|---|
| Current repo Z 7 EG (with CRC) | 33,052,090 | `7f59d8993080203a12692cf6927a0a8218786d3f72230c04174f1563c506a6f6` |
| Required Z 7 MAIN (without CRC) | 33,052,088 | `e6df1764323fb1c287159dd3ce1c84ac93c72b96ba6eb09c070295c093fecbff` |

Raw firmware containers and CRC-bearing EG files cannot be fed directly to the launcher.

## Subsystem Implementations in z7-qemu

| Layer | Implementation & Evidence | Verified Scope |
|---|---|---|
| CPU / Machine | `qemu/nikon-z7-lab.c:z7_common_init`: Cortex-A15 dual-core, A15 MPCore, timers | Experimental machine for Z 7 pathways |
| Memory | MAIN at `0x10020000`, SRAM `0x04008000`, App RAM `0xA1800000`, MMU mappings in guest | Physical vs virtual address spaces separated |
| Assisted Boot | `tools/interactive.py:Camera.boot`: Halts at breakpoints to invoke memory/power setup | Intervened guest execution |
| Key Events | `Camera.key`: Passes bitmaps and durations to Z 7 AutoOperation `0x105230A6` | Menu responses originate from guest code |
| Graphics | `nikon-z7-gpu.h`: Interprets SMAPH-F / OpenVG commands, paths, strokes, blits | Uses firmware font/icon resources |
| LCD | `z7_lcd_present`: Composites output buffers; screenshots captured via QMP | Validates visual display generation |
| Unknown I/O | `z7_unknown_access`: Logs access, registers, and CPU state, requesting halt | Avoids fabricating false success values |
| Viewfinder | RAW DMA → functional ISP → output buffer → LCD | Experimental synthetic pipeline |

Documentation: [Architecture Guide](/home/fdkevin/Workspaces/z7-qemu/docs/architecture.md), [Boot & Input](/home/fdkevin/Workspaces/z7-qemu/tools/interactive.py#L230), [Function Harness](/home/fdkevin/Workspaces/z7-qemu/tools/probe.py#L15), [GPU Model](/home/fdkevin/Workspaces/z7-qemu/qemu/nikon-z7-gpu.h#L34), [UI Verification](/home/fdkevin/Workspaces/z7-qemu/tools/verify_ui.py#L27).

## Critical Architectural Differences with Z 8

| Component | z7-qemu (Z 7 3.80) | Current Z 8 3.11 Evidence | Adaptation Requirements |
|---|---|---|---|
| Architecture | ARMv7 / Thumb; R0..R15, CPSR | AArch64; X0..X30, SP, PC, Exception Levels | Requires `aarch64-softmmu` and 64-bit harness |
| Interrupt Controller | A15 MPCore (GICv2) | `ICC_SRE_EL3/EL2/EL1` boot logic; DTB declares GICv3 | Requires GICv3 routing and initialization |
| CPU Cores | Dual Cortex-A15 | Linux DTB `cpu@3` indicates Cortex-A53; multi-core role assignment | Cortex-A53 quad-core model |
| Main Base Address | `0x10020000` | `0x40160000` | Rebuild boot mappings and MMU configuration |
| Initialized RAM | 32-bit address space | Base `0xA02808000` (`0x2AD000` bytes); BSS at `0xA02AFB000` | Support 64-bit physical/virtual addressing |
| RTOS Subsystem | SMP T-Kernel | SOLID-OS / TOPPERS FMP, Linux container, CEVA DSPs | Map new synchronization primitives and queues |
| Graphics Pointers | 32-bit pointers (`z7_gpu_range`) | 64-bit memory space; new menu node at `0xA02AB4500` | Support 64-bit framebuffers and nodes |
| Graphics Commands | Z 7 3.80 OpenVG command structures | Contains `OpenVG` strings; register formats unverified | Decode Z 8 command packets and formats |
| Remote GDB | 32-bit register XML | 64-bit register XML and PSTATE/EL fields | Update target XML and register parsers |

Boot code disassembly: [z8_boot_landmarks.asm](z8_boot_landmarks.asm). Address references: [Z 8 Report](../Z_8_0311/REPORT.md), [device_tree_0.dts](../Z_8_0311/linux/device_tree_0.dts).

## Significance for the 3.11 P Diagnostic Menu Patch

The current [Diagnostic UI Validator](../../tools/verify_z8_diagnostic_ui.py) tests string objects, metadata getters, and navigation branches, while stubbing graphics allocators, display drivers, and event queues. It cannot verify:

- Dynamic allocation of menu row 45 in live memory pools.
- Retention of the 96-byte node structure without corruption by zero-initialization passes.
- Instruction execution permissions under guest MMU page tables.
- Accurate glyph rendering, anti-aliasing, and spacing for `3.11 P`.
- Stability under repeated MENU, OK, and tap events without memory leaks.

Applying the `z7-qemu` methodology to Z 8 provides the toolchain needed to validate these visual requirements via QMP framebuffer capture.

## Recommended Progression

1. **Establish Z 7 Baseline**: Run `z7-qemu` using the validated Z 7 MAIN binary under QEMU 10.2.4 (`--profile menu`) to inspect menu dependency chains.
2. **Construct Minimal Z 8 AArch64 Machine**: Build `aarch64-softmmu` with GICv3, timers, and memory maps conforming to EG descriptors, tracing execution from `0x40160000`.
3. **Execute Unmodified Z 8 Menu Subsystem**: Model power management, GUI heaps, key events, and LCD interfaces until native menus render.
4. **Compare Unmodified vs Patched Firmware**: Evaluate both versions under identical machine configurations.
5. **Verify New Menu Features**: Validate row 45 appearance, scrolling, diagnostic text rendering, `3.11 P` label display, and re-entry stability.

Focus should center on **menu execution and display rendering**. Sensor streaming, RAW pipelines, and autofocus can be deferred.

## Local Test Verification Results

| Verification Check | Local Result |
|---|---|
| Reference Git Status & Hashes | Clean working tree; 14 file digests recorded |
| Z 7 EG to MAIN Correspondence | Verified (length and SHA-256 match perfectly after stripping 2 CRC bytes) |
| Python Synthetic Tests | 11 passed (Python 3, NumPy 2.3.5, Pillow 12.1.1) |
| C Synthetic Rendering Tests | 270 passed (ASan/UBSan enabled) |
| C Synthetic ISP Tests | 398 passed (ASan/UBSan enabled) |
| QEMU System Emulators | None present in system PATH; guest execution deferred |
