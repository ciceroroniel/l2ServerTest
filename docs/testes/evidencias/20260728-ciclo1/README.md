# Evidência Ciclo 1 — 2026-07-28

## Arquivos

| Arquivo | Conteúdo |
|---|---|
| `char-before-restart.txt` | SaninhaGM antes do Force stop (online=1, karma=9999999) |
| `char-after-restart.txt` | Mesmo char após restart (online=0, karma=0) |
| `items-before-restart.txt` | Inclui PAPERDOLL item 8689 enchant 500 |
| `items-after-restart.txt` | **Sem** item 8689 — BUG-004 |
| `login-java0-post-restart.log` | Boot Login + registro Bartz |
| `game-java0-post-restart.log` | Boot Game (~21s) |

## Achado principal (atualizado)

Item perdido era **Blood Sword Akamanah** (`8689`) — arma amaldiçoada.

Log do Game Server:
`Blood Sword Akamanah being removed offline.`

Isso é **comportamento esperado** (Cursed Weapons: duração 300 min; remoção offline / EnterWorld).  
**Não** classificar como bug de inventário genérico. Retestar persistência com item normal.

