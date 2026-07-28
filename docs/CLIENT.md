# Fase 6 — Client e Primeiro Login

**Data:** 2026-07-27  
**Status:** Contas criadas — aguardando client do usuário

## Pré-requisitos atendidos

| Item | Status |
|---|---|
| Login Server online | Porta 2106 |
| Game Server online | Porta 7777, Server **Bartz** (ID 1) |
| AutoCreateAccounts | `True` — qualquer login/senha nova cria conta |
| Protocolo client | **746** (Interlude CT2.0) |
| Contas pré-criadas | `testplayer`, `admin` (GM) |

## Contas de teste

Credenciais em `config/accounts.local.env` (gitignored):

| Login | Senha | Access Level | Papel |
|---|---|---|---|
| `testplayer` | `Test1234!` | 0 | Jogador normal |
| `admin` | `admin123` | 100 | GM Master |

> Com `AutoCreateAccounts = True`, você também pode usar qualquer login/senha na primeira tentativa — a conta será criada automaticamente com accessLevel 0.

### Níveis de acesso (Mobius)

| Level | Papel |
|---|---|
| 0 | Jogador |
| 10–70 | GM parcial (escalonado) |
| 100 | Master — todos os comandos `//` |

## Client Interlude — requisitos

Você precisa de um **client Interlude CT2.0** de origem legítima (instalação retail que você possua).  
O repositório **não inclui client** — isso é correto por razões legais.

**Não encontramos** client L2 instalado nos caminhos comuns desta máquina.

## Passo 1 — Configurar hosts (obrigatório)

O client Interlude redireciona autenticação via DNS. Adicione ao arquivo hosts do Windows:

```
127.0.0.1 l2authd.lineage2.com
127.0.0.1 l2testauth.lineage2.com
```

**Opção A — Script (PowerShell como Administrador):**

```powershell
cd c:\Users\cicer\Code\l2ServerTest
.\scripts\configure-hosts.ps1
```

**Opção B — Manual:**

1. Abrir `C:\Windows\System32\drivers\etc\hosts` como Administrador
2. Adicionar as duas linhas acima ao final
3. Salvar

## Client L2Impact — incompatível com servidor local

O pack **L2Impact Client Interlude** usa `L2VikosMemory.dll` com licença vinculada ao IP **15.204.x.x** (servidor L2Impact remoto). Mesmo com:

- `hosts` configurado corretamente
- `AltClientGuard=False`
- senha correta no banco local (`admin` / `admin123`)

O login **não chega** ao Login Server local. Evidência:

- `server/login/log/java0.log` — **nenhuma** tentativa de login registrada
- `L2VikosMemory.log` — `LICENSE ACTIVATED: Server IP address: 15.204.***.***`

**Conclusão:** senha "incorreta" porque autentica no servidor L2Impact, não no L2J Mobius local.

### Solução: client Interlude limpo

Use um client **CT2.0 Interlude** sem patch L2Impact/Vikos/SmartGuard:

1. Obtenha client retail Interlude que você possua legalmente, **ou**
2. Pasta `system` limpa compatível com protocolo **746** (sem `L2VikosMemory.dll`, `EmuDev.dll`, Active Anticheat)

### Instalação do client limpo

```powershell
# Exemplo: extrair client limpo para pasta separada
# E:\Servidores de Lineage pra Jogar\Interlude-Clean\

.\scripts\configure-client.ps1 -ClientPath "E:\Servidores de Lineage pra Jogar\Interlude-Clean"
# hosts já configurado — reutilizar configure-hosts-admin.bat se necessário
```

Estrutura mínima necessária na raiz do client:

```
Interlude-Clean/
├── system/     ← l2.exe, l2.ini (sem DLLs Vikos/Impact)
├── maps/
├── textures/
└── ...
```

### Comparativo

| Client | Funciona com L2J Mobius local? |
|---|---|
| L2Impact (Vikos/Active Anticheat) | **Não** — auth remoto hardcoded |
| Interlude limpo CT2.0 rev 746 | **Sim** — com hosts + start-l2-local.bat |


## Passo 2 — Configurar client

Já configurado. Para reconfigurar:

```powershell
.\scripts\configure-client.ps1 -ClientPath "E:\Servidores de Lineage pra Jogar\Server-Interlude-Test"
```

## Passo 3 — Iniciar servidores (se não estiverem rodando)

```powershell
.\scripts\start-login.ps1
Start-Sleep -Seconds 8
.\scripts\start-game.ps1
```

Aguarde ~20s até o Game Server carregar (ver `server/game/log/java0.log`).

## Passo 4 — Entrar no jogo

1. Execute `start-l2-local.bat` na pasta do client
2. Na tela de login, use:
   - Login: `admin`
   - Senha: `Admin1234!`
3. Selecione servidor **Bartz**
4. Crie um personagem (Human Fighter, etc.)
5. Entre no mundo

## Passo 5 — Testar GM

No chat do jogo (com conta `admin`):

```
//admin
//gm
//invul
//hide
//teleportto Giran
//create_item 57 1000000
```

Comandos GM usam prefixo `//` (barra dupla).

## Critérios de validação (MVP)

- [ ] Client conecta na tela de login
- [ ] Lista de servidores mostra **Bartz**
- [ ] Login aceita conta `testplayer` ou `admin`
- [ ] Criação de personagem funciona
- [ ] Entrada no mundo com NPCs visíveis
- [ ] Comando `//admin` abre menu GM (conta admin)

## Erros comuns

| Sintoma | Causa | Correção |
|---|---|---|
| "Cannot connect to login server" | Hosts não configurado | Passo 1 |
| **Login/senha incorretos (conta existe no banco)** | Client L2Impact redireciona para servidor remoto (15.204.x.x) | Executar `.\scripts\fix-client-local.ps1` + configurar hosts |
| Servidor não aparece na lista | Game Server offline | Reiniciar GS, verificar log |
| "Protocol version mismatch" | Client errado (não Interlude) | Usar client CT2.0 rev 746 |
| Login inválido | Senha errada | `admin` / `admin123` |
| Tela preta após login | Geodata ausente | Normal no MVP — movimento básico funciona |
| Client não abre após fix | DLLs desabilitadas | Restaurar de `system_backup_*` e usar client limpo |

## Scripts da Fase 6

| Script | Função |
|---|---|
| `scripts/configure-hosts.ps1` | Entradas DNS locais (admin) |
| `scripts/configure-client.ps1` | Backup + atalho do client |
| `scripts/create-test-accounts.ps1` | Recriar contas teste/GM |

## Próxima etapa (Fase 7 — MVP funcional)

1. Alterar rates de XP/SP/Adena
2. Testar comando GM de spawn/item
3. Modificar drop, NPC ou multisell
4. Reiniciar e validar persistência
5. Backup + commit Git
