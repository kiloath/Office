# 上架導覽的任務清單

## 1. 修正導覽設定

- [x] 1.1 把 `Book/docs/help/.nav.yml` 的 `- *` 改成 `- "*"`。驗收：在 `Book/` 執行 `uv run mkdocs build -f mkdocs.prod.yml`，輸出不再出現 awesome-nav 的 parsing error
- [x] 1.2 重寫 `Book/docs/.nav.yml`：根層設 `flatten_single_child_sections: true`，nav 依序為 `index.md`、幫助、現行規格（`openspec/specs/*`）、歷史決策（`openspec/changes/archive/*`）、變更提案（`openspec/changes/*`），三個 glob 都加 `ignore_no_matches`。驗收：同上指令，輸出不再出現 `index.md` 未被納入導覽的訊息，且沒有「找不到符合項目」的警告
- [x] 1.3 確認 `openspec/` 及其子目錄底下沒有任何 `.nav.yml`。驗收：在專案根執行 `Get-ChildItem openspec -Recurse -Force -Filter .nav.yml` 沒有輸出

## 2. 驗證導覽呈現

- [x] 2.1 執行 VS Code 的 `openspec: junction` task，確認 `Book/docs/openspec` 指向專案的 `openspec/`。驗收：`Get-ChildItem Book/docs -Force` 中該項目的 Attributes 含 ReparsePoint，Target 為專案的 openspec 目錄
- [x] 2.2 啟動 `mkdocs: livereload`，確認導覽出現「變更提案」，其下有本變更（導覽標題為目錄名 Publish openspec nav，繁體中文標題出現在其下的 artifact 頁面）。驗收：http://127.0.0.1:8000 的導覽可見該項目
- [x] 2.3 確認本變更之下依序出現 Design、Proposal、文件站導覽規格、Tasks 四個項目。驗收：同一頁面的導覽，且規格頁顯示的是 H1「文件站導覽規格」而非檔名 Spec
- [x] 2.4 確認規格頁沒有多出 `specs` 與 `site-nav` 兩層目錄（收合生效）。驗收：導覽中該規格頁直接位於本變更之下
- [x] 2.5 確認「現行規格」與「歷史決策」兩個區段在尚無內容時沒有子項，且其連結指向站台首頁而不是產生 404。驗收：建置沒有「找不到符合項目」的警告，且點擊該兩個區段會回到首頁

## 3. 收尾

- [x] 3.1 完整建置一次，確認沒有新增的 WARNING 或 ERROR。驗收：在 `Book/` 執行 `uv run mkdocs build -f mkdocs.prod.yml`，除 Material 團隊關於 MkDocs 2.0 的橫幅外輸出乾淨
- [x] 3.2 驗證變更本身。驗收：執行 `openspec validate publish-openspec-nav --strict` 回報 valid
