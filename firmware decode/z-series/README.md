# Nikon Z 系列固件分析

机型正式公告日期、处理器与已验证封装的对照见 [Z 系列相机发布时间表](RELEASE_TIMELINE.md)。
逐机型 USB／MTP 协议、MAID 功能及配置取值索引见 [Remote SDK 2.0.0 参考资料](references/remote-sdk-2.0.0/README.md)。

已取得 **15 款 Z 系列机身的 148 份历史固件，共 8.79 GB**。123 份旧格式完整解包，
523 个分段 CRC、整包 CRC 和逐字节重编码均通过；25 份新格式完成局部恢复。
164 个已知版本记录中仍缺 16 份原包（15 个首发／出厂版本及 Z6III 1.01）。

- **[全历史主要发现](analysis/all_history/FINDINGS.md)**：封装沿革、AI／DSP、网络候选、Linux 和双处理器差异。
- **[全历史逐版比较](analysis/all_history/REPORT.md)**：148 个版本、133 组相邻已取得版本的分段差异。
- **[下载清单与 SHA-256](analysis/all_history/downloads.json)**、[来源及缺口](analysis/all_history/SOURCES.md)。

Z8 已进入函数级分析：[主 CPU／DSP 装载与调用接口](analysis/z8_dsp_host/REPORT.md)，包含八版交叉验证、网络用途对应和隔离仿真。
结合 Remote SDK 的后续分析见 [主体检测属性到机内设置](analysis/z8_sdk_subject/REPORT.md)：定位鸟类值的版本变化、两项内部设置编号，并完成 4,096 例隔离验证。
视频路径见 [Z8 Open Gate 可行性调查](analysis/z8_open_gate/REPORT.md)：验证模式白名单、尺寸枚举及 RAW 设置编号，并区分全高几何参数与尚未确认的全高录像能力。
后续见 [N-RAW 尺寸到采集状态](analysis/z8_capture_state/REPORT.md)：连接有效尺寸更新回调与采集快照，导出 669 条注册记录，并隔离验证真实函数的数据流。
底层进展见 [CaptureSensor 后端模式与命令参数块](analysis/z8_sensor_backend/REPORT.md)：定位资源 `0x5c`、模式选择及命令字节流地址；参数内容和全高读出能力仍待确认。
后续见 [参数装载与采集尺寸转换](analysis/z8_sensor_inputs/REPORT.md)：确认参数复制地址、尺寸到后端请求的映射及越界值回落，并修正采集快照中的帧率字段解释。
存储范围见 [EG 更新与传感器参数区](analysis/z8_flash_layout/REPORT.md)：隔离执行更新地址循环，确认普通 EG 更新范围不覆盖资源 `0x5c`。
读取路径见 [私有 PTP 参数资源读取](analysis/z8_ptp_resources/REPORT.md)：确认外层 `0x94ff`、内层 `0xf029` 的资源 RAM 读取分支及会话和边界检查；实际数据尚未取得。
新增功能实验见 [Z8 3.11 NFDG 诊断入口](analysis/z8_diagnostic/REPORT.md)：实现 `0x94fd / 0xf0ff` 返回固定标识及补丁版本，生成完整离线实验包，并验证原分派对照和封装校验；尚未刷写或验证真机启动。

设置菜单扩展见 [Z8 3.11 P 诊断页实验](analysis/z8_diagnostic_ui/REPORT.md)：追加 `NFDG diagnostics`，在相机菜单中直接显示诊断身份与版本；原版本页 C 行显示 `3.11 P`。已生成包含 PTP 功能的完整离线实验包，尚未验证真机启动、绘制或滚动。

模拟验证路线见 [z7-qemu 参考分析](analysis/z7_qemu_reference/REPORT.md)：确认本仓库 Z7 MAIN 与其输入匹配，复核合成模型测试，并说明迁移到 Z8 所需的适配。
现已新增 [Z8 QEMU 构建与运行入口](qemu/z8/README.md)，执行未修改的官方 3.11 引导与 RTOS 多核调度；完整相机菜单尚未跑通，具体证据见 [官方启动报告](analysis/z8_qemu_boot/REPORT.md)。

此前各轮结果保留为独立快照：[当前机型调查](analysis/catalog/REPORT.md)、
[跨机型 AI 比较](analysis/ai_comparison/REPORT.md)、[Z f 最早新封装调查](analysis/catalog/ZF_PACKAGING_HISTORY.md)、
[Z8 历史分析](analysis/z8_history/REPORT.md)。

## 专题技术与报告全景索引

本目录积累了 40 余份系统级逆向报告与参考资料，按研究领域分类如下：

