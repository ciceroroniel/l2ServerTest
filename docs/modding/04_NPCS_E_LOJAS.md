# 04 — NPCs, Spawns e Lojas

Como definir um NPC, fazer ele nascer no mapa, dar um diálogo e transformá-lo numa
loja que vende itens (buylist) ou troca itens (multisell / "craft").

## Visão geral do fluxo de um NPC-mercador

```mermaid
flowchart LR
  tmpl["stats/npcs/*.xml (define o NPC)"] --> spawn["spawns/*.xml (faz nascer)"]
  spawn --> click["Jogador clica no NPC"]
  click --> html["html/<pasta>/<id>.htm (dialogo)"]
  html -->|"bypass _Buy 383"| buy["buylists/383.xml (vende)"]
  html -->|"bypass _multisell 001"| multi["multisell/001.xml (troca/craft)"]
```

## 1. Definição do NPC (`data/stats/npcs/*.xml`)

Arquivos por faixa de ID. Exemplo real de mob (de `20000-20099.xml`):

```xml
<npc id="20001" level="1" type="Monster" name="Gremlin">
    <race>FAIRY</race>
    <sex>MALE</sex>
    <acquire exp="29" sp="2" />
    <stats str="40" int="21" dex="30" wit="20" con="43" men="10">
        <vitals hp="39.74" hpRegen="2" mp="40" mpRegen="0.9" />
        <attack physical="8.47" magical="5.78" critical="4" attackSpeed="253" type="SWORD" range="40" />
        <defence physical="44.4" magical="29.5" />
        <speed><walk ground="20" /><run ground="50" /></speed>
    </stats>
    <skillList>
        <skill id="4416" level="13" />
    </skillList>
    <ai aggroRange="1000" isAggressive="false" />
    <collision><radius normal="10" /><height normal="15" /></collision>
</npc>
```

### Atributos e blocos principais

| Elemento | Função |
|---|---|
| `id` | ID único do NPC (mesmo no client, `npcname-e.dat`) |
| `type` | **Comportamento**: `Monster`, `Merchant`, `Teleporter`, `Warehouse`, `Npc` (parado), `RaidBoss`, `Pet`... |
| `name` | Nome interno |
| `<acquire exp sp>` | XP/SP que o mob dá ao morrer |
| `<stats>` | HP/MP, ataque, defesa, velocidade |
| `<skillList>` | Skills do NPC (inclui skills "passivas" de raça/tipo) |
| `<ai>` | Agressividade, alcance de aggro |
| `<dropLists>` | O que larga ao morrer (ver [06_DROPS_E_CRAFT.md](06_DROPS_E_CRAFT.md)) |
| `<collision>` | Tamanho físico |

> O `type` é o que decide a **classe Java** que controla o NPC. Para uma loja você
> vai querer `type="Merchant"`.

## 2. Fazer o NPC nascer (`data/spawns/*.xml`)

Definir o NPC não o coloca no mundo — é preciso um spawn. Exemplo real
(`spawns/Aden/AdenNPCs.xml`):

```xml
<list enabled="true" ...>
    <spawn name="AdenNPCs">
        <npc id="30857" x="147456" y="22576" z="-1989" heading="16384" respawnDelay="60" />
    </spawn>
</list>
```

| Atributo | Significado |
|---|---|
| `id` | ID do NPC (do `stats/npcs`) |
| `x` `y` `z` | Coordenadas no mundo |
| `heading` | Direção que ele olha (0–65535) |
| `respawnDelay` | Segundos até renascer (para mobs) |

> Para pegar coordenadas: entre no jogo como GM e use `//loc` (mostra x/y/z/heading
> onde você está). Ou spawne rápido com `//spawn <npcId>` para testar sem editar XML.

## 3. Diálogo do NPC (`data/html/`)

Ao clicar num NPC do tipo que abre janela, o servidor procura um HTML. O nome
padrão é `data/html/<pasta_do_tipo>/<npcId>.htm` (ou `<npcId>-1.htm` para páginas).

Exemplo real (`html/adventurer_guildsman/31732-1.htm`):

```html
<html><body><center>Use Life Crystals</center><br>
<a action="bypass -h npc_%objectId%_multisell 317325002">Craft Adventurer's Box.</a><br>
<a action="bypass npc_%objectId%_Link adventurer_guildsman/AboutHighLevelGuilds.htm">Ask about higher level crafting</a>
</body></html>
```

### Sintaxe dos bypass (os "botões")

| Bypass | Abre |
|---|---|
| `npc_%objectId%_Buy <buylistId>` | Uma **loja de venda** (buylist) |
| `npc_%objectId%_multisell <multisellId>` | Uma **loja de troca/craft** (multisell) |
| `npc_%objectId%_Link <arquivo.htm>` | Outra página HTML |
| `npc_%objectId%_Chat <n>` | A página `<npcId>-<n>.htm` |

