# 職能手冊

- 以繁體中文回覆，技術名詞保留英文原文。
- Windows system/global 軟體如果找不到，不要安裝，通知使用者處理。
- 若 Codex 沙箱無法存取或執行 WindowsApps、WinGet Links 或 WinGet Packages 中的既有程式，可申請提升權限後重試；此授權不包含自行安裝、重裝或升級 Windows system/global 軟體。

## shell

- 主 shell 是 PowerShell 7 (pwsh)，‵%localappdata%\Microsoft\WindowsApps\pwsh.exe‵。

## 已安裝的工具
- ripgrep: `winget install BurntSushi.ripgrep.MSVC`

## Python

- Python 環境與 dependency 統一使用 `uv` 管理；允許執行任務所需的 `uv` 指令。
- 不得使用 `uv pip install --system` 或以其他方式修改 system Python。
- 獨立 script 優先使用 PEP 723，正式專案或共用 dependency 使用 `pyproject.toml`。
- 完成後回報新增的 dependency 與安裝位置。

## dependency 安裝

- 允許安裝目前任務需要的 Node.js dependency，但 Node.js 必須由 fnm 管理；不得修改 system Node.js。
- 不得為 dependency 安裝修改 Windows PATH，或使用 WinGet、MSI 等 system installer。
- 安裝目標不明確時先停止並詢問使用者。
- 完成後須回報安裝的 dependency 及其隔離環境。

## Node.js 環境

- Node.js 使用 fnm 安裝與管理。
- Node 由 fnm 管理，所有 node 全域工具都掛在 fnm 底下（openspec CLI 也是）。開新 PowerShell 要先喚醒：
  ```powershell
  $fnmPath = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links\fnm.exe'
  & $fnmPath env --use-on-cd --shell powershell | Out-String | Invoke-Expression
  ```

## UI 自動化測試
- 請以寫成腳本的方式執行測試。