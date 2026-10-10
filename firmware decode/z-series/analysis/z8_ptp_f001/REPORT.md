# Nikon Z8 3.11：0xF001 是私有 PTP 子操作码

调研日期：2026-10-07。范围：Z8 3.11 `eg2070_0311b0.bi`，SHA-256 `f85e0138e2f5e660ece8560de62e0d12cb795e0e14983e50f20b61dce906c46c`；并与公开上游 PTP 实现核对。本文没有连接相机或发送 USB 命令。

**在这个固件的私有服务分派路径里，`0xF001` 确实是 sub-opcode（子操作码）：它放在 PTP 第一个参数内，由外层操作继续分派。其成功路径开启一个私有服务状态，`0xF002` 的对应路径关闭该状态。** “私有会话／服务入口”是根据行为采用的分析名称，尚未找到尼康官方的命令名称定义。证据为本目录的[代码摘录](code_landmarks.asm)、[提取与检查结果](manifest.json)，以及[前一轮资源读取分析](../z8_ptp_resources/REPORT.md)。

## 1. 先区分外层操作码和内层子操作码

标准 USB PTP 容器的 `code` 是 16 位字段，位于 `+0x06`；第一个 32 位参数位于 `+0x0C`。libgphoto2 的结构定义及发送函数分别处理这两个字段。[结构定义](https://raw.githubusercontent.com/gphoto/libgphoto2/master/camlibs/ptp2/ptp.h)、[发送实现 `ptp_usb_sendreq`](https://raw.githubusercontent.com/gphoto/libgphoto2/master/camlibs/ptp2/usb.c)

Z8 的通用预检查 `0x407FE27C` 在 `0x407FE294` 用 `ldrh` 读取请求 `+0x0C` 的低 16 位作为内部编号，在 `0x407FE298` 从 `+0x06` 读取外部操作码。内部查询函数 `0x407FE078` 按 48 字节步长搜索 `0x440EC590` 开始的表，第一条编号就是 `0xF001`。这直接证明两者处于不同层次，而不是仅凭编号范围猜测。[反汇编](code_landmarks.asm)

外层表有三条相邻描述符：

| 外层 PTP opcode | 描述符地址 | 原始 flags | 预检查包装 | 处理包装 |
|---|---|---|---|---|
| `0x94FD` | `0x44DF2820` | `0` | `0x407FE130` | `0x407FE138` |
| `0x94FE` | `0x44DF2860` | `2` | `0x407FE150` | `0x407FE158` |
| `0x94FF` | `0x44DF28A0` | `1` | `0x407FE160` | `0x407FE168` |

三组包装最终共用内部预检查 `0x407FE27C` 和处理分派 `0x407FE350`；`0x94FE` 另有数据接收回调 `0x407FE140`。`0xF001` 的内部描述符 flags 为 0，处理器为 `0x407FE53C`，初始化回调为 `0x407FE4F0`。[提取结果](manifest.json)、[反汇编](code_landmarks.asm)

分析时应分别记录 `PTP opcode` 与 `Param1/sub-opcode`。对于这里的 `0xF001`，与 flags 0 所指示的无数据阶段相符的请求形态为：

```text
OperationCode = 0x94FD
Parameters    = [0x0000F001, 0, 0, 0, 0]
```

离线调用原始预检查包装时，此五参数请求通过准入；仅传一个参数 `[0xF001]` 会被参数长度检查以 `0x2006` 拒绝。因此，“处理器不读取额外参数”不等于“只发送一个参数即可”。外层数据方向的解释来自描述符和包装代码，完整传输状态机尚未验证；以上也不表示其它外层组合一定被预检查拒绝。[检查结果](manifest.json)

这还不是经过真机验证的完整调用配方；不能把它简化为直接发送顶层 `0xF001`。

## 2. 0xF001 的行为与 0xF002 对照

初始化回调 `0x407FE4F0` 注册状态查询函数 `0x407FE524`。查询函数读取 `0xA047D9FC8` 的标志；通用预检查据此决定是否允许内部命令继续。标志未开启时，`0xF001` 是该检查中的专门例外，其它内部命令会进入 `0xA004` 拒绝路径。[反汇编](code_landmarks.asm)、[此前对 `0xF029` 的关闭状态检查](../z8_ptp_resources/REPORT.md)

`0xF001` 处理器 `0x407FE53C` 在成功路径 `0x407FE63C` 向同一地址写入 1。相邻 `0xF002` 处理器 `0x407FE734` 调用关闭逻辑 `0x407FE77C`，在 `0x407FE83C` 清除此标志。这组“允许未开启状态下进入—写 1—对应命令清 0”的控制流，支持把 `0xF001` 命名为“开启私有服务／会话”，把 `0xF002` 命名为“关闭私有服务／会话”。这两条完整开启／关闭路径只做了静态分析，没有运行其硬件后端。[反汇编](code_landmarks.asm)

已开启状态下的重复进入分支做了离线执行：外层响应 `code = 0x2001`，但响应第一个参数为内部状态 `0x201E`，处理器返回 0。因此不能仅以外层 `0x2001` 判断内部命令完成了一次新的开启操作。[检查结果](manifest.json)

这里的标志不是标准 PTP `OpenSession (0x1002)` 的命令编号。标准会话与该私有状态应分开记录。[标准操作码定义](https://raw.githubusercontent.com/gphoto/libgphoto2/master/camlibs/ptp2/ptp.h)

## 3. 为什么不能推广为所有尼康机型的统一定义

早期 Nikon 固件工具的 `PtpCommands.cs` 使用顶层 `0xFC01` 开启服务模式、`0xFC02` 退出；`EnterServiceMode` 将前者直接传给 `ExecuteWithNoData`，并接受 `0x2001` 或 `0x201E`。Wireshark 上游的 Nikon USB PTP 字典也将这两个编号标记为 `ServiceModeStart`／`ServiceModeStop`。这些是公开工具的一手实现证据，不是尼康官方规格，也不意味着 Z8 继续使用旧顶层编号。[Nikon 工具源码](https://raw.githubusercontent.com/simeonpilgrim/nikon-firmware-tools/master/PTP%20Tools/CameraModels/PtpCommands.cs)、[Wireshark 上游字典](https://raw.githubusercontent.com/wireshark/wireshark/master/epan/dissectors/packet-usb-ptp.h)

还有不同编号空间复用的情况：libgphoto2 为 Nikon 1 系列补充 `0xF000..0xF01C` 到 `DeviceProps` 列表，其中包含 `0xF001`。因此只看到十六进制数，不能判定其一定是同一个子命令；必须同时确认机型、固件、外层 opcode 和该值所在字段。[Nikon 1 属性补充逻辑](https://raw.githubusercontent.com/gphoto/libgphoto2/master/camlibs/ptp2/library.c)

截至本次检索，在查阅的 libgphoto2 与 Wireshark 上游操作码定义中没有找到 `0xF001` 的 Nikon 官方名称。这里“是子操作码”的肯定结论来自 Z8 3.11 的二进制分派证据，不能扩展为全系列、全版本通用协议。

## 4. 可复现证据和未解决部分

使用[提取工具](../../tools/reverse_z8_ptp_f001.py)重新提取本目录产物，需要 Capstone 与 Unicorn：

```sh
cd "firmware decode/z-series"
python3 tools/reverse_z8_ptp_f001.py
```

本次使用已有 `/tmp/nikon-z8-re-venv/bin/python` 环境执行，系统 Python 未安装 Unicorn。五个离线检查全部通过：

| 私有状态 | 子码 | 参数个数 | 检查结果 |
|---|---|---|---|
| 0 | `0xF001` | 5 | 准入；未执行开启后端 |
| 0 | `0xF002` | 5 | 拒绝，外层 `0xA004` |
| 0 | `0xF029` | 5 | 拒绝，外层 `0xA004` |
| 0 | `0xF001` | 1 | 拒绝，外层 `0x2006` |
| 1 | `0xF001` | 5 | 准入；执行重复进入分支，外层 `0x2001`、内部 `0x201E` |

私有状态由仿真内存构造，响应发送函数被拦截记录；未执行真实 USB 发送。[检查结果](manifest.json)

原始资源读取路径的[工具与报告](../z8_ptp_resources/REPORT.md)可作交叉核对。所有地址均针对上述哈希对应的 Z8 3.11 镜像，不应直接移植到其它版本。

仍需单独确认真实 PTP 连接与标准会话时序、传输状态机、处理器所调用后端的完整副作用，以及其它机型／固件版本中的对应表项。离线分派验证不等于相机已成功进入服务状态，也不能证明开启操作只改这一处 RAM 标志。
