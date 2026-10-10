# Nikon Remote SDK 2.0.0 参考资料

整理日期：2026-10-05。来源为用户提供的 [S-SDKZ-200BF-ALLIN.zip](../../S-SDKZ-200BF-ALLIN.zip)，用于 Z 系列功能比较、USB／MTP 协议分析和固件处理函数定位。它是电脑端遥控 SDK；本次整理没有运行 SDK 程序、加载库或连接相机。

资料包含 **15 款机型的协议文档、3 份公共说明，共 18 份 PDF、8,423 页**。已生成带页码的协议编号索引，并将三个配置文件整理为保留机型和版本作用域的 CSV。提取后的原文保留在本地，便于核对；不把配置声明当成相机运行结果。

| 查找目标 | 入口 |
| --- | --- |
| 某款机型的协议 PDF、封面修订号和全文 | [协议文档索引](PROTOCOLS.md) |
| 配置文件结构、编号区别、版本标签及使用限制 | [配置文件阅读指南](CONFIGURATION.md) |
| 主体检测的协议编号、SDK 枚举和配置差异实例 | [主体检测对照](SUBJECT_DETECTION.md) |
| Operation／Property／Event／Response Code 的定义位置 | [协议编号定位 CSV](indexes/protocol_code_locations.csv) |
| MAID 功能定义及原始操作映射 | [MAID 功能 CSV](indexes/maid_capabilities.csv) |
| 属性转换表 | [PTP 属性映射 CSV](indexes/ptp_property_mappings.csv) |
| 枚举、范围及默认值 | [属性取值 CSV](indexes/range_values.csv) |
| 原始机型标签及各配置块规模 | [配置作用域 CSV](indexes/model_blocks.csv) |
| ZIP 内所有成员的路径、大小、CRC 和 SHA-256 | [来源与产物清单](manifest.json) |

## 原始包与整理范围

ZIP 大小为 **88,048,129 字节**，SHA-256：

```text
d8ff7b10061c3a69ba11c66e2d2cca058b88efd01de346d9152ff34b5202f3fb
```

完整清点了 94 个 ZIP 条目（含目录），读取文件时验证 ZIP CRC，并计算文件 SHA-256。选取 39 个文档、配置、头文件及示例源码到 `original/`，保持 ZIP 内路径。SDK 可执行文件、DLL、Mac 示例程序 ZIP 和工程用户状态文件只登记清单，没有解出或执行。

`original/ReadMe_En.txt` 自述这是 Remote SDK v2.0.0，支持 Z9、Z8、Z6III、Z7II、Z6II、Z7、Z6、Z5II、Z5、Z f、Z50II、Z50、Z30、Z fc、ZR。这里只固定本地包的身份，没有另行核对官方网站下载哈希。

| 原始位置 | 内容与用途 |
| --- | --- |
| `Command/English/` | 逐机型 USB Still Image Capture Device MTP Specifications，包含命令、属性、事件、操作顺序及错误条件 |
| `Module/Document/English/MAID3(E).pdf` | MAID 基础接口说明 |
| `Module/Document/English/MAID3-COMMON(E).pdf` | 公共／扩展接口，含 InitializeSDK、ConnectDevice、EnumCapabilities、GetCapability 等 |
| `Module/Document/English/Sample App Guide(E).pdf` | 示例应用操作指南 |
| `Module/Win/HeaderFile/`、`Module/Mac/HeaderFile/` | 平台头文件、类型与功能枚举；分别保留，不假定内容相同 |
| `Module/Win/SampleApp/`、`Module/Mac/SampleApp/` | 提取 `main.cpp` 和 `Function.cpp`，供阅读调用流程 |
| `Module/Win/BinaryFile/*.config` | MAID 功能、设备属性转换及取值配置 |

根据包内 ReadMe，电脑端运行环境为 Windows 11 64 位及所列 macOS 版本；Windows 另需 Visual C++ 2022 运行库。三个配置文件按原说明部署到 Nikon/NXTether 配置目录。当前 SDK 模块注明不能同时控制两台或更多相机，并要求避免与 NX Tether 等程序同时占用相机。完整操作条件以[原始 ReadMe](original/ReadMe_En.txt)为准，本次没有执行安装或改变用户配置。

## 如何用于当前逆向

1. 先在具体机型 PDF 中确认某功能的属性码、数据类型、取值、Get／Set 能力和模式条件。
2. 再读取配置与头文件，区分 SDK capability ID、设备属性码、操作码和配置内部索引。
3. 在已解包固件中寻找相应常量、分发表和引用，追踪参数检查及处理函数；单个数值命中不足以确认函数用途。
4. 若后续接入真机，查询实际设备支持列表和属性描述，记录机型、固件版本及运行模式，验证静态配置解释。

这套资料能给功能比较提供明确编号和取值依据，也能支持开发联机工具。它没有直接建立“协议属性到 AI 网络权重”的关系，本次亦未在 SDK 中确认新固件封装的解码算法、密钥或完整更新认证链。

## 搜索与复现

在仓库根目录执行，需 Python 3 和 Poppler 的 `pdftotext`：

```sh
python3 'firmware decode/z-series/references/remote-sdk-2.0.0/build_reference.py'
```

生成器只接受上述 SHA-256 的 ZIP，更新本目录的派生资料，保留原始 ZIP。对另一版本 SDK，应另建目录并重新核对格式；不要改掉哈希后直接覆盖当前参考。

在本参考目录内可执行：

```sh
rg -n 'AFSubjectDetection|GetLiveViewImage|PixelShift' text/Command/English
rg -n 'AFSubjectDetection' indexes/maid_capabilities.csv indexes/range_values.csv
rg -n '0x0001D005' indexes/protocol_code_locations.csv
```

PDF 全文保持分页符 `\f`，可用下列方式取第 302 页，与原始 PDF 对照：

```sh
python3 - <<'PY'
from pathlib import Path
pages = Path('text/Command/English/ZfUsbMtpE_02.txt').read_text().split('\f')
print(pages[301])
PY
```

`original/`、`text/` 和 `indexes/` 是可重建的本地产物，本目录 `.gitignore` 已排除；本指南、专题说明、协议目录、来源清单及生成脚本可纳入版本管理。PDF 文本抽取可能损失图表布局，表格列意义、条件和编号应以原始 PDF 为准。
