# 職能手冊

- 以繁體中文回覆，技術名詞保留英文原文。
- 以下軟體如果找不到，不要安裝，通知使用者處理。
- 若 Codex 沙箱無法存取或執行 WindowsApps、WinGet Links 或 WinGet Packages 中的既有程式，可申請提升權限後重試；此授權不包含自行安裝、重裝或升級軟體。

## shell

- 主 shell 是 PowerShell 7 (pwsh)，‵%localappdata%\Microsoft\WindowsApps\pwsh.exe‵。

## 已安裝的工具
- ripgrep: `winget install BurntSushi.ripgrep.MSVC`

## Node.js 環境

- Node.js 使用 fnm 安裝與管理。
- Node 由 fnm 管理，所有 node 全域工具都掛在 fnm 底下（openspec CLI 也是）。開新 PowerShell 要先喚醒：
  ```powershell
  $fnmPath = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links\fnm.exe'
  & $fnmPath env --use-on-cd --shell powershell | Out-String | Invoke-Expression
  ```

## Python 環境
- Python 用 uv。

## 目錄架構與操作權限

- 動手改任何檔案前，先讀 `Book/docs/help/folders.md` —— 那是唯一來源。
