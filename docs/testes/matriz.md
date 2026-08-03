# Matriz de testes — L2J Mobius Interlude

Backlog completo de validação. **Execução imediata:** [ciclo-1.md](ciclo-1.md) (Fase 0 + smoke + persistência mínima).  
Registro: [testes-executados.md](testes-executados.md) · Bugs: [bugs-conhecidos.md](bugs-conhecidos.md)

**Gate:** nenhum S0/S1 aberto sem mitigação; backup de banco + configs restauráveis.

---

## Severidade

| Sev | Definição | Exemplo |
|---|---|---|
| S0 | Impede servidor de funcionar | Game Server não inicia |
| S1 | Corrupção, exploit ou perda | Duplicação de item |
| S2 | Sistema principal quebrado | Olympiad não calcula vencedor |
| S3 | Funciona parcialmente | NPC HTML errado |
| S4 | Visual / baixo impacto | Texto incorreto |
| S5 | Melhoria | Melhorar mensagem |

---

## Fase 0 — Baseline

| ID | Teste | Esperado | Status Ciclo 1 |
|---|---|---|---|
| 0.1 | Backup do banco | Dump restaurável | Ver testes-executados |
| 0.2 | Copiar configs originais | Baseline sanitizada | Ver testes-executados |
| 0.3 | Rastrear source no Git | Commit Mobius documentado | Ver ambiente.md |
| 0.4 | Java / MariaDB | Versões documentadas | Ver ambiente.md |
| 0.5 | Commit/build source | Build reproduzível | Ver ambiente.md |
| 0.6 | Contas player ≠ GM | Separação confirmada | Ver testes-executados |
| 0.7 | Limpar logs antigos | Erros novos identificáveis | Ver testes-executados |

## Fase 1 — Smoke infraestrutura

| ID | Teste | Validação |
|---|---|---|
| 1.1 | MariaDB | Serviço ativo :3306 |
| 1.2 | Login Server | Sem CRITICAL; :2106 |
| 1.3 | Game Server | Mundo carregado; :7777 |
| 1.4 | Registro GS | Online no Login (:9014) |
| 1.5 | Client → Login | Log registra conexão |
| 1.6 | Autenticação | Login válido e inválido |
| 1.7 | Seleção servidor | Tela de personagens |
| 1.8 | Criação personagem | Registro no banco |
| 1.9 | Entrada no mundo | Character correto |
| 1.10 | Logout / novo login | Estado persistido |
| 1.11 | Reinício completo | Personagem íntegro |
| 1.12 | GM básico | Comandos autorizados |

Negativos: senha errada; conta inexistente; conta já conectada; client abortado; restart GS; restart LS.

## Fase 2 — Persistência do personagem

2.1 HP/MP/CP/level/XP · 2.2 Posição · 2.3 Inventário · 2.4 Equip · 2.5 Adena · 2.6 Warehouse · 2.7 Skills · 2.8 Shortcuts · 2.9 Quest · 2.10 Death · 2.11 Subclass · 2.12 Noblesse · 2.13 Karma/PK · 2.14 Clan

## Fase 3 — Configurações globais

Uma mudança por vez. Rates (XP/SP/Adena/Drop/Spoil/Quest/Raid/Manor/Party) · Player · Enchant.

## Fase 4 — Classes, skills e combate

Classes representativas + skills prioritárias + fórmulas (P.Atk/M.Atk, crit, speed, etc.).

## Fase 5 — NPCs e serviços

Gatekeeper, WH, Merchant, Multisell, Blacksmith, Class Master, Buffer, Olympiad, Clan, Manor, Seven Signs, Quest, Custom shop, CB.

## Fase 6 — Itens, drops, craft e economia

Flags de item · drops · craft · métricas de economia.

## Fase 7 — Quests e progressão

Prioridade: class transfers, subclass, noblesse, access, boss, recipes, Seven Signs, customs.

## Fase 8 — Raids e Grand Bosses

Raid comum → Ant, Core, Orfen, Zaken, Baium, Antharas, Valakas, Frintezza.

## Fase 9 — PvP, PK e Olympiad

Flag/karma/zones + ciclo Olympiad completo (registro → hero).

## Fase 10 — Clans, castles e sieges

Clan lifecycle + sieges com restart antes/durante/após.

## Fase 11 — Eventos e customs

Somente após core estável (TvT, CTF, DM, buffer, premium, etc.).

## Fase 12 — Segurança e exploits

Duplicação concorrente · validação server-side · auditoria GM. **Só no lab local.**

## Fase 13 — Estabilidade e carga

24h/72h, memória, threads, DB, restart, falha forçada.

## Fase 14 — Geodata e mundo

Colisão, LoS, zonas críticas (cidades, castelos, GB, Olympiad).

## Fase 15 — Balanceamento e produto

Progressão, economia, PvP divertido/sustentável.

---

## Ordem de execução resumida

0 Baseline → 1 Smoke → 2 Persistência → 3 Configs → 4 Classes → 5 NPCs → 6 Economia → 7 Quests → 8 Bosses → 9 PvP/Oly → 10 Siege → 11 Customs → 12 Segurança → 13 Carga → 14 Geo → 15 Produto

Beta pública: sem S0/S1/S2 abertos sem mitigação.
