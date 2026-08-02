# 03 — Itens

Tudo sobre criar e editar itens: armas, armaduras, materiais, scrolls. Este é o
tópico base para lojas custom, drops custom e itens novos (tipo Vesper).

## Onde ficam

| Camada | Caminho |
|---|---|
| Datapack (editar aqui) | `source/.../dist/game/data/stats/items/*.xml` |
| Runtime (gerado) | `server/game/data/stats/items/*.xml` |
| Parser (código) | `.../gameserver/data/xml/ItemData.java` |
| Templates (código) | `.../gameserver/model/item/` |

Os arquivos são divididos por faixa de ID: `00000-00099.xml`, `00200-00299.xml`, etc.
O item vai no arquivo cuja faixa contém o ID dele.

## Anatomia de um item (exemplo real de arma)

De `data/stats/items/00200-00299.xml`:

```xml
<item id="200" type="Weapon" name="Sage's Staff">
    <set name="icon" val="icon.weapon_sages_staff_i00" />
    <set name="default_action" val="EQUIP" />
    <set name="weapon_type" val="BLUNT" />
    <set name="bodypart" val="lrhand" />
    <set name="damage_range" val="0;0;46;120" />
    <set name="crystal_count" val="1720" />
    <set name="crystal_type" val="C" />
    <set name="material" val="WOOD" />
    <set name="weight" val="1000" />
    <set name="price" val="4300000" />
    <set name="soulshots" val="3" />
    <set name="spiritshots" val="3" />
    <set name="enchant_enabled" val="true" />
    <set name="is_magic_weapon" val="true" />
    <stats>
        <stat type="pAtk">135</stat>
        <stat type="mAtk">111</stat>
        <stat type="critRate">4</stat>
        <stat type="pAtkSpd">325</stat>
        <stat type="pAtkRange">40</stat>
    </stats>
</item>
```

### Atributos do `<item>`

| Atributo | Significado |
|---|---|
| `id` | ID único (servidor E client usam o mesmo) |
| `type` | `Weapon`, `Armor` ou `EtcItem` (define a classe usada, ver abaixo) |
| `name` | Nome interno (o nome exibido vem do client, ver [09](09_CLIENT_SIDE.md)) |

### Tags `<set name="..." val="..." />` (as mais usadas)

| `name` | O que faz |
|---|---|
| `icon` | Ícone (referência a uma textura do client) |
| `default_action` | O que o duplo-clique faz: `EQUIP`, `SKILL_REDUCE` (poção), etc. |
| `weapon_type` | `SWORD`, `BLUNT`, `BOW`, `DAGGER`, `DUAL`, etc. (só arma) |
| `bodypart` | Onde equipa: `rhand`, `lrhand` (duas mãos), `chest`, `legs`, `head`... |
| `damage_range` | Alcance/ângulo de dano da arma |
| `crystal_type` | **Grade**: `NONE`, `D`, `C`, `B`, `A`, `S` (topo do Interlude) |
| `crystal_count` | Quantos crystals ao quebrar (crystallize) |
| `material` | `STEEL`, `FINE_STEEL`, `WOOD`, `MITHRIL`... (afeta som/aparência) |
| `weight` | Peso (afeta carga do inventário) |
| `price` | Preço-base (usado por lojas e venda a NPC) |
| `soulshots` / `spiritshots` | Quantos shots consome por golpe |
| `enchant_enabled` | Se pode ser enchantado (`true`/`false`) |
| `is_magic_weapon` | Arma mágica (usa spiritshots como principal) |

### `<stats>` (atributos numéricos)

| `type` | Significado |
|---|---|
| `pAtk` / `mAtk` | Ataque físico / mágico |
| `pDef` / `mDef` | Defesa (para armaduras) |
| `critRate` | Chance de crítico |
| `pAtkSpd` | Velocidade de ataque |
| `pAtkRange` | Alcance |
| `randomDamage` | Variação de dano |

## Os tipos e as classes (código)

O atributo `type` do XML decide qual classe Java representa o item:

| `type` no XML | Classe (`model/item/`) | Uso |
|---|---|---|
| `Weapon` | `Weapon.java` | Armas |
| `Armor` | `Armor.java` | Armaduras, jóias, escudos |
| `EtcItem` | `EtcItem.java` | Materiais, scrolls, poções, recipes, "quest items" |

Todas herdam de **`ItemTemplate.java`** (a definição imutável). Quando o item
existe de verdade (no inventário/chão), ele é uma instância de
**`model/item/instance/Item.java`** (guarda dono, quantidade, enchant atual).

