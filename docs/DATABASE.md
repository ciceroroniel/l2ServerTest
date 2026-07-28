# Fase 4 — Banco de Dados

**Data:** 2026-07-27  
**Status:** Concluída

## Banco criado

| Parâmetro | Valor |
|---|---|
| Host | `localhost` |
| Porta | `3306` |
| Database | `l2jmobiusinterlude` |
| Usuário | `l2jmobius` (não root) |
| Charset | `utf8mb4` / `utf8mb4_unicode_ci` |
| Credenciais | [`config/database.local.env`](../config/database.local.env) (gitignored) |

## Privilégios do usuário

O usuário `l2jmobius@localhost` recebe permissões **somente** no banco `l2jmobiusinterlude`:

- SELECT, INSERT, UPDATE, DELETE
- CREATE, DROP, INDEX, ALTER
- CREATE TEMPORARY TABLES, LOCK TABLES
- EXECUTE, CREATE/ALTER ROUTINE, TRIGGER, VIEW

Sem privilégios globais (FILE, SUPER, GRANT, etc.).

## Scripts importados

| Tipo | Arquivos | Pasta |
|---|---|---|
| Login | 4 | `server/db_installer/sql/login/` |
| Game | 96 | `server/db_installer/sql/game/` |
| **Total tabelas** | **100** | |

## Tabelas principais

| Tabela | Função |
|---|---|
| `accounts` | Contas de login (senha, accessLevel, lastIP) |
| `account_data` | Dados extras da conta |
| `gameservers` | Game Servers registrados no Login Server |
| `characters` | Personagens (posição, level, stats) |
| `items` | Inventário, warehouse, equipamentos |
| `character_skills` | Skills aprendidas |
| `character_quests` | Estado das quests |
| `clan_data` | Clãs |
| `castle` | Castelos e donos |
| `siege_clans` | Clãs registrados em siege |
| `olympiad_data` | Dados da Olympiad |
| `raidboss_spawnlist` | Respawn de raid bosses |
| `itemsonground` | Itens dropados no chão |
| `punishments` | Banimentos |
| `global_variables` | Variáveis globais do servidor |

> NPCs, drops, spawns e skills **não** ficam no banco — estão no **datapack** (`server/game/data/`).

## Configuração atualizada

Arquivos alterados para usar `l2jmobius` em vez de `root`:

- `server/login/config/Database.ini`
- `server/game/config/Database.ini`

URL JDBC (padrão Mobius):

```
jdbc:mysql://localhost/l2jmobiusinterlude?useUnicode=true&characterEncoding=utf-8&...
```

## Validação executada

```powershell
mariadb -u l2jmobius -p l2jmobiusinterlude -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='l2jmobiusinterlude';"
# Resultado: 100 tabelas
```

Tabelas críticas confirmadas: `accounts`, `characters`, `items`, `clan_data`, `castle`, `olympiad_data`, `raidboss_spawnlist`.

## Scripts utilitários

| Script | Função |
|---|---|
| [`scripts/import-database.ps1`](../scripts/import-database.ps1) | Reimportar schema login + game |
| [`scripts/backup-database.ps1`](../scripts/backup-database.ps1) | Backup `.sql` com timestamp |

### Backup manual

```powershell
.\scripts\backup-database.ps1
```

Backups salvos em `backups/database/`.

## DatabaseInstaller (alternativa GUI)

Para reinstalar via interface gráfica:

1. Desabilitar GUI: `server/db_installer/config/Interface.ini` → `EnableGUI = False`
2. Executar `server/db_installer/DatabaseInstaller.vbs`
3. Informar host, porta, usuário root (para criar DB) ou usuário dedicado

## Erros

Nenhum erro na importação dos 100 scripts SQL.

## Próxima etapa (Fase 5)

1. Configurar IP/portas nos servidores
2. Registrar Game Server (HexID)
3. Iniciar Login Server
4. Iniciar Game Server
5. Analisar logs
