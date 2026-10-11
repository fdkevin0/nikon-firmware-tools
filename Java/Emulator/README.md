# Nikon 固件 Java 模拟器与反汇编套件 (Java Emulator)

[English](#english) | 中文说明

> [!CAUTION]
> **风险提示**：修改相机固件存在极高的风险，可能导致相机永久损坏（“变砖”）。本项目所有工具与文档仅供逆向研究与学习参考。

---

## 中文说明

### 简介
本模块是 Nikon Hacker 早期基于 Java 开发的固件模拟与逆向工具集合，主要面向采用 **Fujitsu FR** 或 **Toshiba TX (TMP19A)** 架构处理器的数码相机（如 D5100 等）。

### 包含工具
1. **`startEmulator` (固件图形化模拟器)**
   - 启动交互式模拟器用户界面，支持加载已解码的固件二进制文件并观察执行与内存状态。
   - 包含工具菜单，可在界面内直接调用解码功能。
2. **`startDfr` (Fujitsu FR 反汇编器)**
   - 将 Kevin Schoedel 的原版 Dfr 移植到 Java 平台，支持配合内存映射文件（如 `Dfr.txt` / `d5100.txt`）对 FR 二进制代码进行符号化反汇编。
3. **`startDtx` (Toshiba TMP19A 反汇编器)**
   - 针对东芝 TMP19A 处理器的反汇编工具，用法类似于 Dfr。
4. **`startFirmwareDecoder` (固件解码工具)**
   - 命令行固件解码工具，可解开加密固件包并输出各个分段文件。

### 运行环境与启动方式
- **Java 环境**：需要 JRE / JDK 7 或更高版本，确保 `JAVA_HOME` 与 `PATH` 配置正确。
- **启动脚本**：
  - Windows: 运行批处理脚本（如 `startEmulator.bat`、`startDfr.bat`）
  - Linux: 运行 shell 脚本（如 `startEmulator.sh`）

### 镜头通信协议文档
在子目录 [doc/lens/](doc/lens/README.md) 中，保存了珍贵的机身与镜头通信协议资料（包括 Gazalou 的研究成果、电气引脚定义与 PIC 单片机模拟镜头源码）。

---

<a name="english"></a>
## English

### Overview
This software is a collection of Java-based tools developed by the Nikon Hacker team to analyze and emulate camera firmware running on **Fujitsu FR** or **Toshiba TX (TMP19A)** processors.

### Included Tools
- **`startEmulator`**: Launches the main emulator GUI. Can load decoded firmware binaries directly.
- **`startDfr`**: A Fujitsu FR disassembler ported from Kevin Schoedel's original Dfr. Expects a mapping configuration file (e.g. `Dfr.txt`).
- **`startDtx`**: A Toshiba TMP19A disassembler for MIPS-based camera subsystems.
- **`startFirmwareDecoder`**: Command-line utility to unpack and decrypt encrypted firmware packages into constituent segments.

### Requirements & Launching
- Requires Java 1.7 or newer.
- Windows: Run `startEmulator.bat`
- Linux: Run `startEmulator.sh`
- Historical documentation: [NikonEmulator Wiki](http://nikonhacker.com/wiki/NikonEmulator) `[Archived]`
