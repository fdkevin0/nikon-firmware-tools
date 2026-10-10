# Nikon Z 系列相机发布时间表

记录本仓库研究范围内 15 款 Nikon Z 系列机身的正式产品公告日期，用于对照处理器代际和固件封装变化。包含全画幅、DX 半画幅及 Z CINEMA 的 ZR；同机型的配色、套机和限定外观不另计机型，不包含 RED 品牌机身、镜头或附件。

最后核验：**2026-10-05**。

“发布时间”统一指尼康正式产品公告的页面日期，优先采用 Nikon 全球官网，必要时使用尼康地区官网并标明。开发预告、开始预订、各地区上市和实际交付是不同事件，不据此改写产品公告日。日期按来源原样记录，未用缺少时刻的日期进行时区换算。

| 正式公告日 | 机型 | 画幅 | 图像处理器 | 已检查固件版本 | 样本封装 | 公告来源 |
| --- | --- | --- | --- | --- | --- | --- |
| 2018-08-23 | Z7 | FX 全画幅 | EXPEED 6 | 3.80 | 旧封装 | [Nikon 全球 Z7／Z6 公告](https://www.nikon.com/company/news/2018/0823_mirrorless_01/) |
| 2018-08-23 | Z6 | FX 全画幅 | EXPEED 6 | 3.80 | 旧封装 | [Nikon 全球 Z7／Z6 公告](https://www.nikon.com/company/news/2018/0823_mirrorless_01/) |
| 2019-10-10 | Z50 | DX 半画幅 | EXPEED 6 | 2.60 | 旧封装 | [Nikon 全球 Z50 公告](https://www.nikon.com/company/news/2019/1010_zmount_01/) |
| 2020-07-21 | Z5 | FX 全画幅 | EXPEED 6 | 1.50 | 旧封装 | [Nikon 美国 Z5 公告](https://www.nikonusa.com/press-room/new-z-5) |
| 2020-10-14 | Z6II | FX 全画幅 | 双 EXPEED 6 | 1.70 | 旧封装 | [Nikon 美国 Z6II／Z7II 公告](https://www.nikonusa.com/press-room/z7ii-z6ii) |
| 2020-10-14 | Z7II | FX 全画幅 | 双 EXPEED 6 | 1.70 | 旧封装 | [Nikon 美国 Z6II／Z7II 公告](https://www.nikonusa.com/press-room/z7ii-z6ii) |
| 2021-06-29 | Z fc | DX 半画幅 | EXPEED 6 | 1.81 | 旧封装 | [Nikon 美国 Z fc 公告](https://www.nikonusa.com/press-room/z-fc) |
| 2021-10-28 | Z9 | FX 全画幅 | EXPEED 7 | 5.32 | 旧封装 | [Nikon 全球 Z9 公告](https://www.nikon.com/company/news/2021/1028_mirrorless_01/) |
| 2022-06-29 | Z30 | DX 半画幅 | EXPEED 6 | 1.20 | 旧封装 | [Nikon 全球 Z30 公告](https://www.nikon.com/company/news/2022/0629_mirrorless_01/) |
| 2023-05-10 | Z8 | FX 全画幅 | EXPEED 7 | 3.11 | 旧封装 | [Nikon 全球 Z8 公告](https://www.nikon.com/company/news/2023/0510_mirrorless_01/) |
| **2023-09-20** | **Z f** | FX 全画幅 | EXPEED 7 | **1.10、1.21、3.01** | **新封装** | [Nikon 全球 Z f 公告](https://www.nikon.com/company/news/2023/0920_mirrorless_01/) |
| 2024-06-17 | Z6III | FX 全画幅 | EXPEED 7 | 2.00 | 新封装 | [Nikon 全球 Z6III 公告](https://www.nikon.com/company/news/2024/0617_imaging_01/) |
| 2024-11-07 | Z50II | DX 半画幅 | EXPEED 7 | 1.11 | 新封装 | [Nikon 全球 Z50II 公告](https://www.nikon.com/company/news/2024/1107_imaging_01/) |
| 2025-04-03 | Z5II | FX 全画幅 | EXPEED 7 | 1.20 | 新封装 | [Nikon 全球 Z5II 公告](https://www.nikon.com/company/news/2025/0403_imaging_01/) |
| 2025-09-10 | ZR | FX 全画幅，Z CINEMA | EXPEED 7 | 1.11 | 新封装 | [Nikon 全球 ZR 公告](https://www.nikon.com/company/news/2025/0910_imaging_01/) |

处理器归属另经[尼康官方 EXPEED 机型列表](https://nij.nikon.com/support/faq/products/article?articleNo=000055730)核对；Z6II／Z7II 的双处理器配置见表内对应公告。固件版本及封装来自本地二进制分析，不是产品公告给出的信息；“已检查版本”不保证始终是官网最新版本。

Z50II 存在地区公告日期差异：[美国公告](https://www.nikonusa.com/press-room/nikon-z50ii)标为 **2024-11-06**，全球公告标为 **2024-11-07**。主表按全球来源保留 11 月 7 日，不将一天差异解释为两次产品发布，也不在缺少精确时刻时断言其原因。

## 固件封装的时间分布

“旧封装”指本项目已验证可用传统三表 XOR 解包的格式，空格标记位于原始文件 `0x20`；“新封装”指固定扩展前缀及 `0x260` 空格标记等特征共同确定的封装家族。它们是本项目的分析名称，不能仅凭标记偏移确定算法。旧格式样本已通过 CRC 与原样重编码验证，新格式整包仍未解开。

按主表的公告顺序，**Z f 及随后四款机型的已检查样本均使用新封装，此前十款机型的已检查样本均使用旧封装**。这是当前样本的观察结果，支持“从 Z f 这一批新机型开始采用新封装”的推断，不代表已确认尼康内部策略，也不能外推到未检查的版本或未来产品。

Z8、Z9 使用 EXPEED 7，但所检查固件仍为旧封装；Z50II 属于 DX 半画幅，却使用新封装。因此处理器代际和画幅都不能单独决定封装类型。

Z f 的机型公告日为 **2023-09-20**，最早已核验的新封装固件是 **2023-11-16 发布的 C 1.10**。两者是不同事件。当前缺少出厂 1.00 对应升级包，不能断言“在 1.10 才切换”，也不能断言每款后续机型从出厂版本起已使用新封装。二进制证据、哈希和来源见 [Z f 封装版本调查](analysis/catalog/ZF_PACKAGING_HISTORY.md)。

固件对照依据见 [全系列分析报告](analysis/catalog/REPORT.md)、[批量分析清单](analysis/catalog/deep_manifest.json)和 [AI 与 DSP 比较报告](analysis/ai_comparison/REPORT.md)。

## 维护方式

- 新增机型时，以尼康正式产品公告补充日期、画幅和处理器，按公告日排序；同日发布不据表内行序推断先后。
- 如补充上市日期，另列地区、日期及官方来源；公告中的“预计上市”保留预计状态，不能自动当作实际上市记录。
- 只有检查过原始固件后才填写对应版本的封装类型；未取得样本时记为“未验证”。保留已有版本证据，避免用单个新版本覆盖整款机型的历史。
- 每次更新标注核验日期；遇到地区日期不一致，保留差异并说明主表采用的来源。本表由后续研究维护，未设置自动更新任务。
