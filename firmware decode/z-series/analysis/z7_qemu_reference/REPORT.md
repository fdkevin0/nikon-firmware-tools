# 参考 z7-qemu：当前 Z8 诊断菜单补丁的验证路线

分析日期：2026-10-10。参考仓库 `/home/fdkevin/Workspaces/z7-qemu`，提交 `97abf0b81cd3211f8374a38987a0beaf4549b90f`，读取时工作区干净。本次未修改该仓库，未修改已有 Z8 实验包。

## 结论

这个实现可以作为**辅助启动、设备建模和菜单验收的方法参考**，不能直接运行当前 Z8 C 3.11 或 `3.11 P` 实验固件。它只适配指定 Z7 C 3.80 的 ARMv7 MAIN；Z8 的主 EG 是 AArch64，启动、中断、内存、RTOS 和图形驱动接口均有区别。

当前仓库已经具备它要求的 Z7 原始输入：`analysis/Z_7_0380/eg1610_038000.bi` 去掉末尾两字节 CRC 后，长度及 SHA-256 **精确匹配**其启动器。无需寻找另一份 Z7 固件。

| 输入 | 字节数 | SHA-256 |
|---|---:|---|
| 本仓库 Z7 EG，含 CRC | 33,052,090 | `7f59d8993080203a12692cf6927a0a8218786d3f72230c04174f1563c506a6f6` |
| QEMU 要求的 Z7 MAIN，不含 CRC | 33,052,088 | `e6df1764323fb1c287159dd3ce1c84ac93c72b96ba6eb09c070295c093fecbff` |

这是本次直接读取文件计算的结果。相机升级包容器和含 CRC 的 EG 均不能原样作为该启动器的输入。机器代码层检查 MAIN 长度，Python 启动器另外检查完整 SHA-256；绕过检查不会得到 Z8 支持。

## 源码实际做了什么

| 层次 | 实现与证据 | 能证明的范围 |
|---|---|---|
| CPU 与机器 | `qemu/nikon-z7-lab.c:z7_common_init`，默认 Cortex-A15、两个核、A15 MPCore、中断和计时器 | 特定 Z7 路径的实验机器，不是完整 EXPEED 硬件规范 |
| 启动与内存 | MAIN 在 `0x10020000`；SRAM `0x04008000`；应用 RAM `0xA1800000`；额外堆、池与别名；guest 建立自己的 MMU 映射 | 不可把所有缓冲地址、虚拟地址及 GPU 句柄视为物理地址 |
| 辅助启动 | `tools/interactive.py:Camera.boot` 在检查点停机，再调用原厂内存、电源、系统状态和应用服务函数 | 原固件在有干预的 guest 中执行，不是自然上电已经还原 |
| 按键 | `Camera.key` 将位图和按压时长传给 Z7 原 AutoOperation 函数 `0x105230A6` | 菜单响应来自 guest；不是网页重画菜单，也不是物理按键电路模拟 |
| 图形 | `nikon-z7-gpu.h` 解释选定的 SMAPH-F/OpenVG 命令、路径、描边、位图及混合 | 使用输入固件自己的字形/图标；不证明 Z8 命令格式相同 |
| LCD | `z7_lcd_present` 从 guest 指定的图像/覆盖缓冲区合成输出，再由 QMP 截图 | 比仅观察“文字函数被调用”更接近真实页面显示验证 |
| 未知设备 | `z7_unknown_access` 记录访问、寄存器和 CPU 状态后请求停机；未知读的 0 是停机路径返回值 | 不把未知访问当作正常设备值继续伪造成功 |
| 取景链路 | RAW DMA → 功能性 ISP → guest 选择输出 → LCD；含完成 IRQ、停止排空和重新启动状态 | 实验场景链路；未还原真实传感器、校准、AF 或写卡拍摄 |
| 保存状态 | 无完整 VMState/migration | 浏览器暂停是保留进程，不是可恢复的完整相机快照 |

`tools/probe.py:call_fixture` 会保存寄存器及栈暂存区，借原有返回检查点调用原函数，再恢复上下文。它跟踪调用/返回 CPU，因为 RTOS 任务可能迁移。函数自身造成的系统状态变化仍然存在，应按辅助操作记录，不能称为被动观察。

