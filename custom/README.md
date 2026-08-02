# Customizações versionadas do servidor

As pastas `server/` e `source/` **não** ficam no git (são pesadas; `source/` é até um repositório git próprio do L2J Mobius). Para que nossas customizações fiquem **versionadas e portáveis** entre máquinas, os arquivos custom moram aqui em `custom/datapack/`, espelhando a estrutura de `data/` do servidor.

## O que tem aqui (exemplos do Guia 11)

| Arquivo | ID | O que faz |
|---|---|---|
| `stats/skills/30000-30099-custom.xml` | skill 30010, 30011 | Passivas: +10% HP/CP e +10% cast speed |
| `stats/items/30000-30099-custom.xml` | item 30010, 30011 | **Cap of Vitality** (+10% HP/CP) e **Mystic Tattoo** (+10% cast speed) |
| `stats/npcs/custom/CustomVendor.xml` | npc 50010 | **Custom Vendor** (Merchant) que vende os itens custom |
| `buylists/5001000.xml` | buylist 5001000 | Loja do Custom Vendor |
| `html/merchant/50010.htm` | — | Diálogo do vendedor |
| `spawns/Giran/CustomTestNPCs.xml` | — | Spawna o **Buffer (50008)** e o **Vendor (50010)** no centro de Giran |

> O Buffer (NPC 50008, tipo `SchemeBuffer`) já existia no datapack; aqui só adicionamos o spawn dele em Giran junto do vendedor.

## Como aplicar em outra máquina

1. Ter o servidor montado (`server/` e `source/` presentes).
2. Rodar o deploy:
   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts\deploy-custom.ps1
   ```
3. Reiniciar o Game Server:
   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts\start-all.ps1
   ```

## Como testar in-game

- Entrar no jogo e ir ao **centro de Giran** (perto da Clarissa) — o Buffer e o Vendor estarão spawnados.
- Ou usar GM: `//spawn 50008` (buffer) e `//spawn 50010` (vendor).
- Pegar os itens direto: `//create_item 30010 1` (cap) e `//create_item 30011 1` (tattoo), equipar e conferir HP/CP/cast speed.

Detalhes completos do pipeline em [`../docs/modding/11_PIPELINE_EXEMPLOS.md`](../docs/modding/11_PIPELINE_EXEMPLOS.md).
