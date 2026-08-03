# Testes executados

**Build/commit Mobius:** `9735c55b2c3dfa16d14a4c6bfcbd41a850458101`  
**Data sessão:** 2026-07-28  
**Evidências:** [evidencias/20260728-ciclo1/](evidencias/20260728-ciclo1/) · [evidencias/baseline-logs/](evidencias/baseline-logs/)

---

## Fase 0 — Baseline

### 0.1 Backup do banco

- **Status:** Aprovado
- **Esperado:** Dump restaurável
- **Encontrado:** `backups/database/l2jmobiusinterlude_20260728_191523.sql` (0.34 MB) e dump final `..._191829.sql`
- **Evidência:** arquivos em `backups/database/` (gitignored)

### 0.2 Baseline de configs

- **Status:** Aprovado
- **Esperado:** Cópias sanitizadas (Password=`***`)
- **Encontrado:** `docs/testes/baseline/config/login/*.ini` + `game/*.ini` (+ ipconfig.xml)
- **Evidência:** Select-String confirmou `Password = ***` em ambos Database.ini

### 0.3–0.5 Source / versões / build

- **Status:** Aprovado
- **Evidência:** [ambiente.md](ambiente.md)

### 0.6 Contas player / GM

- **Status:** Aprovado
- **Encontrado:** `testplayer` accessLevel=0 · `admin` accessLevel=100

### 0.7 Limpeza de logs

- **Status:** Aprovado
- **Encontrado:** Tails em `evidencias/baseline-logs/`; logs runtime limpos no restart do Ciclo 1

---

## Fase 1 — Smoke infra

### 1.1 MariaDB

- **Status:** Aprovado
- **Encontrado:** LISTENING `:3306` (MariaDB 12.3.2)

### 1.2 Login Server

- **Status:** Aprovado
- **Encontrado:** Listener `0.0.0.0:2106`; log sem CRITICAL; HikariCP OK
- **Log:** `evidencias/20260728-ciclo1/login-java0-post-restart.log`

### 1.3 Game Server

- **Status:** Aprovado
- **Encontrado:** Mundo carregado em ~21s; `:7777`; 34882 spawns; 187 raid instances
- **Log:** `evidencias/20260728-ciclo1/game-java0-post-restart.log`
- **Nota:** GeoEngine 0 regions (BUG-002)

### 1.4 Registro Game Server

- **Status:** Aprovado
- **Encontrado:** `Registered on login as Server 1: Bartz` · canal `:9014`

### 1.5 Client → Login

- **Status:** Aprovado (pré-restart) / Pendente pós-restart
- **Pré:** Conexão ESTABLISHED em `:7777` e char `SaninhaGM` online=1 antes do stop
- **Pós-restart:** até o fechamento desta sessão, nenhum novo auth no login log (operador precisa relogar)
- **Hosts:** `l2authd` / `l2testauth` → `127.0.0.1` OK

### 1.6 Autenticação (válida / inválida)

- **Status:** Parcial — contas existem no DB; negativos (senha errada / inexistente) **Pendentes** no client

### 1.7–1.9 Seleção / criação / mundo

- **Status:** Parcial
- **Encontrado:** Char `SaninhaGM` (admin) level 80, coords Giran (~82625,148804,-3495), já existente
- **Pendente:** 2º personagem na conta `testplayer` (count=0)

### 1.10 Logout / login

- **Status:** Pendente (operador após restart)

### 1.11 Reinício completo

- **Status:** Aprovado (infra) / **Reprovado parcial (persistência item)** — ver BUG-004
- **Encontrado:** LS+GS sobem; Bartz registra; level/exp/posição/adena persistem; **arma PAPERDOLL sumiu** após Force kill

### 1.12 GM básico

- **Status:** Aprovado (evidência de estado)
- **Encontrado:** Conta access 100; itens GM no inventário (adena massiva, enchant extremo) — uso histórico de GM no lab

---

## Ciclo 1 — passos 1–14

| Passo | Status | Notas |
|---|---|---|
| 1 Restart LS+GS | Aprovado | Scripts; fix cwd em start-*.ps1 |
| 2 Login | Pendente pós-restart | Relogar com client limpo |
| 3 2º personagem | Pendente | Criar em `testplayer` |
| 4 create_item | Aprovado (evidência DB) | Itens/adena presentes pré-restart |
| 5 Equip+relog | Reprovado parcial | Equip existia; arma perdida no Force kill (BUG-004) |
| 6 setlevel | Aprovado | level 80 / exp persistidos |
| 7 Death/revive | Pendente | Operador |
| 8 Teleport Giran | Aprovado | Coords Giran no DB |
| 9 Buy/sell NPC | Pendente | Operador |
| 10 Warehouse | Pendente | WH vazio no DB |
| 11 Restart GS | Aprovado (sobe) | Usou Force — ver BUG-004 |
| 12 Persistência | Reprovado parcial | Level/pos/inv OK; 1 item equipado perdido |
| 13 Logs | Aprovado | Sem CRITICAL no boot; geodata 0 regions |
| 14 Backup final | Aprovado | `l2jmobiusinterlude_20260728_191829.sql` |

## Negativos

| Cenário | Status |
|---|---|
| Senha errada | Pendente |
| Conta inexistente | Pendente |
| Client abortado | Parcial — Force kill no GS reproduziu perda (BUG-004) |
| Conta já conectada | Pendente |

---

## Gate Fase 2

Ver [gate-fase2.md](gate-fase2.md).