参考：[设备架构](/home/fdkevin/Workspaces/z7-qemu/docs/architecture.md)、[启动和按键实现](/home/fdkevin/Workspaces/z7-qemu/tools/interactive.py:230)、[函数调用辅助](/home/fdkevin/Workspaces/z7-qemu/tools/probe.py:15)、[图形模型](/home/fdkevin/Workspaces/z7-qemu/qemu/nikon-z7-gpu.h:34)、[截图验收](/home/fdkevin/Workspaces/z7-qemu/tools/verify_ui.py:27)。

## 与 Z8 的关键差异

| 项目 | z7-qemu | 当前 Z8 3.11 证据 | 处理方式 |
|---|---|---|---|
| 指令与寄存器 | ARMv7/Thumb；R0..R15、CPSR | AArch64；X0..X30、SP、PC、异常级别 | 需要 AArch64 machine/构建目标和新的调用辅助 |
| 中断控制器 | A15 MPCore；实验 GIC revision 配置 | EG 启动使用 `ICC_SRE_EL3/EL2/EL1`；LI 设备树声明 GICv3 | 重新验证 GICv3 的地址、IRQ 路由和初始化，不能照搬 A15 模型 |
| CPU 类型与核分工 | 显示机器用两个 A15 核 | Linux DTB 的 `cpu@3` 为 Cortex-A53；EG 按核编号区分角色 | A53 可作为起步候选；DTB 不能证明整个 SoC、所有核和启动顺序 |
| EG 地址 | `0x10020000` | `0x40160000` | 重建加载和 MMU 配置，不能以固定差值平移旧函数地址 |
| 初始化 RAM | 32 位地址窗口 | `0xA02808000`，复制 `0x2AD000`；BSS 从 `0xA02AFB000` 起 | 需覆盖高地址物理/虚拟空间，验证复制和清零的实际执行 |
| RTOS | Z7 固件含 SMP T-Kernel；原启动函数为该版本定位 | Z8 EG 含 SOLID-OS/TOPPERS FMP 路径，另有 LI Linux 和 CEVA 映像 | 重新定位锁、队列、任务、内存池、外设完成事件 |
| 图形地址 | `z7_gpu_range` 和 `present_address` 为 `uint32_t`，允许区间写死 | Z8 运行数据和新节点地址超过 32 位；新节点为 `0xA02AB4500` | 不可截断；先确定 GPU 使用完整地址还是低位地址加高位寄存器/窗口 |
| 图形命令 | Z7 3.80 观察到的命令、寄存器和完成 IRQ | Z8 有 `OpenVG` 文本，但没有本次验证的 GPU 指令流对应关系 | 可借鉴光栅化算法；仍需比较 Z8 命令、寄存器、缓冲格式及完成顺序 |
| RSP | ARM XML、4 字节寄存器、Thumb 位、固定返回地址 | 8 字节 X 寄存器及 AArch64 PSTATE/EL、独立 SP/PC | 应按协商的 target XML 解析，不复用原偏移或 CPSR 操作 |
| 上游 QEMU 修改 | GIC 调试读取与 ARM32 CPSR hflags 修正 | 未验证对 Z8 有同样问题 | 起步沿用未改的 AArch64 核心，按实际缺陷决定是否修改 |

Z8 启动指令见 [z8_boot_landmarks.asm](z8_boot_landmarks.asm)。地址及 Linux 设备树来源见 [Z8 原始分析](../Z_8_0311/REPORT.md)、[device_tree_0.dts](../Z_8_0311/linux/device_tree_0.dts)。设备树只覆盖该 Linux 配置，不能代替实时系统完整硬件图。

## 对现有 3.11 P 补丁的意义

现有 [诊断菜单验证器](../../tools/verify_z8_diagnostic_ui.py) 执行了文字对象构造、属性读取、显示辅助函数及导航目标分支，但替代了对象查找、分配器、锁、列表登记、绘制和导航服务。这仍然有价值，却不能回答以下实际运行问题：

