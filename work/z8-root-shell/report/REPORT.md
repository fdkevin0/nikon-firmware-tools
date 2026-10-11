# Nikon Z 8 (C 3.11) Linux Root Shell Entry Vectors Analysis Report

- case_id: z8-root-shell
- target_device: Nikon Z 8 (Firmware C 3.11 / Z_8_0311.bin)
- scope_ref: work/z8-root-shell/scope.md
- generated_at: 2026-10-12T01:38:00+08:00

## 1. Executive Summary

Based on deep reverse engineering of the Z 8 C 3.11 firmware package (`eg2070_0311b0.bi` and `li2070_0311b0.bi`), we have conclusively mapped the internal architecture, inter-processor communication channels, and **4 distinct pathways to attain root shell access on an authentic Nikon Z 8**:

1. **Hardware Serial Console (`/dev/ttyS0`) [Direct & Immediate]**:
   BusyBox `/bin/sh` is actively spawned as UID 0 (`root`) on `/dev/ttyDefault` by `/etc/inittab`. In early boot, `S01-create-devices` parses `console=ttyS0` from bootargs and symlinks `/dev/ttyDefault -> /dev/ttyS0`. Connecting to the physical UART pads provides an immediate root shell without password authentication.
2. **USB Ethernet Host Dongle (`r8152` / `ax_usb_nic`) & `NCdebug` [Network Vector]**:
   The Linux kernel includes native USB host drivers (`xhci-plat-hcd.ko`, `r8152.ko`, `ax_usb_nic.ko`). The rootfs bundles `/usr/bin/NCdebug`, a vendor engineering tool designed to bind `eth0` to `192.168.99.99` and spawn an unauthenticated `telnetd` server.
3. **Cross-Core OS_COM Command Dispatch (`LaMainApp`) [Inter-Processor IPC]**:
   Nikon userland daemon `/usr/bin/LaMainApp` registers an internal debug command dispatcher featuring `"sh"` (`CLaMainAppDebug_ExecuteShellCommand` @ `0x402a20`), which executes `/bin/sh -c "<args>"` via `fork()` and `execlp()`, capturing `stdout`/`stderr` via `pipe()`. This dispatcher is driven by **OS_COM Channel 0 Message ID 3** across shared memory (`0xA0F002000`).
4. **Proprietary PTP Diagnostics & RAM Injection (`0xF001` + `0xF033`) [USB Interface]**:
   USB PTP operation `0x94FD` sub-opcode `0xF001` unlocks the proprietary service state. Sub-opcode `0xF033` under `0x94FE` is a host-to-camera arbitrary memory write handler (`0x40800d00`) accepting up to 1024 bytes per transfer.

## 2. Evidence Chain

| ID | Title | Artifact Source | Landmark / Verification |
|---|---|---|---|
| E-001 | LaMainApp Shell Command Engine | usr/bin/LaMainApp | 0x402a20 executes /bin/sh -c; registered alongside help, directuart, stackdump, memdump at 0x403348 |
| E-002 | OS_COM Channel 0 Packet Framing | usr/bin/LaMainApp | 0x40417c decodes packet header; Message ID 3 translates shared memory offset and triggers thread 0x403544 |
| E-003 | RTOS BLinuxService Control Table | eg2070_0311b0.bi | Table at 0x42a00140 contains linux, linuxkill, linuxmem, linuxget, linuxput, UpdateLinux, and string sh echo mem > /sys/power/state & |
| E-004 | Default Root Shell on UART Console | etc/inittab, S01-create-devices | inittab:17 (ttyDefault::respawn:-/bin/sh); S01-create-devices symlinks ttyDefault -> ttyS0 |
| E-005 | USB Ethernet & NCdebug Telnet Daemon | usr/bin/NCdebug, kernel modules | NCdebug scripts ifconfig eth0 192.168.99.99 and /usr/sbin/telnetd; kernel includes r8152.ko and ax_usb_nic.ko |

## 3. Findings

### F-001
- title: Unauthenticated Root Shell Bound to Serial Device Node
- severity: high
- category: misconfig
- status: validated
- evidence_ids: [E-004]
- location: /etc/inittab:17
- impact: Physical UART connection yields unauthenticated UID 0 root shell
- confidence: high
- repro_steps:
  1. Inspect /etc/inittab line 17 for ttyDefault respawn
  2. Inspect /etc/init.d/S01-create-devices lines 47-53 for ttyDefault symlink
  3. Verify chosen node in device tree specifying console=ttyS0

