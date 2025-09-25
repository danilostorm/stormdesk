
#!/usr/bin/env bash
set -euo pipefail
REPO="."
MODE="--release"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) REPO="$2"; shift 2 ;;
    --release) MODE="--release"; shift ;;
    --debug) MODE=""; shift ;;
    *) shift ;;
  esac
done
pushd "$REPO" >/dev/null
echo "==> Build StormDesk (macOS)"
rustup default stable
rustup target add x86_64-apple-darwin aarch64-apple-darwin
export RUSTFLAGS="-C target-cpu=native"
cargo build $MODE
mkdir -p dist/macos
cp -a target/release/* dist/macos/ || true
echo "Artefatos em dist/macos"
echo "Assinatura/Notarização: configure 'codesign' e 'notarytool' no CI."
popd >/dev/null
