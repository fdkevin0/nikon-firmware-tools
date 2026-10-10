# Z6III 固件 2.00 批量分析

样本：`Z6_3_0200.bin`，117,641,453 字节。
官方来源：[下载页](https://downloadcenter.nikonimglib.com/en/download/fw/571.html)。

SHA-256：`b5c08335dc79d3d36d7bad0976434134db8ce160886d1c8c2935f3b185bcdbc9`。

[全系列报告](../catalog/REPORT.md) · [批量清单](survey/manifest.json)

**尚未完整解密，未验证固件分段或整包 CRC。**

参照辅助恢复窗口：`0x16c20bc–0x1ea95b8`，8,287,484 字节。
已知明文参照位置：`0x18bf8f4`；与原公共掩码的 5,750,024 字节重叠全部一致。

窗口和字符串位于 `survey/reference_assisted_window.*`；结构可解析的 ELF 与符号表位于 `survey/expanded_elf/`。
注入的已知参照不算作独立发现的明文；局部掩码不能用于未覆盖的文件位置。

未执行固件，未生成刷机补丁。
