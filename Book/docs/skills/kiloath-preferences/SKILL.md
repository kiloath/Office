---
name: kiloath-preferences
description: >-
  套用 Kiloath 的個人溝通、開發技術與環境偏好。當使用者表示「我是 Kiloath」
  （名稱不區分大小寫）、明確要求使用此 skill，或適用的 AGENTS.md 宣告使用者
  是 Kiloath／要求套用其偏好時使用。僅在文件、程式碼或引用中提及姓名不觸發。
---

# Kiloath 個人偏好

## 套用原則

- 將以下偏好用於目前任務相關的選擇；當次明確要求及專案既有約束優先。
- 新專案未指定技術時使用偏好預設；既有專案沿用其 framework、版本與工具，不自行遷移。
- 此 skill 隨 Office 專案保存，不建立全域設定，也不寫入使用者家目錄。
- 不寫死使用者名稱與帳號，家目錄下的路徑改以環境變數表示。磁碟機代號與機器層級的掛載路徑
  **允許**寫入，但必須集中在「Dev Container 開發與測試」的環境事實表中，並註明量測日期與
  重新確認的方式；條文本身只引用項目名稱，不重複寫值。

## 溝通與分析

- 以繁體中文回覆，技術名詞保留英文原文。
- 分析缺少關鍵證據時，明確指出需要的 LOG、程式碼、組態或圖檔；不要將推測當成事實。

## Web 開發

- 新 Web 專案預設使用 SvelteKit 建構前端，採用 CSR，不使用 SSR，並以 Rust Axum 作為 Web Server。

## Python

- Python 開發使用 uv 安裝與管理。
- 獨立 Python 腳本採用 PEP 723 宣告。

## Dev Container 開發與測試

- 新 Web 專案使用 Dev Container 開發，Server 一律以容器執行。
- 底層目前使用 Podman，但能用 Docker CLI 的操作就使用 `docker`／`docker compose`，不改用 `podman`；目的是降低未來切換 Rancher Desktop 的差異。執行前確認 Docker CLI 已連到預期的容器引擎，不假設相容連線已設定。
- Dockerfile、Compose 與專案腳本優先採用可跨容器引擎的設定；只有 Docker CLI 無法完成的底層管理或診斷才使用 Podman 專屬指令。下方環境事實中的 Podman／WSL 資訊是目前環境紀錄，不是未來專案的固定依賴。
- 開始開發或測試前，檢查專案的 `.devcontainer/devcontainer.json` 或 `.devcontainer.json` 與其引用的 Dockerfile／Compose 設定；若使用 Dev Container，優先在對應容器內執行編譯、測試與開發服務。
- 開容器不必開 VS Code：`@devcontainers/cli` 與 VS Code 擴充是同一套 reference implementation，
  `devcontainer up --workspace-folder <dir>` 會照 `devcontainer.json` 跑 `initializeCommand`、
  建 image、套用 mounts／runArgs 再執行 `postCreateCommand`，`devcontainer exec` 可在容器內下指令。
  要驗 `devcontainer.json` 本身是否正確就用它；VS Code 只剩「VS Code Server 起得來、能編輯存檔」需要人工確認。
- `devcontainer.json` 只認得 `${localEnv:...}`，**讀不到專案的 `.env`**。機器設定若放在 `.env`，
  啟動 devcontainer／VS Code 前要另外設好同名環境變數，並在建立容器前的檢查腳本比對兩邊、
  不一致就擋下 —— 否則容器會靜默使用另一組值（例如快取 bind 到別的路徑）。
- 啟動供使用者查看的 Web 服務時，一併建立或確認本機 port 轉送。

### 公司環境的條件式憑證處理

- 當網路有 Fortinet 防火牆置換 HTTPS 憑證時，執行`Scripts/export_crt.ps1`會產生憑證 .crt ，容器需匯入憑證才能存取 HTTPS 服務。

### 環境事實（量測於 2026-09-10）

換機器時整張表要重測；條文只引用「項目」欄的名稱，不重複寫值。

