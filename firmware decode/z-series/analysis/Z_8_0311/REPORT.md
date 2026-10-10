# Z_8_0311.bin 逆向分析

分析日期：2026-10-04。对象是`firmware decode/z-series/` 目录的本地样本，采用静态分析，没有运行相机或固件程序。

## 结论

**Z8 C 3.11 仍能用已知的 Nikon 三表 XOR 算法完整解包，原点为原文件偏移 `0x20`。**
提取的五段 CRC 均匹配，整包 CRC 为 `0xC811`，重新编码与原始样本逐字节一致。

相比先前的 Z6，这份固件展示了更复杂的多系统结构：

- 主 EG 分段为 AArch64；启动代码和描述表共同确认启动映射基址 `0x40160000`。
- 主程序含 SOLID-OS、TOPPERS/FMP `fmp_1.4.0` 的构建路径和内核诊断字符串。
- 独立 LI 分段包含 Linux 4.14.224 AArch64 内核、gzip/CPIO 根文件系统和两份设备树。
- EG 内嵌三个可提取的 CEVA ELF，保留共 41,469 个符号表条目，包括 XM6、CDNN 及 RTOS 相关名称。
- EX 分段仍是独立的 ARM M-profile Thumb MCU 固件。

后续 [ZR 容器分析](../ZR__0111/REPORT.md) 从本样本代码还原并验证了外层前 20 字节：
它是解码容器拼接派生 8 字节后的 SHA-1。前缀剩余 12 字节、完整更新认证链和实际运行时权限边界尚未解释。
提取成功并不代表修改后只重算 CRC 就能刷入。

## 输入与校验

| 项目 | 结果 |
| --- | --- |
| 文件名 | `Z_8_0311.bin` |
| 长度 | 99,051,117 字节，`0x05E7666D`，94.462506 MiB |
| SHA-256 | `d67413c2ede6b9ce8887175f20700bd9fbad2a973a4820968c45503d15d80d96` |
| 原包熵 | 7.9999986506 bit/byte |
| XOR 原点 | 原文件 `0x20` |
| 解码目录 | 5 个条目，头部大小 `0xD0` |
| 整包 CRC | `0xC811`，通过 |
| 精确重新编码 | 通过 |

