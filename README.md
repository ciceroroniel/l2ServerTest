# L2 Server Test — Projeto Interlude

Servidor privado Lineage 2 Interlude baseado em **L2J Mobius CT_0_Interlude**.

## Estrutura

```
l2ServerTest/
├── docs/           # Documentação do projeto
├── source/         # Git clone (sparse) do L2J Mobius
├── server/         # Distribuição compilada (runtime)
└── README.md
```

## Documentação

**Comece aqui:** [Guia completo de replicação](docs/GUIA_COMPLETO.md)

| Fase | Documento |
|---|---|
| 1 | [SOURCE_DECISION.md](docs/SOURCE_DECISION.md) |
| 2 | [ENVIRONMENT.md](docs/ENVIRONMENT.md) |
| 3 | [BUILD.md](docs/BUILD.md) |
| 4 | [DATABASE.md](docs/DATABASE.md) |
| 5 | [SERVERS.md](docs/SERVERS.md) |
| 6 | [CLIENT.md](docs/CLIENT.md) |
| — | [COMANDOS_BANCO.md](docs/COMANDOS_BANCO.md) — comandos SQL para GM, contas, itens |
| — | [modding/00_INDICE.md](docs/modding/00_INDICE.md) — **guia de customização** (itens, NPCs, lojas, enchant, drops, código, client) |
| — | [modding/index.html](docs/modding/index.html) — **versão navegável no navegador** (mesma doc, com busca e diagramas). Regenerar: `scripts/build-docs-html.ps1` |
| — | [modding/db.html](docs/modding/db.html) — **Explorador de Dados** (itens, npcs, receitas, drops, sellers, enchant, skills) gerado do datapack. Regenerar: `node scripts/build-db.mjs` |
| — | [modding/11_PIPELINE_EXEMPLOS.md](docs/modding/11_PIPELINE_EXEMPLOS.md) — **pipeline completo** (buffer, cap +HP/CP, tattoo cast speed) do zero ao teste |
| — | [custom/](custom/README.md) — **customizações versionadas** (itens/npcs/skills custom + spawns). Deploy: `scripts/deploy-custom.ps1` |

### QA / Matriz de testes

| Doc | Conteúdo |
|---|---|
| [Matriz completa](docs/testes/matriz.md) | Fases 0–15 (backlog) |
| [Ciclo 1](docs/testes/ciclo-1.md) | Checklist fundação |
| [Gate Fase 2](docs/testes/gate-fase2.md) | Go/No-go |
| [IDs de itens (GM)](docs/ITEMS.md) | create_item + itens no banco |
| [Comandos GM / spawn / TP](docs/ADMIN.md) | teleport, spawn bosses, grandboss |
| [Catálogo completo](docs/testes/items-catalog-full.md) | 9208 IDs do datapack |
| [Catálogo bosses](docs/testes/bosses-catalog.md) | Raid + Grand Boss NPC IDs |
| [Testes executados](docs/testes/testes-executados.md) | Log de resultados |
| [Bugs conhecidos](docs/testes/bugs-conhecidos.md) | S0–S5 |
| [Ambiente](docs/testes/ambiente.md) | Versões e commit Mobius |

### Configuração local (não versionada)

```powershell
copy config\database.local.env.example config\database.local.env
copy config\accounts.local.env.example config\accounts.local.env
```

## Stack

- JDK 25 (Temurin)
- Apache Ant 1.10.15
- MariaDB 12.3.2
- L2J Mobius Interlude (GitLab oficial)

## Status

- [x] Fase 1 — Definição técnica
- [x] Fase 2 — Ambiente local
- [x] Fase 3 — Source e build
- [x] Fase 4 — Banco de dados
- [x] Fase 5 — Configuração dos servidores
- [x] Fase 6 — Client limpo + contas
- [~] Ciclo 1 QA — baseline + smoke OK; **NO-GO** Fase 2 (ver [gate-fase2.md](docs/testes/gate-fase2.md))
- [ ] Fase 7 — MVP funcional / matriz Fases 2+
