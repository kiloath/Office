# 關於

## 特色
- 使用 Material for MkDocs 美化您的文件。
- 支援 openspec 整合，讓您的 openspec 也能展現優美的文件。
- 支援 Visual Studio Code 的 Tasks。
- 支援 PageFind，讓您不會再找不到資料了。

## 環境
建議安裝方式

- PowerShell
    ```
    winget install -e --id Microsoft.PowerShell --source winget
    ```
- Git:
    ```
    winget install --id Git.Git -e --source winget
    ```
- Visual Studio Code
    ```
    winget install -e --id Microsoft.VisualStudioCode --source winget
    code --install-extension anthropic.claude-code
    code --install-extension openai.chatgpt
    ```
- Python:
    ```
    winget install 9NQ7512CXL7T
    py install --configure
    pip install uv
    ```
- Nodejs:
    ```
    winget install -e --id Schniz.fnm --source winget
    fnm install --lts
    fnm default lts-latest
    npm install -g npm@latest
    corepack enable
    corepack prepare pnpm@latest --activate
    ```

## Visual Studio Code
- "task.allowAutomaticTasks": "on"
- `Ctrl + Shift + P` , `run task`
    1. `openspec: junction`: 自動設定 juncstion , 不需要手動。
    2. `mkdocs: livereload`: 自動執行, 開發模式, 可即時檢視開發中的網站。
    3. `mkdocs: pagefind`: 手動檢視最終發行成品, 採用強大的 pagefind, 代換內建的搜尋功能。
    4. `mkdocs: print`: 列印模式, 將你想要的內容列印成 pdf。
- 本專案使用 pnpm 驅動 pagefind, 非 pnpm 愛好者請自行修改
    1. `Scripts/mkdocs_pagefind.ps1`
    - 純 python 使用者:
        ```
        uv add --dev pagefind[extended]
        uv run mkdocs build
        uv run python -m pagefind --site site
        ```
    - Nodejs npx 愛好者
        ```
        npx -y pagefind --site site --serve
        ```