| 研究领域 | 核心主题 | 关键报告与入口 |
| :--- | :--- | :--- |
| **版本演进与全量对比** | 15 款机型、148 份固件跨版本比对与封装沿革 | - [全历史主要发现](analysis/all_history/FINDINGS.md)<br>- [全历史逐版比较总表](analysis/all_history/REPORT.md)<br>- [发布时间与封装对照](RELEASE_TIMELINE.md)<br>- [Z8 历史版本分析](analysis/z8_history/REPORT.md)<br>- [全机型目录调查](analysis/catalog/REPORT.md)<br>- [Z f 最早新封装调查](analysis/catalog/ZF_PACKAGING_HISTORY.md) |
| **机型逆向 (旧三表 XOR)** | 完整解包、分段 CRC 验证与符号提取 | - [Z6 3.80 报告](analysis/Z_6_0380/REPORT.md) · [Z7 3.80 报告](analysis/Z_7_0380/REPORT.md)<br>- [Z8 3.11 报告](analysis/Z_8_0311/REPORT.md) · [Z9 5.32 报告](analysis/Z_9_0532/REPORT.md)<br>- [Z5 1.50 报告](analysis/Z_5_0150/REPORT.md) · [Z50 2.60 报告](analysis/Z_50_0260/REPORT.md)<br>- [Z30 1.20 报告](analysis/Z_30_0120/REPORT.md) · [Z fc 1.81 报告](analysis/Z_fc_0181/REPORT.md)<br>- [Z6II 1.70 报告](analysis/Z6_2_0170/REPORT.md) · [Z7II 1.70 报告](analysis/Z7_2_0170/REPORT.md) |
| **机型逆向 (0x260 新封装)** | 差分匹配、已知明文参照与局部恢复 | - [Z f 3.01 差分报告](analysis/Z_f_0301/REPORT.md)<br>- [Z5 II 1.20 局部恢复报告](analysis/Z5_2_0120/REPORT.md)<br>- [Z50 II 1.11 逆向报告](analysis/Z50_2_0111/REPORT.md)<br>- [Z6 III 2.00 逆向报告](analysis/Z6_3_0200/REPORT.md)<br>- [ZR 1.11 容器分析报告](analysis/ZR__0111/REPORT.md) |
| **AI、DSP 与视觉** | CEVA DSP ELF、网络数据比对、主体检测 | - [跨机型 AI 比较报告](analysis/ai_comparison/REPORT.md)<br>- [Z8 主 CPU／DSP 装载与调用接口](analysis/z8_dsp_host/REPORT.md)<br>- [主体检测属性到机内设置](analysis/z8_sdk_subject/REPORT.md) |
| **视频与传感器数据流** | Open Gate 录制可行性、传感器命令与参数区 | - [Z8 Open Gate 可行性调查](analysis/z8_open_gate/REPORT.md)<br>- [N-RAW 尺寸到采集状态分析](analysis/z8_capture_state/REPORT.md)<br>- [CaptureSensor 后端模式与命令参数块](analysis/z8_sensor_backend/REPORT.md)<br>- [参数装载与采集尺寸转换](analysis/z8_sensor_inputs/REPORT.md)<br>- [EG 更新与传感器参数区](analysis/z8_flash_layout/REPORT.md) |
| **协议、诊断注入与 UI** | 私有 PTP 指令读取、NFDG 诊断补丁与菜单 | - [私有 PTP 参数资源读取](analysis/z8_ptp_resources/REPORT.md)<br>- [私有 PTP f001 分支分析](analysis/z8_ptp_f001/REPORT.md)<br>- [Z8 3.11 NFDG 诊断入口实验](analysis/z8_diagnostic/REPORT.md)<br>- [Z8 3.11 P 诊断页实验与 UI 扩展](analysis/z8_diagnostic_ui/REPORT.md)<br>- [Z8 UI 版本展示分析](analysis/z8_ui_version/REPORT.md) |
| **硬件仿真 (QEMU)** | AArch64 板级模拟、多核调度与固件引导 | - [Z8 QEMU 构建与运行指南](qemu/z8/README.md)<br>- [Z8 官方固件引导启动报告](analysis/z8_qemu_boot/REPORT.md)<br>- [z7-qemu 参考分析报告](analysis/z7_qemu_reference/REPORT.md) |
| **外部规范与参考** | Remote SDK 2.0.0 协议文档与配置索引 | - [Remote SDK 2.0.0 参考资料主页](references/remote-sdk-2.0.0/README.md)<br>- [逐机型协议文档索引](references/remote-sdk-2.0.0/PROTOCOLS.md)<br>- [配置文件阅读指南](references/remote-sdk-2.0.0/CONFIGURATION.md)<br>- [主体检测对照](references/remote-sdk-2.0.0/SUBJECT_DETECTION.md) |

