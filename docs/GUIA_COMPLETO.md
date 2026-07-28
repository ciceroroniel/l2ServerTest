# Guia Completo — Replicar Servidor L2 Interlude (L2J Mobius)

Documento mestre para reproduzir o ambiente em outra máquina Windows.

**Repositório:** https://github.com/ciceroroniel/l2ServerTest  
**Source oficial:** https://gitlab.com/MobiusDevelopment/L2J_Mobius  
**Crônica:** Interlude CT2.0 (protocolo 746)

---

## Índice de documentação

| Fase | Documento | Conteúdo |
|---|---|---|
| 1 | [SOURCE_DECISION.md](SOURCE_DECISION.md) | Por que L2J Mobius, licença, stack |
| 2 | [ENVIRONMENT.md](ENVIRONMENT.md) | Git, JDK 25, Ant, MariaDB |
| 3 | [BUILD.md](BUILD.md) | Clone, compilação Ant, ZIP |
| 4 | [DATABASE.md](DATABASE.md) | Banco, usuário, SQL, backup |
| 5 | [SERVERS.md](SERVERS.md) | Login/Game Server, HexID, portas |
| 6 | [CLIENT.md](CLIENT.md) | Client limpo vs L2Impact, hosts, login |

---

## Arquitetura

```
Client (Interlude CT2.0) ──2106──► Login Server ──9014──► Game Server
                                         │                    │
                                         └──── MariaDB ◄──────┘
                                              l2jmobiusinterlude
```

| Componente | Porta | Função |
|---|---|---|
| Login Server | 2106 | Autenticação de jogadores |
| Login ↔ Game | 9014 | Canal interno (localhost) |
| Game Server | 7777 | Mundo do jogo |
| MariaDB | 3306 | Persistência |

---

## Pré-requisitos (outra máquina)

| Software | Versão | Instalação |
|---|---|---|
| Git | 2.55+ | `winget install Git.Git` |
| JDK | **25** Temurin | `winget install EclipseAdoptium.Temurin.25.JDK` |
| Apache Ant | 1.10.15+ | Ver [ENVIRONMENT.md](ENVIRONMENT.md) ou archive.apache.org |
| MariaDB | 10.6+ / 12.x | `winget install MariaDB.Server` |
| 7-Zip | (opcional) | Para extrair clients `.7z` |

### JAVA_HOME

```powershell
# Após instalar JDK 25
[Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Eclipse Adoptium\jdk-25.x.x-hotspot", "User")
# Adicionar %JAVA_HOME%\bin ao Path do usuário
```

---

## Passo a passo — ordem obrigatória

### 1. Clonar este repositório

```powershell
git clone https://github.com/ciceroroniel/l2ServerTest.git
cd l2ServerTest
```

### 2. Configurar secrets locais

```powershell
copy config\database.local.env.example config\database.local.env
copy config\accounts.local.env.example config\accounts.local.env
# Edite as senhas em database.local.env
```

### 3. Clonar source L2J Mobius (sparse — só Interlude)

```powershell
git clone --filter=blob:none --sparse --depth 1 https://gitlab.com/MobiusDevelopment/L2J_Mobius.git source
cd source
git sparse-checkout set L2J_Mobius_CT_0_Interlude
cd ..
```

### 4. Compilar

```powershell
cd source\L2J_Mobius_CT_0_Interlude
ant cleanup
# Artefato: source\build\L2J_Mobius_CT_0_Interlude.zip
```

### 5. Extrair distribuição

```powershell
Expand-Archive -Path source\build\L2J_Mobius_CT_0_Interlude.zip -DestinationPath server -Force
```

### 6. MariaDB

1. Instalar MariaDB
2. Iniciar serviço (ou `mysqld` manual — ver DATABASE.md)
3. Criar banco e usuário:

```sql
CREATE DATABASE l2jmobiusinterlude CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'l2jmobius'@'localhost' IDENTIFIED BY 'SUA_SENHA';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER,
  CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, CREATE VIEW, SHOW VIEW,
  CREATE ROUTINE, ALTER ROUTINE, TRIGGER ON l2jmobiusinterlude.* TO 'l2jmobius'@'localhost';
FLUSH PRIVILEGES;
```

4. Importar schema:

```powershell
.\scripts\import-database.ps1
```

5. Configurar `server/login/config/Database.ini` e `server/game/config/Database.ini`:
   - `Login = l2jmobius`
   - `Password = SUA_SENHA`

### 7. Registrar Game Server (HexID)

