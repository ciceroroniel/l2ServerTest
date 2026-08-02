# 07 — Configurações (`config/`)

Referência dos arquivos de configuração do Game Server. Editar `.ini` é a forma
mais rápida de customizar (rates, sistemas prontos) **sem tocar em código**.

> Edite no fonte `source/.../dist/game/config/**`. Quase toda mudança de `.ini`
> exige **reiniciar** o Game Server (não há `//reload` para a maioria das configs).

## Configs principais (`config/*.ini`)

| Arquivo | Controla | Chaves que você mais vai mexer |
|---|---|---|
| `Rates.ini` | Multiplicadores de progressão/drop | `RateXp`, `RateSp`, `RateDropManor`, `DeathDropChanceMultiplier`, `DeathDropAmountMultiplier` |
| `Server.ini` | Rede/servidor, criação de conta | `GameserverPort`, `AutoCreateAccounts`, `MaximumOnlineUsers` |
| `Player.ini` | Regras de personagem | `AutoLoot`, `EnchantBlackList`, `DisableOverEnchanting`, `MaximumSlotsForNoDwarf`, `StoreSkillCooltime` |
| `General.ini` | Diversos globais | opções de mundo, drops no chão, GM |
| `NPC.ini` | Comportamento de NPC/mob | aggro, spawn, view, buffs de mob |
| `PVP.ini` | Regras de PvP/PK | tempo de flag, karma, drop em PK |
| `Olympiad.ini` | Olimpíada | período, pontos, recompensas |
| `Siege.ini` / `ConquerableHallSiege.ini` | Cercos | horários, regras |
| `GrandBoss.ini` | Grand bosses | respawn de Antharas/Baium/etc. |
| `Feature.ini` | Recursos de clã/fortaleza | manor, clan hall, fortaleza |
| `FloodProtector.ini` | Anti-flood | limites de ações por segundo |
| `GeoEngine.ini` | Geodata | pathfinding, line of sight |
| `Network.ini` | Rede baixa | buffers, timeouts |
| `Threads.ini` | Pools de threads | performance |
| `IdManager.ini` | Gestão de IDs de objeto | avançado |
| `Development.ini` | Debug/dev | logs, debug de pacotes |
| `Interface.ini` | GUI do servidor | `EnableGUI` (você usa `False`, headless) |
| `Database.ini` | Conexão MariaDB | `URL`, `Login`, `Password` |

## Configs em XML (`config/*.xml`)

| Arquivo | Função |
|---|---|
| `AccessLevels.xml` | Define os níveis de GM (o `accesslevel` do personagem no banco). O 100 = admin full |
| `AdminCommands.xml` | Qual `accesslevel` pode usar cada comando `//` |
| `ClassMaster.xml` | Regras do NPC de mudança de classe (útil para servidor "auto-class") |
| `DynamicExpRates.xml` | XP variável por faixa de nível |
| `ipconfig.xml` | IP que o servidor anuncia (você usa `127.0.0.1` local) |
| `Scripts.xml` | Quais scripts/handlers são carregados |
| `SiegeSchedule.xml` | Agenda de cercos |

> `AccessLevels.xml` + `AdminCommands.xml` são o que fazem o `//admin` funcionar.
> Ver `docs/COMANDOS_BANCO.md` para o lado do banco (`characters.accesslevel`).

## `config/Custom/` — Sistemas prontos (só ligar/ajustar)

O Mobius já traz 43 sistemas custom. Cada `.ini` costuma ter um `Enable...=True/False`
no topo. Os mais úteis para o seu tipo de servidor:

| Arquivo | O que habilita |
|---|---|
| `PremiumSystem.ini` | Conta premium com rates próprios de XP/drop/adena |
| `SchemeBuffer.ini` | NPC buffer com esquemas salvos (buff em 1 clique) |
| `SellBuffs.ini` | Jogadores vendem buffs a outros |
| `AutoPlay.ini` | Auto-farm/auto-caça (bot oficial estilo "macro") |
| `AutoPotions.ini` | Uso automático de poções HP/MP |
| `Transmog.ini` | Aparência de um item sobre outro (skin) |
| `ChampionMonsters.ini` | Mobs "campeões" com mais HP/drop |
| `CommunityBoard.ini` | Painel Alt+B (loja, buffer, teleport na UI) |
| `OfflineTrade.ini` | Loja offline (personagem fica vendendo deslogado) |
| `OfflinePlay.ini` | Continuar farmando offline |
| `FactionSystem.ini` | Duas facções em guerra |
| `PvpRewardItem.ini` | Item por PvP kill |
| `PvpTitleColor.ini` / `PvpAnnounce.ini` | Cor de título/anúncio por PvP |
| `ClassBalance.ini` | Ajuste fino de dano por classe |
| `NpcStatMultipliers.ini` | Multiplica HP/dano de mobs globalmente |
| `RandomSpawns.ini` | Varia posição de spawn dos mobs |
| `StartingLocation.ini` | Onde novos personagens nascem |
| `StartingTitle.ini` | Título inicial |
| `Wedding.ini` | Sistema de casamento |
| `Banking.ini` | Troca adena↔goldbar por comando |
| `Captcha.ini` / `WalkerBotProtection.ini` | Anti-bot |
| `DualboxCheck.ini` | Limita janelas por IP |
| `ScreenWelcomeMessage.ini` | Mensagem de boas-vindas na tela |
| `FakePlayers.ini` | "Jogadores" fake para dar movimento ao servidor |
| `MultilingualSupport.ini` | Suporte a múltiplos idiomas de client |
| `FreeMounts.ini`, `NoblessMaster.ini`, `DelevelManager.ini`, `WarehouseSorting.ini`, `PrivateStoreRange.ini`, `MerchantZeroSellPrice.ini`, `AllowedPlayerRaces.ini`, `CancelReturn.ini`, `FindPvP.ini`, `OnlineInfo.ini`, `ServerTime.ini`, `PasswordChange.ini`, `ChatModeration.ini`, `CustomMailManager.ini`, `BossAnnouncements.ini` | Conveniências diversas — abra o `.ini` para ver as chaves |

### Como ativar um sistema custom

1. Abra o `.ini` em `source/.../dist/game/config/Custom/`.
2. Mude `Enable...=False` para `True` e ajuste as chaves.
3. Confirme que ele é carregado (a maioria já vem no `Scripts.xml`/config loader).
4. `ant` (ou copiar) → **reiniciar** o Game Server.

## Dica: comparar com o default

Ao editar, mantenha um backup do `.ini` original ou compare com o mesmo arquivo em
`source/.../dist/game/config/` (versionado). Assim você sempre sabe o que mudou.

## Relação com os outros docs

- Rates de XP/drop → também em [06_DROPS_E_CRAFT.md](06_DROPS_E_CRAFT.md).
- Enchant (`Player.ini`) → [05_ENCHANT.md](05_ENCHANT.md).
- GM/`AccessLevels.xml` → `docs/COMANDOS_BANCO.md`.