## 快速复现命令

> [!TIP]
> **推荐使用 [`uv`](../../docs/PYTHON_UV_GUIDE.md) 运行时**：在仓库根目录执行 `uv sync` 可在数秒内自动配置隔离环境并补全 `capstone`、`pycryptodome` 与 `unicorn` 依赖。以下命令均可直接使用 `uv run python3 ...` 执行。

```sh
cd "firmware decode/z-series"
uv run python3 tools/discover_z_history.py
uv run python3 tools/collect_all_z_history.py .
uv run python3 tools/compare_all_z_history.py .
```

仅获取当前官方目录的复现命令：

```sh
cd "firmware decode/z-series"
python3 tools/collect_z_series.py . --through-year 2026 --download
python3 tools/analyze_z_catalog.py .
```

本目录保存 Nikon Z 系列固件分析工具、报告、原始样本和本地生成产物。
从仓库根目录运行以下命令后，再执行本文中的复现命令：

```sh
cd "firmware decode/z-series"
```

- `tools/`：Python 解包、分析脚本、XOR 表和测试。
- `analysis/<样本名>/`：分析报告、校验清单、反汇编摘录及生成产物。
- 本目录的 `*.bin`：原始固件。

原始固件、SDK 压缩包、提取的二进制、字符串、根文件系统、符号表和 QEMU 构建产物保留在本地，
由本目录的 `.gitignore` 排除；报告、顶层分析清单和代码摘录可纳入版本管理。

当前包含以下离线逆向结果，以及用于新封装对比的 Z f 1.21、Z6 III、Z5 II 样本：

| 样本 | 分段 | 主要发现 | 报告 |
| --- | ---: | --- | --- |
| `Z_6_0380.bin` | 4 | ARM/Thumb、SMP T-Kernel，主固件基址 `0x10020000` | [Z6 报告](analysis/Z_6_0380/REPORT.md) |
| `Z_8_0311.bin` | 5 | AArch64、SOLID/TOPPERS、Linux 4.14.224、3 个 CEVA ELF | [Z8 报告](analysis/Z_8_0311/REPORT.md) |
| `ZR__0111.bin` | 未解出 | 新前缀结构；旧 XOR 全相位排查无有效目录，算法仍待还原 | [ZR 报告](analysis/ZR__0111/REPORT.md) |
| `Z_f_0301.bin` | 未解出 | 五样本共享固定头与表；Z f 1.21/3.01 同位置密文差分已完成 | [Z f 报告](analysis/Z_f_0301/REPORT.md) |
| `Z5_2_0120.bin` | 局部恢复 | 两个完整差分 ELF；参照辅助恢复 8,264,100 字节窗口，整包尚未解开 | [Z5 II 报告](analysis/Z5_2_0120/REPORT.md) |

Z6、Z8 通过了各分段 CRC、整包 CRC 和重新编码逐字节一致性检查。ZR、Z f 尚未解包，未验证 CRC。
Z5 II 的局部内容已有交叉验证，尚未验证容器 CRC。

## Z5 II 分析复现

```sh
python3 tools/analyze_z5ii.py . --z8-directory analysis/Z_8_0311 --output analysis/Z5_2_0120
python3 -m unittest discover -s tools -p 'test_*.py'
```

脚本校验四个新格式样本及 Z8 参照，导出差分 ELF、符号表、公共位置掩码和 Z5 II 局部窗口。
报告区分直接差分候选、已知明文参照和独立交叉检查；这不是通用的整包解密器。

## Z f 分析复现

```sh
python3 tools/analyze_zf.py . --output analysis/Z_f_0301
python3 -m unittest discover -s tools -p 'test_*.py'
# 可选，需要 PyCryptodome：
python3 tools/probe_zf_stream.py Z_f_0301.bin > analysis/Z_f_0301/stream_probes.json
```

主脚本校验五个已记录样本的 SHA-256，并输出结构比较和 Z f 两版本的完整同位置差分。
报告明确区分固定字段、候选目录和未验证的掩码假设；不会把推测内容输出为已解密固件。

## ZR 分析复现

```sh
python3 tools/analyze_zr.py ZR__0111.bin --output analysis/ZR__0111 \
  --z8-firmware Z_8_0311.bin --z8-directory analysis/Z_8_0311
python3 -m unittest discover -s tools -p 'test_*.py'
```

