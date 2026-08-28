# 目錄架構

本頁是目錄架構與操作權限的**唯一來源**。`openspec/config.yaml` 只留指針指到這裡，不重複內容。

## 上層：專案家族

- 跟本 repo 兄弟目錄都是相關的專案。

## 本 repo

```text
./
├── Book/                    mkdocs 專案根
│   ├── mkdocs.yml           ⛔ 開發站設定
│   ├── mkdocs.prod.yml      ⛔ 正式站設定
│   ├── mkdocs.print.yml     ⛔ 列印站設定
│   ├── overrides/           ⛔ 佈景主題覆寫（注意：在 Book/ 而非 Book/docs/）
│   ├── site/                ⛔ 建置產出（.gitignore 已排除）
│   └── docs/
│       ├── .nav.yml         ⛔ mkdocs-awesome-nav 的導覽定義
│       ├── index.md         首頁
│       ├── MEETINGS/        會議紀錄，檔名 YYYY-MM-DD.md
│       ├── PR/              程式需求＋驗證測試報告
│       ├── TEST/            可重用測試個案、regression suites 與逐次測試報告
│       ├── QA/              問答
│       ├── SPEC/            給人看的規格與使用手冊
│       ├── KM/              🙋 使用者自行維護的筆記，AI 不要寫進去
│       ├── EVIDENCE/        ✅ AI 探測與分析的結果，使用者不干涉
│       │   ├── index.md     收錄清單與寫入規矩
│       │   └── data/        原始探測輸出，檔名帶日期
│       ├── help/            操作說明（本頁、測試計畫）
│       ├── openspec/        ⛔ junction，指向 ../../openspec（.gitignore 已排除）
│       ├── assets/          ⛔ 圖檔與 favicon
│       ├── javascripts/     ⛔ KaTeX 等前端資源
│       └── stylesheets/     ⛔ 自訂 CSS
├── Scripts/
│   ├── *.ps1                ⛔ 第一層的兩支腳本，由 .vscode/tasks.json 呼叫
│   └── uiautomation/        ✅ UI 測試腳本，視案例開發
├── Supporting/              ⛔ LOG／組態／規格文件，只供參考
├── openspec/                OpenSpec 的家
│   ├── config.yaml          專案 context 與規則（指向本頁）
│   ├── specs/               現行規格（行為契約）
│   └── changes/             變更提案；完成後進 changes/archive/
├── .claude/  .agent/  .agents/  .devin/    ✅ 各家 AI agent 的設定，SKILL 四份都要同步
├── .vscode/                 ⛔tasks.json（mkdocs／junction 工作）、settings.json（圖檔儲存設定）
├── CLAUDE.md                指向 AGENTS.md。規則實際住在 openspec/config.yaml 與 AGENTS.md，不需要處理
├── pyproject.toml           mkdocs 工具鏈依賴
├── uv.lock
└── .venv/                   🔧 .gitignore 已排除；只由 Python dependency manager 操作
```

**圖例**（兩張樹狀圖共用）

⛔ = 禁止操作，也不需要檢查　　✅ = AI 需要編寫與執行
🔧 = 只能透過指定的 dependency manager 操作
🙋 = 使用者維護，AI 只讀不寫　　🚫 = 連讀都不要主動讀

## 禁止操作的清單

改任何檔案前先確認不在這張表上。這些由使用者手動維護，AI 一律不動：

| 對象                                                     | 為什麼                                                                               |
| -------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| `Book/mkdocs.yml`、`mkdocs.prod.yml`、`mkdocs.print.yml` | 站台設定由使用者手動調整                                                             |
| `Book/docs/.nav.yml`                                     | 導覽定義由使用者手動調整。**不要改，也不用檢查** —— 新增目錄後不必比對導覽有沒有跟上 |
| `Book/overrides/`                                        | 佈景主題覆寫                                                                         |
| `Book/site/`                                             | 建置產出                                                                             |
| `Book/docs/` 下的 `assets`、`javascripts`、`stylesheets` | 前端資源                                                                             |
| `Book/docs/openspec/`                                    | junction，改它等於改 `openspec/`                                                     |
| `Scripts/` **第一層的檔案**                              | 由 `.vscode/tasks.json` 呼叫。禁改的是**檔案**，不含子目錄 `uiautomation/`           |
| `Supporting/`                                            | 只供參考的證據，不要修改                                                             |

