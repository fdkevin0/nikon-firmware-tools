# Nikon 相机处理器架构与固件逆向状态总矩阵 (Master Camera Matrix)

本矩阵整合了 Nikon Hacker 社区历史资料（`camera_matrix.csv`、`FirmwareNotes.md`）以及最新的 [Z 系列发布时间表](../firmware%20decode/z-series/RELEASE_TIMELINE.md)，全面梳理从早期数码单反到最新 Z 系列微单的硬件架构、处理器代际、固件封装格式及本仓库逆向支持状态。

---

## 1. Nikon Z 系列微单相机 (Mirrorless)

| 公告日期 | 机型 | 画幅 | 处理器 | 主 CPU 架构 | 运行时 / OS | 封装格式 | 逆向状态与核心产物 | 对应报告与工具 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 2018-08-23 | **Z7** | FX | EXPEED 6 | ARM/Thumb (32-bit) | SMP T-Kernel | 旧三表 XOR | 完整解包，四分段 CRC 与整包验证通过 | [Z7 3.80 报告](../firmware%20decode/z-series/analysis/Z_7_0380/REPORT.md) |
| 2018-08-23 | **Z6** | FX | EXPEED 6 | ARM/Thumb (32-bit) | SMP T-Kernel | 旧三表 XOR | 完整解包，四分段 CRC 与重编码一致性验证 | [Z6 3.80 报告](../firmware%20decode/z-series/analysis/Z_6_0380/REPORT.md) |
| 2019-10-10 | **Z50** | DX | EXPEED 6 | ARM/Thumb (32-bit) | T-Kernel | 旧三表 XOR | 完整解包，三分段 CRC 验证通过 | [Z50 2.60 报告](../firmware%20decode/z-series/analysis/Z_50_0260/REPORT.md) |
| 2020-07-21 | **Z5** | FX | EXPEED 6 | ARM/Thumb (32-bit) | T-Kernel | 旧三表 XOR | 完整解包，四分段 CRC 验证通过 | [Z5 1.50 报告](../firmware%20decode/z-series/analysis/Z_5_0150/REPORT.md) |
| 2020-10-14 | **Z6II** | FX | 双 EXPEED 6 | ARM/Thumb (32-bit) | 双核/双系统 | 旧三表 XOR | 完整解包，独立主/从程序 (`mas`/`sla`) 分别验证 | [Z6II 1.70 报告](../firmware%20decode/z-series/analysis/Z6_2_0170/REPORT.md) |
| 2020-10-14 | **Z7II** | FX | 双 EXPEED 6 | ARM/Thumb (32-bit) | 双核/双系统 | 旧三表 XOR | 完整解包，独立主/从程序 (`mas`/`sla`) 分别验证 | [Z7II 1.70 报告](../firmware%20decode/z-series/analysis/Z7_2_0170/REPORT.md) |
| 2021-06-29 | **Z fc** | DX | EXPEED 6 | ARM/Thumb (32-bit) | T-Kernel | 旧三表 XOR | 完整解包，三分段 CRC 验证通过 | [Z fc 1.81 报告](../firmware%20decode/z-series/analysis/Z_fc_0181/REPORT.md) |
| 2021-10-28 | **Z9** | FX | EXPEED 7 | AArch64 (64-bit) | TOPPERS + Linux 4.14 | 旧三表 XOR | 完整解包，内核/根文件系统/CEVA DSP 提取与全历史比对 | [Z9 5.32 报告](../firmware%20decode/z-series/analysis/Z_9_0532/REPORT.md) |
| 2022-06-29 | **Z30** | DX | EXPEED 6 | ARM/Thumb (32-bit) | T-Kernel | 旧三表 XOR | 完整解包，三分段 CRC 验证通过 | [Z30 1.20 报告](../firmware%20decode/z-series/analysis/Z_30_0120/REPORT.md) |
| 2023-05-10 | **Z8** | FX | EXPEED 7 | AArch64 (64-bit) | TOPPERS + Linux 4.14 | 旧三表 XOR | 函数级逆向、CEVA DSP、Open Gate 调研、QEMU 板级仿真 | [Z8 3.11 报告](../firmware%20decode/z-series/analysis/Z_8_0311/REPORT.md) · [QEMU](../firmware%20decode/z-series/qemu/z8/README.md) |
| 2023-09-20 | **Z f** | FX | EXPEED 7 | AArch64 (64-bit) | - | **0x260 新封装** | 首款新封装机型；同位置密文差分匹配已知推理 ELF | [Z f 3.01 报告](../firmware%20decode/z-series/analysis/Z_f_0301/REPORT.md) |
| 2024-06-17 | **Z6III** | FX | EXPEED 7 | AArch64 (64-bit) | - | **0x260 新封装** | 新封装局部恢复，提取出完整 A/B 类 DSP | [Z6III 2.00 报告](../firmware%20decode/z-series/analysis/Z6_3_0200/REPORT.md) |
| 2024-11-07 | **Z50II** | DX | EXPEED 7 | AArch64 (64-bit) | - | **0x260 新封装** | 新封装局部恢复，匹配同一份 C 类推理 ELF | [Z50II 1.11 报告](../firmware%20decode/z-series/analysis/Z50_2_0111/REPORT.md) |
| 2025-04-03 | **Z5II** | FX | EXPEED 7 | AArch64 (64-bit) | - | **0x260 新封装** | 两个完整差分 ELF，参照辅助恢复 8.26 MB 窗口 | [Z5II 1.20 报告](../firmware%20decode/z-series/analysis/Z5_2_0120/REPORT.md) |
| 2025-09-10 | **ZR** | FX | EXPEED 7 | AArch64 (64-bit) | - | **0x260 新封装** | Z CINEMA 机型；外层 SHA-1 校验已还原，载荷待解 | [ZR 1.11 报告](../firmware%20decode/z-series/analysis/ZR__0111/REPORT.md) |

