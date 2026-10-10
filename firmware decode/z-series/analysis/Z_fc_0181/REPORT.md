# Z fc 固件 1.81 批量分析

样本：`Z_fc_0181.bin`，35,578,974 字节。
官方来源：[下载页](https://downloadcenter.nikonimglib.com/en/download/fw/593.html)。

SHA-256：`e4cd838a215c113659416983b31dbdba8896591caacf7309170d4cc3c60bd1b6`。

[全系列报告](../catalog/REPORT.md) · [批量清单](survey/manifest.json)

**已解包，3 个分段的 CRC、整包 CRC 和逐字节重编码均通过。**

| 分段 | 字节数 |
| --- | ---: |
| `ex1985_014000.bi` | 524,290 |
| `_tpj04_v10a5.bin` | 32,802 |
| `eg1985_018100.bi` | 35,021,690 |

分段二进制、带偏移的字符串和熵统计位于本目录；深入结构检查位于 `survey/`。

未执行固件，未生成刷机补丁。
