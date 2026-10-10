# Z 9 固件 5.32 批量分析

样本：`Z_9_0532.bin`，101,846,611 字节。
官方来源：[下载页](https://downloadcenter.nikonimglib.com/en/download/fw/585.html)。

SHA-256：`2f13e75d38cd5b65da5b1f21a7828bc8a65ab17dc4c1b435b040ee62d2ed1d81`。

[全系列报告](../catalog/REPORT.md) · [批量清单](survey/manifest.json)

**已解包，6 个分段的 CRC、整包 CRC 和逐字节重编码均通过。**

| 分段 | 字节数 |
| --- | ---: |
| `ex1990_051000.bi` | 524,290 |
| `_tpj01_0210.bin` | 57,346 |
| `eg1990_053200.bi` | 81,823,631 |
| `vr1990_010200.bi` | 838,664 |
| `_gst00_0017.bin` | 661,910 |
| `li1990_053200.bi` | 17,940,482 |

分段二进制、带偏移的字符串和熵统计位于本目录；深入结构检查位于 `survey/`。

检出 3 个结构可解析的嵌入 ELF，文件与符号表位于 `survey/embedded_elf/`。

Linux CPIO 条目数：1505；只提取普通文件，不创建固件中的设备节点或符号链接。

内核标识：`Linux version 4.14.224-ts-aarch64 (n8410@n8410) (gcc version 6.5.0 (Timesys 20200228)) #1 SMP PREEMPT Wed Jul 16 15:23:50 JST 2025`。

未执行固件，未生成刷机补丁。