ZR 的空格标记移至 `0x260`，但不能仅调整偏移用旧算法解包。
脚本记录原始结构、全相位排查和统计，不输出假定的固件分段。
两个可选的 `--z8-*` 参数用于复现本轮从 Z8 代码还原的外层 SHA-1 校验；
ZR 目录中的反汇编摘录是 **Z8 参照代码**，不是 ZR 解密结果。
详情与后续入口见 [ZR 报告](analysis/ZR__0111/REPORT.md)。

## Z8 分析复现

```sh
python3 tools/analyze_firmware.py Z_8_0311.bin --output analysis/Z_8_0311
python3 tools/analyze_z8.py analysis/Z_8_0311
python3 -m unittest discover -s tools -p 'test_*.py'
```

第二步解析 NISI Linux 容器、解压根文件系统、导出设备树、提取 CEVA ELF 和符号表。
仅用 Python 标准库即可提取数据；安装了 `capstone` 时还生成启动代码反汇编。
CPIO 中的符号链接和设备节点仅记录于清单，`rootfs_files` 只保存普通文件，不能直接作为可启动根目录。
不执行固件中的程序或启动脚本。

Z8 主要产物：

- [deep_manifest.json](analysis/Z_8_0311/deep_manifest.json)：嵌套结构、内核、主程序映射和入口。
- [linux](analysis/Z_8_0311/linux)：内核 `Image`、配置、CPIO、设备树及普通文件。
- [embedded_elf](analysis/Z_8_0311/embedded_elf)：3 个 CEVA ELF、符号 CSV 与元数据。
- [code_landmarks.asm](analysis/Z_8_0311/code_landmarks.asm)：AArch64 启动、EX MCU 和 Linux 应用入口。

可用系统工具独立检查提取物：

```sh
gzip -t analysis/Z_8_0311/linux/rootfs.cpio.gz
cpio -it --quiet < analysis/Z_8_0311/linux/rootfs.cpio
readelf --wide -h -S -s analysis/Z_8_0311/embedded_elf/ceva_0151caa0.elf
readelf --wide -h -l analysis/Z_8_0311/linux/rootfs_files/usr/bin/LaMainApp
```

## Z6 分析

本项目分析本地 `Z_6_0380.bin`，包含解包工具、校验结果和反汇编入口。
**该样本可以使用 Nikon Hacker 的三表 XOR 算法解包，只需将 XOR 原点设为原文件的 `0x20`。**
已提取四个分段，四个分段 CRC 和整包 CRC 均通过，并验证重新编码与原文件逐字节一致。

分析详情、地址依据和未解决问题见 [分析报告](analysis/Z_6_0380/REPORT.md)。

## 复现

在本目录运行，解包和统计仅依赖 Python 3 标准库：

```sh
python3 tools/analyze_firmware.py Z_6_0380.bin --output analysis/Z_6_0380
python3 -m unittest discover -s tools -p 'test_*.py'
```

生成反汇编摘录需要 Python `capstone`，本次环境已安装：

```sh
python3 tools/inspect_code.py analysis/Z_6_0380
```

工具读取原固件，输出提取件、JSON 清单、带偏移的字符串和每 64 KiB 的熵数据。
重复运行会更新指定输出目录内的同名分析产物。`inspect_code.py` 通过分段 SHA-256
限制为本次样本，避免把这些固定地址误用于其他版本。

## 产物

- [manifest.json](analysis/Z_6_0380/manifest.json)：原文件和分段的 SHA-256、长度、两种偏移、CRC、熵与字符串线索。
- [code_landmarks.asm](analysis/Z_6_0380/code_landmarks.asm)：启动、异常向量及候选校验函数的反汇编摘录。
- [code_landmarks.json](analysis/Z_6_0380/code_landmarks.json)：主固件和 EX 固件加载地址、启动时复制到 RAM 的区间。
- [entropy.csv](analysis/Z_6_0380/entropy.csv)：原包及分段的熵分布。
- `analysis/Z_6_0380/*.strings.txt`：ASCII 可打印连续串，最短 6 字节；包含随机命中和代码偶然形成的串。
- `analysis/Z_6_0380/decoded_package.bin`：保留 32 字节空格头、可直接核验整包 CRC 的解码包。
- 同目录的四个分段文件保留各自末尾的两字节 CRC。

XOR 表与目录结构来源于 [Nikon Hacker Package.cs](https://github.com/simeonpilgrim/nikon-firmware-tools/blob/main/Nikon-Patch/LocalUI/Package.cs)。
本目录包含离线分析和 Z8 诊断实验补丁；尚未执行相机刷写或验证修改包的真机启动。
