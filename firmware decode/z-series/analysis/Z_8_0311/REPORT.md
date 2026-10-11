# Z_8_0311.bin Reverse Engineering Analysis

Analysis date: 2026-10-04. Subject: Local raw firmware sample under `firmware decode/z-series/`. Analysis performed via static inspection; no firmware or camera code was executed on hardware.

## Conclusions

**Nikon Z 8 C 3.11 firmware can be fully unpacked using the established Nikon 3-table XOR algorithm, with the container origin located at raw file offset `0x20`.**
All five extracted section CRCs match, the complete package CRC-16 is `0xC811`, and bit-for-bit re-encoding perfectly matches the original binary sample.

Compared to the earlier Z 6 architecture, this firmware exhibits a significantly more complex multi-subsystem architecture:

- The primary EG executable is AArch64; bootloader code and section descriptor tables jointly confirm a boot mapping base address of `0x40160000`.
- The main OS contains build strings, path references, and kernel diagnostics for SOLID-OS and TOPPERS/FMP `fmp_1.4.0`.
- An independent LI section contains a Linux 4.14.224 AArch64 kernel, a gzip-compressed CPIO root filesystem, and dual Device Tree Blobs (DTBs).
- The EG payload embeds three extractable CEVA DSP ELFs preserving 41,469 symbol table entries, including XM6, CDNN, and RTOS references.
- The EX section remains an independent ARM M-profile Thumb microcontroller firmware image.

Subsequent [ZR container analysis](../ZR__0111/REPORT.md) reconstructed and verified the outer 20-byte prefix from this sample's code: it represents a SHA-1 hash computed over the decoded package concatenated with 8 derived bytes. The remaining 12 prefix bytes, full updater verification chain, and runtime privilege boundaries remain under investigation. Successful extraction does not imply that modified payloads can be flashed simply by updating CRC checksums.

## Inputs and Verification

| Parameter | Value |
| --- | --- |
| Filename | `Z_8_0311.bin` |
| Length | 99,051,117 bytes (`0x05E7666D`, ~94.4625 MiB) |
| SHA-256 | `d67413c2ede6b9ce8887175f20700bd9fbad2a973a4820968c45503d15d80d96` |
| Raw Entropy | 7.9999986506 bits/byte |
| XOR Origin | Raw file offset `0x20` |
| Decoded Directory | 5 entries, header size `0xD0` |
| Full-Package CRC | `0xC811` (Passed) |
| Bit-for-bit Re-encoding | Passed |

