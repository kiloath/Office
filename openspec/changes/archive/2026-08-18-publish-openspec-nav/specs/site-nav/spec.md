# 文件站導覽規格

## Purpose

規範文件站導覽呈現哪些內容，以及 OpenSpec 產出物在新增時如何自動出現在導覽中，讓導覽設定不需要隨著規格與變更的累積而持續維護。

## ADDED Requirements

### Requirement: 導覽設定必須被 awesome-nav 接受

所有 `.nav.yml` 設定檔 MUST 能被 awesome-nav 成功解析。建置過程 MUST NOT 出現 awesome-nav 的 parsing error 或 validation error，因為一個被丟棄的設定檔會讓導覽靜默退回預設行為，且會使「建置無警告」這條驗收標準永久失效。

#### Scenario: 建置時所有導覽設定都被解析

- **WHEN** 在 `Book/` 執行 `uv run mkdocs build -f mkdocs.prod.yml`
- **THEN** 輸出中沒有任何 awesome-nav 的 parsing error 或 validation error

#### Scenario: 通配設定使用有效的 YAML 純量

- **WHEN** 導覽設定需要表達「這個目錄下的其餘項目」
- **THEN** 該項目寫成 YAML 的字串純量，而不是會被解析為 alias 起頭的裸星號

### Requirement: OpenSpec 產出物在導覽中分成三個頂層區段

文件站導覽 MUST 以三個具名的頂層區段呈現 OpenSpec 的產出物：現行規格（來自 `openspec/specs/`）、變更提案（來自 `openspec/changes/` 底下進行中的變更）、歷史決策（來自 `openspec/changes/archive/`）。這三個頂層區段的名稱 MUST 為繁體中文，不得直接曝露 `changes`、`specs`、`archive` 這類工具語彙。

#### Scenario: 進行中的變更出現在變更提案

- **WHEN** `openspec/changes/<name>/` 底下存在 artifact 且已建置
- **THEN** 該變更出現在「變更提案」區段之下

#### Scenario: 已歸檔的變更只出現在歷史決策

- **WHEN** `openspec/changes/archive/<name>/` 底下存在 artifact 且已建置
- **THEN** 該變更出現在「歷史決策」區段之下
- **THEN** 「變更提案」區段中不出現 archive，也不出現任何已歸檔的變更

#### Scenario: 主規格出現在現行規格

- **WHEN** `openspec/specs/<capability>/spec.md` 存在且已建置
- **THEN** 該規格出現在「現行規格」區段之下
- **THEN** 其導覽標題取自該頁面的 H1，而非檔名

### Requirement: 變更的導覽標題取自其目錄名

單一變更在導覽中的標題 MUST 由它的 kebab-case 目錄名產生，繁體中文標題則出現在該變更底下各 artifact 的頁面層級。目錄層沒有 H1 可以取用，而為了替目錄命名而在 `openspec/` 底下補 index.md 會違反「該目錄不放任何導覽用檔案」的約束，因此這是已接受的取捨。

#### Scenario: 變更以其目錄名出現在導覽

- **WHEN** 變更 `publish-openspec-nav` 出現在「變更提案」區段之下
- **THEN** 其導覽標題是該目錄名經 mkdocs 美化後的形式，而非繁體中文標題
- **THEN** 其底下每個 artifact 的導覽標題取自該頁面的繁體中文 H1

### Requirement: 尚無產出物時的區段行為

當 `openspec/specs/` 或 `openspec/changes/archive/` 尚未有任何 Markdown 檔案時，建置 MUST NOT 發出找不到符合項目的警告。對應的頂層區段 MUST 以沒有子項的形式存在，其連結指向站台首頁而不是不存在的路徑，因此 MUST NOT 產生 404。內容出現之後，該區段 MUST 自動填入對應項目而不需要修改導覽設定。

#### Scenario: 空的規格目錄不產生警告

- **WHEN** `openspec/specs/` 底下沒有任何 Markdown 檔案，且執行建置
- **THEN** 輸出中沒有「找不到符合項目」之類的警告

#### Scenario: 空區段不產生失效連結

- **WHEN** 「現行規格」區段尚無任何內容
- **THEN** 該區段在導覽中沒有子項
- **THEN** 該區段的連結指向站台首頁，點擊後不會得到 404

### Requirement: 新增產出物自動上架且不需修改導覽設定

新增的變更、capability 或歸檔 MUST 在下一次建置後自動出現在對應區段。導覽設定檔 MUST NOT 因為新增產出物而需要修改，`openspec/` 目錄底下 MUST NOT 存在任何導覽設定檔。

#### Scenario: 新增變更後無需調整導覽

- **WHEN** 新增一個變更並寫入 artifact，且未修改任何 `.nav.yml`
- **THEN** 建置後該變更出現在「變更提案」區段之下

#### Scenario: openspec 目錄不含導覽設定

- **WHEN** 檢視 `openspec/` 及其所有子目錄
- **THEN** 其中不存在任何 `.nav.yml`

### Requirement: 首頁被導覽收錄

站台首頁 `Book/docs/index.md` MUST 被導覽收錄，使建置不再回報有頁面存在於文件目錄卻未被導覽納入。

#### Scenario: 建置不再回報未收錄頁面

- **WHEN** 執行建置
- **THEN** 輸出中不出現 `index.md` 未被納入導覽的訊息

### Requirement: 單一子項的目錄鏈收合呈現

當一個目錄在導覽中只有單一子項時，該層級 MUST 被收合，避免讀者為了看一份規格而逐層展開重複的目錄名稱。

#### Scenario: 變更底下的單一規格不逐層巢狀

- **WHEN** 某個變更的 `specs/` 底下只有一個 capability，且該 capability 只有一份 `spec.md`
- **THEN** 該規格頁直接出現在該變更之下，不額外產生 `specs` 與 capability 兩層區段
