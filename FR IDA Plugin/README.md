# IDA Pro Fujitsu FR 处理器插件 (FR IDA Plugin)

[English](#english) | 中文说明

## 中文说明

### 简介
本项目是适用于 **IDA Pro 6.x** 的 Fujitsu FR 系列（FR65 / FR80 等）处理器增强插件。Nikon 早期数码单反相机（如 D5100、D7000、D3100、D3200、D3000、D300S 等）的主控或辅助处理器采用了富士通 FR 架构（Big-Endian 大端序）。

相比 IDA Pro 原生默认的 FR 处理器模块，本插件：
- 修复了原生处理器模块中的多处反汇编与指令解析缺陷；
- 增加了对 switch-case 跳转表的自动识别与恢复；
- 增加了类型信息推断与辅助注释。

### 作者
- **Simeon Pilgrim** (Nikon Hacker 团队)

### 编译说明
- 使用 **Visual Studio**（支持打开 `fr65.sln` 或 `fr.vcxproj`）进行编译；
- 依赖 IDA Pro SDK（通常建议与 IDA Pro SDK 目录同级放置；若移动到标准插件目录，需在工程属性中调整头文件与库文件的相对路径）。

---

<a name="english"></a>
## English

### What
This is an improved Fujitsu FR processor plugin for **IDA Pro 6.x**. It fixes several issues present in IDA's default processor module, adds switch statement jump-table detection, and improves type information handling.

### Author
- **Simeon Pilgrim**

### Compilation
This plugin can be compiled using Visual Studio (`fr65.sln` / `fr.vcxproj`). By default, this directory is expected to sit parallel to the IDA Pro SDK directory. If moved into IDA's standard processor directory, relative include and library paths in the project settings will need adjustment.