---

## 2. Nikon 数码单反相机 (DSLR)

### 2.1 现代单反（ARM 架构时代，EXPEED 3 / 4 / 5 / 6）

| 机型 | 发布年份 | 画幅 | 处理器 | 主 CPU 架构 | 加载基址 (Load Base) | 固件格式 | 逆向与补丁支持状态 | 资源位置 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **D780** | 2020 | FX | EXPEED 6 | ARM v7 LE | `0x12020000` | 加密 B 固件 | 内存映射记录已确认 | [FirmwareNotes](../FirmwareNotes/FirmwareNotes.md) |
| **D850** | 2017 | FX | EXPEED 5 | ARM v7 LE | - | 加密 B 固件 | 在线补丁支持 / 解包支持 | [Nikon-Patch](../Nikon-Patch/) |
| **D7500** | 2017 | DX | EXPEED 5 | ARM v7 LE | - | 加密 B 固件 | 在线补丁支持 / 解包支持 | [Nikon-Patch](../Nikon-Patch/) |
| **D500** | 2016 | DX | EXPEED 5 | ARM v7 LE | - | 加密 B 固件 | 在线补丁支持 | [Nikon-Patch](../Nikon-Patch/) |
| **D5** | 2016 | FX | EXPEED 5 | ARM v7 LE | - | 加密 B 固件 | 在线补丁支持 | [Nikon-Patch](../Nikon-Patch/) |
| **D5600** | 2016 | DX | EXPEED 4 | ARM v7 LE | - | 加密 B 固件 | 在线补丁支持 | [Nikon-Patch](../Nikon-Patch/) |
| **D3400** | 2016 | DX | EXPEED 4 | ARM v7 LE | - | 加密 B 固件 | 在线补丁支持 | [Nikon-Patch](../Nikon-Patch/) |
| **D7200** | 2015 | DX | EXPEED 4 | ARM v7 LE | - | 加密 B 固件 | 在线补丁支持 | [Nikon-Patch](../Nikon-Patch/) |
| **D5500** | 2015 | DX | EXPEED 4 | ARM v7 LE | `0x90020000` | 加密 B 固件 | 内存映射已记录，在线补丁支持 | [FirmwareNotes](../FirmwareNotes/FirmwareNotes.md) · [Nikon-Patch](../Nikon-Patch/) |
| **D750** | 2014 | FX | EXPEED 4 | ARM v7 LE | `0x90020000` | 加密 B 固件 | 内存映射详细分析，IDC 脚本，在线补丁 | [FirmwareNotes](../FirmwareNotes/FirmwareNotes.md) · [IDA_files/D750](../IDA_files/D750/) |
| **D810** | 2014 | FX | EXPEED 4 | ARM v7 LE | - | 加密 B 固件 | 在线补丁支持 | [Nikon-Patch](../Nikon-Patch/) |
| **D4S** | 2014 | FX | EXPEED 4 | ARM v7 LE | - | 加密 B 固件 | 在线补丁支持 | [Nikon-Patch](../Nikon-Patch/) |
| **D3300** | 2014 | DX | EXPEED 4 | ARM v7 LE | `0x90020000` | 加密 B 固件 | 内存映射已记录，在线补丁支持 | [FirmwareNotes](../FirmwareNotes/FirmwareNotes.md) · [Nikon-Patch](../Nikon-Patch/) |
| **D5300** | 2013 | DX | EXPEED 4 | ARM v7 LE | `0x90020000` | 加密 B 固件 | 内存映射已记录，在线补丁支持 | [FirmwareNotes](../FirmwareNotes/FirmwareNotes.md) · [Nikon-Patch](../Nikon-Patch/) |
| **D7100** | 2013 | DX | EXPEED 3 | ARM v7 LE | `0x50020000` | 加密 B 固件 | 内存映射已记录，在线补丁支持 | [FirmwareNotes](../FirmwareNotes/FirmwareNotes.md) · [Nikon-Patch](../Nikon-Patch/) |
| **D610** | 2013 | FX | EXPEED 3 | ARM v7 LE | `0x9E000000` (RAM) | 加密 B 固件 | 在线补丁支持（视频码率/无损输出） | [Nikon-Patch](../Nikon-Patch/) |
| **D5200** | 2012 | DX | EXPEED 3 | ARM v7 LE | `0x50020000` | 加密 B 固件 | 内存映射、RTTI 分析、IDC 脚本、在线补丁 | [FirmwareNotes](../FirmwareNotes/FirmwareNotes.md) · [IDA_files/D5200](../IDA_files/D5200/) |
| **D600** | 2012 | FX | EXPEED 3 | ARM v7 LE | `0x9E000000` (RAM) | 加密 B 固件 | 完整 IDC 脚本、函数转储、在线补丁 | [IDA_files/D600](../IDA_files/D600/) · [Nikon-Patch](../Nikon-Patch/) |
| **D800 / D800E** | 2012 | FX | EXPEED 3 | ARM v7 LE | `0x84F00000` (RAM) | 加密 B 固件 | 完整 IDC 脚本、任务表、ExifTables、在线补丁 | [IDA_files/D800](../IDA_files/D800/) · [Nikon-Patch](../Nikon-Patch/) |
| **D4** | 2012 | FX | EXPEED 3 | ARM v7 LE | `0xBE000000` (RAM) | 加密 B 固件 | IDC 脚本、在线补丁支持 | [IDA_files/D4](../IDA_files/D4/) · [Nikon-Patch](../Nikon-Patch/) |

