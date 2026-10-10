# Z 30 固件 1.20 批量分析

样本：`Z_30_0120.bin`，34,496,798 字节。
官方来源：[下载页](https://downloadcenter.nikonimglib.com/en/download/fw/556.html)。

SHA-256：`1a5449ef505f1f347ed4e066a6a3f588ea542240680e83f4ebcae3b16da3434a`。

[全系列报告](../catalog/REPORT.md) · [批量清单](survey/manifest.json)

**已解包，3 个分段的 CRC、整包 CRC 和逐字节重编码均通过。**

| 分段 | 字节数 |
| --- | ---: |
| `ex2090_012000.bi` | 524,290 |
| `_tpj04_v10a5.bin` | 32,802 |
| `eg2090_0120a0.bi` | 33,939,514 |

分段二进制、带偏移的字符串和熵统计位于本目录；深入结构检查位于 `survey/`。

未执行固件，未生成刷机补丁。
