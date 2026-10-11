# 固件解码与分析 (Firmware Decode)

本目录包含 Nikon 固件解包、解码、分段提取与深入逆向工程的工具和研究成果。

## 工具分类与使用指引

不同机型与固件版本使用不同的解包工具：

### 1. 经典单反相机 (DSLR) 固件解包
- **工具**：[Nikon-Patch LocalUI](../Nikon-Patch/) 或 [Nikon-Patch-JS (Web 版)](../Nikon-Patch-JS/)
- **操作方式**：
  - 在桌面端运行 `LocalUI`，点击 **"Decode Firmware"** 按钮选择 `.bin` 固件即可解出各分段；
  - 或在命令行使用 [firmware decode.sln](firmware%20decode.sln) 编译出的可执行文件进行解包。
- **内存映射与基址参考**：详见 [FirmwareNotes](../FirmwareNotes/FirmwareNotes.md) 与 [IDA_files](../IDA_files/)。

### 2. Nikon Z 系列微单固件解包与深度逆向 (Python 工具链)
- **主目录**：[z-series/README.md](z-series/README.md)
- **适用机型**：覆盖 15 款 Z 系列机身（Z6, Z7, Z50, Z5, Z6II, Z7II, Z fc, Z9, Z30, Z8, Z f, Z6III, Z50II, Z5II, ZR）。
- **核心工具**：位于 `z-series/tools/`，采用 Python 3 编写：
  - `analyze_firmware.py`：传统三表 XOR 封装通用解包（支持 Z6, Z8 等旧封装样本）；
  - `analyze_zf.py` / `analyze_z5ii.py` / `analyze_zr.py`：针对 `0x260` 扩展头新封装的差分恢复与容器分析；
  - `collect_all_z_history.py` / `compare_all_z_history.py`：历史固件批量采集与逐版对比。
- **仿真与深入报告**：包含 Z8 官方固件引导 QEMU 适配、Open Gate 视频录制可行性调研、CEVA DSP ELF 模块分析等。