---

### 2.2 经典单反（Fujitsu FR / Toshiba TX 时代，EXPEED 1 / 2）

| 机型 | 发布年份 | 画幅 | 处理器 | 主 CPU 架构 | 辅助/协处理器 | 固件格式 | 逆向与补丁支持状态 | 资源位置 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **D3200** | 2012 | DX | EXPEED 3 | Fujitsu FR BE | - | 加密 B 固件 | IDC 脚本，在线补丁支持 | [IDA_files/D3200](../IDA_files/D3200/) · [Nikon-Patch](../Nikon-Patch/) |
| **D5100** | 2011 | DX | EXPEED 2 | Fujitsu FR BE | - | 加密 B 固件 | 社区早期旗舰研究机型；dfr 反汇编，完整 IDC 脚本，在线补丁 | [dfr](../dfr/) · [IDA_files/D5100](../IDA_files/D5100/) · [Nikon-Patch](../Nikon-Patch/) |
| **D7000** | 2010 | DX | EXPEED 2 | Fujitsu FR BE | - | 加密 B 固件 | 完整 IDC 脚本、菜单文本转储、系统表、在线补丁 | [IDA_files/D7000](../IDA_files/D7000/) · [Nikon-Patch](../Nikon-Patch/) |
| **D3100** | 2010 | DX | EXPEED 2 | Fujitsu FR BE | - | 加密 B 固件 | IDC 脚本，在线补丁支持 | [IDA_files/D3100](../IDA_files/D3100/) · [Nikon-Patch](../Nikon-Patch/) |
| **D3000** | 2009 | DX | EXPEED 1 | Fujitsu FR BE | - | 经典固件 | IDC 脚本，RAM 设置与清除脚本 | [IDA_files/D3000](../IDA_files/D3000/) |
| **D300S** | 2009 | DX | EXPEED 1 | Fujitsu FR BE | - | 经典固件 | IDC 脚本，菜单名称与语言修复 | [IDA_files/D300S](../IDA_files/D300S/) |
| **D3S** | 2009 | FX | EXPEED 1 | Fujitsu FR BE | - | 经典固件 | IDC 脚本，RAM 设置与 JPEG 修复 | [IDA_files/D3S](../IDA_files/D3S/) |
| **D90** | 2008 | DX | EXPEED 1 | Fujitsu FR BE | TX19A (MIPS) | 经典固件 | 系统架构拓扑描述 (YAML)，首款视频单反 | [arch/d90.yaml](../arch/d90.yaml) · [Tx19a Plugin](../Tx19a%20IDA%20Plugin/) |
| **D700** | 2008 | FX | EXPEED 1 | Fujitsu FR BE | - | 经典固件 | IDC 脚本，菜单与语言修复 | [IDA_files/D700](../IDA_files/D700/) |
| **D300** | 2007 | DX | EXPEED 1 | Fujitsu FR BE | - | 经典固件 | 在线补丁支持 | [Nikon-Patch](../Nikon-Patch/) |
| **D3** | 2007 | FX | EXPEED 1 | Fujitsu FR BE | - | 经典固件 | 早期全画幅旗舰机型分析 | [wiki/cameras/](../wiki/cameras/) |

