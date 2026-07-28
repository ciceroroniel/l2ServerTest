# Fase 5 — Configuração dos Servidores

**Data:** 2026-07-27  
**Status:** Concluída — Login + Game Server online

## Rede configurada (MVP localhost)

| Serviço | Host | Porta | Função |
|---|---|---|---|
| Login Server (clientes) | `0.0.0.0` | **2106** | Autenticação de jogadores |
| Login Server (Game Servers) | `127.0.0.1` | **9014** | Canal Login ↔ Game |
| Game Server (clientes) | `0.0.0.0` | **7777** | Mundo do jogo |

### ipconfig.xml

Arquivo: `server/game/config/ipconfig.xml`  
Baseado em `default-ipconfig.xml` — external/internal apontando para `127.0.0.1`.

Subnets configuradas para LAN (`192.168.x.x`, `10.x.x.x`) para uso futuro em rede local.

## Game Server registrado

| Campo | Valor |
|---|---|
| Server ID | **1** |
| Nome | **Bartz** |
| HexID | em `server/game/config/hexid.txt` |
| Tabela | `gameservers` no banco |

`RequestServerID = 1` em `server/game/config/Server.ini` (padrão Mobius).

## Configurações alteradas

| Arquivo | Alteração |
|---|---|
| `server/game/config/ipconfig.xml` | Criado (localhost) |
| `server/game/config/hexid.txt` | Novo HexID para Server 1 |
| `server/login/config/Interface.ini` | `EnableGUI = False` (headless) |
| `server/game/config/Interface.ini` | `EnableGUI = False` (headless) |
| `server/game/java.cfg` | RAM reduzida: `-Xms512m -Xmx2g` (MVP local) |

## Scripts de operação

```powershell
# Ordem obrigatória: Login primeiro, depois Game
.\scripts\start-login.ps1
Start-Sleep -Seconds 8
.\scripts\start-game.ps1

# Parar ambos
.\scripts\stop-servers.ps1
```

Alternativa via VBS (com janela):

```
server\login\LoginServer.vbs
server\game\GameServer.vbs
```

## Logs

| Servidor | Arquivo |
|---|---|
| Login | `server/login/log/java0.log` |
| Game | `server/game/log/java0.log` |

## Validação executada

### Portas

```
TCP 0.0.0.0:2106   LISTENING   (Login — clientes)
TCP 127.0.0.1:9014 LISTENING   (Login — Game Servers)
TCP 0.0.0.0:7777   LISTENING   (Game — clientes)
```

### Login Server (`java0.log`)

```
Database: Initialized with a valid connection.
Loaded 1 registered Game Servers.
LoginServer: Login client listener started on 0.0.0.0:2106.
Game server listener is listening on 127.0.0.1:9014.
```

### Game Server (`java0.log`)

```
Network Config: ipconfig.xml exists, using manual configuration...
Database: Initialized with a valid connection.
SpawnData: 34882 spawns have been initialized!
GameServer: Started, using 1036 of 2048 MB total memory.
LoginServerThread: Registered on login as Server 1: Bartz
```

## Avisos não críticos

| Log | Impacto |
|---|---|
| `GeoEngine: Loaded 0 regions` | Sem geodata — pathfinding desabilitado; movimento básico funciona |
| `Directory not found: buylists/custom` | Pasta custom vazia — normal em instalação limpa |

Geodata pode ser adicionada depois em `server/game/data/geodata/`.

## Erros

Nenhum erro fatal. Servidores iniciaram e autenticaram entre si.

## Próxima etapa (Fase 6)

1. Configurar client Interlude para `127.0.0.1`
2. Criar conta (AutoCreateAccounts = True no Login)
3. Criar personagem e entrar no mundo
4. Elevar conta a GM