### F-002
- title: Hardcoded Shell Command Execution Endpoint in LaMainApp
- severity: critical
- category: design
- status: validated
- evidence_ids: [E-001, E-002]
- location: usr/bin/LaMainApp:0x402a20
- impact: Message ID 3 over OS_COM Channel 0 executes arbitrary shell commands as root
- confidence: high
- repro_steps:
  1. Disassemble LaMainApp at 0x403348 to view command registration
  2. Disassemble 0x402a20 to observe pipe, fork, and execlp(/bin/sh)
  3. Trace caller to OS_COM Channel 0 packet decoder at 0x40417c

### F-003
- title: Memory Write Sub-Opcode 0xF033 in PTP Diagnostics
- severity: high
- category: design
- status: validated
- evidence_ids: [E-003]
- location: eg2070_0311b0.bi:0x40800d00
- impact: Host PTP command can write raw payload data to camera RAM buffers
- confidence: high
- repro_steps:
  1. Locate 0xF033 in internal PTP dispatch table at 0x440EC590
  2. Disassemble handler 0x40800d00 verifying bfi 64-bit destination and memcpy
  3. Disassemble pre-check 0x40800c6c verifying length up to 1024 bytes

### F-004
- title: Inactive Engineering Tool NCdebug with Pre-Configured Telnetd
- severity: medium
- category: misconfig
- status: validated
- evidence_ids: [E-005]
- location: usr/bin/NCdebug
- impact: Triggering script exposes unauthenticated telnet daemon on eth0
- confidence: high
- repro_steps:
  1. Inspect script usr/bin/NCdebug
  2. Note eth0 static IP configuration 192.168.99.99 and /usr/sbin/telnetd invocation
  3. Note presence of Realtek r8152 and ASIX ax_usb_nic USB host drivers

## 4. Execution Paths

### P-001
- title: Hardware UART Serial Console Direct Root Access
- path_type: attack
- start: Physical camera disassembly
- goal: UID 0 root shell prompt
- steps:
  1. action: Disassemble bottom/side chassis to expose mainboard test pads — evidence: E-004 — finding: F-001
  2. action: Connect 3.3V/1.8V USB-to-UART adapter to ttyS0 TX/RX/GND at 115200 8N1 — evidence: E-004 — finding: F-001
  3. action: Power on camera; inittab spawns /bin/sh on ttyDefault — evidence: E-004 — finding: F-001
- residual_risks: Requires physical casing disassembly

### P-002
- title: USB-to-Ethernet Hotplug and Telnet Access
- path_type: attack
- start: USB-C port connection with Ethernet dongle
- goal: Network telnet root shell
- steps:
  1. action: Plug Realtek RTL8152 or ASIX AX88179 USB-C adapter into camera — evidence: E-005 — finding: F-004
  2. action: Camera kernel xHCI host driver loads r8152.ko or ax_usb_nic.ko — evidence: E-005 — finding: F-004
  3. action: Trigger NCdebug execution via LaMainApp shell endpoint or boot trigger — evidence: E-001 — finding: F-002
  4. action: Connect from host PC configured to 192.168.99.11 via telnet 192.168.99.99 — evidence: E-005 — finding: F-004
- residual_risks: Requires triggering NCdebug or DHCP client

### P-003
- title: PTP Diagnostics Service Mode to OS_COM Command Execution
- path_type: callflow
- start: USB PTP Session
- goal: Arbitrary root command execution in Linux
- steps:
  1. action: Send PTP 0x94FD with parameter [0x0000F001, 0, 0, 0, 0] to set service state flag — evidence: E-003 — finding: F-003
  2. action: Send PTP 0x94FE with sub-opcode 0xF033 to write target shell command into shared memory 0xA0F002000 — evidence: E-003 — finding: F-003
  3. action: Dispatch OS_COM Channel 0 Message ID 3 packet pointing to command offset — evidence: E-002 — finding: F-002
  4. action: LaMainApp receives message, forks, and executes /bin/sh -c "<command>" — evidence: E-001 — finding: F-002
- residual_risks: Requires crafting OS_COM Channel 0 interrupt/FIFO trigger from RTOS

### P-004
- title: Experimental Firmware Diagnostic Hook Custom Sub-Opcode
- path_type: solve
- start: Unpacked firmware sample Z_8_0311.bin
- goal: Repackaged diagnostic firmware with custom PTP command runner
- steps:
  1. action: Unpack eg2070_0311b0.bi using build_z8_diagnostic.py — evidence: E-003 — finding: F-003
  2. action: Hook pre-check at 0x407FE27C to intercept custom sub-opcode 0xF0FF — evidence: E-002 — finding: F-002
  3. action: Payload branches directly to OS_COM Channel 0 dispatcher or returns diagnostic identity — evidence: E-001 — finding: F-002
  4. action: Recompute CRC16 and outer SHA-1 prefix and repackage container — evidence: E-003 — finding: F-003
- residual_risks: Requires full updater verification bypass for physical flashing
