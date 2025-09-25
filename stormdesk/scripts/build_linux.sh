
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
echo "==> Build StormDesk (Linux)"
rustup default stable
rustup target add x86_64-unknown-linux-gnu
export RUSTFLAGS="-C target-cpu=native"
cargo build $MODE
mkdir -p dist/linux
cp -a target/release/* dist/linux/ || true
echo "Artefatos em dist/linux"
popd >/dev/null
