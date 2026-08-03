# Configurações — baseline de referência

Configs runtime ficam em `server/**/config/` (gitignored).  
Cópias **sanitizadas** (Password=`***`) em [baseline/config/](baseline/config/).

## Arquivos críticos

| Arquivo | Papel |
|---|---|
| `server/login/config/Database.ini` | Credenciais Login → MariaDB |
| `server/login/config/Server.ini` | Porta 2106, AutoCreateAccounts |
| `server/login/config/Network.ini` | Bind Login |
| `server/game/config/Database.ini` | Credenciais Game → MariaDB |
| `server/game/config/Server.ini` | Porta 7777, ServerID |
| `server/game/config/Rates.ini` | XP/SP/Adena/Drop (não alterar no Ciclo 1) |
| `server/game/config/Player.ini` | Personagem / inventário |
| `server/game/config/hexid.txt` | Registro no Login (único; não versionar) |
| `server/game/config/ipconfig.xml` | IP anunciado aos clients |

## Regras do Ciclo 1

- **Não** alterar rates, Player.ini, Olympiad, Siege, GrandBoss neste ciclo
- Qualquer mudança futura: uma config por vez → restart → teste → registrar em `testes-executados.md`
- Restaurar baseline: copiar de `docs/testes/baseline/config/` e reaplicar Password local

## Como restaurar

1. Parar servidores: `.\scripts\stop-servers.ps1`
2. Restaurar dump: ver `docs/DATABASE.md`
3. Restaurar INIs da baseline + Password de `config/database.local.env`
4. Subir Login → Game