| 項目 | 值 | 量測日期 | 怎麼重新確認 |
| ---- | -- | -------- | ------------ |
| 容器 base image | `mcr.microsoft.com/devcontainers/rust:2-1-trixie` | 2026-09-10 | Dockerfile 第一行 |
| 憑證檔 | `FG4H1FT922900257.crt`，Fortinet root CA，`CN=FG4H1FT922900257`，2025-02-08 ~ 2035-02-09 | 2026-09-10 | `openssl x509 -in <crt> -noout -subject -dates` |
| 歷史憑證來源（非固定依賴） | 兄弟專案 `kiloath-rust/.devcontainer/`；當時工作目錄的憑證是 CRLF（24 個）。新環境以使用者當次匯出為準，未匯出時不沿用此檔 | 2026-09-10 | `git -C ../kiloath-rust ls-files --eol .devcontainer/FG4H1FT922900257.crt` |
| 憑證安裝 | `COPY` 到 `/usr/local/share/ca-certificates/` 後 `update-ca-certificates` | 2026-09-10 | 容器內 `ls /usr/local/share/ca-certificates/` |
| Node 專用信任庫 | `NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt` | 2026-09-10 | 容器內 `echo $NODE_EXTRA_CA_CERTS` |
| 套件管理器憑證設定 | 不需要 —— `npm config get cafile` 與 `proxy` 皆為 `null` 仍可安裝 | 2026-09-10 | 容器內 `npm config get cafile` |
| Node.js | `24.19.0`，官方 tarball 解到 `/usr/local`（不用 devcontainer feature） | 2026-09-10 | 容器內 `node -v` |
| Rust 工具 | `cargo 1.98.0`；`cargo-watch 8.5.3`（`--locked`） | 2026-09-10 | 容器內 `cargo --version` |
| 容器執行環境 | `podman-machine-default`（WSL2 distro），podman 為 **rootful** | 2026-09-10 | `podman info` 的 `rootless` 欄位 |
| 快取 VHD | 掛載於 `/mnt/wsl/volume`，必須是 `ext4` | 2026-09-10 | `wsl -d podman-machine-default -e findmnt -n -o FSTYPE --target /mnt/wsl/volume` |
| VHD 重掛指令 | `wsl --mount --vhd C:\docker_volume\docker_volume.vhdx --name volume` | 2026-09-10 | 上一列失敗時直接執行 |
| 快取目錄 | `/mnt/wsl/volume/<專案>/node_modules` 與 `/mnt/wsl/volume/<專案>/cargo-target` | 2026-09-10 | 容器內 `df -T` 對兩個掛載點顯示 `ext4` |
| 原始碼掛載 | `C:\` 掛在 `/mnt/c`，type `9p`（`aname=drvfs; uid=1000; gid=1000`） | 2026-09-10 | 容器內 `findmnt -t 9p` |
| 檔案監看 | 輪詢，間隔 250 毫秒（vite 為 `watch: { usePolling: true, interval: 250 }`） | 2026-09-10 | 專案的 dev server 設定 |
| git 疊加來源 | `${localEnv:USERPROFILE}/.gitconfig` 以 readonly bind 掛到 `/home/vscode/.gitconfig-windows` | 2026-09-10 | 容器內 `git config user.name` 讀到 Windows 的值 |
| git 覆蓋項 | `http.sslVerify=true`、`core.editor=code --wait`、`init.defaultBranch=main` | 2026-09-10 | 容器內 `git config http.sslVerify` |
| 依 lockfile 安裝 | `npm ci --ignore-scripts --no-audit --no-fund`；`cargo fetch --locked` | 2026-09-10 | Dockerfile 內的安裝步驟 |
| image 內暫存安裝路徑 | `/opt/<專案>/frontend`、`/opt/<專案>/backend`，建立容器時複製到快取目錄 | 2026-09-10 | 容器內 `ls /opt/<專案>` |
| build context | repo root（才能 `COPY` 兩個 lockfile）；`.dockerignore` 排除 `.git`、`node_modules`、`.svelte-kit`、`build`、`target`、`.env*` | 2026-09-10 | `devcontainer.json` 的 `build.context` |
| host port 綁定 | `runArgs` 加 `--publish 127.0.0.1:<port>:<port>`；`forwardPorts` 保留給 IDE | 2026-09-10 | `curl 127.0.0.1:<port>` |
| Windows 端腳本啟動 | `powershell.exe -NoProfile -Command` 內啟動 PowerShell 7 的明確路徑並傳回結束碼。**路徑用正斜線、避免內嵌雙引號**：`& ($env:LOCALAPPDATA + '/Microsoft/WindowsApps/pwsh.exe') -NoProfile -ExecutionPolicy Bypass -File './.devcontainer/preflight.ps1'; if ($null -eq $LASTEXITCODE) { exit 1 }; exit $LASTEXITCODE` | 2026-09-11 | `devcontainer.json` 的 `initializeCommand`；反斜線版本會被吃掉而靜默跳過 |
| 行尾規則 | `* text=auto eol=lf`，另明列 `*.sh`、`Dockerfile`、`*.crt`、`*.pem`；`*.png`、`*.ico`、`*.woff2`、`*.wasm` 為 `binary` | 2026-09-10 | `git ls-files --eol` |
| Node.js 管理 | fnm，**global 套件分版本**：換 Node 版本等於換一套 global CLI，裝過的指令不會跟著走 | 2026-09-11 | `fnm list`，再到各版本的 `installation/` 看有哪些 `.cmd` |
| 非互動 shell 取得 node／global CLI | fnm 的 PATH 靠互動 shell 的 hook 注入，非互動 shell 沒有。先執行 `fnm env --shell powershell \| Out-String \| Invoke-Expression` | 2026-09-11 | 未執行時 `node`、`npm`、`openspec`、`devcontainer` 一起找不到 |
| Dev Container CLI | `@devcontainers/cli` 0.89.0（npm global） | 2026-09-11 | `devcontainer --version` |
| OpenSpec CLI | `@fission-ai/openspec` 1.13.0（npm global） | 2026-09-11 | `openspec --version` |

### 建置與快取的既定作法

- 有提供公司憑證時，依「公司環境的條件式憑證處理」先完成系統與 Node.js 信任設定，再進行需要 HTTPS 的 `apt`／`curl`／`cargo`／`npm` 操作；未提供時跳過公司憑證匯入，使用原有公開 CA 信任庫。（archive 決策 8；依使用者於 2026-09-11 補充改為條件式）
- 套件安裝目錄與編譯產物目錄以 **bind mount**（不是 named volume）指向「快取目錄」，原始碼留在 NTFS。bind 不受 image 重建影響，`--no-cache` 重建後快取仍在。每次建立容器都要把快取目錄擁有者改回容器使用者 —— podman 是 rootful，自動建出的是 `root`；這動作放在建立容器的步驟裡而非一次性手動處理，才能在換機器或重建 VHD 後自動修好。（archive 決策 12）
- 建立容器**之前**先驗「快取 VHD」已掛載且為 `ext4`，不通過就以非零結束碼擋下並印出「VHD 重掛指令」，不建立替代快取目錄。podman 對不存在的 bind 來源會自動建空目錄且不報錯，沒有這道檢查就是靜默失敗。（archive design.md「Risks」第一項）
- 所有 dependency 依 lockfile 在 **image 建置期**安裝，全部寫在 Dockerfile 裡；建立容器後的步驟只做修正擁有者、複製已安裝內容、產生本機型別定義，不對外連網。驗收條件是 `docker build --no-cache` 重建並重開容器後，不做任何手動安裝即可建置成功。（archive 決策 9、archive「試裝結果與固化」）
- 容器內的 git 設定以 `[include]` 引入 Windows 那份，再覆蓋「git 覆蓋項」；身分與編碼設定照舊沿用，不重複設定。Windows 設定檔未掛載時 git 靜默忽略缺失的引入來源，只留覆蓋項，不會失敗。（archive 決策 10）

### NTFS 與 9p 的已知限制

- **檔案監看一律用輪詢**，不依賴 inotify。原生監看在 9p 上從 Windows 端與容器內寫入皆無事件；改輪詢後兩端皆更新且不重整。（`hmr-native.json`、`hmr-polling.json`、`hmr-atomic.json`、`hmr-inplace-recheck.json`、`hmr-vscode-windows.json`、`hmr-vscode-devcontainer.json`）「寫入來源 × 寫入方式」四格已測滿，編輯器存檔不構成第五種寫法，**不必再測、也不做條件判斷**。
- **行尾**：新 repo 的第一個 commit 就要有 `.gitattributes`（內容見「行尾規則」）。bind mount 逐位元組傳遞，checkout 時轉出的 CRLF 會原封不動送進容器執行；事後才加要另跑 `git add --renormalize .`。**執行權限位元**：NTFS 存不了 `+x`，Windows 端建立的 `.sh` 在容器內是 `644` —— 盡量不新增 `.sh`，能用套件管理器的 script 欄位或建置工具子命令表達的就不開腳本檔；只在 Windows 端執行、不進容器的 `.ps1` 不受此限。（archive 決策 11）
- **單檔 bind mount 的 inode 陷阱**：git 寫設定檔是「寫暫存檔 + rename」，會產生新 inode。在 Windows 端改完 `.gitconfig` 後，容器裡看到的還是舊內容，**必須重建容器**才生效。（archive design.md「Risks」第三項）
- **Windows App Alias 無法被 Dev Container CLI 解析**：建立容器前執行的腳本不能直接把 `pwsh` 當可執行檔，要用系統內建的 `powershell.exe` 啟動 PowerShell 7 的明確路徑並回傳結束碼（見「Windows 端腳本啟動」）。（archive「試裝結果與固化」）
- **`initializeCommand` 的路徑一律用正斜線，結束碼要保底**：該字串在送到 `powershell.exe` 之前會再被拆解一次，
  `\X` 會連同反斜線一起被吃掉（`\.devcontainer\preflight.ps1` → `devcontainerreflight.ps1`），腳本直接被跳過；
  而 PowerShell 自己的解析錯誤**不會**設定 `$LASTEXITCODE`，`exit $LASTEXITCODE` 因此回 0，
  建立流程會當成檢查通過而繼續。所以路徑用 `/`，並在 `$LASTEXITCODE` 為 `$null` 時 `exit 1`。
  （2026-09-11 以 `devcontainer up` 實測；只用 Docker CLI 手動重現 mounts 看不出來）

## UI 自動化測試

- 將 UI 自動化測試寫成可重跑的腳本，保留操作步驟與必要的驗證結果。
- 在 Office 專案中，依 Book/docs/help/folders.md 的規範存放測試腳本與結果。

## Office 專案整合

- 整體 workspace 以 `Office/` 的上一層 `../` 為工作範圍；`Office/` 與實際開發的程式專案是平行的兄弟目錄，不把 `Office/` 視為程式碼根目錄。
- `Office/` 集中保存文件、規格、分析與測試報告，依 `Book/docs/help/folders.md` 分類存放，避免將協作文件混入程式碼 repo；實際程式碼在對應的兄弟專案中讀取與修改。
- `Office/` 與各兄弟程式專案各有獨立的 Git repo；執行 Git 操作前確認目標 repo，分別管理各自的變更。
- `Office/` 以外的程式專案使用 Git Flow 管理分支；`Office/` 維持原有方式，不套用 Git Flow。
- 程式專案需要初始化 Git Flow 時，執行 `git flow init -d` 採用預設設定；已初始化的 repo 沿用既有 Git Flow 設定。
- 整體工作範圍不代表環境已授予所有目錄的寫入權限；修改兄弟專案時，仍須遵循該專案規則及目前環境的存取權限。
- 修改檔案前，閱讀專案的 AGENTS.md 與 Book/docs/help/folders.md，遵循目錄權限及產物位置。
- 調整 `Book/docs/skills/` 下的任何 skill 時，須同步至各 AI agent 的對應 skills 目錄：`.agent/skills/`、`.agents/skills/`、`.claude/skills/`、`.devin/skills/`，確保內容一致。
- 保持指令與 agent 廠牌無關，不依賴個別電腦的全域 skill。
- `Office/` 不主動 commit 或 push。兄弟程式專案的 commit 與分支依「Git Flow 分支流程」執行；目前兄弟專案皆無 remote，不主動 push。切換 branch 失敗時交由使用者處理。

## Git Flow 分支流程

適用於 `Office/` 以外的兄弟程式專案。本機安裝的是 git-flow-next 2.0.0，config schema 為 `gitflow.branch.<type>.*`，與 nvie／AVH 版本的旗標和設定鍵不同，不要套用其他版本的用法。

- 一個 openspec change 對應一條 `feature/<change-name>`，以 `git flow feature start` 建立。
- `develop` 只由 `git flow feature finish` 前進；唯一例外是 repo 初始化的第一個 commit（例如 `.gitattributes` 必須是第一筆，否則換行正規化會失效）。
- feature 分支 finish 前不設限制，commit 訊息與粒度都自由。
- finish 時機：change 的 tasks 全數完成並驗證通過後才 finish，之後才 archive change。finish 預設會刪除 feature 分支，過早 finish 會讓後續補救無處可去。
- finish 前整理該分支：訊息不符 `<type>: <繁體中文說明>` 的 commit 視為存檔點，squash 進前一筆符合規範的 commit；沒有可併入目標時，補寫合規訊息保留該筆。本環境不支援 `git rebase -i`，以非互動方式重演（soft reset 或逐筆重放 tree）。
- commit 訊息用 `<type>: <繁體中文說明>`，type 用英文（feat / fix / chore / docs / test / refactor），說明用繁體中文、技術名詞保留原文。
- finish 不加 `--ff`，保留 merge commit 作為 change 的邊界。
- finish 遇衝突時執行 `git flow feature finish --abort` 回到原狀，交由使用者處理。
- 規則生效前既有的 commit 不追溯調整。
