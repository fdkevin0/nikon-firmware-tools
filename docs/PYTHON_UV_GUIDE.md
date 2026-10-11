# Python 脚本规范化与 uv 运行时使用指南

[English](#english) | 中文说明

本项目已全面规范化 Python 脚本标准，统一基于 **PEP 621 / PEP 735**（`pyproject.toml`）进行依赖与环境管理，并**强烈推荐使用现代极速包与虚拟环境管理工具 [`uv`](https://docs.astral.sh/uv/)** 作为默认运行时。

---

## 为什么推荐使用 uv？

1. **极速体验**：由 Astral（Ruff 团队）使用 Rust 开发，依赖解析与安装速度比传统 `pip` / `poetry` 快 10~100 倍。
2. **免手动激活虚拟环境**：使用 `uv run <命令>` 即可自动在隔离环境中执行 Python 脚本，彻底杜绝全局环境污染与依赖版本冲突。
3. **零门槛依赖补全**：本项目的逆向工具链涉及 `capstone`（AArch64 反汇编）、`pycryptodome`（固件流分析）与 `unicorn`（CPU 仿真）。使用 `uv sync` 可在数秒内一键补齐所有环境，直接跑通所有 51 项单元测试。
4. **确定性重现**：配合 `uv.lock` 锁定所有间接依赖的版本，确保跨平台（Linux / macOS / Windows）运行结果逐字节一致。

---

## 快速上手

### 1. 安装 uv

- **Linux / macOS**:
  ```sh
  curl -LsSf https://astral.sh/uv/install.sh | sh
  # 或者通过 Homebrew:
  # brew install uv
  ```
- **Windows (PowerShell)**:
  ```powershell
  powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
  ```

验证安装：
```sh
uv --version
```

---

### 2. 同步项目虚拟环境与依赖

在仓库根目录执行：

```sh
# 自动创建 .venv 并安装所有逆向分析与测试依赖 (capstone, pycryptodome, unicorn, pytest, ruff)
uv sync
```

---

### 3. 执行测试与自动化校验

```sh
# 运行全部 51 项测试
uv run pytest

# 执行代码风格与语法检查
uv run ruff check "firmware decode/z-series/tools"

# 格式化 Python 脚本
uv run ruff format "firmware decode/z-series/tools"
```

---

### 4. 运行逆向与分析脚本

使用 `uv run` 可以直接执行项目内任何脚本，无需手动 `source .venv/bin/activate`：

#### 示例 A：从根目录运行
```sh
# 解包 Z6 固件
uv run "firmware decode/z-series/tools/analyze_firmware.py" "firmware decode/z-series/Z_6_0380.bin" --output /tmp/z6_output

# 运行 Z8 QEMU 引导设备校验
uv run "firmware decode/z-series/tools/check_z8_qemu_devices.py" --output /tmp/z8-check
```

#### 示例 B：进入 `firmware decode/z-series` 目录运行
`uv` 会自动向上查找根目录的配置与虚拟环境：

```sh
cd "firmware decode/z-series"

# 发现历史固件
uv run tools/discover_z_history.py

# 批量采集并比较
uv run tools/collect_all_z_history.py .
uv run tools/compare_all_z_history.py .

# 单独执行单元测试
uv run tools/test_analyze_firmware.py
```

---

## 代码规范化成果说明

1. **UTF-8 无 BOM 规范**：已去除所有脚本（如 `IDA_files/*/rtti.py`）中的 Windows UTF-8 BOM（`\xef\xbb\xbf`），确保 Python AST 干净解析。
2. **Python 3 兼容性**：历史 IDA Python 脚本中的 `print "..."` 已全部现代化改造为 `print(...)`，兼容现代 IDA Pro 7.x/8.x/9.x 的 Python 3 环境。
3. **Shebang 与执行权限**：所有 CLI 脚本与测试套件均已标注 `#!/usr/bin/env python3` 并设置了可执行权限（`chmod +x`）。
4. **导入与代码风格**：经过 `ruff` 全面整理，规范导入顺序，移除无效导入，并将 lambda 赋值规范化为 `def` 函数声明。

---

<a name="english"></a>
## English: Python Normalization & uv Guide

This project adopts modern **PEP 621 / PEP 735** (`pyproject.toml`) standard and strongly recommends **[`uv`](https://docs.astral.sh/uv/)** as the primary runtime.

### Quick Commands
```sh
# 1. Sync environment and install all dependencies (capstone, pycryptodome, unicorn, pytest, ruff)
uv sync

# 2. Run all 51 test suites
uv run pytest

# 3. Execute any tool with isolated dependencies
uv run "firmware decode/z-series/tools/analyze_firmware.py" <firmware.bin> --output <dir>
```