[尼康官方页面](https://downloadcenter.nikonimglib.com/en/download/fw/606.html) 将这个文件名列为 Z8 的 C 3.11。
该版本修复说明涉及 NX Tether、高频闪烁消减和 Picture Control 操作。
本次未另行下载官方文件比较哈希；输入 SHA-256 是本地样本的指纹。
包内 EG/LI 使用内部版本 `0311b0`，不能仅据字母 `b` 将它判断为测试固件。

原文件 `0x00–0x1F`：

```text
61060072cc6f4032491ef95570e1e7e9e053b8fd5866cd124269c27e621da226
```

其后 `0x20–0x3F` 为 32 字节空格。解码方式与 [Z6 报告](../Z_6_0380/REPORT.md) 相同：
保留空格头，用容器内偏移索引三张 XOR 表，目录整数为大端，16 MiB 后索引回绕。
所有分段和整包使用 CRC-16/XMODEM：多项式 `0x1021`、初值 0、大端保存结果。

整包 CRC 位于容器偏移 `0x05E7663D`，对应原包 `0x05E7665D`；覆盖此前全部解码字节，之后有 14 个零字节。
保留空格头的 `decoded_package.bin` SHA-256 为：
`da0b0843d2e790ed6267f8a7fbbb393f464de4ed1c217964df782bf0a2795b43`。

## 外层五个分段

文件名按目录原样保留，大小含末尾两字节 CRC。分段在容器中连续排列，无间隙或重叠。

| 文件 | 容器偏移 | 原包偏移 | 字节数 | CRC | 熵 |
| --- | --- | --- | ---: | --- | ---: |
| `ex2070_030000.bi` | `0x000000D0` | `0x000000F0` | 524,290 | `9B99` | 4.189403 |
| `_tpj01_0210.bin` | `0x000800D2` | `0x000800F2` | 57,346 | `8F0D` | 6.246823 |
| `eg2070_0311b0.bi` | `0x0008E0D4` | `0x0008E0F4` | 81,807,711 | `201B` | 5.937611 |
| `vr2070_010100.bi` | `0x04E92A33` | `0x04E92A53` | 838,664 | `5BD4` | 1.942176 |
| `li2070_0311b0.bi` | `0x04F5F63B` | `0x04F5F65B` | 15,822,850 | `C731` | 7.624270 |

完整分段哈希和字符串线索位于 [manifest.json](manifest.json)。
通用解包工具中的部分预设搜索词来自 Z6，Z8 专用标记和嵌套分析结果位于 [deep_manifest.json](deep_manifest.json)。

## EG 主程序的架构和加载地址

EG 开头是连贯的 AArch64 启动代码：屏蔽异常，读取 `MPIDR_EL1` 和 `CurrentEL`，
根据当前异常级别设置 `SCR_EL3`、GIC 系统寄存器以及 `ELR_EL3/ELR_EL2`，随后 `ERET`。
它不能按 Z6 的 ARMv7 32 位语言导入。

启动映射的三组依据相互一致：

1. 文件 `0x670` 的 64 位小端字面量为 `0x40160250`，对应文件内 `0x250` 的 EL1 入口。
2. 文件 `0x678` 的字面量为 `0x401601C0`，对应文件内 `0x1C0` 的 EL2 入口。
3. 启动代码从绝对地址 `0x40168000` 复制 0x160 字节描述表；实际表位于文件 `0x8000`，其中 `+0x128` 再次记录 `0x40160000`。

描述表首项为 `0x401691D0`，启动初始化结束时通过这项做间接调用。
它是进入后续主系统的已确认入口；原始映像的最初入口仍为 `0x40160000`。

描述表还给出初始化数据区和零初始化区，使用过程可见文件 `0x1328–0x13A8`：

| 区间 | 文件来源 | 运行地址 | 大小 |
| --- | --- | --- | --- |
| 初始化数据复制 | EG `0x04B13000` | `0xA02808000` | `0x002AD000` |
| 零初始化区 | 无文件来源 | `0xA02AFB000` | `0x0208E000` |

这些只是已追踪的区间，不是完整 MMU 映射。EG 内还有资源、DSP 映像、数据和尾部结构，不能将所有字节自动反汇编为 AArch64 指令。
也不能把初始化数据中的字符串简单按 `0x40160000 + 文件偏移` 当作运行时引用地址；被复制的数据应使用 RAM 映射。

在文件 `0xEB0` 的小函数中，核编号等于 3 时设置不同的角色标志；其他核取另一值。
结合下面设备树的 `cpu@3`，推断为实时主系统和 Linux 分配不同 CPU 核的设计。
本次未验证每个核在真机上的完整调度与启动过程。

## SOLID 与 TOPPERS 证据

| EG 文件偏移 | 原始线索 |
| --- | --- |
| `0x04DB6480` | `SOLID CS ENTRY.` |
| `0x04DB6546` | `Starting Kernel.` |
| `0x04DB69A9` | `E:/solid/release/customer/solid-os/rtos/toppers_fmp/fmp_1.4.0/kernel/dataqueue.c` |
| `0x04DB6A32` | 相同路径下的 `mutex.c` |
| `0x04DB8D18` | `SOLID_ARM_s003_v1/.../aarch64/.../mutex_stub.c` |

这些构建痕迹支持主系统采用 SOLID-OS/TOPPERS FMP 的判断。
[KMC 官方说明](https://solid.kmckk.com/SOLID/doc/latest/os/index.html) 也说明 SOLID 使用 TOPPERS 内核并扩展内存和装载功能。
路径中的 `fmp_1.4.0` 不足以证明它与未修改的上游 1.4.0 源码完全相同。
DSP 中的 `FREERTOS_MEMORY` 与此属于不同组件，不能据此把整个相机系统归为 FreeRTOS。

## LI 分段的 NISI 容器

`li2070_0311b0.bi` 起始标识为 `NISI`，`0x10` 为条目数 4，`0x14` 为版本串 `0311b0`。
从 `0x20` 起，每条记录为四个小端 u32：起始块、分配块数、实际数据长度、保留值。
本样本块单位为 **2048 字节**；四条边界与内核头、gzip 及 DTB 的真实长度全部吻合。

| 内容 | LI 内偏移 | 实际长度 | 分配长度 |
| --- | --- | --- | --- |
| AArch64 Linux `Image` | `0x00000800` | `0x005B0008` | `0x005B0800` |
| gzip 根文件系统 | `0x005B1000` | `0x00963DBB` | `0x00964000` |
| 设备树 0 | `0x00F15000` | `0x00000C45` | `0x00001000` |
| 设备树 1 | `0x00F16000` | `0x00000C60` | `0x00001000` |

最后分配区在 `0xF17000` 结束，其后是 LI 自身的两字节 CRC。
提取物位于 [linux](linux)，入口及哈希见 [deep_manifest.json](deep_manifest.json)。

### Linux 内核

内核头在偏移 `0x38` 含 `ARM\x64` 魔数，结构符合
[Linux AArch64 Image 格式](https://docs.kernel.org/arch/arm64/booting.html)。
头中 `text_offset=0`，运行内存尺寸为 `0x607000`；文件尺寸与运行内存尺寸不同是正常的，需要分别记录。

读取到的构建信息：

```text
Linux version 4.14.224-ts-aarch64
gcc version 6.5.0 (Timesys 20200228)
#1 SMP PREEMPT Mon Dec 23 10:24:17 JST 2024
```

构建时间是内核的内部时间标记，不是 Z8 C 3.11 更新包的发布时间。
已通过 `IKCFG_ST` / `IKCFG_ED` 边界提取 [kernel_config.txt](linux/kernel_config.txt)：

- `CONFIG_ARM64=y`、`CONFIG_ARCH_NIKON_XXX=y`。
- `CONFIG_SMP=y`、`CONFIG_PREEMPT=y`。
- `CONFIG_IKCONFIG=y`、`CONFIG_IKCONFIG_PROC=y`。
- `CONFIG_MODULES=y`、`CONFIG_UIO=y`。

`CONFIG_NR_CPUS=64` 是编译配置上限，不能当作相机有 64 核的证据。

### 根文件系统与 Nikon 应用

gzip 完整流校验通过，解压为 **23,337,472 字节的 newc CPIO**。
独立使用 GNU cpio 核对了所有路径及顺序，共 820 项：272 个普通文件、406 个符号链接、105 个目录和37 个字符设备。

普通文件已经提取到 [rootfs_files](linux/rootfs_files)，全部目录条目保存在
[rootfs_inventory.json](linux/rootfs_inventory.json)。符号链接、设备节点和原始执行权限没有在主机上重建。
这份提取目录用于阅读和反汇编，不是可直接启动的完整 rootfs。

`etc/os-version` 标识 Timesys LinuxLink；`etc/inittab` 经 `rcS` 调用启动脚本。
`etc/init.d/S11-LaMainApp` 明确后台启动 `/usr/bin/LaMainApp`。
实际存在的 Nikon 程序包括：

```text
LaMainApp  LaIfCtrl  LaFtpClient  LaNetCameraCtrl  LaSyncRelease  LaLiveView
```

`LaMainApp` 为 AArch64 ELF64，ELF 入口 `0x4021CC`，可直接使用 ELF 导入器加载。
它含 `/dev/oscom_memhelper`、`OS_COM`、`/tmp/LaMainApp_unix_socket` 和 `oscom_fifo_handler` 符号，
与 rootfs 中的 `oscom_memhelper.ko`、`oscom_inthelper.ko` 相呼应，是跨系统通信的优先分析对象。
它还包含 `CLaMainAppDebug_ExecuteShellCommand` 文本，但仅凭文本不能确定该调试路径是否对外可达。
反汇编后续应追踪消息来源、分发条件及调用链。

根文件系统中出现网络服务和网络工具不等于它们在真机上已对网络开放。
例如 LaMainApp 有 `LaHttpServer` 路径文本，但这次 CPIO 中未见该普通文件，不能据此宣称它已启动。

### 设备树与核分工

两份 DTB 均通过结构边界检查，并导出 [device_tree_0.dts](linux/device_tree_0.dts) 与
[device_tree_1.dts](linux/device_tree_1.dts)。DTS 为本项目的可读渲染，未用外部 dtc 再编译；原始 DTB 保留。

共同内容包括：

| 属性/节点 | 值及解释 |
| --- | --- |
| `/cpus/cpu@3` | `arm,cortex-a53`，核标识 3；仅说明此 Linux 配置中的 CPU |
| 普通 RAM | 起点 `0xA07800000`，大小 `0x07800000`，即 120 MiB |
| `reserved-memory/OS_COM` | `0xA0F000000`，大小 `0x2000` |
| `reserved-memory/share_mem` | `0xA0F002000`，大小 `0x7FD000` |
| USB 控制器兼容串 | `socionext,sc2007-xhci`；不足以单独确定整个 SoC 的型号 |
| 启动参数 | `console=ttyS0,115200 rdinit=/sbin/init keepinitrd` |

串口节点同时有 `console="disabled"` 自定义属性，不能仅根据 bootargs 宣称实际串口控制台可用。
两份 DTB 的主要差异在 SDIO：设备树 0 使用 `fixed-1.8v` / `uhs-limit-sdr104`；
设备树 1 使用 `fixed-3.3v` / `uhs-limit-sdr12`，并有 50 MHz 限制。
它们可能服务于不同配置，但这次没有确认选择逻辑或硬件变体。

## EG 内嵌的 CEVA ELF

三个命中都经 ELF 头、程序头和节表边界核验；按实际文件区间提取，没有仅凭魔数截取固定长度。
ELF 的 `e_machine=245` 对应 [ELF 官方登记的 CEVA 架构](https://gabi.xinuos.com/elf/a-emachine.html)。

| EG 内偏移 | 提取文件 | 字节数 | 符号表条目 |
| --- | --- | ---: | ---: |
| `0x0151CAA0` | `ceva_0151caa0.elf` | 692,516 | 4,052 |
| `0x015C5BD0` | `ceva_015c5bd0.elf` | 456,004 | 2,739 |
| `0x01635120` | `ceva_01635120.elf` | 5,750,024 | 34,678 |

这些数量包括空符号、节符号和局部标签，并非同等数量的函数。
符号 CSV、完整 ELF 及 readelf 核验输出保存在 [embedded_elf](embedded_elf)。
可见 `CEVA-XM6`、`NikonTask_RTOS_TaskSwitchIn`、`FREERTOS_MEMORY`、CDNN 和卷积/ReLU 等神经网络运算符号。
第三份文件提供丰富的 AI/DSP 研究线索，但本次没有实现 CEVA 指令解码或还原具体识别模型。

Linux 内核中另有一个有效的 AArch64 vDSO ELF，以及一个诊断文本中的假 `ELF` 魔数。
本报告的“三个 CEVA ELF”仅计 EG 内的三个有效对象，不将这些 Linux 内容混算。

## 其他分段与功能线索

EX 的初始 SP 为 `0x20000C08`，Thumb 复位向量为 `0x080002B5`。
以基址 `0x08000000` 在文件 `0x2B4` 可解出启动代码，与 Z6 的 MCU 分段结构相近。
文件 `0x3709` 可见 `Z 8 Firmware Ex Copyright Nikon Corp.`，内部名称仍为 `030000`，不代表整包版本错误。

VR 在偏移 `0x0A` 含 `NikonBVR`，支持机身防抖相关组件的推测。
TPJ 的头部与 Z6 对应段相近，但其具体控制器、指令集和用途仍未确认。

下面的 EG 文件偏移可用于下一轮交叉引用分析：

| 偏移 | 线索 |
| --- | --- |
| `0x03F6403A` | `FirmwareManagement.c` |
| `0x03F65442` | `FirmwareManagement_Device_Loader.c` |
| `0x03F65515` | `FirmwareManagement_Device_Linux.c` |
| `0x03F655B7` | `FirmwareManagement_Device_Ai.c` |
| `0x028A01FE` | `NISI`，有望定位 Linux 包解析器 |
| `0x03F72930` | `MovieRecordApplicationServiceData.c` |
| `0x03F72954` | `MovieRecordApplicationServiceDebugInfo.c` |
| `0x03F823F8` | `PictureControlService.c` |
| `0x0295217D` / `0x029521ED` | Apple ProRes 422 HQ / ProRes RAW HQ 文本 |

这些是源码名或字符串的位置，不是已经识别的函数入口。

## 继续分析的实际入口

1. **跨系统通信**：先用 ELF 导入器打开 `LaMainApp`，追踪 `oscom_fifo_handler`、本地套接字和两个 helper 模块；无需先恢复整个裸映像。
2. **更新验证链**：从 EG 的 `FirmwareManagement_Device_*` 和 `NISI` 引用追踪包解析、完整性、机型/版本及认证检查；前缀 SHA-1 已在后续 ZR 分析中复现，仍需解释其余 12 字节和完整检查链。
3. **主程序**：以 Raw Binary、`AARCH64:LE:64:v8A` 候选语言、基址 `0x40160000` 导入 EG，先手动标记启动区和 `0x401691D0`，再按已恢复描述表映射 RAM 数据。此 Ghidra 流程尚未在本环境实际执行。
4. **DSP/AI**：利用 CEVA ELF 符号表建立模块清单；指令反汇编需要匹配的 CEVA 工具支持。
5. **版本差异**：获取另一份官方 Z8 固件后逐段比较，优先分析 EG/LI，避免直接在混淆后的整包上做代码差分。

## 验证范围

完成了外包精确重新编码、全部 CRC、NISI 分配/长度、gzip 完整流与尾部、CPIO 全目录、
DTB 节点/属性边界、嵌入 ELF 头/段/节范围，以及主程序基址的交叉验证。
GNU cpio 对 820 条目录逐项核对一致，gzip 和 readelf 独立核验通过。
现有测试与新增嵌套格式测试合计 **14 项通过**。

没有进行真机刷写、漏洞利用、网络服务可达性测试或完整功能反编译。
输入原文件保持不变；对启动映射和系统组成的结论强于对完整认证链及运行时行为的结论。
