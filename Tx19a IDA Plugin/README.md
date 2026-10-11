# IDA Pro Toshiba TX19A 处理器插件 (Tx19a IDA Plugin)

[English](#english) | 中文说明

## 中文说明

### 简介
本项目是适用于 **IDA Pro 6.x** 的处理器插件（需要 IDA 具备 MIPS 架构支持），完整实现了**东芝 TX19A（Toshiba TX19A MIPS 指令集扩展）**的反汇编支持。

部分数码相机固件（包括 Canon 及特定型号数码设备）采用了东芝 TMP19A / TX19A 系列 RISC 控制器。

### 作者与历史背景
- **原作者**：JollyRogerXP (2009 年在逆向佳能数码相机与摄像机时编写)。
- **历史**：代码最初发布于 CHDK 社区论坛。后来原帖附件失效，Nikon Hacker 团队与 JollyRogerXP 取得联系后获得代码副本，由 Indy Arm 协助找回并在此开源仓库中永久保存。

### 编译说明
- 使用 **Visual Studio** 配合 IDA Pro C/C++ 插件规范进行编译。
- 编译生成产物为 `tx19a.plw`（IDA Pro 32 位插件）。

### 历史参考资料
- [32Bit TX System RISC TX19A Family Architecture](http://www.semicon.toshiba.co.jp/info/docget.jsp?type=CpuArchitecture1&lang=en&pid=TMP19A43CDXBG) `[东芝官方文档/历史归档]`
- [IDA PLUG-IN WRITING IN C/C++](http://www.binarypool.com/idapluginwriting/idapw.pdf) `[历史归档]`
- [CHDK 论坛 JollyRogerXP 原帖讨论](http://chdk.setepontos.com/index.php?topic=1641.msg38489#msg38489) `[历史归档]`
- [CHDK Wiki: HV30 Firmware Analysis](http://chdk.wikia.com/wiki/HV30_Firmware_Analysis) `[历史归档]`
- [Magic Lantern Wiki: Tx19a](http://magiclantern.wikia.com/wiki/Tx19a) `[历史归档]`

---

<a name="english"></a>
## English

### What
This is a plugin for **IDA Pro 6.x** (MIPS architecture support required!) that implements Toshiba's **TX19A MIPS instruction set extension**.

### Author & History
- **Author**: JollyRogerXP (2009).
- **History**: Originally created by JollyRogerXP in 2009 while reverse engineering Canon still and video cameras on the CHDK forums. After the original forum download link went dead, Nikon Hacker re-established contact with JollyRogerXP, who generously provided a copy for hosting here. Special thanks to Indy Arm for recovering and forwarding the source.

### Compilation
Compile using Visual Studio in conjunction with the IDA Pro SDK according to standard IDA C/C++ plugin guidelines.
Binary target: `tx19a.plw`.
