# IDs de itens — referência GM (Interlude / L2J Mobius)

Uso no jogo (conta GM):

```
//admin
//create_item <id> [quantidade]
```

Exemplos:

```
//create_item 57 1000000
//create_item 6364 1
//create_item 1467 5000
```

- Catálogo **completo** (9208 itens do datapack): [testes/items-catalog-full.md](testes/items-catalog-full.md)
- Fonte XML: `source/L2J_Mobius_CT_0_Interlude/dist/game/data/stats/items/`
- **Não** use Akamanah (`8689`) / Zariche (`8190`) para teste de persistência (armas amaldiçoadas — somem offline)

---

## Itens já existentes no seu banco (lab)

Snapshot do inventário atual (personagens no MariaDB):

| ID | Nome | Tipo | Qtd total | Loc |
|---:|---|---|---:|---|
| 6 | Apprentice's Wand | Weapon | 1 | INVENTORY |
| 10 | Dagger | Weapon | 1 | PAPERDOLL |
| 57 | Adena | EtcItem | 2147000043 | INVENTORY |
| 425 | Apprentice's Tunic | Armor | 1 | PAPERDOLL |
| 461 | Apprentice's Stockings | Armor | 1 | PAPERDOLL |
| 1146 | Squire's Shirt | Armor | 1 | PAPERDOLL |
| 1147 | Squire's Pants | Armor | 1 | PAPERDOLL |
| 2369 | Squire's Sword | Weapon | 1 | INVENTORY |
| 5588 | Tutorial Guide | EtcItem | 2 | INVENTORY |
| 6578 | Blessed Scroll: Enchant Armor (Grade S) | EtcItem | 1 | INVENTORY |
| 6704 | Sealed Imperial Crusader Boots Design | EtcItem | 37 | INVENTORY |

Para atualizar esta seção: consultar `SELECT DISTINCT item_id FROM items` e cruzar com o catálogo completo.

---

## Consumíveis úteis (lab / Ciclo 1)

| ID | Nome |
|---:|---|
| 57 | Adena |
| 1060 | Lesser Healing Potion |
| 1061 | Healing Potion |
| 1539 | Greater Healing Potion |
| 1540 | Quick Healing Potion |
| 728 | Mana Potion |
| 734 | Haste Potion |
| 735 | Potion of Alacrity |

## Soulshots / Spiritshots

| ID | Nome |
|---:|---|
| 1835 | Soulshot: No Grade |
| 1463 | Soulshot: D-grade |
| 1464 | Soulshot: C-grade |
| 1465 | Soulshot: B-grade |
| 1466 | Soulshot: A-grade |
| 1467 | Soulshot: S-grade |
| 2509 | Spiritshot: No Grade |
| 3947 | Blessed Spiritshot: No Grade |
| 3948 | Blessed Spiritshot: D-Grade |
| 3949 | Blessed Spiritshot: C-Grade |
| 3950 | Blessed Spiritshot: B-Grade |
| 3951 | Blessed Spiritshot: A-Grade |
| 3952 | Blessed Spiritshot: S Grade |

## Scrolls de enchant

| ID | Nome |
|---:|---|
| 955 | Scroll: Enchant Weapon (D) |
| 956 | Scroll: Enchant Armor (D) |
| 951 | Scroll: Enchant Weapon (C) |
| 952 | Scroll: Enchant Armor (C) |
| 947 | Scroll: Enchant Weapon (B) |
| 948 | Scroll: Enchant Armor (B) |
| 729 | Scroll: Enchant Weapon (A) |
| 730 | Scroll: Enchant Armor (A) |
| 959 | Scroll: Enchant Weapon (S) |
| 960 | Scroll: Enchant Armor (S) |
| 6577 | Blessed Scroll: Enchant Weapon (S) |
| 6578 | Blessed Scroll: Enchant Armor (S) |

## Armas (progressão / teste)

| ID | Nome | Nota |
|---:|---|---|
| 2499 | Elven Long Sword | Cedo |
| 75 | Caliburs | |
| 76 | Sword of Delusion | |
| 135 | Samurai Longsword | |
| 142 | Keshanberk | |
| 79 | Sword of Damascus | |
| 80 | Tallum Blade | |
| 81 | Dragon Slayer | |
| 6364 | Forgotten Blade | S |
| 6365 | Basalt Battlehammer | S |
| 6366 | Imperial Staff | S |
| 6367 | Angel Slayer | S |
| 7575 | Draconic Bow | S |

## Sets S (armor)

| ID | Nome |
|---:|---|
| 6373–6378 | Imperial Crusader (heavy) |
| 6379–6382 | Draconic Leather (light) |

| ID | Nome |
|---:|---|
| 6373 | Imperial Crusader Breastplate |
| 6374 | Imperial Crusader Gaiters |
| 6375 | Imperial Crusader Gauntlets |
| 6376 | Imperial Crusader Boots |
| 6377 | Imperial Crusader Shield |
| 6378 | Imperial Crusader Helmet |
| 6379 | Draconic Leather Armor |
| 6380 | Draconic Leather Gloves |
| 6381 | Draconic Leather Boots |
| 6382 | Draconic Leather Helmet |

## Boss jewels (teste)

| ID | Nome |
|---:|---|
| 6660 | Ring of Queen Ant |
| 6658 | Ring of Baium |
| 6659 | Earring of Zaken |
| 6656 | Earring of Antharas |
| 6657 | Necklace of Valakas |

## Cursed weapons (evitar em teste de persistência)

| ID | Nome |
|---:|---|
| 8190 | Demonic Sword Zariche |
| 8689 | Blood Sword Akamanah |

---

## Totais no datapack

| Tipo | Quantidade |
|---|---:|
| Weapon | 1221 |
| Armor | 1106 |
| EtcItem | 6881 |
| **Total** | **9208** |

Qualquer ID dessa faixa que exista no XML pode ser spawnado com `//create_item` (respeitando regras do servidor: weight, inventory slots, itens especiais).

## Dica no painel //admin

No HTML de admin do Mobius, o campo de item costuma pedir o **ID numérico** (não o nome). Use esta lista ou busque no catálogo completo com Ctrl+F pelo nome em inglês.