---

### 2.3 早期数码单反（前 EXPEED 时代，1998-2006）

| 机型 | 发布年份 | 传感器类型 | 分辨率 | 硬件分析记录 | 资源位置 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **D1 / D1H / D1X** | 1998-2001 | 2.7MP / 5.4MP CCD | 2012x1324 / 3008x1960 | 子系统分解图、电路原理图 | [wiki/cameras/camera_matrix.csv](../wiki/cameras/camera_matrix.csv) |
| **D100** | 2002 | 6.1MP CCD | 3008x2000 | EEPROM 数据表、框图 | [wiki/cameras/camera_matrix.csv](../wiki/cameras/camera_matrix.csv) |
| **D2H / D2Hs** | 2003-2005 | 4.1MP JFET LBCAST | 2464x1632 | 内部接线图、主板照片 | [wiki/cameras/camera_matrix.csv](../wiki/cameras/camera_matrix.csv) |
| **D2X / D2Xs** | 2004-2006 | 12.4MP CMOS (Sony IMX038) | 4288x2848 | 电路图、传感器特性 | [wiki/cameras/camera_matrix.csv](../wiki/cameras/camera_matrix.csv) |
| **D70 / D70s** | 2004-2005 | 6.1MP CCD | 3008x2000 | 闪存 RAM 描述、内部布线图 | [wiki/cameras/camera_matrix.csv](../wiki/cameras/camera_matrix.csv) |
| **D50** | 2005 | 6.1MP CCD | 3008x2000 | 内部接线图 | [wiki/cameras/camera_matrix.csv](../wiki/cameras/camera_matrix.csv) |
| **D200** | 2005 | 10.2MP CCD | 3872x2592 | 日文布线图、CAM2000 对焦模块 | [wiki/cameras/camera_matrix.csv](../wiki/cameras/camera_matrix.csv) |
| **D40 / D40X** | 2006-2007 | 6.1MP / 10.2MP CCD | 3008x2000 / 3872x2592 | 内部接线图、CAM530 模块 | [wiki/cameras/camera_matrix.csv](../wiki/cameras/camera_matrix.csv) |
| **D80** | 2006 | 10.2MP CCD | 3872x2592 | CAM1000 对焦系统分析 | [wiki/cameras/camera_matrix.csv](../wiki/cameras/camera_matrix.csv) |

---

## 3. 固件封装格式沿革与特征

| 封装代际 | 典型机型 | 头部特征 | 算法与解密方式 | 校验方式 | 本仓库解包支持 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **经典加密单反固件** | D5100, D7000, D800, D750 等 | 专有魔数与加密分段表 | AES / XOR 专有解密 | CRC-16 / MD5 | **支持**（[Nikon-Patch](../Nikon-Patch/)、[firmware decode](../firmware%20decode/)） |
| **旧三表 XOR 封装** | Z6, Z7, Z50, Z5, Z6II, Z7II, Z fc, Z9, Z30, Z8 | 原文件 `0x20` 开始有 32 字节空格标记 | 三张 64 KiB XOR 表，原点为 `0x20`，大端目录 | CRC-16/XMODEM (分段及整包) | **支持**（`tools/analyze_firmware.py`，已 100% 验证 123 份原包） |
| **0x260 扩展头新封装** | Z f, Z6III, Z50II, Z5II, ZR | 原文件 `0x00` 固定前缀，空格标记移至 `0x260` | 未知新流加密算法（旧 XOR 排查无有效目录） | 包含派生 8 字节后 SHA-1 外层校验 | **局部恢复**（通过差分与已知明文恢复部分 DSP 与网络数据；整包待解） |
