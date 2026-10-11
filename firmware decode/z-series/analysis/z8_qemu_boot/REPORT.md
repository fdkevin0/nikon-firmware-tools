# Z 8 3.11 Official Firmware QEMU Boot Progress

An AArch64 Z 8 board model has been added to execute the **unmodified official 3.11 firmware payload**:
EL3 boot, EL1 initialization, authentic DMA clearing and copying, firmware-driven core release for CPUs 1 and 2, RTOS scheduling, and platform device tasks.
**Full camera boot, native setup menus, Linux subsystems, and visual diagnostic patch verification remain incomplete.**

See [QEMU Build & Run Guide](../../qemu/z8/README.md), [Board Model Source](../../qemu/z8/nikon-z8.c), [Manifest](manifest.json), and [Z7 Reference Study](../z7_qemu_reference/REPORT.md).

## Input Artifacts and Execution Boundaries

| Artifact | SHA-256 |
| --- | --- |
| Official `Z_8_0311.bin` | `d67413c2ede6b9ce8887175f20700bd9fbad2a973a4820968c45503d15d80d96` |
| Unpacked EG section (with 2-byte CRC) | `f85e0138e2f5e660ece8560de62e0d12cb795e0e14983e50f20b61dce906c46c` |
| Flashed EG payload (81,807,709 bytes) | `2b43a31c9de838f84b12416de4348a7004e65be07f853ec56ec2b10f3a8e3853` |
| Official QEMU 10.2.4 source tarball | `821b545b92f165e57dddccac5077d76d4d436a226595b8813ad59306bbfd0746` |

The container CRC `201b` is stripped prior to flashing simulated ROM. Execution begins at reset vector `0x40160000` without modifying opcodes, altering PC via GDB, or injecting bootloader shortcuts. Initialized RAM is populated by official code executing through simulated DMA.
Only EG is loaded; EX MCU, VR, and Linux sections are not simulated in this harness.

## Verified Official Boot Breakpoint

Execution halts at official RTOS kernel entry `0x401691d0`:

| Inspection Item | Value / Observation |
| --- | --- |
| Primary Core PC | `0x401691d0` |
| Primary Core SP | `0xa02801140` |
| Primary Core CPSR | `0x60000004` (EL1) |
| Official Boot Descriptor | Copied by firmware to `0xa02800048` |
| Initialized Data | All `0x2ad000` bytes of `EG[0x4b13000:0x4dc0000]` match `RAM[0xa02808000:0xa02ab5000]` |
| CPUs 1 and 2 | Released by firmware via SRAM mailboxes; parked at `0x40160348` awaiting primary core |
| CPU 3 | Powered down, awaiting firmware initialization of Linux entry points |
| Container CRC Offset | In erased state (`0xff 0xff`), not populated with `20 1b` |

Continuing execution enters RTOS scheduling, GIC interrupt delivery, and platform bus initialization. Exception logs record active IRQs on CPUs 0, 1, and 2.

## Model Subsystems and Assumptions

| Component | Implemented Behavior | Validation Scope |
| --- | --- | --- |
| CPU / GIC | 4 Cortex-A53 cores, GICv3, 24 MHz ARM arch timer | Core type based on DTB references |
| Memory | EG ROM at `0x40160000`; 1 GiB DDR at `0xa00000000` | DDR capacity is an assumption |
| Memory DMA | 6 channels, row-stride copies, zero-fill, byte-fill, W1C status | Retains row gaps; 1 µs completion delay assumed |
| Aux Memory | Heap pool at `0x8ff800000` (8 MiB), shared SRAM at `0x16020000` (2 KiB) | Mirrored mappings unverified |
| Core Release | Powers on secondary cores when firmware writes boot cookies | Firmware-driven release |
| Sequencer | Status latching, timed completion, IRQ 224 | 1 µs delay assumed |
| Peripheral Registers | Address and width decoding from ROM tables | Read-zero reset assumed |
| Timers / Counters | Periodic overflow, one-shot counts, W1C, IRQs 155..167 | 100 MHz clock assumed |
| I2C | 4 buses: BUSY → delayed NACK → IRQ sequence | Cadence compatibility assumed; no slave devices |
| SPI | 11 ports: master FIFO shift/ACK; slave clock wait | FIFO 16 words, MISO high assumed; no external MCUs |
| UART | 3 ports, startup flag ACK, TX transmission | TX-empty timing assumed; no RX source |
| HDMAC | 3 groups of 8 channels, control word decoding | Channel enable currently rejected; no DMA transfers |
| Platform Control | Latching 8 parameter fields and gates | Signal output marked unemulated |
| Reset Controllers | Reset toggles for engines at `0x153c0000/0x15400000` | Disables processed without generating output |

SPI and I2C models draw from [`z7-qemu`](/home/fdkevin/Workspaces/z7-qemu/qemu/nikon-z7-lab.c). Z 8 allocates individual SPI IRQs `211…221` per port rather than paired IRQs. MISO high-level pull-ups model a disconnected bus, not device responses.

## Unmapped Flash Storage

The EG partition spans `[0x40160000, 0x45980000)`. Official code accesses regions beyond this (e.g. `0x46400000`).
The model maps `[0x45980000, 0x48000000)` as erased flash (`0xff`), logging `Z8_ABSENT_FLASH_HYPOTHESIS`. External resources including Resource `0x5c` remain unobtained; see the [Flash Layout Report](../z8_flash_layout/REPORT.md).

## Verification and Current Execution Blockers

- Test suites validate DMA data integrity (2D strides, non-zero fill), I2C NACKs, SPI FIFOs, and 4-core enumeration.
- Negative tests confirm halts on invalid DMA targets, unconfigured gates, and unmodeled registers.
- Official code on I2C channel 3 sends 2 bytes to address `0x38`, receives a NACK, and retries successfully.

The primary execution halt occurs during **HDMAC channel activation**: routine `0x40c16948` writes `0x9200004b` (Group 0, Channel 4 enable) to `0x0e100180`. The model logs `Z8_HDMAC_REQUEST` and terminates with `data_transferred=0`. Captured request fields:
`1200004b, 25180000, 00000404, 00000000, 00000000, 00000000, 0e700700, 00000000`. Target address points to **SPI 7 Data Register**, with source address zero.

See [HDMAC Landmarks](hdmac_landmarks.asm) for descriptors and base tables at `0x4164bb98`.
The Linux [Milbeaut HDMAC Driver](https://github.com/torvalds/linux/blob/v6.12/drivers/dma/milbeaut-hdmac.c) shares similar control bits, though channel strides and register layouts differ. Next steps require mapping zero-source buffer handling and SPI FIFO integration.

See [README](../../qemu/z8/README.md) for execution commands.
