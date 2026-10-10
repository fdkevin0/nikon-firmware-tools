# Z8 官方固件 QEMU 适配

目标是先让 **未修改的 Z8 C 3.11** 启动，再验证诊断菜单补丁。
当前已执行官方 EL3/EL1 引导、DMA 初始化数据搬运、多核释放及 RTOS 调度；
**完整相机开机、原生菜单和 Linux 尚未跑通**。证据及剩余阻塞见
[启动报告](../../analysis/z8_qemu_boot/REPORT.md)。

这是本仓库新增的 AArch64 板级模型，参考了
[`z7-qemu`](../../analysis/z7_qemu_reference/REPORT.md) 的研究方式。
Z7 的 CPU、32 位地址、GIC、GPU 命令及辅助启动脚本不能直接移植到 Z8。
模型没有修改 QEMU 的 CPU 核心，也没有改官方固件指令或通过 GDB 写入启动 RAM。

## 构建与启动

从本仓库根目录执行：

```sh
cd 'firmware decode/z-series'
python3 -B tools/build_z8_qemu.py --jobs 4
python3 -B tools/run_z8_qemu.py --output /tmp/z8-stock-probe --seconds 5
```

需要 Python 3.12+、C 编译器、Ninja、Git、pkg-config 和 QEMU 构建所需的 GLib 开发文件。
构建脚本下载官方 QEMU **10.2.4** 源码并验证 SHA-256，dtc 固定到 QEMU 锁定的
`b6910bec11614980a21e46fbccc35934b671bd81`。
首次配置还会使用 QEMU 自带的 Python 构建依赖包。
默认构建目录 `/tmp/nikon-z8-qemu-build`，目录名不能含空格或冒号；源码所在仓库可以含空格。

已有源码压缩包时：

```sh
python3 -B tools/build_z8_qemu.py --archive /tmp/qemu-10.2.4.tar.xz
```

运行器只接受指纹匹配的 `Z_8_0311.bin`，重新解包并检查封装 CRC 和 EG 指纹，
随后把官方 EG 的有效载荷加载到 `0x40160000`；分段末尾两字节容器 CRC 不装入闪存。
它会检查已构建 QEMU 及板级代码的指纹；
修改模型后必须重新构建。

输出目录必须尚不存在，包含 `official-eg.bi`、`guest.log`、`exceptions.log` 和
`manifest.json`。遇到未建模的 CPU 访问，模型记录地址、访问宽度、PC 和各核状态，
以退出码 2 停止；运行器返回 1。有限时间内运行结束或命中断点返回 0，
**这个退出码不代表相机完整启动**。

## 可复现的引导验收点

```sh
python3 -B tools/run_z8_qemu.py \
  --output /tmp/z8-stock-bootstrap --seconds 1 --breakpoint 0x401691d0
```

`0x401691d0` 是官方 RTOS 内核入口。这个点应满足：

- CPU 0 的 PC 为 `0x401691d0`，状态为 EL1。
- 官方初始化数据 `EG[0x4b13000:0x4dc0000]` 与
  `RAM[0xa02808000:0xa02ab5000]` 的全部 `0x2ad000` 字节一致。
- 日志包含实际 DMA 完成，以及固件通过 SRAM 邮箱释放 CPU 1、2。
- GDB 线程枚举包含四核；CPU 3 保持关闭，等待固件的 Linux 启动路径。

继续运行后，RTOS 会修改全局变量，`initialized_ram_copy_exact` 通常变为 false；
必须在上述入口断点核对初始数据，不能据此判定后续搬运失败。

## 模型契约检查

```sh
python3 -B -m unittest discover -s tools -p 'test_*.py'
python3 -B tools/check_z8_qemu_devices.py --output /tmp/z8-device-check
```

第二条需要 Clang、LLD 和 llvm-objcopy，执行独立合成 AArch64 客户机，
验证 DMA 的真实复制、清零、二维跨度及非零字节填充，完成确认、时序器状态变化、
时钟写掩码、计数器、空 I2C、SPI FIFO、复位配置与四核枚举，
以及 UART 无 RX 回显、24 个 HDMAC 通道的独立配置，
非法 DMA 目标、未实现的工作请求和未知寄存器访问的停止行为。
合成客户机与官方固件运行分开，不向官方固件注入测试指令。

配置覆盖表可以重新生成；这项离线分析需要 Capstone、Unicorn：

```sh
python3 -B tools/reverse_z8_qemu_config.py --output /tmp/z8-config-coverage
cmp qemu/z8/nikon-z8-config.h /tmp/z8-config-coverage/nikon-z8-config.h
```

这里的 Unicorn 函数探针使用初始化数据夹具、合成栈及 reset-zero MMIO。
它用于提取配置访问地址，不能作为真实硬件寄存器值或冷启动成功的证据。

## 假设与尚未实现的部分

- Cortex-A53、4 核、24 MHz 计时器、GICv3；CPU 类型是基于固件线索的候选模型。
- DDR 的 1 GiB 容量是模型假设；只验证了启动实际访问到的范围。
- 根据官方代码实际访问，额外映射 `0x8ff800000` 的 8 MiB 堆池窗口和
  `0x16020000` 的 2 KiB 共享 SRAM；与 DDR 的别名关系和 SRAM 对端尚未实现。
- 芯片修订值、启动 strap、部分首次读取的配置值和 1 µs 设备完成时间是明确假设。
- 辅助计数器使用 100 MHz 输入时钟假设，支持计数、周期溢出、有限次数结束和 IRQ；
  捕获输入及真实时钟频率仍未验证。`0x0e00100c` 保留读、改、写后的通道位。
- 平台接口仅锁存已经写全的参数和门控，不产生传感器或时序信号输出。
- `0x153c0000/0x15400000` 处理设备只支持已分析的复位和门控字段，
  复位字段的读回值是假设；处理工作、结果和完成中断尚未实现。
- 官方升级包缺少 `0x45980000..0x48000000` 的部分机身资源。
  当前只读擦除态 `FF`，首次访问会记录 `Z8_ABSENT_FLASH_HYPOTHESIS`；
  没有伪造或恢复校准参数。
- I2C 总线为空，只产生 NACK；SPI 无从设备，只按 MISO 高电平假设采样。
  SPI 的 16 字 FIFO 深度及 100 µs 完成延迟仍是假设，SPI 的总线 DMA 路径尚未实现。
  这两个模型参考了 `z7-qemu/qemu/nikon-z7-lab.c`，Z8 的地址、IRQ 和字段另行核对。
- UART 可配置和发送，没有接收源；读取 RX 会停机，不能把发送值回显为相机外设回复。
- 三组 HDMAC 各八个通道可保存已分析的配置，启用通道仍停机。
  当前官方启动停在第 0 组、第 4 通道向 SPI 7 的传输请求，尚未执行该数据搬运。
- 只建模已分析的 DMA、时序器、计数器、空总线和配置行为。其他总线传输、MCU 协议、
  加速器工作、GPU/LCD、按键和 Linux 装载仍需后续适配。
- 上游 GICv3 仍记录部分 reserved SGI-frame offset `0x10000` 访问，尚未完全解释。
- 尚未提供迁移/保存状态支持，重跑从官方固件的复位入口开始。

此前生成的 `3.11 P` 诊断菜单实验包没有在这个模型里运行过。
