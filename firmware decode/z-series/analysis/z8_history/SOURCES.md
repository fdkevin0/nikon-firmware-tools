# Z 8 固件历史：来源与覆盖边界

调查日期：2026-10-05。已定位全部 **8 个公开更新版本**的尼康官方 CDN 文件。另有出厂版 **1.00** 的官方版本记录，但尚未找到其原始升级二进制；不能把源码包算成固件。

| 版本 | 官方索引日期 | 下载页编号 | 下载文件 | HEAD 字节数 | 来源状态 |
|---|---|---|---|---:|---|
| 1.00 | 2023-05-25 | — | 未找到升级二进制 | — | 仅有出厂版本及 OSS 记录 |
| 1.01 | 2023-08-23 | 495 | [F-Z8-V101W.exe](https://download.nikonimglib.com/archive6/K5wUs009R5Fh06tpTET156eIlD62/F-Z8-V101W.exe) | 70578888 | 已确认官方 CDN 返回 200 |
| 2.00 | 2024-02-07 | 514 | [Z_8_0200.bin](https://download.nikonimglib.com/archive6/nAw07006uaoL06zvSCg38iqdVt56/Z_8_0200.bin) | 96221253 | 已确认官方 CDN 返回 200 |
| 2.01 | 2024-04-23 | 527 | [Z_8_0201.bin](https://download.nikonimglib.com/archive6/PfgBE008SOjN06KgRkV51CswoO24/Z_8_0201.bin) | 96225349 | 已确认官方 CDN 返回 200 |
| 2.10 | 2025-02-26 | 550 | [Z_8_0210.bin](https://download.nikonimglib.com/archive7/N4LVm007uyXE07kH9hg00m9htz95/Z_8_0210.bin) | 96524357 | 已确认官方 CDN 返回 200 |
| 3.00 | 2025-07-01 | 563 | [Z_8_0300.bin](https://download.nikonimglib.com/archive7/9r1LM00QTFkw07nZfqG26FMTZa99/Z_8_0300.bin) | 99051117 | 已确认官方 CDN 返回 200 |
| 3.01 | 2025-07-16 | 570 | [Z_8_0301.bin](https://download.nikonimglib.com/archive7/3eg5G00HkcGK07XnlMZ279huk309/Z_8_0301.bin) | 99051117 | 已确认官方 CDN 返回 200 |
| 3.10 | 2025-09-17 | 573 | [Z_8_0310.bin](https://download.nikonimglib.com/archive7/Hij1g00TJmvi07pPtcJ38Yk9EH03/Z_8_0310.bin) | 99051117 | 已确认官方 CDN 返回 200 |
| 3.11 | 2026-09-16 | 606 | [Z_8_0311.bin](https://download.nikonimglib.com/archive8/wP5Vr003qbpC07ibhJ666rmRfF47/Z_8_0311.bin) | 99051117 | 已确认官方 CDN 返回 200 |

## 核查方法

版本与日期首先核对[尼康 OSS 总索引](https://imaging.nikon.com/imaging/oss/en/)，再用[当前固件完整更新历史](https://downloadcenter.nikonimglib.com/en/download/fw/606.html)交叉检查版本序列。OSS 日期是源码公布日期；八个公开更新的官方 CDN `Last-Modified` 日期与之逐项相符。1.00 的 2023-05-25 只能按 OSS 索引日期表述，不将其解释成公开升级包发布日期。

部分旧下载页已撤下，直接访问返回 404。2.00、2.10 的缓存官方页面仍可恢复下载跳转：[2.00 德语页](https://downloadcenter.nikonimglib.com/de/download/fw/514.html)、[2.10 英语 origin 页](https://downloadcenter-origin.nikonimglib.com/en/download/fw/550.html)。3.11 来自当前官方页。

其余失效页面的二进制链接通过 [TousLesDrivers 尼康历史档案](https://www.touslesdrivers.com/index.php?v_page=26&v_code=535)中的公开跳转定位；跳转目标均是 `https://download.nikonimglib.com/` 官方 CDN。这里将第三方站点作为地址线索，实际固件只取官方源。每个版本的跳转地址、官方 CDN、HEAD 状态、长度、时间及来源均在 [discovery.json](discovery.json)。

1.01 使用尼康原始 Windows 自解压 EXE 分发包 `F-Z8-V101W.exe`，需静态解压其中的 `Z_8_0101.bin`，无需执行 EXE。其他七版为直接 BIN。

## 缺失及限制

- 尼康有[1.00 源码页面](https://imaging.nikon.com/imaging/oss/en/download/Z8_v1.00.html)，但 `Z8_v1.00-GPL_sources.tar.xz` 是 GPL 源码，不能替代可分析的相机完整固件。
- 本次检索 `Z_8_0100.bin`、`F-Z8-V100W.exe`、1.00 固件下载/降级线索以及官方和第三方历史目录，未找到 1.00 原包；搜索未命中不等于证明该包从未存在。
- HEAD 验证只证明下载地址在线且元数据合理；实际下载哈希、解包 CRC、原样重编码由后续采集与分析流程验证。
