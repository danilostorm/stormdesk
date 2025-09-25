
    #!/usr/bin/env bash
    set -euo pipefail
    REPO="."
    BROKER="broker.stormdesk.cloud"
    RELAY="relay.stormdesk.cloud"
    TURN="turn.stormdesk.cloud:3478"
    TURN_USER="storm"
    TURN_PASS="senhaFort3"
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --repo) REPO="$2"; shift 2 ;;
        --broker) BROKER="$2"; shift 2 ;;
        --relay) RELAY="$2"; shift 2 ;;
        --turn) TURN="$2"; shift 2 ;;
        --turn-user) TURN_USER="$2"; shift 2 ;;
        --turn-pass) TURN_PASS="$2"; shift 2 ;;
        *) shift ;;
      esac
    done
    pushd "$REPO" >/dev/null
    echo "==> Ajustando endpoints StormDesk"
    for f in libs/config/src/defaults.rs flutter/lib/common/config.dart flutter/lib/common/consts.dart flutter/assets/config.json; do
      if [[ -f "$f" ]]; then
        sed -i.bak "s/hbbs.rustdesk.com/${BROKER}/g; s/hbbr.rustdesk.com/${RELAY}/g; s/turn.rustdesk.com:3478/${TURN}/g" "$f" || true
      fi
    done
    if [[ -f "flutter/assets/config.json" ]]; then
      python3 - <<PY
import json
p = "flutter/assets/config.json"
j = json.load(open(p,"r",encoding="utf-8"))
j["turn"] = {"server":"${TURN}","username":"${TURN_USER}","credential":"${TURN_PASS}"}
open(p,"w",encoding="utf-8").write(json.dumps(j,ensure_ascii=False,indent=2))
PY
    fi
    echo "Endpoints ajustados."
    popd >/dev/null