## 受限操作的環境

| 對象                    | 允許操作                                                                        | 禁止操作                                                     |
| ----------------------- | ------------------------------------------------------------------------------- | ------------------------------------------------------------ |
| `.venv/`                | 允許 uv 或 pip 為目前任務建立 virtual environment、安裝及管理 Python dependency | 不直接手改其中檔案、不放入 Git、不修改 system Python         |
| fnm 管理的 Node.js 環境 | 允許安裝目前任務需要的 Node.js dependency                                       | 不修改 system Node.js、Windows PATH，或使用 system installer |

dependency 安裝完成後，AI 必須回報安裝內容與所在的隔離環境；安裝目標不明確時先詢問使用者。

## 各目錄放什麼

### `Book/docs/` —— 給人看的文件

| 目錄        | 放什麼                                                                                                                                                                                                                                                     |
| ----------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `MEETINGS/` | 對話紀錄整理重點後做成的會議紀錄，檔名 `YYYY-MM-DD.md`。收**決議、產出、待辦**，不是逐句回放。首篇：[2026-08-20](../MEETINGS/2026-08-20.md)                                                                                                                |
| `PR/`       | 使用者提出的程式需求，走 `/opsx:propose`。**最後的驗證測試報告要加到原檔案後面，並寫明 openspec 的設計書名稱**                                                                                                                                             |
| `TEST/`     | 可跨需求重跑的 Test Case 定義、regression suite 與逐次測試報告。案例定義不累積執行紀錄；報告以穩定 Test Case ID 引用案例。                                                                                                                                 |
| `QA/`       | 使用者以文件方式提問；**回覆時加到原檔案後面**，不要另開新檔                                                                                                                                                                                               |
| `SPEC/`     | 依開發目的撰寫的規格與使用手冊                                                                                                                                                                                                                             |
| `KM/`       | 🙋 **使用者自行維護的筆記。AI 不要寫進去，也不要改。**                                                                                                                                                                                                     |
| `EVIDENCE/` | ✅ **AI 探測與分析的結果，使用者不干涉。** 從程式碼分析不出來的事實 —— 執行期資料樣貌、靜態分析給不出答案的行為、踩過的坑；以及分析過程中「原本不存在的證據」，例如錄製的電文、原始 dump。收錄清單與寫入規矩見 [`EVIDENCE/index.md`](../EVIDENCE/index.md) |
| `help/`     | 操作說明：本頁、[測試計畫](plan_test.md)                                                                                                                                                                                                                   |

!!! info "`KM/` 與 `EVIDENCE/` 的分界是「誰寫」，不是「寫什麼」"

    兩邊的主題可能重疊 —— 使用者也可能在 `KM/` 記下執行期觀察到的事。
    判準只有一條：**AI 產出的一律進 `EVIDENCE/`，`KM/` 只有使用者能動。**

    這條規則確立前，AI 的探測結果曾誤放在 `KM/`
    （`xqcsc-stock-futures.md` 與 `data/arrFutures-dump-20260814.txt`），
    已於 2026-08-20 搬到 `EVIDENCE/`。

### `Scripts/`

第一層是給 VS Code task 用的兩支腳本（`openspec_junction.ps1` 建立 junction、`mkdocs_pagefind.ps1` 起 pagefind 搜尋站），**不要動**。

`Scripts/uiautomation/` 是 UI 測試腳本，需要編寫與執行，新機器怎麼跑起來見 [測試計畫](plan_test.md)。

### `openspec/`