```powershell
# Gerar HexID e registrar server_id=1 (Bartz) — ver SERVERS.md
# Ou usar GameServerRegister.vbs em server/login/
```

Registro manual (PowerShell):

```powershell
# Gerar hex aleatório, INSERT em gameservers, criar server/game/config/hexid.txt
# ServerID=1, RequestServerID=1 em server/game/config/Server.ini
```

### 8. Configurar rede do Game Server

```powershell
copy source\L2J_Mobius_CT_0_Interlude\dist\game\config\default-ipconfig.xml server\game\config\ipconfig.xml
```

Conteúdo: `address="127.0.0.1"` para MVP local.

### 9. Criar contas de teste

```powershell
.\scripts\create-test-accounts.ps1
```

### 10. Iniciar servidores

```powershell
.\scripts\start-login.ps1
Start-Sleep -Seconds 8
.\scripts\start-game.ps1
```

Validar portas: `2106`, `9014`, `7777`.

### 11. Client Interlude LIMPO (crítico)

**NÃO use client L2Impact** — autentica em servidor remoto (15.204.x.x).

Requisitos do client:
- Interlude CT2.0, protocolo **746**
- Pasta `system/` **sem** `L2VikosMemory.dll`, `EmuDev.dll`, Active Anticheat

```powershell
# PowerShell como Administrador
.\scripts\configure-hosts-admin.bat

# Configurar client limpo
.\scripts\configure-client.ps1 -ClientPath "CAMINHO\DO\CLIENT\LIMPO"
```

Executar `start-l2-local.bat` na pasta do client.

Login: `admin` / `admin123` | Servidor: **Bartz**

---

## Scripts disponíveis

| Script | Função |
|---|---|
| `scripts/import-database.ps1` | Importar SQL login + game |
| `scripts/create-test-accounts.ps1` | Criar testplayer + admin GM |
| `scripts/backup-database.ps1` | Backup .sql |
| `scripts/start-login.ps1` | Iniciar Login Server |
| `scripts/start-game.ps1` | Iniciar Game Server |
| `scripts/stop-servers.ps1` | Parar processos Java Temurin |
| `scripts/configure-hosts.ps1` | Entradas L2 no hosts (admin) |
| `scripts/configure-hosts-admin.bat` | Atalho admin para hosts |
| `scripts/configure-client.ps1` | Backup system + start-l2-local.bat |
| `scripts/fix-client-local.ps1` | AltClientGuard=False (só Impact) |

---

## Lições aprendidas

### Client L2Impact é incompatível com L2J Mobius local

- `L2VikosMemory.dll` licencia IP remoto `15.204.x.x`
- Login nunca chega ao Login Server local (log vazio)
- Desabilitar DLL quebra o launcher (Active Anticheat)
- **Solução:** client Interlude limpo CT2.0

### Hosts é obrigatório (client limpo)

```
127.0.0.1 l2authd.lineage2.com
127.0.0.1 l2testauth.lineage2.com
```

### Senhas no L2J Mobius

- Hash: **SHA-1 + Base64** (não bcrypt)
- `AutoCreateAccounts = True` no Login Server cria conta no primeiro login

### Geodata

- Distribuição padrão: 0 regiões — pathfinding desabilitado
- Movimento básico funciona; adicionar geodata depois em `server/game/data/geodata/`

### O que NÃO commitar no Git

- `config/*.local.env` (senhas)
- `server/` (gerado pelo build + configs locais)
- `source/build/`
- `backups/`
- `hexid.txt` (único por instalação)

---

## Checklist MVP

- [ ] JDK 25 + Ant + MariaDB instalados
- [ ] Source clonada e compilada (`ant cleanup`)
- [ ] `server/` extraído do ZIP
- [ ] Banco importado (100 tabelas)
- [ ] Game Server registrado (HexID, server_id=1)
- [ ] Login + Game online (portas 2106, 7777)
- [ ] Hosts configurado (admin)
- [ ] Client **limpo** Interlude CT2.0
- [ ] Login admin, criar personagem, entrar no mundo
- [ ] Comando GM: `//admin`

---

## Próxima fase (7)

- Alterar rates XP/SP/Adena
- Testar spawn, drop, multisell, NPC
- Backup + versionar customizações

---

## Referências

- L2J Mobius Wiki: https://l2jmobius.org/wiki/
- GitLab: https://gitlab.com/MobiusDevelopment/L2J_Mobius
- GPL v3 — modificações devem ser disponibilizadas se distribuir binários
