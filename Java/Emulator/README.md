# Nikon Firmware Java Emulator & Disassembly Suite

> [!CAUTION]
> **Risk Warning**: Modifying camera firmware carries high risks and can permanently brick your camera. All tools and notes here are provided strictly for educational and reverse engineering research.

---

## Overview
This suite is a collection of Java-based tools developed by the early Nikon Hacker team to analyze and emulate firmware targeting **Fujitsu FR** or **Toshiba TX (TMP19A)** processors (such as the Nikon D5100).

## Included Tools

1. **`startEmulator` (Interactive Firmware Emulator)**
   - Launches a GUI emulator capable of loading decoded firmware binaries to inspect memory structures and execution flows.
   - Includes a Tools menu to decode packages directly within the UI.
2. **`startDfr` (Fujitsu FR Disassembler)**
   - A Java port of Kevin Schoedel's original Dfr tool. Uses memory and code mapping definition files (e.g. `d5100.txt`) to produce symbolicated FR disassembly.
3. **`startDtx` (Toshiba TMP19A Disassembler)**
   - Disassembler tailored for Toshiba TMP19A microcontrollers.
4. **`startFirmwareDecoder` (Firmware Decoding Tool)**
   - CLI utility to unpack encrypted firmware into individual section binaries.

## Requirements & Launching
- **Java Runtime**: JRE / JDK 7 or higher (`JAVA_HOME` and `PATH` must be configured).
- **Scripts**:
  - Windows: Run `.bat` files (`startEmulator.bat`, `startDfr.bat`, etc.)
  - Linux: Run `.sh` shell scripts (`startEmulator.sh`)

## Lens Communication Documentation
In the [doc/lens/](doc/lens/README.md) subdirectory, historical technical articles covering F-mount body-lens serial communication protocols are preserved (including research by Gazalou, pinout specifications, and PIC microcontroller emulation prototypes).
