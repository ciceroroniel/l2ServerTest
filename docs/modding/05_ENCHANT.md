# 05 — Sistema de Enchant

Como controlar enchant máximo, chances de sucesso por nível, scrolls normais/blessed/
crystal e como criar seu próprio esquema (ex.: enchant "fácil" até +25 com blessed
que não quebra o item).

## As peças do sistema

| Peça | Arquivo / Classe | Papel |
|---|---|---|
| Quais scrolls existem + enchant máx | `data/EnchantItemData.xml` | Define cada scroll (id, grade, maxEnchant) |
| Chances por nível de enchant | `data/EnchantItemGroups.xml` | % de sucesso conforme o +atual do item |
| Limite rígido de over-enchant | `config/Player.ini` (`DisableOverEnchanting`) | Impede passar do máximo |
| Abrir a janela ao usar scroll | `handlers/items/EnchantScrolls.java` | Só dispara a UI de seleção |
| Lógica de sucesso/falha | `network/clientpackets/RequestEnchantItem.java` | **Onde o resultado é decidido** |

## 1. `EnchantItemData.xml` — os scrolls e o teto

Cada `<enchant>` é um scroll. Exemplos reais:

```xml
<!-- Scrolls: Enchant Weapon -->
<enchant id="959" targetGrade="S" maxEnchant="16" />

<!-- Blessed Scrolls: Enchant Weapon -->
<enchant id="6577" targetGrade="S" maxEnchant="16" />

<!-- Crystal Scrolls: Enchant Weapon -->
<enchant id="961" targetGrade="S" bonusRate="100" />
```

| Atributo | Significado |
|---|---|
| `id` | ID do item scroll (tem que existir em `stats/items`) |
| `targetGrade` | Grade do item que ele pode enchantar (`D`,`C`,`B`,`A`,`S`) |
| `maxEnchant` | **Enchant máximo** que este scroll alcança (retail = 16) |
| `bonusRate` | Bônus de chance somado (usado nos crystal scrolls) |
| `scrollGroupId` | Qual grupo de chances usar (default `0`) |

> **Aumentar o enchant máximo:** troque `maxEnchant="16"` para `maxEnchant="25"`
> nos scrolls que quiser. Faça isso nos scrolls E ajuste as chances (próxima seção),
> senão de +16 pra cima a chance vira 0%.

Os três "sabores" de scroll (comportamento definido no código, ver seção 4):
- **Normal** (ex.: 959): falhou → **item quebra** (vira crystals).
- **Blessed** (ex.: 6577): falhou → **item preservado**, enchant volta a **+0**.
- **Crystal** (ex.: 961): falhou → **item preservado**, enchant **mantém** o valor.

## 2. `EnchantItemGroups.xml` — as chances por nível

Duas partes:

### a) Grupos de taxa (`<enchantRateGroup>`)

Definem a % de sucesso conforme o enchant **atual** do item:

```xml
<enchantRateGroup name="FIGHTER_WEAPON_GROUP">
    <current enchant="0-2" chance="100" />
    <current enchant="3-15" chance="66" />
    <current enchant="16-65535" chance="0" />
</enchantRateGroup>
```

Leitura: de +0 a +2 = 100% (enchant "seguro"), de +3 a +15 = 66%, de +16 pra cima = 0%.

### b) Amarração grupo→slot (`<enchantScrollGroup id="0">`)

Diz qual grupo se aplica a qual tipo de item:

```xml
<enchantScrollGroup id="0">
    <enchantRate group="ARMOR_GROUP"> ... slots de armadura ... </enchantRate>
    <enchantRate group="FIGHTER_WEAPON_GROUP">
        <item slot="rhand"  magicWeapon="false" />
        <item slot="lrhand" magicWeapon="false" />
    </enchantRate>
    <enchantRate group="MAGE_WEAPON_GROUP">
        <item slot="rhand"  magicWeapon="true" />
        <item slot="lrhand" magicWeapon="true" />
    </enchantRate>
</enchantScrollGroup>
```