- 新菜单行是否能由原内存池分配，滚动到第 45 项时是否可见、可选。
- 初始化数据复制后，新节点的 96 字节是否保留；随后是否被清零或重用。
- 新代码在 guest 的实际 MMU 属性下是否可执行，资源表和节点地址是否可访问。
- 新标题及 `3.11 P` 的实际字形、布局、描边是否正确，文字缓存是否造成重复进入异常。
- MENU、OK、右键和触摸动作经真实事件队列后，是否进入/退出正确页面。

z7-qemu 展示了如何补上这些验证：保留原菜单、内存池、文字缓存及事件处理，让固件绘制实际图像；用 QMP 截图和 guest 状态共同验收。它没有 USB 控制器的完整 PTP 模拟，因此也不能直接证明 `0x94FD / 0xF0FF` 的真实 USB 交付。

## 建议的最小推进顺序

1. **先建立 Z7 对照基线。** 用已确认匹配的 MAIN 和参考仓库固定 QEMU 10.2.4 构建复现 `--profile menu`；记录帮助调用与截图，不启用拍摄/RAW/ISP。目的是核对本地工具链和取得菜单设备依赖清单。
2. **单独建立 Z8 最小机器。** 构建 `aarch64-softmmu`，按 EG 启动描述表建内存、EL、GICv3 与计时器；从 `0x40160000` 跟踪原始启动。未知访问停机记录，逐个解释等待的生产者、完成状态与消费者；不先用通用 `virt` 或大量“成功”返回代替设备。
3. **原版先跑菜单。** 找到 Z8 自己的电源/应用就绪路径、GUI 堆、原生按键/事件入口、GPU 和 LCD 接口。辅助步骤版本绑定且逐项记录。只有发现实际依赖时才增加 Linux、DSP 或其他服务，不能预先认定它们必要或无关。
4. **同一模型对照原版和补丁。** 除输入镜像和指纹外保持设备配置及辅助步骤一致。补丁模式记录构建清单的精确 hash，不删除输入校验，也不以“已经 patched”为由替代新菜单绘制函数。
5. **验收本次新增功能。** 原版 44 项、补丁 45 项；滚动到末项；检查诊断标题、四行字段、Done；原固件版本页 C 行为 `3.11 P`；重复进入/退出三轮且同一 guest 不重启。记录节点/缓冲区边界、实际截图、未建模访问与错误。

这里的实现目标应是 **Z8 菜单运行与显示验证**。传感器、RAW、ISP、AF 和拍摄写卡可以等菜单验证成功后再研究。本次只完成参考分析，没有开始移植完整 Z8 QEMU。

## 本次实际复核

| 检查 | 本地结果 |
|---|---|
| 参考 Git 状态与来源 hash | 工作区干净；已记录 14 个关键源码/文档指纹 |
| 本仓库 Z7 EG 到参考 MAIN 的对应 | 去掉 2 字节 CRC 后长度与 SHA-256 精确匹配 |
| Python 合成测试 | 11 项通过，使用 `/usr/bin/python3`，NumPy 2.3.5、Pillow 12.1.1 |
| C 合成渲染契约 | 270 项通过，ASan/UBSan 开启 |
| C 合成 ISP 契约 | 398 项通过，ASan/UBSan 开启 |
| LeakSanitizer | 当前执行环境下报不支持 ptrace，未验证泄漏；上述重跑使用 `detect_leaks=0` |
| 测试依赖 | 系统 pkg-config 未找到 GLib；C 检查改用已安装的 Homebrew GLib 2.90.1 与 `/usr/bin/cc`，未安装依赖 |
| QEMU 运行 | PATH 中未发现 `qemu-system-arm` 或 `qemu-system-aarch64`；参考 checkout 无现成 `.build`；未构建/启动 guest |

测试二进制仅写入 `/tmp/z7-qemu-native-tests-*`；源码仓库没有写入或新增构建文件。机器可读结果与来源见 [manifest.json](manifest.json)。合成测试通过证明这些模型在所测契约下工作，不代表本次复现了 Z7 原生菜单，更不代表 Z8 菜单已通过 QEMU 或真机验证。

即使将来 Z8 QEMU 菜单通过，也只能提高运行逻辑与显示方面的可信度；真机升级接受、Flash 布局、实际外设行为和恢复能力仍需独立证据。