The [official Nikon download page](https://downloadcenter.nikonimglib.com/en/download/fw/606.html) lists this filename for Z 8 C 3.11. Release notes document fixes for NX Tether, high-frequency flicker reduction, and Picture Control operations. The SHA-256 above represents the local file fingerprint. The internal version string in EG and LI reads `0311b0`; the letter `b` should not be construed as indicating a beta/test build.

Raw file bytes `0x00–0x1F`:

```text
61060072cc6f4032491ef95570e1e7e9e053b8fd5866cd124269c27e621da226
```

Offsets `0x20–0x3F` consist of 32 ASCII space bytes. Decoding proceeds identically to the [Z 6 report](../Z_6_0380/REPORT.md):
Retain the space header, index the three XOR tables using container-relative offsets, interpret directory integers as big-endian, and wrap indices at 16 MiB.
All sections and the complete package use CRC-16/XMODEM: polynomial `0x1021`, initial value `0x0000`, stored big-endian.

The package CRC resides at container offset `0x05E7663D` (raw offset `0x05E7665D`), covering all preceding decoded bytes, followed by 14 trailing zero bytes.
The canonical `decoded_package.bin` (retaining the 32-byte space header) has SHA-256:
`da0b0843d2e790ed6267f8a7fbbb393f464de4ed1c217964df782bf0a2795b43`.

## The Five Outer Sections

Filenames are preserved exactly as defined in the container directory; sizes include the trailing 2-byte CRC. Sections are contiguous without gaps or overlaps.

| Section Filename | Container Offset | Raw File Offset | Bytes | CRC-16 | Entropy |
| --- | --- | --- | ---: | ---: | ---: |
| `ex2070_030000.bi` | `0x000000D0` | `0x000000F0` | 524,290 | `9B99` | 4.189403 |
| `_tpj01_0210.bin` | `0x000800D2` | `0x000800F2` | 57,346 | `8F0D` | 6.246823 |
| `eg2070_0311b0.bi` | `0x0008E0D4` | `0x0008E0F4` | 81,807,711 | `201B` | 5.937611 |
| `vr2070_010100.bi` | `0x04E92A33` | `0x04E92A53` | 838,664 | `5BD4` | 1.942176 |
| `li2070_0311b0.bi` | `0x04F5F63B` | `0x04F5F65B` | 15,822,850 | `C731` | 7.624270 |

Full section hashes and string markers are recorded in [manifest.json](manifest.json); Z 8 specific markers and nested structures are detailed in [deep_manifest.json](deep_manifest.json).

## EG Main Executable Architecture and Load Address

The EG section begins with contiguous AArch64 startup instructions: masking exceptions, reading `MPIDR_EL1` and `CurrentEL`, configuring `SCR_EL3`, GIC system registers, and `ELR_EL3/ELR_EL2` based on current exception level, followed by `ERET`. It cannot be disassembled as 32-bit ARMv7.

Three independent indicators confirm the boot mapping base address:

1. A 64-bit little-endian literal at file offset `0x670` reads `0x40160250`, pointing to the EL1 entry point at file offset `0x250`.
2. A literal at file offset `0x678` reads `0x401601C0`, pointing to the EL2 entry point at file offset `0x1C0`.
3. Startup code copies a `0x160`-byte descriptor table from physical address `0x40168000`; the table at file offset `0x8000` records `0x40160000` at `+0x128`.

The first entry of this descriptor table is `0x401691D0`, called indirectly at the conclusion of early initialization to launch the primary OS.
The entry point of the raw binary image remains `0x40160000`.

The descriptor table specifies initialized data copy and zero-initialization (BSS) regions, executed in the sequence at file offsets `0x1328–0x13A8`:

| Region | File Source | Runtime Target Address | Size |
| --- | --- | --- | --- |
| Initialized Data Copy | EG `0x04B13000` | `0xA02808000` | `0x002AD000` |
| Zero-Initialized BSS | None | `0xA02AFB000` | `0x0208E000` |

These represent mapped execution segments, not the complete MMU table. The EG binary contains embedded resources, DSP images, data structures, and trailing metadata; not all bytes should be disassembled as AArch64 instructions. Strings in initialized data reside at their RAM mapped locations rather than `0x40160000 + file_offset`.

A routine at file offset `0xEB0` sets specialized role flags when CPU core ID equals 3, and alternate flags for other cores. Correlating with `cpu@3` in the Device Tree, this indicates asymmetric core allocation between the real-time OS and Linux.

## SOLID and TOPPERS OS Identifiers

| EG File Offset | Extracted Marker String |
| --- | --- |
| `0x04DB6480` | `SOLID CS ENTRY.` |
| `0x04DB6546` | `Starting Kernel.` |
| `0x04DB69A9` | `E:/solid/release/customer/solid-os/rtos/toppers_fmp/fmp_1.4.0/kernel/dataqueue.c` |
| `0x04DB6A32` | `.../mutex.c` (under identical path) |
| `0x04DB8D18` | `SOLID_ARM_s003_v1/.../aarch64/.../mutex_stub.c` |

These build paths demonstrate that the primary OS utilizes SOLID-OS / TOPPERS FMP.
[KMC Documentation](https://solid.kmckk.com/SOLID/doc/latest/os/index.html) explains that SOLID pairs a TOPPERS RTOS kernel with memory management and dynamic loading. Path references to `fmp_1.4.0` do not guarantee 100% equivalence to unmodified upstream source.
The symbol `FREERTOS_MEMORY` found in DSP modules belongs to an independent subsystem and should not be conflated with the host OS.

## LI Section NISI Container

Section `li2070_0311b0.bi` begins with the magic ASCII string `NISI`, entry count 4 at `0x10`, and version string `0311b0` at `0x14`.
Beginning at `0x20`, entries consist of four little-endian u32 fields: start block, allocated blocks, actual length, and reserved.
The allocation block size is **2048 bytes**; boundaries align with the parsed kernel headers, gzip archive, and DTB structures.

| Payload | Offset in LI | Actual Size | Allocated Size |
| --- | --- | --- | --- |
| AArch64 Linux `Image` | `0x00000800` | `0x005B0008` | `0x005B0800` |
| gzip Root Filesystem | `0x005B1000` | `0x00963DBB` | `0x00964000` |
| Device Tree 0 (DTB) | `0x00F15000` | `0x00000C45` | `0x00001000` |
| Device Tree 1 (DTB) | `0x00F16000` | `0x00000C60` | `0x00001000` |

The final allocation block terminates at `0xF17000`, followed by the 2-byte LI section CRC.
Extracted files reside in [linux/](linux); entry points and hashes are detailed in [deep_manifest.json](deep_manifest.json).

### Linux Kernel

The kernel header at offset `0x38` features the `ARMd` magic constant, conforming to the [Linux AArch64 Boot Image Protocol](https://docs.kernel.org/arch/arm64/booting.html).
The header indicates `text_offset=0` and runtime image size `0x607000`.

Extracted kernel banner:

```text
Linux version 4.14.224-ts-aarch64
gcc version 6.5.0 (Timesys 20200228)
#1 SMP PREEMPT Mon Dec 23 10:24:17 JST 2024
```

This build timestamp represents the internal compile time of the kernel binary, not the release date of firmware 3.11.
The embedded kernel config was extracted from markers `IKCFG_ST` / `IKCFG_ED` into [kernel_config.txt](linux/kernel_config.txt):

- `CONFIG_ARM64=y`, `CONFIG_ARCH_NIKON_XXX=y`
- `CONFIG_SMP=y`, `CONFIG_PREEMPT=y`
- `CONFIG_IKCONFIG=y`, `CONFIG_IKCONFIG_PROC=y`
- `CONFIG_MODULES=y`, `CONFIG_UIO=y`
- `CONFIG_NR_CPUS=64` (Compiler ceiling, not physical core count).

### Root Filesystem and Nikon Applications

The gzip stream decompresses to a **23,337,472-byte newc CPIO archive**.
All 820 paths were verified against GNU cpio: 272 regular files, 406 symbolic links, 105 directories, and 37 character devices.

Regular files are extracted to [rootfs_files](linux/rootfs_files); directory metadata is cataloged in [rootfs_inventory.json](linux/rootfs_inventory.json). Symlinks and device nodes were not created on the host filesystem. This extracted tree serves inspection and disassembly purposes, not direct emulation.

Configuration files include `etc/os-version` (Timesys LinuxLink) and `etc/inittab` (calling `rcS`).
Init script `etc/init.d/S11-LaMainApp` launches `/usr/bin/LaMainApp` in the background. Nikon user-space executables comprise:

```text
LaMainApp  LaIfCtrl  LaFtpClient  LaNetCameraCtrl  LaSyncRelease  LaLiveView
```

`LaMainApp` is an AArch64 ELF64 executable with entry point `0x4021CC`. It references `/dev/oscom_memhelper`, `OS_COM`, `/tmp/LaMainApp_unix_socket`, and `oscom_fifo_handler`, aligning with kernel modules `oscom_memhelper.ko` and `oscom_inthelper.ko` in rootfs, forming the primary inter-OS communication channel. It contains the debug string `CLaMainAppDebug_ExecuteShellCommand`, though runtime accessibility remains unverified.

The presence of network utilities in rootfs does not prove active exposure over external interfaces in camera operating modes.

### Device Trees and Hardware Peripherals

Both DTBs pass structural validation and have been decompiled to [device_tree_0.dts](linux/device_tree_0.dts) and [device_tree_1.dts](linux/device_tree_1.dts).

Shared configuration properties:

| Node / Property | Value & Context |
| --- | --- |
| `/cpus/cpu@3` | `arm,cortex-a53`, core ID 3 (Allocated to Linux) |
| System RAM | Base `0xA07800000`, size `0x07800000` (120 MiB) |
| `reserved-memory/OS_COM` | Base `0xA0F000000`, size `0x2000` |
| `reserved-memory/share_mem` | Base `0xA0F002000`, size `0x7FD000` |
| USB xHCI Controller | `socionext,sc2007-xhci` |
| Boot Arguments | `console=ttyS0,115200 rdinit=/sbin/init keepinitrd` |

The serial node contains property `console="disabled"`, indicating hardware console output may be suppressed.
The primary distinction between the two DTBs lies in SDIO parameters: DTB 0 specifies `fixed-1.8v` / `uhs-limit-sdr104`; DTB 1 specifies `fixed-3.3v` / `uhs-limit-sdr12` with a 50 MHz clock limit.

## Embedded CEVA DSP ELFs

Three embedded ELFs were identified in the EG payload, verified via ELF headers, program headers, and section table boundaries.
`e_machine=245` matches the registered CEVA architecture.

| Offset in EG | Output Filename | Size (Bytes) | Symbol Table Entries |
| --- | --- | ---: | ---: |
| `0x0151CAA0` | `ceva_0151caa0.elf` | 692,516 | 4,052 |
| `0x015C5BD0` | `ceva_015c5bd0.elf` | 456,004 | 2,739 |
| `0x01635120` | `ceva_01635120.elf` | 5,750,024 | 34,678 |

Symbol counts include local labels and section markers. Symbol CSVs and readelf outputs reside in [embedded_elf](embedded_elf).
Identified symbols include `CEVA-XM6`, `NikonTask_RTOS_TaskSwitchIn`, `FREERTOS_MEMORY`, CDNN, and convolution/activation neural network routines.
The third binary provides rich data for subject recognition research, though CEVA instruction decoding was not performed in this phase.

## Auxiliary Sections and Key Code References

The EX section has initial SP `0x20000C08` and Thumb reset vector `0x080002B5`. At base address `0x08000000`, boot code unpacks at file offset `0x2B4`, matching the MCU layout observed in Z 6. Offset `0x3709` contains string `Z 8 Firmware Ex Copyright Nikon Corp.`.

Section VR contains string `NikonBVR` at offset `0x0A`, pointing to vibration reduction firmware.
Section TPJ shares header traits with touch firmware in Z 6, though controller models remain unverified.

Key EG string and symbol offsets:

| Offset in EG | Marker Reference |
| --- | --- |
| `0x03F6403A` | `FirmwareManagement.c` |
| `0x03F65442` | `FirmwareManagement_Device_Loader.c` |
| `0x03F65515` | `FirmwareManagement_Device_Linux.c` |
| `0x03F655B7` | `FirmwareManagement_Device_Ai.c` |
| `0x028A01FE` | `NISI` (Linux container parser entry) |
| `0x03F72930` | `MovieRecordApplicationServiceData.c` |
| `0x03F72954` | `MovieRecordApplicationServiceDebugInfo.c` |
| `0x03F823F8` | `PictureControlService.c` |
| `0x0295217D` / `0x029521ED` | Apple ProRes 422 HQ / ProRes RAW HQ strings |

## Recommended Entry Points for Downstream Analysis

1. **Inter-OS Communication**: Inspect `LaMainApp` with an ELF analyzer, tracing `oscom_fifo_handler`, UNIX sockets, and helper kernel drivers.
2. **Firmware Verification**: Trace package verification through `FirmwareManagement_Device_*` and `NISI`. The prefix SHA-1 has been reproduced in subsequent ZR work, while the remaining 12 bytes require further tracing.
3. **Primary Firmware**: Import EG as raw binary `AARCH64:LE:64:v8A` at base `0x40160000`, labeling early startup routines, entry `0x401691D0`, and RAM mappings from the descriptor table.
4. **DSP / AI Subsystems**: Leverage CEVA ELF symbol tables to map API boundaries.

## Verification Scope

All 40 section CRCs, 8 package CRCs, NISI allocations, gzip streams, CPIO catalogs, DTB properties, and CEVA ELF boundaries were validated.
GNU cpio matched all 820 paths; gzip and readelf ran cleanly. All 14 automated unit tests pass.
No firmware was executed on real hardware, and raw input binaries remain unmodified.
