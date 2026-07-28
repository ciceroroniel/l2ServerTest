# Fase 3 — Source e Build

**Data:** 2026-07-27  
**Status:** BUILD SUCCESSFUL

## Repositório

| Item | Valor |
|---|---|
| URL | https://gitlab.com/MobiusDevelopment/L2J_Mobius.git |
| Crônica | `L2J_Mobius_CT_0_Interlude` |
| Clone | sparse checkout (somente Interlude) |
| Pasta source | [`source/L2J_Mobius_CT_0_Interlude`](../source/L2J_Mobius_CT_0_Interlude) |

## Build tool

- **Apache Ant** 1.10.15
- Arquivo: `build.xml`
- Java exigido: **25** (`source="25" target="25"`)
- Dependências: JARs em `dist/libs/` (HikariCP, mysql-connector-j, slf4j)

## Comandos usados

```powershell
# Clone sparse (somente Interlude)
git clone --filter=blob:none --sparse --depth 1 https://gitlab.com/MobiusDevelopment/L2J_Mobius.git source
cd source
git sparse-checkout set L2J_Mobius_CT_0_Interlude

# Compilar e gerar ZIP
cd L2J_Mobius_CT_0_Interlude
ant cleanup
```

## Resultado do build

```
BUILD SUCCESSFUL
Total time: 16 seconds
```

Artefatos gerados:

| Arquivo | Descrição |
|---|---|
| `source/build/L2J_Mobius_CT_0_Interlude.zip` | Distribuição completa (JARs + datapack) |
| `LoginServer.jar` | Autenticação e lista de servidores |
| `GameServer.jar` | Simulação do mundo |
| `DatabaseInstaller.jar` | Instalador de schema SQL |

Runtime extraído em: [`server/`](../server/)

## Estrutura da distribuição

```
server/
├── login/           # Login Server (configs + LoginServer.vbs)
├── game/            # Game Server (configs + datapack + GameServer.vbs)
├── libs/            # JARs compilados + dependências
├── db_installer/    # Scripts SQL + DatabaseInstaller
├── backup/
└── images/
```

## Auditoria rápida

| Verificação | Resultado |
|---|---|
| Origem | GitLab oficial MobiusDevelopment |
| Licença | GPL v3 (README raiz do repo) |
| Arquivos Java | 1609 compilados sem erro |
| Padrões suspeitos (backdoor) | Nenhum indício em busca superficial |
| Binários em libs | HikariCP, mysql-connector-j, slf4j (Maven Central) |

## Importar no IntelliJ IDEA

1. File → Open → selecionar `source/L2J_Mobius_CT_0_Interlude`
2. Configurar SDK: JDK 25 (Temurin)
3. Marcar `java/` como Sources Root
4. Adicionar `dist/libs/*.jar` ao classpath do módulo
5. Para compilar: clicar direito em `build.xml` → Run Ant Target → `cleanup`

## Erros de build

Nenhum erro nesta execução.

## Próxima etapa (Fase 4)

1. Criar banco `l2jmobius` (ou nome configurado)
2. Criar usuário com privilégio mínimo
3. Executar `DatabaseInstaller`
4. Validar tabelas (`accounts`, `characters`, etc.)
