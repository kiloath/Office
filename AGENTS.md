# 職能手冊

- 以繁體中文回覆，技術名詞保留英文原文。
- Windows system/global 軟體如果找不到，不要安裝，通知使用者處理。
- 若 Codex 沙箱無法存取或執行 WindowsApps、WinGet Links 或 WinGet Packages 中的既有程式，可申請提升權限後重試；此授權不包含自行安裝、重裝或升級 Windows system/global 軟體。

## shell

- 主 shell 是 PowerShell 7 (pwsh)，‵%localappdata%\Microsoft\WindowsApps\pwsh.exe‵。

## 已安裝的工具
- ripgrep: `winget install BurntSushi.ripgrep.MSVC`

## Python 環境
- Python 用 uv。

## dependency 安裝

- 允許安裝目前任務需要的 Python dependency，但只能安裝至專案 `.venv`，或 uv 建立的隔離環境／cache；不得修改 system Python。
- 允許安裝目前任務需要的 Node.js dependency，但 Node.js 必須由 fnm 管理；不得修改 system Node.js。
- 不得為 dependency 安裝修改 Windows PATH，或使用 WinGet、MSI 等 system installer。
- 安裝目標不明確時先停止並詢問使用者。
- 完成後須回報安裝的 dependency 及其隔離環境。

## Python script dependency 風格

- 可獨立執行、具有專屬 dependency 的 Python script，優先使用 PEP 723 inline script metadata，並以 `uv run <script>` 執行。
- `Scripts/uiautomation/` 的 executable entry point 採用 PEP 723；被 import 的內部 modules 不重複宣告 metadata。
- UI automation 等需要可重現環境的 script，其 direct dependency 應固定版本。
- 多個程式共用的 dependency、Python package 或正式 application dependency，仍應放在 `pyproject.toml`，不使用 PEP 723。
- 不得在 PEP 723 與 `pyproject.toml` 重複宣告同一用途的 dependency，除非文件明確說明原因。

## Node.js 環境

- Node.js 使用 fnm 安裝與管理。
- Node 由 fnm 管理，所有 node 全域工具都掛在 fnm 底下（openspec CLI 也是）。開新 PowerShell 要先喚醒：
  ```powershell
  $fnmPath = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links\fnm.exe'
  & $fnmPath env --use-on-cd --shell powershell | Out-String | Invoke-Expression
  ```