`openspec/` 透過 `Scripts/openspec_junction.ps1` 建立一個 junction 掛在 `Book/docs/openspec/`，讓 OpenSpec 的內容能被 mkdocs 一起發佈。

```text
openspec/  ──── junction ────▶  Book/docs/openspec/
（來源，可改）                    （連結，⛔ 不要動）
```

### AI agent 設定 —— 四份都要同步

同時啟用多種 AI agent，各自讀自己的目錄。四個目錄結構相同（`skills/<name>/SKILL.md`）：

```text
.claude/skills/<name>/SKILL.md     Claude Code
.agent/skills/<name>/SKILL.md
.agents/skills/<name>/SKILL.md     openspec CLI 的生成目標（.openspec-target = codex）
.devin/skills/<name>/SKILL.md
```

**新增或修改 SKILL 時，四份都要一起改**，不要只動其中一份 —— 每個 agent 只看得到自己那一份，
漏掉哪一個，那個 agent 就少一個 skill。

寫 SKILL 的內容時因此要**與工具無關**：不要假設某家 agent 專有的指令或路徑，
才能四份完全相同、用檔案雜湊就能驗證有沒有同步。

## 已決定

決策記錄，避免同一件事被重新討論。規則本身寫在上面對應的段落，這裡只留結論與出處。

| 日期       | 問題                                              | 結論                                                                                                                                              | 規則在哪                    |
| ---------- | ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------- |
| 2026-08-20 | 可重用 Test Case 與逐次執行結果放哪裡？           | `TEST/cases` 放長期定義、`TEST/suites` 放執行集合、`TEST/reports` 放逐次結果；PR 只保留需求與其驗證摘要／連結                                     | 各目錄放什麼                |
| 2026-08-20 | `KM/` 是使用者維護還是 AI 寫入？                  | 使用者維護，AI 不寫                                                                                                                               | 各目錄放什麼                |
| 2026-08-20 | `EVIDENCE/` 與 `KM/` 的界線？                     | 分界是**誰寫**，不是寫什麼；AI 產出一律進 `EVIDENCE/`                                                                                             | 各目錄放什麼                |
| 2026-08-20 | 新目錄誰加進 `.nav.yml`？                         | 使用者維護。**AI 不改也不檢查**，不必比對導覽是否跟上，也不用回報落差                                                                             | 禁止操作的清單              |
| 2026-08-20 | 自訂 SKILL 要同步到哪幾個 agent 目錄？            | **四個都要**（`.agent`、`.agents`、`.claude`、`.devin`），確認每個 agent 都有自己那一份                                                           | AI agent 設定               |
| 2026-08-20 | 兄弟目錄 `Office/` 與 root `CLAUDE.md` 怎麼看待？ | `Office/` 是遺產，**不要主動查看或引用**，只有使用者明確要求時才去讀。root `CLAUDE.md` 是空檔，規則住在 `openspec/config.yaml` 與本頁，不需要處理 | 上層：KingCon 專案家族      |
| 2026-08-20 | 「`Scripts/` 第一層」指檔案還是目錄？             | 指**檔案**。子目錄 `uiautomation/` 不在禁改範圍，那裡要編寫與執行                                                                                 | 禁止操作的清單              |
| 2026-08-20 | `MEETINGS/` 還要嗎？                              | 要。會議紀錄檔名 `YYYY-MM-DD.md`，首篇為 `2026-08-20.md`                                                                                          | 各目錄放什麼                |
| 2026-08-27 | AI 可以安裝 dependency 嗎？                       | 可以，但 Python 只能使用專案 `.venv` 或 uv 隔離環境／cache，Node.js 必須由 fnm 管理；禁止 system/global 安裝                                      | 受限操作的環境、`AGENTS.md` |

## 待確認

**目前沒有未決的項目。**

日後若發現規則有矛盾或說不清的地方，列在這裡，並且**碰到相關情境時先問，不要自己選一邊**；
有結論後移到上面的「已決定」。
