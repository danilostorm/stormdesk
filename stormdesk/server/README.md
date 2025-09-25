# Servidores StormDesk (Broker/Relay/TURN)

## Variáveis (.env)
Copie `env.sample` para `.env` e ajuste:
- TURN_REALM=stormdesk.cloud
- TURN_USER=storm
- TURN_PASS=senhaFort3

## Portas a abrir (no firewall/UDM)
- 21114/TCP, 21115/TCP, 21116/TCP (hbbs)
- 21117/TCP, 21119/UDP (hbbr)
- 3478/UDP (TURN)
- 49152-49999/UDP (TURN media range)

## DNS sugeridos
- broker.stormdesk.cloud → IP do host (21114–21116)
- relay.stormdesk.cloud  → IP do host (21117/21119)
- turn.stormdesk.cloud   → IP do host (3478/UDP)

## Subir
```bash
docker compose --env-file .env up -d
docker ps
```
