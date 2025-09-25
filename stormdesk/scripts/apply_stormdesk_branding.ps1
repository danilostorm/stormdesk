
param(
  [string]$RepoPath=".",
  [string]$AppName="StormDesk"
)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Push-Location $RepoPath
Write-Host "==> Aplicando branding '$AppName'"
# Exemplo de substituição de strings nos manifests e UI (ajuste caminhos conforme versão do RustDesk)
$files = Get-ChildItem -Recurse -Include *.rs,*.toml,*.json,*.yml,*.yaml,*.md
foreach ($f in $files) {
  (Get-Content $f.FullName) |
    ForEach-Object { $_ -replace "RustDesk","$AppName" } |
    Set-Content $f.FullName -Encoding UTF8
}
Write-Host "Branding básico aplicado (verifique ícones/splash manualmente)."
Pop-Location
