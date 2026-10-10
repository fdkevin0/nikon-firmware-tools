# Z 5 固件 1.50 批量分析

样本：`Z_5_0150.bin`，36,011,790 字节。
官方来源：[下载页](https://downloadcenter.nikonimglib.com/en/download/fw/562.html)。

SHA-256：`efc0ce70dcafdd96c64e95d8d50f6b7f0509fc0c2840b28d12b6f9e4877ee776`。

[全系列报告](../catalog/REPORT.md) · [批量清单](survey/manifest.json)

**已解包，4 个分段的 CRC、整包 CRC 和逐字节重编码均通过。**

| 分段 | 字节数 |
| --- | ---: |
| `ex1650_013000.bi` | 524,290 |
| `_tpt01_0010.bin` | 45,034 |
| `eg1650_015001.bi` | 34,603,578 |
| `vr1650_010100.bi` | 838,664 |

分段二进制、带偏移的字符串和熵统计位于本目录；深入结构检查位于 `survey/`。

未执行固件，未生成刷机补丁。
