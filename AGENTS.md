# AGENTS.md

給所有 AI agent 的共用入口。在這個 repo 動手前先讀這一份。

## 環境

- 主 shell 是 PowerShell 7 (pwsh)。
- Node 由 fnm 管理，開新 shell 要先喚醒：
  `fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression`
  所有 node 全域工具都掛在 fnm 底下（openspec CLI 也是），沒喚醒會 command not found。
- 以 pnpm / pnpm dlx 指令優先。
- Python 用 uv。
- 有 Docker, 但我實際是 podman, 沒啟動可執行 `podman machine start`, 但請使用 docker 操作, 不要用 podman 指令。
- podman 架在 WSL 裡, 我有Mount一個虛擬磁碟 `/mnt/wsl/volume/` , 在保存檔案設定 volumes 時, 請指向此目錄以確認資料永存。
- 以上軟體如果不存在**不要自己安裝**，通知使用者處理。

## 溝通

- 以繁體中文回覆，技術名詞保留英文原文。

## 目錄架構與操作權限

- 動手改任何檔案前，先讀 `Book/docs/help/folders.md` —— 那是唯一來源。