Grupos existentes: `ARMOR_GROUP`, `FULL_ARMOR_GROUP`, `FIGHTER_WEAPON_GROUP`,
`MAGE_WEAPON_GROUP`.

> **Enchant seguro (safe enchant):** é a faixa `chance="100"`. No retail vai até +2/+3.
> Para dar "safe +4", mude `enchant="0-2"` para `enchant="0-4"`.

## 3. `Player.ini` — o teto rígido

```ini
# Impede enchantar acima do maxEnchant (só manda aviso).
DisableOverEnchanting = True
# Itens que nunca podem ser enchantados.
EnchantBlackList = 7816,7817,...
```

Se `DisableOverEnchanting = True`, o `maxEnchant` do `EnchantItemData.xml` é um teto
duro. Se `False`, o jogo tenta enchantar além (com a chance do grupo, que costuma
ser 0% acima do range → sempre falha). Mantenha `True` e controle pelo `maxEnchant`
+ chances.

## 4. Onde o resultado é decidido (código)

- `handlers/items/EnchantScrolls.java` → método `onItemUse`: só valida condições
  (não montado, não castando) e abre a janela `ChooseInventoryItem`. **Não decide
  sucesso.**
- `network/clientpackets/RequestEnchantItem.java`: recebe qual item o jogador
  escolheu, calcula a chance (via `EnchantItemGroupsData`), sorteia sucesso/falha e
  aplica o resultado (incrementa enchant, quebra o item, ou reseta pra +0).

Quer mudar **comportamento** (ex.: blessed que não reseta pra 0, mas mantém o +)?
É aqui em `RequestEnchantItem.java` que você mexe — depois `ant` + reiniciar.
Ver [08_CODIGO_FONTE.md](08_CODIGO_FONTE.md).

## Receita A — Enchant máximo +25 com chances customizadas

1. `EnchantItemData.xml`: nos scrolls desejados, `maxEnchant="25"`.
2. `EnchantItemGroups.xml`: estenda as faixas de chance, ex.:
   ```xml
   <enchantRateGroup name="FIGHTER_WEAPON_GROUP">
       <current enchant="0-4" chance="100" /> <!-- safe ate +4 -->
       <current enchant="5-15" chance="66" />
       <current enchant="16-20" chance="40" />
       <current enchant="21-25" chance="20" />
       <current enchant="26-65535" chance="0" />
   </enchantRateGroup>
   ```
3. `Player.ini`: mantenha `DisableOverEnchanting = True`.
4. `//reload` (enchant data) ou reiniciar. Teste com `//enchant` ou scrolls no jogo.

## Receita B — Blessed scroll custom que facilita enchant

Rota **só datapack** (sem tocar código):
1. Crie/reuse um scroll blessed em `EnchantItemData.xml` com `maxEnchant` alto e
   aponte pra um `scrollGroupId` de um grupo com chances generosas.
2. Crie um `<enchantRateGroup>` novo (ex.: `BLESSED_EASY`) com chances altas e um
   `<enchantScrollGroup id="1">` amarrando aos slots — e ponha `scrollGroupId="1"`
   no scroll blessed. Assim só o blessed usa as chances fáceis.

Rota **código** (comportamento diferente do retail, ex.: blessed nunca reseta): editar
`RequestEnchantItem.java`. Ver [10_RECEITAS_PRATICAS.md](10_RECEITAS_PRATICAS.md), receita 3.

## Cuidados

| Erro | Efeito |
|---|---|
| Aumentar `maxEnchant` sem estender as chances | Trava em 0% acima de +16 |
| `DisableOverEnchanting=False` achando que "libera" | Continua 0% acima do range → só falha |
| Editar em `server/` e não em `source/` | Perde no `ant` |
| Esquecer `//reload`/reiniciar | Mudança não aplica |
