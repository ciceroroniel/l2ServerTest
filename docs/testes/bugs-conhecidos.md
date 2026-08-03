# Bugs conhecidos

Severidade: **S0** Bloqueador · **S1** Crítico · **S2** Alto · **S3** Médio · **S4** Baixo · **S5** Melhoria

| ID | Severidade | Status | Descrição | Mitigação |
|---|---|---|---|---|
| BUG-001 | S1 | Resolvido (histórico) | Client L2Impact/Vikos autenticava em IP remoto (`15.204.x.x`) | Client limpo Interlude CT2.0 em uso |
| BUG-002 | S3 | Aberto | Geodata: 0 regions — pathfinding desabilitado | Movimento básico OK; adicionar geodata depois |
| BUG-003 | S4 | Aberto (lab ok) | `AutoCreateAccounts=True` — risco se servidor for público | Desativar antes de exposição pública |
| BUG-004 | S1→S5 | **Falso positivo / Resolvido** | Item `8689` **Blood Sword Akamanah** (arma amaldiçoada) sumiu após restart. Log: `Blood Sword Akamanah being removed offline.` — comportamento do sistema de Cursed Weapons (`CursedWeapons.xml`: duration 300 min; `EnterWorld` destrói se estiver no inventário sem cursed equip válido). **Não** foi perda genérica de inventário. | Para testes de persistência usar itens normais (não Zariche/Akamanah). Force kill ainda é má prática, mas este caso não prova duplicação/perda. |
| BUG-005 | S4 | Aberto (observação) | Char GM com enchant extremo (+500), adena ~2.1B e CP anômalo — estado de lab via GM, não baseline retail | Usar `testplayer` para testes de economia; não misturar com métricas de produto |

## Template para novos bugs

```
ID: BUG-00N
Severidade: S?
Status: Aberto / Mitigado / Resolvido
Descrição:
Reprodução:
Evidência:
Mitigação:
```
