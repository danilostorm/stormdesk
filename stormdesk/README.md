# StormDesk Starter (base RustDesk)

Este pacote prepara o rebranding e a automação de build do **RustDesk** para o nome **StormDesk** (AGPL-3.0).
> Objetivo: você clona o RustDesk, aplica os scripts deste pacote e gera instaladores para Windows/macOS/Linux,
> além de subir seus servidores Broker/Relay/TURN com Docker.

## Aviso legal (licença)
- RustDesk é AGPL-3.0. Se você **distribuir** binários modificados, **você deve disponibilizar o código-fonte** das modificações.
- Inclua créditos ao projeto original: https://github.com/rustdesk/rustdesk

## Resumo do que há aqui
- `server/` → Docker Compose para **stormdesk-broker** (hbbs), **stormdesk-relay** (hbbr) e **coturn**.
- `scripts/` → Scripts para aplicar branding e apontar endpoints, e para build multi-plataforma.
- `installer/` → Inno Setup (Windows), DMG (macOS) e pacote .deb (Linux).
- `ci/.github/workflows/build.yml` → Pipeline GitHub Actions para gerar artefatos (.exe, .dmg, .AppImage/.deb).
- `patches/branding.patch` → Patch indicativo de renomeações e strings (pode variar vs. versão do RustDesk).

## Passo a passo rápido
1. **Fork** o RustDesk no GitHub para sua org/conta (ex.: `hoststorm/stormdesk`).
2. **Clone** o seu fork:  
   ```bash
   git clone https://github.com/SEU_USUARIO/rustdesk.git stormdesk-src
   cd stormdesk-src
   ```
3. **Copie** o conteúdo deste pacote para a pasta acima do repositório (ou onde preferir) e rode os scripts:
   - Windows PowerShell (administrador recomendado):
     ```powershell
     ..\stormdesk\scripts\apply_stormdesk_branding.ps1 -RepoPath . -AppName "StormDesk"
     ..\stormdesk\scripts\set_server_endpoints.ps1 -RepoPath . -Broker "broker.stormdesk.cloud" -Relay "relay.stormdesk.cloud" -Turn "turn.stormdesk.cloud:3478" -TurnUser "storm" -TurnPass "senhaFort3"
     ..\stormdesk\scripts\build_windows.ps1 -RepoPath . -Configuration Release
     ```
   - Linux/macOS:
     ```bash
     ../stormdesk/scripts/apply_stormdesk_branding.sh --repo . --app-name "StormDesk"
     ../stormdesk/scripts/set_server_endpoints.sh --repo . --broker broker.stormdesk.cloud --relay relay.stormdesk.cloud --turn turn.stormdesk.cloud:3478 --turn-user storm --turn-pass senhaFort3
     ../stormdesk/scripts/build_linux.sh --repo . --release
     # no macOS:
     ../stormdesk/scripts/build_macos.sh --repo . --release
     ```
4. **CI opcional**: copie `ci/.github/workflows/build.yml` para o seu repo em `.github/workflows/build.yml`, ajuste Secrets e faça push. Os artefatos de build aparecerão nos Releases/Actions.
5. **Servidores**: suba `server/docker-compose.yml` em um host (Unraid/VM) e aponte DNS/ports conforme README do `server/`.

## Dúvidas comuns
- **UAC/desktop seguro no Windows**: alguns recursos (CTRL+ALT+DEL, tela de UAC) exigem driver/serviço elevado. O RustDesk já trata isso em parte; leia a doc oficial do projeto para detalhes.
- **Wayland (Linux)**: use PipeWire e permissões adequadas; veja docs do RustDesk/Wayland.
- **Assinatura de binários**: configure seu certificado de assinatura (Windows) e notarização (macOS) no pipeline.
