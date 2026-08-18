# 關於
- 製作: [mkdocs](https://www.mkdocs.org/)
- 主題背景: [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)
- 全文檢索: [pagefind](https://pagefind.app/)
- 外掛:
    1. [mkdocs-awesome-nav](https://github.com/lukasgeiter/mkdocs-awesome-nav)
    2. [mkdocs-print-site-plugin](https://github.com/timvink/mkdocs-print-site-plugin)
- Visual Studio Code
    - mkdocs: livereload
        - 開發模式, 會 hotreload, 開啟目錄時就會自動執行。
    - mkdocs: pagefind
        - 正式產品模式。
    - mkdocs: print
        - 列印模式, 會 hotreload。
    - openspec: junction 
        - 自動執行, 基本上不需要手動。 
- OpenSpec
    - `openspec init`
- .gitignore
    - 會排除所有第一層的 .開頭目錄, 所以要手動 add 進版控
    - 例如 claude, `git add .\.claude\ -f`