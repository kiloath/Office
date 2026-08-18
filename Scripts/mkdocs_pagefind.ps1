$BookPath = Resolve-Path (Join-Path $PSScriptRoot '..\Book')
uv run mkdocs build -f (Join-Path $BookPath 'mkdocs.prod.yml')
pnpm dlx pagefind --site (Join-Path $BookPath 'site') --serve
