
param(
  [string]$RepoPath=".",
  [string]$Configuration="Release"
)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Push-Location $RepoPath
Write-Host "==> Build StormDesk (Windows)"
# Pré-requisitos: Visual Studio Build Tools (C++), Rust toolchain, LLVM, vcpkg (opcional)
rustup default stable
rustup target add x86_64-pc-windows-msvc
$env:RUSTFLAGS="-C target-cpu=native"
cargo build --release
# Artefato principal (ajuste conforme estrutura do RustDesk)
New-Item -ItemType Directory -Force -Path dist\windows | Out-Null
Copy-Item -Recurse -Force target\release\*.exe dist\windows\
Write-Host "Artefatos em dist\\windows"
Pop-Location
