# Ambiente de testes (snapshot)

**Data do snapshot:** 2026-07-28  
**Projeto:** l2ServerTest (L2J Mobius CT_0_Interlude)

## 0.4 — Versões

| Componente | Versão |
|---|---|
| JDK | OpenJDK Temurin **25.0.3+9** LTS (`C:\Program Files\Eclipse Adoptium\jdk-25.0.3.9-hotspot`) |
| MariaDB | **12.3.2** (client 15.2) |
| Apache Ant | 1.10.15 (ver `docs/ENVIRONMENT.md`) |
| SO | Windows 10/11 (build 26200) |
| Protocolo client | Interlude CT2.0 — **746** |

## 0.5 — Source / build

| Item | Valor |
|---|---|
| Repo Mobius | https://gitlab.com/MobiusDevelopment/L2J_Mobius |
| Sparse path | `source/L2J_Mobius_CT_0_Interlude` |
| Commit clone (`source`) | `9735c55b2c3dfa16d14a4c6bfcbd41a850458101` |
| Artefato | `source/build/L2J_Mobius_CT_0_Interlude.zip` (gitignored) |
| Runtime | `server/` (gitignored) |

> O tree `source/` **não** é versionado neste repositório. Para reproduzir: sparse clone + `ant cleanup` (ver `docs/BUILD.md` / `docs/GUIA_COMPLETO.md`).

## Portas (lab localhost)

| Serviço | Porta |
|---|---|
| MariaDB | 3306 |
| Login Server | 2106 |
| Login ↔ Game | 9014 |
| Game Server | 7777 |

## Contas de lab (0.6)

| Login | Access | Uso no Ciclo 1 |
|---|---|---|
| `testplayer` | 0 | Fluxo player (criar char, persistência) |
| `admin` | 100 | Apenas passos GM (`//create_item`, level, teleport) |

Credenciais: `config/accounts.local.env` (não versionado).

## Client

Interlude **limpo / zerado** (sem L2Vikos / EmuDev / Active Anticheat). Ver `docs/CLIENT.md`.
