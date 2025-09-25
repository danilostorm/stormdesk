
#!/usr/bin/env bash
set -euo pipefail
APP_NAME="StormDesk"
APP_BIN="../dist/macos/stormdesk"
OUT_DIR="../dist/installer"
mkdir -p "$OUT_DIR"
# Empacotamento simples (substitua por app bundle completo conforme sua UI/toolkit)
hdiutil create -volname "$APP_NAME" -srcfolder "$(dirname "$APP_BIN")" -ov -format UDZO "$OUT_DIR/${APP_NAME}.dmg"
echo "DMG gerado em $OUT_DIR"
