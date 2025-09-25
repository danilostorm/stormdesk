
#!/usr/bin/env bash
set -euo pipefail
REPO="."
APP="StormDesk"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) REPO="$2"; shift 2 ;;
    --app-name) APP="$2"; shift 2 ;;
    *) shift ;;
  esac
done
pushd "$REPO" >/dev/null
echo "==> Aplicando branding '$APP'"
# Substituição simples (confira paths específicos do RustDesk antes de rodar em massa)
grep -rl "RustDesk" . | xargs -I{} sed -i.bak "s/RustDesk/${APP}/g" {}
echo "Lembre-se de trocar ícones (ICO/ICNS/PNG) e nomes de bundles."
popd >/dev/null
