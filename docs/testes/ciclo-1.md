# Ciclo 1 — Fundação (checklist executável)

Valida login, criação, persistência e restart **antes** de alterar rates/bosses/customs.

**Contas:** `testplayer` (player) · `admin` (só GM)  
**Pré:** MariaDB + Login + Game online · hosts → localhost · client limpo  
**Registro:** [testes-executados.md](testes-executados.md) · Gate: [gate-fase2.md](gate-fase2.md)

## Passos (sessão 2026-07-28)

| # | Ação | Conta | Esperado | OK |
|---|---|---|---|---|
| 1 | Reiniciar Login + Game | — | Portas 2106/9014/7777; sem CRITICAL | [x] |
| 2 | Logar | testplayer + admin | Auth OK; Bartz | [ ] pós-restart |
| 3 | Criar segundo personagem | testplayer | Char no banco | [ ] |
| 4 | `//create_item` | admin | Item no inventário | [x] evidência DB |
| 5 | Equipar + relog | admin | Equip persiste | [!] BUG-004 |
| 6 | Alterar level (GM) | admin | Level no char/DB | [x] lv80 |
| 7 | Morrer + reviver | — | Estado coerente | [ ] |
| 8 | Teleport Giran | admin | Posição Giran | [x] coords |
| 9 | Comprar/vender NPC | testplayer | Adena/itens OK | [ ] |
| 10 | Warehouse depositar/retirar | testplayer | WH + inv OK | [ ] |
| 11 | Restart Game Server | — | Sobe e registra | [x] (Force) |
| 12 | Confirmar persistência | — | Inv, level, posição | [!] item equip perdido |
| 13 | Revisar logs | — | Sem S0/S1 novos | [x] + BUG-004 |
| 14 | Novo backup do banco | — | Dump em backups/ | [x] |

## Negativos

| Cenário | Status |
|---|---|
| Senha errada | Pendente |
| Conta inexistente | Pendente |
| Client fechado abruptamente | Reproduzido via Force kill → BUG-004 |
| Conta já conectada | Pendente |

## Comandos úteis

```powershell
cd c:\Users\cicer\Code\l2ServerTest
.\scripts\stop-servers.ps1          # ATENÇÃO: Force kill (BUG-004)
.\scripts\start-login.ps1
Start-Sleep -Seconds 8
.\scripts\start-game.ps1
.\scripts\backup-database.ps1
```

In-game (GM): `//admin` · `//create_item 57 1000000` · `//teleportto Giran` · `//setlevel 40`

## Critério go/no-go Fase 2

Ver [gate-fase2.md](gate-fase2.md) — atualmente **NO-GO** até fechar pendências e reteste gracioso.
