# Z 50 固件 2.60 批量分析

样本：`Z_50_0260.bin`，31,972,272 字节。
官方来源：[下载页](https://downloadcenter.nikonimglib.com/en/download/fw/555.html)。

SHA-256：`69745c9e8f3156e936918e62a4a1fad18e7078e9ea3b95d8b8e08144b1542e49`。

[全系列报告](../catalog/REPORT.md) · [批量清单](survey/manifest.json)

**已解包，3 个分段的 CRC、整包 CRC 和逐字节重编码均通过。**

| 分段 | 字节数 |
| --- | ---: |
| `ex1630_021000.bi` | 524,290 |
| `_tpt01_0091.bin` | 43,700 |
| `eg1630_026000.bi` | 31,404,090 |

分段二进制、带偏移的字符串和熵统计位于本目录；深入结构检查位于 `survey/`。

未执行固件，未生成刷机补丁。
