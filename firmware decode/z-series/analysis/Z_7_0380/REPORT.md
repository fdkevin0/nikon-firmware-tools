# Z 7 固件 3.80 批量分析

样本：`Z_7_0380.bin`，34,472,614 字节。
官方来源：[下载页](https://downloadcenter.nikonimglib.com/en/download/fw/558.html)。

SHA-256：`07cf19513ada5b770caec4cfc3531a6734c48aede28dcec037f0f8374ef441a2`。

[全系列报告](../catalog/REPORT.md) · [批量清单](survey/manifest.json)

**已解包，4 个分段的 CRC、整包 CRC 和逐字节重编码均通过。**

| 分段 | 字节数 |
| --- | ---: |
| `ex1610_037000.bi` | 524,290 |
| `_tpj01_v140.bin` | 57,346 |
| `eg1610_038000.bi` | 33,052,090 |
| `vr1610_010200.bi` | 838,664 |

分段二进制、带偏移的字符串和熵统计位于本目录；深入结构检查位于 `survey/`。

未执行固件，未生成刷机补丁。
