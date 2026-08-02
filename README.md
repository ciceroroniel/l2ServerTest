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
- [x] Fase 6 — Client e primeiro login (contas prontas; client pendente)
- [ ] Fase 7 — MVP funcional