Enums úteis em `model/item/type/`:
- `CrystalType` — os graus (NONE→S). É o que amarra o item às regras de enchant.
- `WeaponType`, `ArmorType`, `MaterialType`, `EtcItemType`, `ActionType`.

### Parser: `ItemData.java`

No boot, `ItemData.load()` lê todos os `stats/items/*.xml`, cria um `Weapon`/
`Armor`/`EtcItem` por `<item>` e guarda num mapa por ID. O resto do servidor pega
o template com `ItemData.getInstance().getTemplate(itemId)`.

## Exemplo de EtcItem (material) — o que você vai usar para custom

Materiais/scrolls são `EtcItem`. Formato típico:

```xml
<item id="1864" type="EtcItem" name="Stem">
    <set name="icon" val="icon.etc_raw_material_stem_i00" />
    <set name="weight" val="90" />
    <set name="price" val="24" />
    <set name="material" val="LIQUID" />
</item>
```

Para um **material custom** (ex.: "Fragmento Custom" que dropa de mob e serve de
ingrediente de craft), basta um `EtcItem` novo com um ID livre. Ver
[06_DROPS_E_CRAFT.md](06_DROPS_E_CRAFT.md).

## Criando um item custom (passo a passo, lado servidor)

1. **Escolha um ID livre.** Para não colidir com retail, use IDs altos, ex.: a
   partir de `30000`. (IDs retail do Interlude vão até ~`22000` em itens comuns.)
2. **Escolha o arquivo** pela faixa. Como não existe `30000-30099.xml` por padrão,
   crie um novo arquivo XML nessa pasta (o `ItemData` lê todos os `*.xml` da pasta)
   ou adicione a um arquivo existente. Recomendo criar
   `source/.../dist/game/data/stats/items/30000-30099-custom.xml`:

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <list xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="../../xsd/items.xsd">
       <item id="30000" type="Weapon" name="Custom Blade">
           <set name="icon" val="icon.weapon_long_sword_i00" /> <!-- reusa icone existente -->
           <set name="default_action" val="EQUIP" />
           <set name="weapon_type" val="SWORD" />
           <set name="bodypart" val="rhand" />
           <set name="damage_range" val="0;0;40;120" />
           <set name="crystal_type" val="S" />
           <set name="material" val="STEEL" />
           <set name="weight" val="1600" />
           <set name="price" val="10000000" />
           <set name="enchant_enabled" val="true" />
           <stats>
               <stat type="pAtk">300</stat>
               <stat type="critRate">12</stat>
               <stat type="pAtkSpd">400</stat>
               <stat type="pAtkRange">40</stat>
           </stats>
       </item>
   </list>
   ```
3. **Build/deploy:** `ant` (ou copie o arquivo pra `server/game/data/stats/items/`).
4. **Reiniciar** o Game Server (itens não têm `//reload` isolado confiável; reinicie).
5. **Testar:** `//create_item 30000 1`.

> Nesse exemplo reusamos o ícone `icon.weapon_long_sword_i00`, então funciona sem
> mexer no client. O nome "Custom Blade" só aparece de verdade se você adicionar o
> ID 30000 no `itemname-e.dat` do client — senão aparece o nome interno/placeholder.
> Ver [09_CLIENT_SIDE.md](09_CLIENT_SIDE.md).

## Caso "Vesper" (item que NÃO existe no Interlude)

Vesper é de crônicas posteriores. No Interlude o topo é **grade S** (Icarus/Dynasty
não existem). Você tem duas rotas:

1. **Vesper "de mentira" (rápido):** criar um item custom grade S com stats de
   Vesper e **reusar visual existente** (ícone e mesh de uma arma S atual, ex.:
   Draconic Bow / Forgotten Blade). É só servidor + `itemname-e.dat` no client.
2. **Vesper "de verdade" (visual novo):** importar ícone, mesh e textura da Vesper
   para o client e referenciá-los. É a rota completa client-side, detalhada em
   [09_CLIENT_SIDE.md](09_CLIENT_SIDE.md) e na receita 2 de [10_RECEITAS_PRATICAS.md](10_RECEITAS_PRATICAS.md).

## Erros comuns

| Sintoma | Causa | Correção |
|---|---|---|
| Item some depois do `ant` | Editou em `server/` em vez de `source/` | Editar no datapack fonte |
| Item sem nome/ícone no client | ID não existe no client | Adicionar no `itemname-e.dat`/grp (doc 09) |
| Item não aparece com `//create_item` | XML inválido / não recarregado | Validar XML e reiniciar |
| Grade errada / não enchanta | `crystal_type` incorreto ou `enchant_enabled=false` | Corrigir os `<set>` |
