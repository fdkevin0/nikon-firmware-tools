# Python Toolchain Normalization & uv Runtime Guide

This project adopts the modern **PEP 621 / PEP 735** (`pyproject.toml`) standard for dependency and environment management, and strongly recommends [`uv`](https://docs.astral.sh/uv/) as the primary Python package and project runtime.

---

## Why uv?

1. **Extreme Performance**: Built in Rust by Astral, dependency resolution and installation are 10-100x faster than legacy `pip` and `poetry`.
2. **Zero-Configuration Isolated Execution**: Running scripts via `uv run <command>` automatically creates and uses an isolated virtual environment without manual activation (`source .venv/bin/activate`).
3. **One-Command Environment Setup**: The reverse engineering toolchain utilizes `capstone` (AArch64 disassembly), `pycryptodome` (cipher stream probes), and `unicorn` (CPU emulation). `uv sync` installs all required packages in seconds, enabling all 51 test suites out of the box.
4. **Reproducible Determinism**: Paired with `uv.lock`, all direct and transitive dependencies are pinned for bit-identical execution across Linux, macOS, and Windows.

---

## Getting Started

### 1. Install uv

- **Linux / macOS**:
  ```sh
  curl -LsSf https://astral.sh/uv/install.sh | sh
  # Or via Homebrew:
  # brew install uv
  ```
- **Windows (PowerShell)**:
  ```powershell
  powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
  ```

Verify installation:
```sh
uv --version
```

---

### 2. Synchronize Project Dependencies

From the repository root, run:

```sh
# Automatically creates .venv and installs all dependencies (capstone, pycryptodome, unicorn, pytest, ruff)
uv sync
```

---

### 3. Run Tests & Linting

```sh
# Run all 51 test suites
uv run pytest

# Check code formatting and linting
uv run ruff check "firmware decode/z-series/tools"

# Format Python scripts
uv run ruff format "firmware decode/z-series/tools"
```

---

### 4. Running Reverse Engineering Scripts

Use `uv run` to execute any script in the repository:

#### Example A: From the repository root
```sh
# Unpack a Z6 firmware image
uv run "firmware decode/z-series/tools/analyze_firmware.py" "firmware decode/z-series/Z_6_0380.bin" --output /tmp/z6_output

# Check Z8 QEMU bootstrap device contracts
uv run "firmware decode/z-series/tools/check_z8_qemu_devices.py" --output /tmp/z8-check
```

#### Example B: From `firmware decode/z-series`
`uv` automatically traverses parent directories to discover the root `pyproject.toml` and `.venv`:

```sh
cd "firmware decode/z-series"

# Discover historical releases
uv run tools/discover_z_history.py

# Collect and compare all history
uv run tools/collect_all_z_history.py .
uv run tools/compare_all_z_history.py .

# Run single test suite
uv run tools/test_analyze_firmware.py
```

---

## Python Codebase Normalization Summary

1. **UTF-8 Clean (No BOM)**: Stripped historical Windows UTF-8 BOM bytes (`\xef\xbb\xbf`) from IDA scripts (`IDA_files/*/rtti.py`) to ensure clean AST parsing.
2. **Python 3 Modernization**: Converted legacy Python 2 `print "..."` statements in IDA Python scripts into `print(...)`, compatible with modern IDA Pro 7.x/8.x/9.x and Python 3.
3. **Shebangs & Permissions**: Standardized `#!/usr/bin/env python3` and granted `chmod +x` executable permissions across all CLI and test tools.
4. **Imports & Code Style**: Cleaned unused imports, sorted import blocks with Ruff, and refactored lambda variable assignments into standard `def` functions per PEP 8.
