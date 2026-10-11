# Nikon 单反与微单固件逆向笔记 (Firmware Notes)

本文件整理了 Nikon 数码单反相机（DSLR）及微单相机固件的处理器架构、加载基址（Load Base）、内存分段映射（Memory Map）与分析入口。

---

## 机型速查索引

| 机型 | 处理器架构 | 加载基址 (Load Base) | 对应 IDA 脚本 / 资源目录 | 笔记定位 |
| :--- | :--- | :--- | :--- | :--- |
| **D750** | ARM v7 LE | `0x90020000` | [IDA_files/D750/](../IDA_files/D750/) | [跳转](#d750) |
| **D780** | ARM v7 LE | `0x12020000` | - | [跳转](#d780) |
| **D7100** | ARM v7 LE | `0x50020000` | - | [跳转](#d7100) |
| **D7000** | Fujitsu FR BE | `0x8F800000` (RAM) | [IDA_files/D7000/](../IDA_files/D7000/) | [跳转](#d7000) |
| **D5500** | ARM v7 LE | `0x90020000` | - | [跳转](#d5500) |
| **D5300** | ARM v7 LE | `0x90020000` | - | [跳转](#d5300) |
| **D5200** | ARM v7 LE | `0x50020000` | [IDA_files/D5200/](../IDA_files/D5200/) | [跳转](#d5200) |
| **D5100** | Fujitsu FR BE | - | [IDA_files/D5100/](../IDA_files/D5100/) · [dfr](../dfr/) | [跳转](#d5100) |
| **D3300** | ARM v7 LE | `0x90020000` | - | [跳转](#d3300) |
| **D3200** | Fujitsu FR BE | `0x9D000000` (RAM) | [IDA_files/D3200/](../IDA_files/D3200/) | [跳转](#d3200) |
| **D3100** | Fujitsu FR BE | `0x8FA00000` (RAM) | [IDA_files/D3100/](../IDA_files/D3100/) | [跳转](#d3100) |
| **D3000** | Fujitsu FR BE | `0x800000` (RAM) | [IDA_files/D3000/](../IDA_files/D3000/) | [跳转](#d3000) |
| **D800** | ARM v7 LE | `0x84F00000` (RAM) | [IDA_files/D800/](../IDA_files/D800/) | [跳转](#d800) |
| **D600** | ARM v7 LE | `0x9E000000` (RAM) | [IDA_files/D600/](../IDA_files/D600/) | [跳转](#d600) |
| **Z 系列** | AArch64 / ARM | 参见专题报告 | [firmware decode/z-series/](../firmware%20decode/z-series/) | [跳转](#z-series) |

---

## DSLR 单反机型内存映射详情

### D750
- **固件文件**：B Firmware (`b1010_nnnd.bin`)
- **处理器架构**：ARM v7 LE
- **加载基址**：`0x90020000`
- **内存映射 (v1.10)**：
  | 源地址 (Src) | 目标地址 (Dst) | 长度 (Len) | 权限 (Status) |
  | :--- | :--- | :--- | :--- |
  | `0x912bec08` | `0x10000000` | `0x30344` | rwx |
  | `0x912eef4c` | `0x10030344` | `0xf95c` | rw |
  | `0x9135fc40` | `0x100a1400` | `0x5340c` | rw |
- **IDA 工具与脚本**：参见 [IDA_files/D750/](../IDA_files/D750/)（含 Setup RAM 1.02/1.10、PTP、Services 及 RTTI 分析脚本）。

### D780
- **固件文件**：B Firmware (`eg1510_nnnnb0.bi`)
- **处理器架构**：ARM v7 LE
- **加载基址**：`0x12020000`

### D7100
- **固件文件**：B Firmware (`b760nnnn.bin`)
- **处理器架构**：ARM v7 LE
- **加载基址**：`0x50020000`
- **内存映射 (v1.04)**：
  | 源地址 (Src) | 目标地址 (Dst) | 长度 (Len) | 权限 (Status) |
  | :--- | :--- | :--- | :--- |
  | `0x516c6388` | `0x10000000` | `0x3b284` | rwx |
  | `0x5170160c` | `0x1003b284` | `0x1670` | rw |
  | `0x517d0c80` | `0x1010ac80` | `0x1890c` | rw |

### D7000
- **固件文件**：B Firmware (`b750nnnn.bin`)
- **处理器架构**：Fujitsu FR BE
- **RAM 设置**：`0x8F800000`
- **IDA 工具与脚本**：参见 [IDA_files/D7000/](../IDA_files/D7000/)（含 1.05 菜单文本转储、ExifTables、系统任务表、PTP 代码与 RAM 设置脚本）。

### D5500
- **固件文件**：B Firmware (`b1120_nnn.bin`)
- **处理器架构**：ARM v7 LE
- **加载基址**：`0x90020000`
- **内存映射 (v1.02)**：
  | 源地址 (Src) | 目标地址 (Dst) | 长度 (Len) | 权限 (Status) |
  | :--- | :--- | :--- | :--- |
  | `0x9109dd3c` | `0x10000000` | `0x30ac4` | rwx |
  | `0x910ce800` | `0x10030ac4` | `0xd718` | rw |
  | `0x9113e060` | `0x100a0700` | `0x5cbfc` | rw |
  | `0x9113e048` | `0x100a0308` | `0x4` | rw |

### D5300
- **固件文件**：B Firmware (`b930_nnn.bin`)
- **处理器架构**：ARM v7 LE
- **加载基址**：`0x90020000`
- **内存映射 (v1.03)**：
  | 源地址 (Src) | 目标地址 (Dst) | 长度 (Len) | 权限 (Status) |
  | :--- | :--- | :--- | :--- |
  | `0x91498e24` | `0x10000000` | `0x3b5b4` | rwx |
  | `0x914d43d8` | `0x1003b5b4` | `0x1834` | rw |
  | `0x915b26a0` | `0x10119c60` | `0x1cd4c` | rw |
  | `0x915b2688` | `0x10119868` | `0x4` | rw |
- **分段布局 (Segments)**：
  | 地址 (Addr) | 长度 (Len) | 权限 (Status) | 备注 (Notes) |
  | :--- | :--- | :--- | :--- |
  | `0x10000000` | ? | rwx | Kernel |
  | `0x90020000` | ? | rx | B Firmware |
  | `0xA2000000` | ? | rwv | A Firmware 共享内存窗口 |

### D5200
- **固件文件**：B Firmware (`b970nnna.bin`)
- **处理器架构**：ARM v7 LE
- **加载基址**：`0x50020000`
- **内存映射 (v1.03)**：
  | 源地址 (Src) | 目标地址 (Dst) | 长度 (Len) | 权限 (Status) |
  | :--- | :--- | :--- | :--- |
  | `0x51494220` | `0x10000000` | `0x3c758` | rwx |
  | `0x514d0978` | `0x1003c758` | `0x10e4` | rw |
  | `0x515a6280` | `0x101123e0` | `0x1a60c` | rw |
- **IDA 工具与脚本**：参见 [IDA_files/D5200/](../IDA_files/D5200/)（含 RTTI 脚本、函数表、资源表、语言表）。

### D5100
- **固件文件**：B Firmware (`b640nnnb.bin`)
- **处理器架构**：Fujitsu FR BE
- **相关工具与脚本**：
  - [dfr/d5100.txt](../dfr/d5100.txt)：代码与内存映射定义
  - [IDA_files/D5100/](../IDA_files/D5100/)：含 ROM 加载、RAM 设置、菜单与符号表修复脚本。

### D3300
- **固件文件**：B Firmware (`b860_nnn.bin`)
- **处理器架构**：ARM v7 LE
- **加载基址**：`0x90020000`
- **内存映射 (v1.02)**：
  | 源地址 (Src) | 目标地址 (Dst) | 长度 (Len) | 权限 (Status) |
  | :--- | :--- | :--- | :--- |
  | `0x9158a358` | `0x10000000` | `0x0003b5b4` | rwx |
  | `0x915c590c` | `0x1003b5b4` | `0x0000179c` | rw |
  | `0x916a73a0` | `0x1011d420` | `0x00028b3c` | rw |
  | `0x916a739c` | `0x1011d03c` | 4 | rw |

### D3200
- **固件文件**：B Firmware (`b830nnna.bin`)
- **处理器架构**：Fujitsu FR BE
- **IDA 脚本**：参见 [IDA_files/D3200/](../IDA_files/D3200/)。

### D3100
- **固件文件**：B Firmware
- **处理器架构**：Fujitsu FR BE
- **IDA 脚本**：参见 [IDA_files/D3100/](../IDA_files/D3100/)。

### D3000
- **固件文件**：B Firmware
- **处理器架构**：Fujitsu FR BE
- **IDA 脚本**：参见 [IDA_files/D3000/](../IDA_files/D3000/)。

### D800 / D800E
- **固件文件**：B Firmware
- **处理器架构**：ARM v7 LE
- **IDA 脚本**：参见 [IDA_files/D800/](../IDA_files/D800/)。

### D600 / D610
- **固件文件**：B Firmware
- **处理器架构**：ARM v7 LE
- **IDA 脚本**：参见 [IDA_files/D600/](../IDA_files/D600/)。

---

## Z-series 微单机型概要与索引

Z 系列相机采用了新一代硬件架构（EXPEED 6 / EXPEED 7），已从传统的单个单片机固件演变为包含主 CPU、独立 Linux 系统与多个 DSP 神经网络协处理器的异构多核系统：

- **Z6 / Z7 (EXPEED 6)**：ARM/Thumb，SMP T-Kernel 实时操作系统，主固件基址 `0x10020000`。
  - [Z6 3.80 逆向报告](../firmware%20decode/z-series/analysis/Z_6_0380/REPORT.md)
  - [Z7 3.80 逆向报告](../firmware%20decode/z-series/analysis/Z_7_0380/REPORT.md)
- **Z8 / Z9 (EXPEED 7)**：AArch64，SOLID-OS / TOPPERS/FMP，Linux 4.14.224 运行时环境，内嵌 3 个 CEVA DSP ELF 图像与神经网络推理程序。
  - [Z8 3.11 逆向报告](../firmware%20decode/z-series/analysis/Z_8_0311/REPORT.md)
  - [Z9 5.32 逆向报告](../firmware%20decode/z-series/analysis/Z_9_0532/REPORT.md)
  - [Z8 QEMU 板级仿真指南](../firmware%20decode/z-series/qemu/z8/README.md)
- **Z f / Z50 II / Z5 II / Z6 III / ZR (新封装)**：自 2023 年 Z f 起引入 `0x260` 扩展前缀新封装格式。
  - [Z f 3.01 分析报告](../firmware%20decode/z-series/analysis/Z_f_0301/REPORT.md)
  - [Z5 II 1.20 局部恢复报告](../firmware%20decode/z-series/analysis/Z5_2_0120/REPORT.md)
  - [ZR 1.11 容器分析报告](../firmware%20decode/z-series/analysis/ZR__0111/REPORT.md)
- **Z 系列完整分析工具与复现指南**：详见 [firmware decode/z-series/README.md](../firmware%20decode/z-series/README.md)。
