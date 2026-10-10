# Z f 固件新封装的最早可验证版本

后续[全历史采集](../all_history/FINDINGS.md)已补齐 Z f 的八个公开更新版本，均实测为新封装；1.00 仍缺原包。下表样本状态已据此次采集更新。

核验日期：2026-10-05（Asia/Shanghai）。范围：官方发布记录、官方 CDN 原始升级文件、文件头逐字节比较；没有向相机刷写固件。

**已取得并核验 2023-11-16 发布的 Z f C 1.10：它已经采用与本仓库 1.21、3.01 同族的新封装。** 因而此前仅由 1.21 样本建立的时间上界，可以前推至 1.10。1.10 是尼康公开更新履历中最早列出的更新（从 1.00 升至 1.10），但当前没有 1.00 的原始升级包，不能进一步断言“恰好在 1.10 从旧封装切换”。最稳妥的说法是：**至少自首个公开更新 C 1.10 起已采用新封装；出厂 1.00 所对应的升级包格式仍未确认。** [尼康 1.10 下载页](https://downloadcenter.nikonimglib.com/en/download/fw/507.html)、[尼康官方版本及日期记录](https://www.nikon.com.sg/zf-firmware-updates)。

## 版本边界

| 版本 | 官方记录 / 样本状态 | 能得出的封装结论 |
|---|---|---|
| 1.00 | 1.10 官方页面明确列为可升级的原始版本；未找到官方原始升级包 | 不能判断 1.00 包格式；机内固件版本的存在不等于存在公开升级包 |
| **1.10（2023-11-16）** | 本次由官方 CDN 下载 `Z_f_0110_01.bin` | **已实测为新封装家族，最早已核验样本** |
| 1.20 | 后续全历史采集已取得并核验原包 | 新封装，固定头部区域相同 |
| 1.21 | 仓库原有官方样本 `Z_f_0121.bin` | 新封装，与 1.10 的固定头部区域完全相同 |
| 2.00、2.01、2.02、3.00 | 后续全历史采集已逐个取得并核验原包 | 全部为新封装，固定头部区域相同 |
| 3.01（2026-03-31） | 仓库原有官方样本 `Z_f_0301.bin` | 新封装，与 1.10 的固定头部区域完全相同 |

版本序列见[当前尼康下载页](https://downloadcenter.nikonimglib.com/en/download/fw/586.html)；3.01 日期见[产品下载记录](https://downloadcenter.nikonimglib.com/en/products/624/Z_f.html)。

由此也能排除“到 2.00 加入 Nikon Imaging Cloud 才引入这种封装”的时间判断：1.10 的原始包已具备同样的封装特征，早于 2.00。这里没有把云功能或 AI 功能当作封装变更的原因。

## 原始样本和获取链

所有路径均相对 `firmware decode/z-series/`。

| 版本 | 文件 | 字节数 | SHA-256 |
|---|---|---:|---|
| 1.10 | `Z_f_0110_01.bin` | 90,124,933 | `89aeb3bfb4110f21a1a0ee05244296da52824208d916dc2b53b90202e693a03d` |
| 1.21 | `Z_f_0121.bin` | 90,124,933 | `0c6ea7c59659bade5c8ca08d1275451e592b2b87e3482373008e63583ab9deda` |
| 3.01 | `Z_f_0301.bin` | 107,820,261 | `bfc1ef4ec1588ef10c85e06bf1bf5bcaa7456e49bb2b7160dd4043ab8934d1a6` |

1.10 的获取链可独立复核：

1. [官方旧版下载页 fw/507.html](https://downloadcenter.nikonimglib.com/en/download/fw/507.html)的网页缓存记载版本 1.10、支持从 1.00 升级、原始文件名 `Z_f_0110_01.bin`、约 85.95 MB，并保留下载链接。旧网页本次直接 HTTP 请求返回 404；不能将网页缓存误写成旧页当前仍在线。
2. [页面保留的官方 crossgate 下载入口](https://crossgate.nikonimglib.com/dsd_redirect/redirect.do?L=STc7F06&O=5pA4G00&P=FVGG968&R=KRmgA31)本次仍返回 HTTP 302。
3. 跳转到[官方 CDN 上的 1.10 原始 BIN](https://download.nikonimglib.com/archive6/v7Z7l00GsKkB06Lz6BL31fXyzd72/Z_f_0110_01.bin)，HTTP 200，`Content-Length: 90124933`，`Last-Modified: Thu, 16 Nov 2023 00:18:08 GMT`，`ETag: "f80324167a1b4c1e3f9f73b77646d9a6:1700093884.053734"`。下载后的长度与 HTTP 头一致，SHA-256 如上。

1.21 来源：[官方旧页](https://downloadcenter.nikonimglib.com/en/download/fw/545.html)、[官方 BIN](https://download.nikonimglib.com/archive7/n0iDd008ZRGu06fP5t0730yBc323/Z_f_0121.bin)，来源此前已记录于[Z f 既有分析报告](../Z_f_0301/REPORT.md)。3.01 来源：[官方 BIN](https://download.nikonimglib.com/archive8/5iAlW002osm707LL35I60VUlT357/Z_f_0301.bin)，下载元数据见同目录 `manifest.json`。

Windows 下载项 `F-Zf-V110_01W.exe` 是分发用的自解压包装；本次直接获取官方 BIN，没有执行 EXE。判断的是相机读取的 BIN 内部封装，不能把 EXE 与直接 BIN 的分发方式变化混为一谈。[官方 1.10 安装说明](https://downloadcenter.nikonimglib.com/en/download/fw/507.html)。

## 文件头证据

“新封装”在本报告中指本仓库此前识别的 Z f / Z6III / Z5II / ZR 不透明封装家族，**不是尼康公布的格式名称，也不代表已确定加密算法或签名方案**。本次直接比较 1.10、1.21、3.01 的下列字节区域，判定不依赖文件名或功能介绍。

三者的 `0x000–0x01f` 都是：

```text
420601f57f69308eab4d2a4ea3f486e256d93c6d8f165c968e99e4d20a029fb3
```

三者的 `0x120–0x21f` 逐字节相同，其 SHA-256 为：

```text
c0b167b8b9ee0ff4706f4239ee5b18932d9bad71425330cb385c227446d386f4
```

三者均满足 `data[0x220:0x240] == data[:32][::-1]`、`data[0x260:0x280] == b" " * 32`；`0x280–0x28f` 也完全相同：

```text
e14c9918cd6382668a35f65123f14e4f
```

| 比较区域（结束位置不包含） | 长度 | 1.10 ↔ 1.21 不同字节 | 1.10 ↔ 3.01 不同字节 |
|---|---:|---:|---:|
| `0x000:0x020` | 32 | 0 | 0 |
| `0x020:0x120` | 256 | 255 | 256 |
| `0x120:0x220` | 256 | 0 | 0 |
| `0x220:0x240` | 32 | 0 | 0 |
| `0x240:0x260` | 32 | 32 | 32 |
| `0x260:0x280` | 32 | 0 | 0 |
| `0x280:0x290` | 16 | 0 | 0 |
| `0x290:0x330` | 160 | 8 | 23 |

这些结果支持“固定封装结构已经出现在 1.10”；变化区的长度、字节数本身不证明其为 RSA 签名、密钥、模型权重或任何指定密码算法。目录和整个负载仍应分别验证，不能凭文件头相同宣布整包成功解码。

复核命令（在仓库根目录运行，仅用 Python 标准库）：

```bash
python3 - <<'PY'
from pathlib import Path
import hashlib

root = Path('firmware decode/z-series')
names = ['Z_f_0110_01.bin', 'Z_f_0121.bin', 'Z_f_0301.bin']
data = {name: (root / name).read_bytes() for name in names}
regions = [(0, 0x20), (0x20, 0x120), (0x120, 0x220),
           (0x220, 0x240), (0x240, 0x260), (0x260, 0x280),
           (0x280, 0x290), (0x290, 0x330)]
for name, blob in data.items():
    print(name, len(blob), hashlib.sha256(blob).hexdigest())
    print('first32', blob[:32].hex())
    print('reverse', blob[0x220:0x240] == blob[:32][::-1])
    print('spaces', blob[0x260:0x280] == b' ' * 32)
baseline = data[names[0]]
for name in names[1:]:
    print(name, [(hex(lo), hex(hi), sum(a != b for a, b in
                  zip(baseline[lo:hi], data[name][lo:hi])))
                 for lo, hi in regions])
PY
```

## 未解决的边界

本次检索了官方旧页、当前更新履历，以及 `Z_f_0100.bin` / `F-Zf-V100` 等精确文件名，未取得 1.00 官方升级包。这是证据缺口，**不是“1.00 不存在”或“1.00 必定旧封装”的证据**。1.00 出厂机内的 Flash 镜像也不一定含升级文件的外层包装，不能只读取机内固件版本或普通 Flash 镜像就断定公开升级包封装。要证明确切切换点，需要来源可追溯的 1.00 升级包，或能明确描述该外层格式引入时点的尼康构建 / 更新器证据。
