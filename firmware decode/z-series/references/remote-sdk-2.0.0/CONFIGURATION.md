# Remote SDK 配置文件阅读指南

来源为包内 `Module/Win/BinaryFile/` 下的三个配置文件，原件位于本目录 [original/Module/Win/BinaryFile](original/Module/Win/BinaryFile)。这些文件描述电脑端 SDK 如何组织和转换相机功能，不能直接当作机内配置或硬件规格。

## 三层配置

| 文件 | 原文结构与可读取信息 | 索引 |
| --- | --- | --- |
| `MaidLayer.config` | `<model:…>`、`<version>…</version>` 内的 capability；名称、数字 ID、操作字段、观察者依赖及 DeviceCommand | [8,373 条功能记录](indexes/maid_capabilities.csv) |
| `DC_PTP_Config.config` | 机型与 versionInfo 分组下的 usPropSel 和 PropConv；保存设备属性相关选择器及数值转换 | [12,278 条属性选择器记录](indexes/ptp_property_mappings.csv) |
| `RangeValue.config` | 机型内再分 `<version:…>`；保存 capability 的枚举、范围和默认值 | [4,767 条取值记录](indexes/range_values.csv) |

三个文件的 `ProfileVersion` 均为 `9.0.3000`，`AppCompatibilityVersion` 均为 `5`；这些是配置元数据，不能写成相机固件版本。三个文件分别有 38、39、23 个 model 块，共 100 块；同一机型可能重复出现，不是 100 款机型。

语法外观接近 XML，但存在 `<model:Z f>`、`<usPropSel:293,118789,…>`、`<value:enum>…</value>` 之类自定义标签，不能直接假定标准 XML 解析器会接受。本次生成器按实测的 model／version／capability 边界提取，保留原始字段，不尝试重新解释整个配置语言。

## 编号与操作字段

以照片主体检测为例：

| 所属层 | 编号或名称 | 证据 |
| --- | --- | --- |
| MAID capability | `kNkMAIDCapability_AFSubjectDetection`，十进制 `34118`，十六进制 `0x8546` | `MaidLayer.config`／`RangeValue.config` 和 `Maid3d1.h` |
| 相机协议属性 | `AFSubjectDetection`，`0x0001D005` | Z f PDF 第 302 页、Z8 PDF 第 285 页 |
| 配置内部映射 | Z f `1.0` 块中该 capability 的 `DeviceCommand` 为 `219,0,0,0,0`；另有头为 `293,118789,…` 的 usPropSel | 保留为原始映射字段，未确认它们之间的完整转换流程 |

`118789` 等于 `0x1D005`，但不能因此把 capability ID、usPropSel 第一项、DeviceCommand 第一项和协议属性码混成同一命名空间。解释映射时需结合 SDK 代码／文档和实际调用。

[Maid3.h](original/Module/Win/HeaderFile/Maid3.h) 定义 capability 操作位：Start=`0x01`、Get=`0x02`、Set=`0x04`、GetArray=`0x08`、GetDefault=`0x10`。配置中 `allowedoperation:14` 的位值与 Get、Set、GetArray 相符；这不表示真机在任意模式都允许这些操作。设备能力查询、状态变化及协议错误条件仍需检查。

## 版本和继承边界

配置含 `common`、`Default`、`DC`、`FU1`、`FU2`、`Type0023`、`DemoZ f`、`DEMO95` 等标签，也包含 `Z f` 的 `1.0`／`2.0`／`3.0`、`Z 8` 的 `common`／`2.0`／`3.0`／`4.0`／`5.0` 等块。

- 版本标签按原文保存。未验证选择逻辑之前，不将 `1.0` 自动等同于相机固件 `1.00`，也不据更高数字宣布存在对应公开固件。
- 不猜测 `Type…`、`Demo…` 或 `DEMO95` 与正式机型的对应关系。
- 本次 CSV 没有展开通用块继承、型号回退和运行时条件。一块内未列出某功能，不足以判定该机型没有此功能。
- 记录数包含版本重复、覆盖及声明；不能用于给相机功能数量排名。
- RangeValue 的缺项或枚举限制是 SDK 配置证据，不直接证明硬件能力上限，也不证明修改配置就能让相机接受额外值。

## 索引字段与回查

所有配置 CSV 保留 `file`、`model_block`、`model_label` 和原始文件 `line`。`model_block` 是该文件内从 1 开始的块序号。版本字段不做数值归一化。

`maid_capabilities.csv` 保留 capability 名称和 ID、description、allowedoperation、DeviceCommand。观察者及其他依赖未扁平化到 CSV，应回查原文件。`ptp_property_mappings.csv` 保留完整选择器头部与 PropConv，未为未知数字列编造含义。`range_values.csv` 保留 `enum:`／`range:` 等类型前缀及原始取值顺序。

例如在本参考目录查出 Z f 的主体检测取值：

```sh
python3 - <<'PY'
import csv
with open('indexes/range_values.csv', newline='') as f:
    for row in csv.DictReader(f):
        if row['model_label'] == 'Z f' and row['capability'] == 'kNkMAIDCapability_AFSubjectDetection':
            print(row['version_label'], row['values_raw'], row['defaults_raw'], 'line', row['line'])
PY
```

这些索引用于检索和提出待验证的差异。得到结论时应同时记录原文位置、配置作用域、对应机型协议页码和真机验证状态。
