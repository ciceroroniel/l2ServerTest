# 02 — Estrutura de Pastas

Passeio comentado por cada pasta. Os caminhos abaixo são mostrados a partir do
runtime `server/game/` (o que roda), mas lembre: para editar de forma permanente,
use o espelho em `source/L2J_Mobius_CT_0_Interlude/dist/game/` (ver
[01_ARQUITETURA.md](01_ARQUITETURA.md)).

## Raiz do servidor (`server/`)

| Pasta | Função |
|---|---|
| `login/` | Login Server (autenticação, lista de servidores) |
| `game/` | Game Server (o mundo) — é aqui que você customiza |
| `libs/` | JARs compilados (`GameServer.jar`, `LoginServer.jar`) + dependências |
| `db_installer/` | Instalador do schema SQL |
| `backup/` | Backups automáticos do banco |

Quase tudo de customização está em `server/game/`.

## `server/game/config/` — Configurações

Arquivos `.ini` e `.xml` de ajuste. Os principais (detalhados em [07_CONFIGS.md](07_CONFIGS.md)):

| Arquivo | Controla |
|---|---|
| `Rates.ini` | Multiplicadores de XP/SP/Adena/Drop |
| `Server.ini` | Porta, `AutoCreateAccounts`, `AcceptNewGameServer` |
| `Player.ini` | Regras de personagem (inventário, enchant de skill, etc.) |
| `General.ini` | Diversos (autoloot, opções gerais) |
| `NPC.ini` | Comportamento de NPCs/mobs |
| `Rates.ini` / `PVP.ini` / `Olympiad.ini` | Rates, PvP, Olimpíada |
| `EnchantItemData.xml` | Quais scrolls existem e enchant máximo (fica em `data/`, não em config) |
| `Custom/` | 43 sistemas custom prontos (Premium, SchemeBuffer, Transmog, etc.) |
| `AccessLevels.xml` / `AdminCommands.xml` | Níveis de GM e permissões de comandos `//` |

## `server/game/data/` — O Datapack

O coração da customização. Estrutura:

```
data/
├── stats/            # Definições numéricas (o "banco de dados" em XML)
│   ├── items/        # Itens: armas, armaduras, materiais, scrolls (93 arquivos)
│   ├── npcs/         # NPCs e mobs, incluindo DROPS (82 arquivos)
│   ├── skills/       # Skills
│   ├── armorsets/    # Bônus de set de armadura
│   ├── augmentation/ # Augment (life stone)
│   ├── pets/         # Pets
│   └── players/      # Templates de classe
├── buylists/         # Lojas de VENDA (NPC vende por adena) — 616 arquivos
├── multisell/        # Lojas de TROCA / "craft" — 95 arquivos
├── spawns/           # Onde cada NPC nasce no mapa
├── html/             # Janelas de diálogo dos NPCs (HTML)
├── teleporters/      # Destinos dos gatekeepers
├── instances/        # Instâncias (dungeons privadas)
├── scripts/          # Lógica em "script" (Java compilado junto) — ver abaixo
├── EnchantItemData.xml       # Scrolls de enchant e enchant máximo
├── EnchantItemGroups.xml     # Chances de enchant por grupo
├── RecipeData.xml            # Receitas de craft (dwarf)
├── geodata/          # Colisão/pathfinding (vazio no MVP)
├── mapregion/        # Regiões do mapa
├── zones/            # Zonas (peace, pvp, water, etc.)
└── xsd/              # Schemas de validação dos XML (não editar)
```

### `data/stats/` em detalhe

- **`items/`** — arquivos nomeados por faixa de ID: `00000-00099.xml`,
  `00200-00299.xml`, etc. Cada `<item>` é uma arma/armadura/material.
  Ver [03_ITENS.md](03_ITENS.md).
- **`npcs/`** — também por faixa de ID: `20000-20099.xml` (mobs clássicos),
  `30000-30999` (NPCs de vila), `25000+` (raid bosses). Cada `<npc>` tem stats,
  skills, IA e o bloco `<dropLists>`. Ver [04](04_NPCS_E_LOJAS.md) e [06](06_DROPS_E_CRAFT.md).

### `data/scripts/` — Lógica do datapack

Scripts Java que são compilados junto e dão comportamento:

| Pasta | Conteúdo |
|---|---|
| `ai/` | Inteligência de NPCs (bosses, mobs especiais) |
| `quests/` | Todas as quests |
| `custom/` | Sistemas/NPCs custom (ex.: `SellBuff`, `Transmog`, `FakePlayers`) |
| `handlers/` | "Plugins" de comportamento (ver abaixo) |
| `events/` | Eventos automáticos |
| `village_master/` | NPCs de mudança de classe/clã |
| `conquerablehalls/` | Clan halls conquistáveis |

### `data/scripts/handlers/` — os "plugins"

| Pasta | O que faz |
|---|---|
| `items/` | O que acontece ao **usar** um item (poção, scroll de enchant, etc.) |
| `skill/` | Efeitos/lógica de skills |
| `actions/` | Ação ao clicar em algo (NPC, item no chão) |
| `bypass/` | Botões/links dentro das janelas HTML dos NPCs |
| `chat/` | Canais de chat |
| `punishments/` | Ban, jail, etc. |

## `server/game/data/html/` — Diálogos

HTML simples que aparece ao falar com um NPC. Ex.: o botão "Comprar" de um
mercador chama um `bypass` que abre uma buylist. Ver [04_NPCS_E_LOJAS.md](04_NPCS_E_LOJAS.md).

## Código-fonte (`source/.../java/org/l2jmobius/`)

| Pacote | Função |
|---|---|
| `gameserver/data/xml/` | **Parsers**: leem os XML do datapack (`ItemData`, `NpcData`, `BuyListData`, `MultisellData`, `EnchantItemData`...) |
| `gameserver/model/` | **Templates e objetos**: `item/`, `buylist/`, `multisell/`, `actor/` (Player, Npc), `skill/` |
| `gameserver/handler/` | Registro dos handlers |
| `gameserver/managers/` | Gerenciadores globais (spawn, olympiad, siege...) |
| `gameserver/network/` | Protocolo de rede (pacotes cliente↔servidor) |
| `gameserver/ai/` | IA base |
| `commons/` | Utilidades (banco, threads) |

Detalhes de classes/métodos em [08_CODIGO_FONTE.md](08_CODIGO_FONTE.md).

## Client (`C:\Users\Pandinha\L2\Interlude-Client\`)

| Pasta | Conteúdo |
|---|---|
| `system/` | `.dat` (nomes, grupos de item/npc/skill), `L2.exe`, `l2.ini` |
| `systextures/` / `textures/` | Texturas (`.utx`), inclui ícones |
| `animations/`, `staticmeshes/` | Modelos 3D (`.ukx`, `.usx`) |
| `maps/` | Mapas |

Ver [09_CLIENT_SIDE.md](09_CLIENT_SIDE.md).
