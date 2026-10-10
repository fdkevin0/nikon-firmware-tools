# Z50II 固件 1.11 批量分析

样本：`Z50_2_0111.bin`，107,828,357 字节。
官方来源：[下载页](https://downloadcenter.nikonimglib.com/en/download/fw/605.html)。

SHA-256：`f1e92e1ae982a589000f1bc2bcd9e3e57613886b5b72398024ebc569bb8d7439`。

[全系列报告](../catalog/REPORT.md) · [批量清单](survey/manifest.json)

**尚未完整解密，未验证固件分段或整包 CRC。**

参照辅助恢复窗口：`0x16c20bc–0x1ea95b8`，8,287,484 字节。
已知明文参照位置：`0x16c20bc`；与原公共掩码的 5,726,640 字节重叠全部一致。

窗口和字符串位于 `survey/reference_assisted_window.*`；结构可解析的 ELF 与符号表位于 `survey/expanded_elf/`。
注入的已知参照不算作独立发现的明文；局部掩码不能用于未覆盖的文件位置。

未执行固件，未生成刷机补丁。
