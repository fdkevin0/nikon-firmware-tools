# Fujitsu FR Processor Plugin for IDA Pro

## Overview
This is an improved Fujitsu FR processor plugin for **IDA Pro 6.x** (FR65 / FR80 family, Big-Endian). Early Nikon DSLRs (such as D5100, D7000, D3100, D3200, D3000, D300S) utilized Fujitsu FR microcontrollers for main control or camera subsystem processing.

Compared to IDA Pro's default FR processor module, this plugin:
- Fixes several disassembly and instruction decoding defects in the default module;
- Adds automatic detection and recovery of switch-case jump tables;
- Improves type information and struct offset propagation.

## Author
- **Simeon Pilgrim** (Nikon Hacker team)

## Compilation
Compile using Visual Studio (`fr65.sln` / `fr.vcxproj`) alongside the IDA Pro SDK. By default, this directory is expected to sit parallel to the IDA Pro SDK directory. If placed directly in IDA's processor directory, adjust relative include and library paths in the project configuration.
