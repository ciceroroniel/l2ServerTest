# Guia de Customização — L2J Mobius Interlude

Documentação minuciosa para customizar o servidor: do macro (estrutura de pastas)
ao micro (arquivo, classe, método), sempre com exemplos reais do **seu** servidor
e receitas de ponta a ponta.

> Feito para quem é programador mas nunca mexeu em L2J. Leia na ordem.

## Ordem de leitura

| # | Documento | O que você aprende |
|---|---|---|
| 1 | [01_ARQUITETURA.md](01_ARQUITETURA.md) | Como o servidor é montado, fluxo de boot, onde editar |
| 2 | [02_ESTRUTURA_PASTAS.md](02_ESTRUTURA_PASTAS.md) | O que cada pasta e arquivo faz (datapack, config, código) |
| 3 | [03_ITENS.md](03_ITENS.md) | Criar/editar itens (armas, armaduras, materiais) |
| 4 | [04_NPCS_E_LOJAS.md](04_NPCS_E_LOJAS.md) | NPCs, spawns, lojas (buylist) e trocas/craft (multisell) |
| 5 | [05_ENCHANT.md](05_ENCHANT.md) | Enchant máximo, chances, blessed scrolls |
| 6 | [06_DROPS_E_CRAFT.md](06_DROPS_E_CRAFT.md) | Drops de mobs e transformar material em item |
| 7 | [07_CONFIGS.md](07_CONFIGS.md) | Todos os `.ini` de customização (rates, custom, etc.) |
| 8 | [08_CODIGO_FONTE.md](08_CODIGO_FONTE.md) | Mapa do código Java para modders |
| 9 | [09_CLIENT_SIDE.md](09_CLIENT_SIDE.md) | Editar o client (nomes, ícones, meshes) |
| 10 | [10_RECEITAS_PRATICAS.md](10_RECEITAS_PRATICAS.md) | 4 casos completos passo a passo |
| 11 | [11_PIPELINE_EXEMPLOS.md](11_PIPELINE_EXEMPLOS.md) | Pipeline completo até o teste: NPC buffer, cap +10% HP/CP, tattoo de cast speed |

## A regra de ouro (leia antes de tudo)

O servidor que roda fica em `server/game/`, mas **essa pasta é gerada pelo build
e é descartável** (está no `.gitignore`). Se você editar direto nela, **perde tudo
no próximo `ant`**.

> **Sempre edite o datapack FONTE:**
> `source/L2J_Mobius_CT_0_Interlude/dist/game/data/**`
> e o código em `source/L2J_Mobius_CT_0_Interlude/java/**`.
> Depois rode `ant` (ou copie o arquivo pra `server/`) e, no jogo, `//reload`.

Isso está detalhado em [01_ARQUITETURA.md](01_ARQUITETURA.md).

## Glossário / palavras-chave

| Termo | Significado |
|---|---|
| **Datapack** | Os dados do jogo em XML/HTML (itens, npcs, lojas, drops). Não é código. |
| **Item template** | A definição de um item (`data/stats/items/*.xml`), carregada por `ItemData.java`. |
| **NPC template** | A definição de um NPC/mob (`data/stats/npcs/*.xml`), carregada por `NpcData.java`. |
| **Buylist** | Loja onde o NPC **vende** itens por adena (`data/buylists/*.xml`). |
| **Multisell** | Loja de **troca**: dá X itens, recebe Y (serve como "craft") (`data/multisell/*.xml`). |
| **Droplist** | Bloco `<dropLists>` dentro do NPC: o que o mob larga ao morrer. |
| **Recipe** | Receita de crafting real via skill de Create Item (`data/RecipeData.xml`). |
| **Handler** | Pequeno "plugin" que dá comportamento a um item/skill/comando (`data/scripts/handlers/**`). |
| **Parser (`*Data.java`)** | Classe Java que lê um XML no boot e cria os objetos em memória. |
| **`//reload`** | Comando GM que recarrega dados sem reiniciar o servidor. |
| **grade / crystal_type** | Grau do item: NG, D, C, B, A, **S** (o topo no Interlude). |

## IDs importantes (referência rápida)

| Item | ID |
|---|---|
| Adena | `57` |
| Scroll: Enchant Weapon S | `959` |
| Scroll: Enchant Armor S | `960` |
| Blessed Enchant Weapon S | `6577` |
| Blessed Enchant Armor S | `6578` |

> Faixa recomendada para **itens custom**: use IDs altos e livres, ex.: a partir de
> `30000`/`50000`, para não colidir com itens retail (ver [03_ITENS.md](03_ITENS.md)).