`%objectId%` é substituído automaticamente pelo ID da instância do NPC no mundo.

## 4. Loja de VENDA — Buylist (`data/buylists/*.xml`)

Vende itens por adena. O **nome do arquivo é o ID da buylist**. Exemplo real
(`buylists/0000383.xml`):

```xml
<list ...>
    <npcs>
        <npc>31373</npc> <!-- Atan: NPCs que podem abrir esta loja -->
    </npcs>
    <item id="1835" price="8" />   <!-- Soulshot: No Grade -->
    <item id="2509" price="18" />  <!-- Spiritshot: No Grade -->
    <item id="17"   price="2" />   <!-- Wooden Arrow -->
</list>
```

| Elemento | Função |
|---|---|
| `<npcs><npc>ID</npc></npcs>` | Quais NPCs têm acesso a esta loja (segurança) |
| `<item id price />` | Item vendido e por quanto de adena |
| `count` / `restock_delay` | (opcional) estoque limitado que repõe com o tempo |

Parser: `data/xml/BuyListData.java` → modelo `model/buylist/`.

> **Vender até grade S / itens custom:** basta listar os IDs. Ex.: adicionar
> `<item id="959" price="500000" />` (Enchant Weapon S) ou `<item id="30000" price="10000000" />`
> (seu item custom).

## 5. Loja de TROCA / "Craft" — Multisell (`data/multisell/*.xml`)

Multisell = "dê estes itens, receba aqueles". É como se faz **craft simples** sem
skill de dwarf. O nome do arquivo é o ID. Exemplo real (`multisell/001.xml`):

```xml
<list ...>
    <item>
        <ingredient count="2100" id="57" /> <!-- Adena -->
        <ingredient count="1" id="21" />    <!-- Shirt -->
        <production count="1" id="22" />     <!-- Leather Shirt -->
    </item>
</list>
```

| Elemento | Função |
|---|---|
| `<ingredient count id />` | O que o jogador **paga** (pode ter vários) |
| `<production count id />` | O que ele **recebe** |

Atributos úteis no `<list ...>`: `maintainEnchantment="true"` (mantém enchant),
`applyTaxes`, `isChanceMultisell`.

Parser: `data/xml/MultisellData.java` → modelo `model/multisell/`.

> **"Craft" de material custom em item:** crie um multisell onde os ingredientes são
> seus materiais custom e a produção é o item final. Ver [06_DROPS_E_CRAFT.md](06_DROPS_E_CRAFT.md).

## Receita: NPC loja custom que vende até S / itens custom

1. **Criar o NPC** em `source/.../dist/game/data/stats/npcs/` (arquivo custom, ex.:
   `50000-50099-custom.xml`):
   ```xml
   <npc id="50000" level="70" type="Merchant" name="Custom Shop">
       <race>HUMAN</race><sex>MALE</sex>
       <stats str="40" int="21" dex="30" wit="20" con="43" men="10">
           <vitals hp="3000" mp="1500" />
           <attack physical="10" magical="10" attackSpeed="253" type="FIST" range="40" />
           <defence physical="100" magical="100" />
           <speed><walk ground="50" /><run ground="120" /></speed>
       </stats>
       <collision><radius normal="8" /><height normal="23" /></collision>
   </npc>
   ```
2. **Criar a buylist** em `data/buylists/0050000.xml` ligada a esse NPC:
   ```xml
   <list ...>
       <npcs><npc>50000</npc></npcs>
       <item id="959" price="500000" />   <!-- Enchant Weapon S -->
       <item id="30000" price="10000000" /> <!-- seu item custom -->
   </list>
   ```
3. **Criar o HTML** `data/html/merchant/50000.htm`:
   ```html
   <html><body><center>Loja Custom</center><br>
   <a action="bypass npc_%objectId%_Buy 50000">Comprar itens</a>
   </body></html>
   ```
4. **Spawnar** o NPC (edite um `spawns/*.xml` ou use `//spawn 50000` para testar).
5. **Client:** adicione o ID 50000 no `npcname-e.dat`/`npcgrp.dat` para nome/aparência
   (senão fica genérico). Ver [09_CLIENT_SIDE.md](09_CLIENT_SIDE.md).
6. **Build + reiniciar**, ou testar em runtime com `//reload` (buylist/multisell/npc).

## Comandos de teste (GM)

```
//spawn 50000        cria o NPC onde você está
//loc                mostra coordenadas para o spawn XML
//reload             painel de reload (npc, buylist, multisell...)
```
