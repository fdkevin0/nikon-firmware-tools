# Z 7II 固件 1.70 批量分析

样本：`Z7_2_0170.bin`，48,494,024 字节。
官方来源：[下载页](https://downloadcenter.nikonimglib.com/en/download/fw/561.html)。

SHA-256：`fc0e94f57500a1f0e287c6b9a036c81a5ffceccb8432a377d645b3fa35a19b6a`。

[全系列报告](../catalog/REPORT.md) · [批量清单](survey/manifest.json)

**已解包，5 个分段的 CRC、整包 CRC 和逐字节重编码均通过。**

| 分段 | 字节数 |
| --- | ---: |
| `ex1840_013000.bi` | 524,290 |
| `_tpj01_v140.bin` | 57,346 |
| `eg1840_mas_01700` | 38,239,098 |
| `vr1840_010100.bi` | 838,664 |
| `eg1840_sla_01700` | 8,834,370 |

分段二进制、带偏移的字符串和熵统计位于本目录；深入结构检查位于 `survey/`。

未执行固件，未生成刷机补丁。
