# 10 — Receitas Práticas (ponta a ponta)

Quatro casos completos, do zero ao teste no jogo. Cada passo aponta para o doc
detalhado. **Regra sempre válida:** edite em `source/.../dist/game/**` (nunca só em
`server/`), depois `ant`/copiar → `//reload` ou reiniciar. Ver [01](01_ARQUITETURA.md).

Convenções de IDs usadas aqui (livres, altos, sem colisão retail):

| Coisa | ID |
|---|---|
| NPC loja custom | `50000` |
| Arma custom "Custom Blade" | `30000` |
| Material custom "Fragmento Custom" | `30500` |
| Buylist custom | `0050000` |
| Multisell custom | `50001` |

---

## Receita 1 — NPC loja que vende itens (inclusive grade S e custom)

**Objetivo:** um mercador que vende scrolls S, itens retail e seu item custom.

1. **Criar o NPC** — [04](04_NPCS_E_LOJAS.md#1-definição-do-npc-datastatsnpcsxml).
   Em `source/.../dist/game/data/stats/npcs/50000-50099-custom.xml`:
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <list xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="../../xsd/npcs.xsd">
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
   </list>
   ```
2. **Criar a buylist** `data/buylists/0050000.xml` — [04](04_NPCS_E_LOJAS.md#4-loja-de-venda--buylist-databuylistsxml):
   ```xml
   <list xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="../xsd/buylist.xsd">
       <npcs><npc>50000</npc></npcs>
       <item id="959" price="500000" />    <!-- Enchant Weapon S -->
       <item id="960" price="500000" />    <!-- Enchant Armor S -->
       <item id="30000" price="10000000" /> <!-- Custom Blade -->
   </list>
   ```
3. **Criar o HTML** `data/html/merchant/50000.htm`:
   ```html
   <html><body><center>Loja Custom</center><br>
   <a action="bypass npc_%objectId%_Buy 50000">Comprar itens</a>
   </body></html>
   ```
4. **Client:** adicione o ID 50000 em `npcname-e.dat`/`npcgrp.dat` (reuse aparência
   de um mercador retail) — [09](09_CLIENT_SIDE.md).
5. **Deploy:** `ant` (ou copiar os arquivos) → reiniciar (ou `//reload npc` +
   `//reload buylist` + `//reload htm`).
6. **Testar:** `//spawn 50000`, clique no NPC, compre.

---

## Receita 2 — Arma custom estilo "Vesper" (grade S)

