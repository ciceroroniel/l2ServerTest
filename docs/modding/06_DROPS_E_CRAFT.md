# 06 — Drops e Craft

Como fazer mobs largarem itens (inclusive materiais custom) e como transformar esses
materiais em itens finais — por multisell ("troca") ou por recipe de verdade (dwarf).

## Parte 1 — Drops de mobs

Os drops ficam **dentro do próprio NPC**, no bloco `<dropLists>`
(`data/stats/npcs/*.xml`). Exemplo real (Gremlin, `20000-20099.xml`):

```xml
<dropLists>
    <drop>
        <group chance="70">
            <item id="57" min="30" max="42" chance="100" /> <!-- Adena -->
        </group>
        <group chance="25.7011">
            <item id="112" min="1" max="1" chance="30.9858" /> <!-- Apprentice's Earring -->
            <item id="116" min="1" max="1" chance="46.0093" /> <!-- Magic Ring -->
            <item id="118" min="1" max="1" chance="23.0049" /> <!-- Necklace of Magic -->
        </group>
        <group chance="6.6992">
            <item id="1864" min="1" max="1" chance="29.1259" /> <!-- Stem -->
            <item id="1788" min="1" max="1" chance="11.6506" /> <!-- Recipe: Bow -->
        </group>
    </drop>
</dropLists>
```

### Como ler isso (importante!)

O drop é em **dois estágios**:

1. **`<group chance="X">`** — primeiro sorteia se o grupo "cai" (X%).
2. **`<item ... chance="Y">`** — se o grupo caiu, sorteia **qual** item dele sai
   (as chances dos itens dentro do grupo somam ~100%; é uma escolha ponderada).

Então no exemplo: 25.70% de chance de cair uma jóia; se cair, é Magic Ring 46%,
Earring 31%, ou Necklace 23%.

| Atributo | Significado |
|---|---|
| `<group chance>` | Probabilidade do grupo ativar (%) |
| `<item id>` | Item que pode sair |
| `min` / `max` | Quantidade (sorteada entre min e max) |
| `<item chance>` | Peso do item **dentro** do grupo (%) |

> **Spoil** usa um bloco `<spoil>` no mesmo formato (drop por skill Spoil do dwarf).

### Adicionar um drop a um mob

Edite o `<dropLists>` do mob no datapack fonte. Ex.: fazer o Gremlin dropar seu
material custom (id 30500) a 15%:

```xml
<group chance="15">
    <item id="30500" min="1" max="2" chance="100" /> <!-- Fragmento Custom -->
</group>
```

Depois: `ant` (ou copiar) → `//reload` (npc) ou reiniciar.

> Para um item **sempre** dropar (ex.: evento), use `<group chance="100">` com um
> único `<item ... chance="100" />`.

## Parte 2 — Rates de drop (`config/Rates.ini`)

Os multiplicadores globais afetam TODOS os drops sem editar cada mob:

```ini
# Chance (probabilidade de cair)
DeathDropChanceMultiplier = 1
SpoilDropChanceMultiplier = 1
# Amount (quantidade quando cai)
DeathDropAmountMultiplier = 1
SpoilDropAmountMultiplier = 1
# Adena (via lista por item id; 57 = adena)
DropAmountMultiplierByItemId = 57,1;...
```

| Config | Efeito |
|---|---|
| `DeathDropChanceMultiplier` | Multiplica a **chance** de drop ao matar |
| `DeathDropAmountMultiplier` | Multiplica a **quantidade** dropada |
| `RateDropManor`, `Herb...`, `Raid...` | Variantes (manor, ervas, raid) |
| `DropAmountMultiplierByItemId` | Rate específico por item (formato `id,mult;...`) |

> ⚠️ Chance × Amount se multiplicam. Chance 5 + Amount 5 = **25x**. Cuidado.

## Parte 3 — Autoloot (`config/Player.ini`)

```ini
AutoLoot = False        # itens caem no chão (True = vão direto pro inventario)
AutoLootHerbs = False   # ervas
AutoLootRaids = False   # drops de raid
AutoLootItemIds = 0     # itens que NUNCA sao autoloot (lista de ids)
```

Servidores custom geralmente ligam `AutoLoot = True` para conforto.

## Parte 4 — Transformar material em item

Você tem duas formas de "craftar". Escolha conforme o objetivo.

### Opção A — Multisell (troca instantânea, sem skill)

Melhor para lojas de troca (ex.: "10 Fragmentos Custom → 1 Custom Blade"). Já
coberto em [04_NPCS_E_LOJAS.md](04_NPCS_E_LOJAS.md). Formato:

```xml
<item>
    <ingredient count="10" id="30500" /> <!-- Fragmento Custom -->
    <ingredient count="1000000" id="57" /> <!-- + adena -->
    <production count="1" id="30000" /> <!-- Custom Blade -->
</item>
```

Vantagens: simples, 100% datapack, sem precisar de dwarf/recipe book. É a forma
mais usada em servidores custom.

### Opção B — Recipe de verdade (dwarven craft, com skill e chance)

Craft "clássico": o dwarf aprende uma **recipe book** e craft com chance de sucesso.
Definido em `data/Recipes.xml`. Exemplo real:

```xml
<item id="4" recipeId="1788" name="mk_bow" craftLevel="1" type="dwarven" successRate="100">
    <ingredient id="1864" count="4" />
    <ingredient id="1869" count="2" />
    <production id="17" count="500" />
    <statUse name="MP" value="30" />
</item>
```

| Atributo | Significado |
|---|---|
| `id` | ID interno da recipe (único na lista) |
| `recipeId` | **ID do item "receita"** (a recipe book que o dwarf usa) |
| `name` | Nome interno |
| `craftLevel` | Nível de Create Item exigido |
| `type` | `dwarven` ou `common` |
| `successRate` | Chance de sucesso (%) |
| `<ingredient>` | Materiais consumidos |
| `<production>` | Item produzido |
| `<statUse>` | MP gasto por tentativa |

Parser: `data/xml/RecipeData.java`. O jogador precisa:
1. Ter o **item recipe** (o `recipeId`) — que você dá por drop/loja.
2. "Registrar" a recipe (duplo-clique) para aprendê-la.
3. Craftar via skill Create Item.

> Para uma recipe custom: crie o **item recipe book** (um `EtcItem` em stats/items),
> use o ID dele como `recipeId`, e defina ingredientes/produção. Distribua o book por
> drop ([Parte 1](#parte-1--drops-de-mobs)) ou loja.

### Quando usar qual

| Objetivo | Use |
|---|---|
| Loja de troca rápida, qualquer classe | **Multisell** |
| Craft com chance, exclusivo de dwarf, "economia" | **Recipe** |

## Receita completa — Material custom que vira arma

1. **Item material** (`stats/items`, EtcItem id 30500 "Fragmento Custom").
2. **Item final** (`stats/items`, Weapon id 30000 "Custom Blade") — ver [03](03_ITENS.md).
3. **Drop:** adicione o 30500 no `<dropLists>` de um mob (Parte 1).
4. **Craft:** multisell `10x 30500 → 1x 30000` (Opção A) OU recipe (Opção B).
5. **Loja/NPC** que abre o multisell — ver [04](04_NPCS_E_LOJAS.md).
6. `ant` → `//reload` ou reiniciar. Teste: mate o mob, junte 10, troque.

Passo a passo detalhado na receita 4 de [10_RECEITAS_PRATICAS.md](10_RECEITAS_PRATICAS.md).
