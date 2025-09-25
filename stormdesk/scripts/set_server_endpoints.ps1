
param(
  [string]$RepoPath=".",
  [string]$Broker="broker.stormdesk.cloud",
  [string]$Relay="relay.stormdesk.cloud",
  [string]$Turn="turn.stormdesk.cloud:3478",
  [string]$TurnUser="storm",
  [string]$TurnPass="senhaFort3"
)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Push-Location $RepoPath
Write-Host "==> Ajustando endpoints StormDesk"
# Ajuste os caminhos dos arquivos de config do RustDesk (exemplos)
$targets = @(
  "libs/config/src/defaults.rs",
  "flutter/lib/common/config.dart",
  "flutter/lib/common/consts.dart",
  "flutter/assets/config.json"
)
foreach ($t in $targets) {
  if (Test-Path $t) {
    (Get-Content $t) | % {
      $_ -replace "hbbs.rustdesk.com","$Broker" `
         -replace "hbbr.rustdesk.com","$Relay" `
         -replace "turn.rustdesk.com:3478","$Turn"
    } | Set-Content $t -Encoding UTF8
  }
}
# TURN credenciais em JSON/Dart se existirem
if (Test-Path "flutter/assets/config.json") {
  $json = Get-Content "flutter/assets/config.json" -Raw | ConvertFrom-Json
  $json.turn = @{ server=$Turn; username=$TurnUser; credential=$TurnPass }
  $json | ConvertTo-Json -Depth 5 | Set-Content "flutter/assets/config.json" -Encoding UTF8
}
Write-Host "Endpoints ajustados."
Pop-Location