**Objetivo:** arma custom forte, com visual reusado (rota segura sem mesh novo).
Lembre: no Interlude o topo é **grade S** — Vesper "de verdade" é de outra crônica,
então fazemos uma arma S custom com o nome/stats de Vesper. Ver [03](03_ITENS.md#caso-vesper-item-que-não-existe-no-interlude).

1. **Criar o item** em `data/stats/items/30000-30099-custom.xml`
   ([03](03_ITENS.md#criando-um-item-custom-passo-a-passo-lado-servidor)):
   ```xml
   <item id="30000" type="Weapon" name="Vesper Cutter">
       <set name="icon" val="icon.weapon_forgotten_blade_i00" /> <!-- reusa visual S -->
       <set name="default_action" val="EQUIP" />
       <set name="weapon_type" val="SWORD" />
       <set name="bodypart" val="rhand" />
       <set name="damage_range" val="0;0;40;120" />
       <set name="crystal_type" val="S" />
       <set name="material" val="STEEL" />
       <set name="weight" val="1600" />
       <set name="price" val="50000000" />
       <set name="enchant_enabled" val="true" />
       <stats>
           <stat type="pAtk">340</stat>
           <stat type="critRate">12</stat>
           <stat type="pAtkSpd">400</stat>
           <stat type="pAtkRange">40</stat>
       </stats>
   </item>
   ```
2. **Client:** adicione o ID 30000 no `itemname-e.dat` (nome "Vesper Cutter" +
   descrição) e no `weapongrp.dat` reusando o mesh/ícone da Forgotten Blade —
   [09](09_CLIENT_SIDE.md#caso-vesper-no-client-item-que-não-existe-no-interlude).
3. **Deploy:** `ant` → reiniciar o Game Server.
4. **Testar:** `//create_item 30000 1`, equipe, confira stats e visual.

> Quer o **visual real** da Vesper? Importe ícone/mesh/textura de uma crônica
> posterior e registre no `weapongrp.dat` (rota completa, mais arriscada) — [09](09_CLIENT_SIDE.md).

---

## Receita 3 — Enchant até +25 com blessed que facilita

**Objetivo:** subir o teto de enchant e ter um blessed scroll com chances generosas.
Ver [05](05_ENCHANT.md).

1. **Aumentar o teto** em `data/EnchantItemData.xml` — nos scrolls desejados,
   `maxEnchant="25"`. Ex.:
   ```xml
   <enchant id="959" targetGrade="S" maxEnchant="25" />
   <enchant id="6577" targetGrade="S" maxEnchant="25" scrollGroupId="1" /> <!-- blessed usa grupo facil -->
   ```
2. **Chances normais** em `data/EnchantItemGroups.xml` — estenda os ranges:
   ```xml
   <enchantRateGroup name="FIGHTER_WEAPON_GROUP">
       <current enchant="0-4" chance="100" />
       <current enchant="5-15" chance="66" />
       <current enchant="16-20" chance="40" />
       <current enchant="21-25" chance="20" />
       <current enchant="26-65535" chance="0" />
   </enchantRateGroup>
   ```
3. **Chances fáceis do blessed** — crie um grupo novo e um `<enchantScrollGroup id="1">`
   amarrando aos slots, com chances altas; aponte o scroll blessed a `scrollGroupId="1"`
   (passo 1). Ver [05](05_ENCHANT.md#receita-b--blessed-scroll-custom-que-facilita-enchant).
4. **Teto rígido** em `config/Player.ini`: `DisableOverEnchanting = True`.
5. **Comportamento** (opcional, só se quiser blessed que **não reseta pra 0** ao
   falhar): editar `network/clientpackets/RequestEnchantItem.java` e `ant` —
   [08](08_CODIGO_FONTE.md#pacotes-de-rede-onde-as-ações-acontecem-de-verdade).
6. **Deploy:** `//reload` (enchant) ou reiniciar. Teste com scrolls no jogo.

---

## Receita 4 — Mob dropa material → craft de item custom

**Objetivo:** um mob larga "Fragmento Custom"; junte 10 e troque por "Custom Blade".
Ver [06](06_DROPS_E_CRAFT.md).

1. **Material custom** em `data/stats/items/30500-30599-custom.xml`
   ([03](03_ITENS.md#exemplo-de-etcitem-material--o-que-você-vai-usar-para-custom)):
   ```xml
   <item id="30500" type="EtcItem" name="Fragmento Custom">
       <set name="icon" val="icon.etc_adena_i00" /> <!-- reusa icone -->
       <set name="weight" val="10" />
       <set name="price" val="0" />
       <set name="material" val="PAPER" />
   </item>
   ```
2. **Item final** = "Custom Blade" (id 30000) da Receita 2 (ou outro).
3. **Drop no mob** — no `<dropLists>` do mob escolhido (ex.: Gremlin em
   `20000-20099.xml`) — [06](06_DROPS_E_CRAFT.md#adicionar-um-drop-a-um-mob):
   ```xml
   <group chance="20">
       <item id="30500" min="1" max="2" chance="100" /> <!-- Fragmento Custom -->
   </group>
   ```
4. **Craft via multisell** `data/multisell/50001.xml`
   ([06](06_DROPS_E_CRAFT.md#opção-a--multisell-troca-instantânea-sem-skill)):
   ```xml
   <list xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="../xsd/multisell.xsd">
       <item>
           <ingredient count="10" id="30500" />
           <ingredient count="1000000" id="57" /> <!-- + adena -->
           <production count="1" id="30000" />
       </item>
   </list>
   ```
5. **Ligar ao NPC** (o da Receita 1): adicione no HTML dele:
   ```html
   <a action="bypass -h npc_%objectId%_multisell 50001">Craftar Custom Blade</a>
   ```
6. **Client:** nome/ícone do 30500 no `etcitemgrp.dat`/`itemname-e.dat` (ou reuse) —
   [09](09_CLIENT_SIDE.md).
7. **Deploy:** `ant`/copiar → `//reload` (npc, multisell) ou reiniciar.
8. **Testar:** mate o mob até juntar 10 fragmentos, fale com o NPC, craft.

---

## Checklist geral (vale para todas as receitas)

- [ ] Editei em `source/.../dist/game/**` (não só em `server/`)
- [ ] IDs livres e consistentes entre servidor e client
- [ ] Fiz `ant` (se mexi em Java) ou copiei os XML/HTML
- [ ] `//reload` (datapack) ou reiniciei (config/Java)
- [ ] Client atualizado (nome/ícone) se o item/NPC é novo
- [ ] Testei com comandos GM (`//spawn`, `//create_item`, `//reload`)
- [ ] Commitei o `source/` no git para não perder (ver `README.md`)

## Comandos GM úteis para testar

```
//spawn <npcId>          cria NPC
//create_item <id> <qtd> gera item
//loc                    coordenadas p/ spawn
//reload                 painel de reload
//enchant                testar enchant
```
