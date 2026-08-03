# Comandos GM (`//admin`) — além de itens

Sim: o painel `//admin` também **teleporta**, **spawna NPCs/mobs/bosses**, edita char, skills, siege, etc.  
Itens: [ITEMS.md](ITEMS.md) · Bosses: [testes/bosses-catalog.md](testes/bosses-catalog.md)

No chat, os comandos usam prefixo `//` (ex.: `//spawn_monster 29019`).

---

## Antharas no meio de Giran — sim, dá

1. Vá a Giran:
   ```
   //goto giran
   ```
2. Spawne o NPC do Antharas **na sua posição**:
   ```
   //spawn_monster 29019
   ```
   ou pelo menu: `//admin` → Spawn → campo ID `29019` → **Spawn** / **Spawn 1**.

### O que esperar

| Modo | Comando | Comportamento |
|---|---|---|
| **Spawn solto (lab/diversão)** | `//spawn_monster 29019` em Giran | Cria o bicho onde você está. Pode aggro/lutar; **não** é o ciclo oficial do nest (entrada, waiting, respawn AI). |
| **Ciclo oficial do boss** | `//goto antharas` + `//grandboss` / `//grandboss_respawn 29019` | Usa zona/AI do Antharas Nest — teste “de verdade” do raid. |

Para **sumir** com o spawn: mira no NPC → `//delete` (ou menu Delete).

IDs principais de Antharas: `29019` (clássico), também templates `29066` / `29067` / `29068` no datapack.

---

## Teleporte

| Comando | O que faz |
|---|---|
| `//goto giran` | Cidade (também: `aden`, `goddard`, `rune`, `heine`, …) |
| `//goto antharas` | Nest do Antharas |
| `//goto valakas` / `baium` / `queenant` / `core` / `orfen` / `zaken` / `frintezza` | Nests dos GBs |
| `//goto <nome_player>` | Até outro jogador online |
| `//move_to X Y Z` | Coordenadas exatas |
| `//recall <player>` | Traz o player até você |
| `//teleto` / instant move | Clique no chão para teleportar |
| `//admin` → Teleport menu | Lista HTML de destinos |

Cidades úteis: `giran`, `aden`, `gludio`, `dion`, `oren`, `hunter`, `goddard`, `rune`, `heine`, `schuttgart`, villages de raça (`ti`, `elf`, `darkelf`, `dwarf`, `orc`).

---

## Spawn de NPC / mob / boss

| Comando | Uso |
|---|---|
| `//spawn_monster <id> [qtd]` | Spawna na sua posição (aceita ID ou nome com `_`) |
| `//spawn_once <id>` | Spawn único (não fica no spawn table permanente) |
| `//spawn` | Abre menu Spawn |
| `//show_npcs` | Browser de NPCs |
| `//delete` | Remove NPC mirado |
| `//kill` | Mata o target |
| `//unspawnall` / `//respawnall` | Cuidado — afeta o mundo inteiro |

No HTML Spawn: campo **ID|name** + qty → botão Spawn.

Exemplos:

```
//spawn_monster 29001          # Queen Ant
//spawn_monster 29006          # Core
//spawn_monster 29014          # Orfen
//spawn_monster 29020          # Baium
//spawn_monster 29022          # Zaken
//spawn_monster 29028          # Valakas
//spawn_monster 29045          # Frintezza
//spawn_monster orc_fighter 5  # nome com underscore
```

Lista completa de Raid/Grand Boss: [testes/bosses-catalog.md](testes/bosses-catalog.md) (225 entradas).

---

## Grand Boss (menu dedicado)

```
//grandboss
//grandboss 29019
//grandboss_respawn 29019
//grandboss_skip 29019
//grandboss_abort 29019
```

Serve para status / respawn / skip da **AI oficial** (Antharas, Baium, etc.), não só “dropar o modelo em Giran”.

---

## Personagem / combate / utilidade

| Comando | Função |
|---|---|
| `//setlevel <n>` / Level menu | Level |
| `//heal` | Cura |
| `//res` | Revive |
| `//invul` | Invulnerável |
| `//gm` | Toggle modo GM |
| `//hide` | Invisível |
| `//gmspeed` | Velocidade GM |
| `//kick` / `//disconnect` | Kick |
| `//skill` menu | Dar skills |
| `//enchant` | Enchant no item equipado |
| `//create_item <id> [qtd] [ench]` | Itens (ver ITEMS.md) |
| `//cw` / cursed weapons | Zariche / Akamanah |
| `//ride` | Montaria |
| `//zone` | Info de zona |
| `//siege` | Castelos |
| `//olympiad` (se no menu) | Olympiad admin |
| `//reload <tipo>` | Recarregar datapack (cuidado) |
| `//shutdown` | Desligar Game Server |

Abra `//admin` e navegue pelos botões — quase tudo do Mobius está nos HTMLs em `data/html/admin/`.

---

## Grand Bosses — IDs rápidos

| NPC ID | Nome | `//goto` |
|---:|---|---|
| 29001 | Queen Ant | `queenant` |
| 29006 | Core | `core` |
| 29014 | Orfen | `orfen` |
| 29019 | Antharas | `antharas` |
| 29020 | Baium | `baium` |
| 29022 | Zaken | `zaken` |
| 29028 | Valakas | `valakas` |
| 29045 | Frintezza | `frintezza` |

---

## Avisos de lab

1. Spawnar GB em cidade é ótimo para **teste visual/combate**; para validar raid “de produto”, use o nest + `//grandboss_*`.
2. `//unspawnall` limpa o mapa — não use em sessão com outros jogadores sem avisar.
3. Sem geodata, pathfinding de bosses grandes pode ficar estranho (BUG-002).
4. Preferir `//spawn_once` para testes descartáveis.

## Fontes no source

- Teleport nomes: `.../admin/AdminGoto.java`
- Spawn: `.../admin/AdminSpawn.java` + `html/admin/spawn.htm`
- Grand Boss: `.../admin/AdminGrandBoss.java`
- Itens: `.../admin/AdminCreateItem.java`
