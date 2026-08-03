# Fase 6 — Client e Primeiro Login

**Data:** 2026-07-28  
**Status:** Client **limpo** em uso · contas de lab prontas

## Pré-requisitos

| Item | Status |
|---|---|
| Login Server | Porta 2106 |
| Game Server | Porta 7777, **Bartz** (ID 1) |
| AutoCreateAccounts | `True` (lab) |
| Protocolo | **746** (Interlude CT2.0) |
| Contas | `testplayer`, `admin` (GM) |
| Client | Interlude **limpo / zerado** (sem Vikos/Impact) |

## Contas de teste

Credenciais em `config/accounts.local.env` (gitignored):

| Login | Senha | Access Level | Papel |
|---|---|---|---|
| `testplayer` | `Test1234!` | 0 | Jogador |
| `admin` | `admin123` | 100 | GM Master |

> `AutoCreateAccounts = True` cria conta access 0 no primeiro login com credenciais novas.

### Níveis de acesso (Mobius)

| Level | Papel |
|---|---|
| 0 | Jogador |
| 10–70 | GM parcial |
| 100 | Master — todos os `//` |

## Client em uso (padrão)

**Client Interlude limpo CT2.0** — pasta `system/` **sem** `L2VikosMemory.dll`, `EmuDev.dll` ou Active Anticheat.

```powershell
.\scripts\configure-client.ps1 -ClientPath "CAMINHO\DO\CLIENT\LIMPO"
.\scripts\configure-hosts-admin.bat   # Admin
```

Estrutura mínima:

```
Interlude-Clean/
├── system/     ← l2.exe, l2.ini (sem DLLs Vikos/Impact)
├── maps/
└── ...
```

## Passo 1 — Hosts (obrigatório)

```
127.0.0.1 l2authd.lineage2.com
127.0.0.1 l2testauth.lineage2.com
```

```powershell
.\scripts\configure-hosts.ps1
# ou configure-hosts-admin.bat
```

## Passo 2 — Servidores

```powershell
.\scripts\start-login.ps1
Start-Sleep -Seconds 8
.\scripts\start-game.ps1
```

## Passo 3 — Entrar

1. `start-l2-local.bat` (ou launcher do client limpo)
2. Login: `admin` / `admin123` (ou `testplayer` / `Test1234!`)
3. Servidor **Bartz**
4. Criar personagem → entrar no mundo

## Passo 4 — GM (conta admin)

```
//admin
//gm
//invul
//hide
//teleportto Giran
//create_item 57 1000000
```

## Nota histórica — L2Impact (não usar)

O pack **L2Impact** com `L2VikosMemory.dll` autenticava no IP remoto `15.204.x.x` e **nunca** chegava ao Login local. Esse cenário está **resolvido** neste lab (BUG-001). Não misturar client Impact com o servidor Mobius local.

## Critérios MVP / Ciclo 1

Ver [testes/ciclo-1.md](testes/ciclo-1.md) e [testes/matriz.md](testes/matriz.md).

## Scripts

| Script | Função |
|---|---|
| `scripts/configure-hosts.ps1` | Hosts locais |
| `scripts/configure-client.ps1` | Backup + atalho |
| `scripts/create-test-accounts.ps1` | Contas teste/GM |
| `scripts/fix-client-local.ps1` | Legado Impact — **não necessário** com client limpo |

## Erros comuns

| Sintoma | Causa | Correção |
|---|---|---|
| Cannot connect to login | Hosts | Passo 1 |
| Protocol mismatch | Client não Interlude 746 | Client CT2.0 limpo |
| Login inválido | Senha | `admin`/`admin123` |
| Tela preta pós-login | Sem geodata | MVP OK — movimento básico |
| Servidor some da lista | GS offline | Reiniciar GS |
