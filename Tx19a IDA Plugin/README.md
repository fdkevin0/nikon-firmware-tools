# Toshiba TX19A Processor Plugin for IDA Pro

## Overview
This is a plugin for **IDA Pro 6.x** (MIPS architecture support required) implementing Toshiba's **TX19A MIPS instruction set extension**.

Certain digital camera subsystems (including specific Canon and Nikon architectures) utilize Toshiba TMP19A / TX19A family RISC microcontrollers.

## Author & Historical Background
- **Original Author**: JollyRogerXP (written in 2009 while reverse engineering Canon cameras and camcorders).
- **History**: Originally posted to the CHDK forums. When the original download link expired, the Nikon Hacker team contacted JollyRogerXP, who generously provided a copy. Special thanks to Indy Arm for recovering and forwarding the source code for permanent hosting here.

## Compilation
Compile using Visual Studio alongside the IDA Pro SDK following standard IDA C/C++ plugin conventions.
Target binary: `tx19a.plw`.

## Historical References
- [32Bit TX System RISC TX19A Family Architecture](http://www.semicon.toshiba.co.jp/info/docget.jsp?type=CpuArchitecture1&lang=en&pid=TMP19A43CDXBG) `[Archived]`
- [IDA PLUG-IN WRITING IN C/C++](http://www.binarypool.com/idapluginwriting/idapw.pdf) `[Archived]`
- [CHDK Forum Discussion by JollyRogerXP](http://chdk.setepontos.com/index.php?topic=1641.msg38489#msg38489) `[Archived]`
- [CHDK Wiki: HV30 Firmware Analysis](http://chdk.wikia.com/wiki/HV30_Firmware_Analysis) `[Archived]`
- [Magic Lantern Wiki: Tx19a](http://magiclantern.wikia.com/wiki/Tx19a) `[Archived]`
