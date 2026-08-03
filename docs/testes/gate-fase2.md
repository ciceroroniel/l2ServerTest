# Gate — Avanço para Fase 2

**Data:** 2026-07-28  
**Decisão:** **NO-GO** (condicional)

## Critérios

| Critério | Resultado |
|---|---|
| Backup restaurável + baseline configs | OK |
| Smoke 1.1–1.4 | OK |
| Sem S0 aberto | OK |
| Sem S1 aberto sem mitigação | OK — BUG-004 era Akamanah (esperado) |
| Ciclo 1 completo Aprovado | **Não** — passos manuais pendentes; reteste de persistência com item normal |

## Por que NO-GO

1. Passos in-game ainda pendentes: 2º char em `testplayer`, death/revive, buy/sell, warehouse, auth negativa.
2. Persistência de equip precisa reteste com **item normal** (não cursed weapon).

## O que pode continuar em paralelo

- Documentação / matriz Fases 2–15 (já em [matriz.md](matriz.md))
- Planejar geodata (BUG-002)
- Melhorar `stop-servers.ps1` para shutdown gracioso (próximo trabalho)

## Checklist para virar GO

- [ ] Relogar com client limpo; evidência no `login/log/java0.log`
- [ ] Criar 2º personagem em `testplayer`
- [ ] Death + revive
- [ ] Comprar/vender NPC
- [ ] Warehouse depositar/retirar
- [ ] Restart Game Server com char online → inventário/equip **de item normal** intactos (não usar Akamanah/Zariche)
- [ ] Confirmar que BUG-004 permanece fechado como falso positivo
- [ ] Novo backup após ciclo limpo

## Resumo executivo

Fundação de **infra está estável** (MariaDB, Login, Game, Bartz).  
Persistência básica de char (level, posição, adena) OK.  
**Não** avançar para alteração de rates (Fase 3) nem expansão da matriz de combate até o Ciclo 1 fechar os itens acima.
