# 讓 OpenSpec 產出物上架文件站導覽

## Why

這個站台的主角不在架上。`openspec/` 已經透過 junction 掛進 `Book/docs/openspec`，產出物會被 build 成 HTML，但 `Book/docs/.nav.yml` 只列了 `help`，所以 OpenSpec 的 artifact 全部沒有導覽入口 —— 展示櫃存在，展品卻進不去。

同時 `Book/docs/help/.nav.yml` 的 `- *` 是無效 YAML（裸星號是 alias 的起頭），awesome-nav 每次 build 都報 parsing error 並丟棄整個檔案。這讓「build 沒有 WARNING 與 ERROR」這條驗收標準在乾淨狀態下就是紅的，任何後續變更都無法用它把關。

這是**站台機制變更**（導覽行為改變），不是純文件內容變更，因此需要 spec。

## What Changes

- 修正 `Book/docs/help/.nav.yml` 的 `- *` 為 `- "*"`，消除 build 的 parsing error
- 重寫 `Book/docs/.nav.yml`，用 glob 對準 OpenSpec 結構固定的三個路徑（`openspec/specs/*`、`openspec/changes/*`、`openspec/changes/archive/*`），讓現行規格、變更提案與歷史決策自動上架
- 每個 glob 加上 `ignore_no_matches`，讓目錄還是空的時候不產生警告，也不退化成壞連結
- 把 `index.md` 列入導覽，消除 mkdocs 的「頁面存在但未被 nav 收錄」訊息
- 開啟 `flatten_single_child_sections`，收合 `specs/<capability>/spec.md` 這種單一子項的目錄鏈

新增的 change、capability 與歸檔一律由 glob 自動吸收，導覽設定寫完這次之後不再需要維護。這也是這次刻意付出設計成本換來的結果。

## Capabilities

### New Capabilities

- `site-nav`: 文件站導覽的行為 —— 哪些內容出現在導覽、OpenSpec 產出物如何在新增時自動上架、以及導覽設定檔必須是有效且被 awesome-nav 接受的

### Modified Capabilities

無。`openspec/specs/` 目前為空，這是本專案第一個 capability。

## 不做什麼

- 不調整 `mkdocs.print.yml`。列印設定由使用者按當次需求手動調整，沒有規律。
- 不調整 `toc_depth`。維持 3，`#### Scenario` 不進右側目錄是已接受的取捨。
- 不在 `openspec/` 底下放任何 `.nav.yml`。導覽全部從 `Book/docs/.nav.yml` 一處決定。
- 不用 YAML front matter 調整 artifact 在導覽中的順序。字母序（Design、Proposal、規格、Tasks）是已知且接受的。
- 不改動 junction 的範圍或 `openspec_junction.ps1`。
- 不整理 `help/` 的內容本身，這次只修它的導覽設定語法。

## Impact

- `Book/docs/.nav.yml` —— 重寫
- `Book/docs/help/.nav.yml` —— 修正一行語法
- `mkdocs.yml`、`mkdocs.prod.yml`、`Scripts/`、`pyproject.toml` —— 均不變動
- 無新增相依
- 對 pagefind 的影響：導覽入口出現後，OpenSpec 產出物成為站台的正式內容。這個 change 自己的 artifact 就是第一批展品。
