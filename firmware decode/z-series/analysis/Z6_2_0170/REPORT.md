# Z 6II 固件 1.70 批量分析

样本：`Z6_2_0170.bin`，49,002,888 字节。
官方来源：[下载页](https://downloadcenter.nikonimglib.com/en/download/fw/560.html)。

SHA-256：`5a9640b4c07abe1ecbf5a52655cbec6b893bba045bb2a1a1d21055b9f8f9d06d`。

[全系列报告](../catalog/REPORT.md) · [批量清单](survey/manifest.json)

**已解包，5 个分段的 CRC、整包 CRC 和逐字节重编码均通过。**

| 分段 | 字节数 |
| --- | ---: |
| `ex1850_012000.bi` | 524,290 |
| `_tpj01_v140.bin` | 57,346 |
| `eg1850_mas_01700` | 38,750,138 |
| `vr1850_010100.bi` | 838,664 |
| `eg1850_sla_01700` | 8,832,194 |

分段二进制、带偏移的字符串和熵统计位于本目录；深入结构检查位于 `survey/`。

未执行固件，未生成刷机补丁。
