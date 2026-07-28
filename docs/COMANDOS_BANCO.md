# Comandos de Banco de Dados — L2J Mobius Interlude

Guia prático para acessar o MariaDB manualmente e alterar dados do servidor
(status de GM, level, adena, contas, etc.).

**Banco:** `l2jmobiusinterlude` · **Motor:** MariaDB 12.3

---

## Regra de ouro (leia antes de qualquer UPDATE)

> **Pare o Game Server antes de alterar `characters` ou `accounts`.**

Enquanto um personagem está carregado (online ou até você sair pra seleção),
o servidor guarda os dados em memória e **grava por cima do banco** ao salvar.
Se você fizer um `UPDATE` com o servidor ligado, sua alteração é perdida.

Sequência segura para editar personagem/conta:

```powershell
# 1. Parar o Game Server
powershell -ExecutionPolicy Bypass -File "C:\Users\Pandinha\codes\l2ServerTest\scripts\stop-servers.ps1"

# 2. Fazer os UPDATEs no banco (ver exemplos abaixo)

# 3. Subir o Game Server de novo
powershell -ExecutionPolicy Bypass -File "C:\Users\Pandinha\codes\l2ServerTest\scripts\start-game.ps1"
```

> Para apenas **consultar** (`SELECT`), não precisa parar nada.

---

## 1. Conectar no banco

O cliente fica em `C:\Program Files\MariaDB 12.3\bin\mariadb.exe`.

### Modo interativo (abre o prompt do MariaDB)

```powershell
& "C:\Program Files\MariaDB 12.3\bin\mariadb.exe" -u root
```

Depois de entrar, escolha o banco:

```sql
USE l2jmobiusinterlude;
```

Para sair do prompt: `exit` ou `quit`.

### Modo direto (roda um comando e volta pro PowerShell)

```powershell
& "C:\Program Files\MariaDB 12.3\bin\mariadb.exe" -u root --table -e "SELECT char_name, level, accesslevel FROM l2jmobiusinterlude.characters;"
```

- `--table` = mostra o resultado em formato de tabela (mais legível).
- `-e "..."` = executa o SQL entre aspas.

> **Usuário:** `root` (sem senha, só localhost) ou o usuário da aplicação
> `l2jmobius` (senha em `config/database.local.env`). Para tarefas
> administrativas manuais, use `root`.

---

## 2. Navegação básica

```sql
SHOW DATABASES;                         -- lista os bancos
USE l2jmobiusinterlude;                 -- entra no banco do servidor
SHOW TABLES;                            -- lista as 100 tabelas
DESCRIBE characters;                    -- mostra as colunas de uma tabela
SELECT COUNT(*) FROM characters;        -- conta registros
```

---

## 3. Personagens (`characters`)

### Consultar

```sql
-- Todos os personagens (resumo)
SELECT charId, char_name, account_name, level, accesslevel, online
FROM characters;

-- Um personagem específico
SELECT * FROM characters WHERE char_name = 'Sana';

-- Quem está online agora
SELECT char_name, level FROM characters WHERE online = 1;
```

### Virar GM / mudar nível de acesso  (Game Server PARADO)

```sql
-- Tornar Master GM (todos os comandos //)
UPDATE characters SET accesslevel = 100 WHERE char_name = 'Sana';

-- Tirar GM (jogador normal)
UPDATE characters SET accesslevel = 0 WHERE char_name = 'Sana';
```

Níveis disponíveis (definidos em `server/game/config/AccessLevels.xml`):

| Nível | Nome | É GM? |
|---|---|---|
| -1 | Banned | não |
| 0 | User (jogador) | não |
| 10 | Chat Moderator | não |
| 20 | Test GM | não |
| 30 | General GM | não |
| 40 | Support GM | não |
| 50 | Event GM | não |
| 60 | Head GM | não |
| 70 | Admin | **sim** |
| 100 | Master (tudo) | **sim** |

> Depois do UPDATE + reiniciar o Game Server, entre no jogo e use `//admin`
> (tudo minúsculo). O `//gm` só liga/desliga o modo GM, **não** remove o acesso.

### Level, EXP, SP  (Game Server PARADO)

```sql
-- Mudar o level (ex.: 80). Ajuste também a EXP se quiser evitar reset ao logar.
UPDATE characters SET level = 80 WHERE char_name = 'Sana';

-- Zerar SP / dar SP
UPDATE characters SET sp = 1000000000 WHERE char_name = 'Sana';
```

> Dica: subir level costuma ser mais seguro **no jogo** com `//addexp` ou
> `//setlevel`, porque acerta EXP/stats juntos.

### Karma e PK

```sql
UPDATE characters SET karma = 0, pkkills = 0 WHERE char_name = 'Sana';
```

### Personagem "preso" — teleportar por coordenadas  (Game Server PARADO)

```sql
-- Giran (town) aproximado
UPDATE characters SET x = 83400, y = 147943, z = -3404 WHERE char_name = 'Sana';
```

### Renomear / apagar

```sql
-- Renomear
UPDATE characters SET char_name = 'NovoNome' WHERE char_name = 'Sana';

-- Marcar para exclusão (o servidor apaga depois). CUIDADO.
-- Melhor apagar personagem pelo próprio jogo (tela de seleção).
```

---

## 4. Contas (`accounts`)

A senha é guardada como **hash SHA-1 + Base64** (não é texto puro).

### Consultar

```sql
SELECT login, accessLevel, lastIP, lastactive FROM accounts;
```

### Mudar nível de acesso da conta

```sql
UPDATE accounts SET accessLevel = 100 WHERE login = 'admin';   -- conta GM
UPDATE accounts SET accessLevel = -1  WHERE login = 'fulano';  -- banir conta
UPDATE accounts SET accessLevel = 0   WHERE login = 'fulano';  -- desbanir
```

> Observação: o acesso de **GM in-game** vem do personagem (`characters.accesslevel`),
> não da conta. O `accessLevel` da conta é usado para banir/permitir login.

### Trocar/definir senha

O hash precisa ser gerado com SHA-1 + Base64. Use este comando PowerShell para
gerar o hash de uma senha e já montar o SQL:

```powershell
$senha = "MinhaNovaSenha123"
$sha = [System.Security.Cryptography.SHA1]::Create()
$bytes = [System.Text.Encoding]::UTF8.GetBytes($senha)
$hash = [Convert]::ToBase64String($sha.ComputeHash($bytes))
Write-Host "UPDATE accounts SET password = '$hash' WHERE login = 'admin';"
```

Copie o `UPDATE` que ele imprime e rode no MariaDB.

### Criar conta nova rapidamente

Mais fácil: com `AutoCreateAccounts = True` (já ativo), basta digitar um
login/senha novos na tela de login do jogo — a conta é criada sozinha.
Ou use o script pronto:

```powershell
powershell -ExecutionPolicy Bypass -File "C:\Users\Pandinha\codes\l2ServerTest\scripts\create-test-accounts.ps1"
```

---

## 5. Itens (`items`)

```sql
-- Ver o inventário de um personagem (owner_id = charId)
SELECT object_id, item_id, count, loc, enchant_level
FROM items WHERE owner_id = (SELECT charId FROM characters WHERE char_name = 'Sana');
```

> **Dar itens/adena:** faça **no jogo** com GM — é o método correto e seguro:
> `//create_item 57 10000000` (adena) ou `//create_item <id> <qtd>`.
> Inserir item direto no banco exige gerar `object_id` único e é arriscado.

Alguns IDs úteis: `57` = Adena · `5575` = Ancient Adena · `6673` = Festival Adena.

---

## 6. Game Servers (`gameservers`)

```sql
-- Ver o servidor registrado (deve ter server_id = 1 = Bartz)
SELECT server_id FROM gameservers;
```

Se algum dia o servidor aparecer com nome errado (ex.: Sieghardt/ID 2), pare
tudo, limpe e reinicie:

```sql
TRUNCATE TABLE gameservers;   -- com Login e Game PARADOS
```

Depois apague `server/game/config/hexid.txt` e reinicie Login + Game.

---

## 7. Backup e restauração

### Backup (dump completo do banco)

```powershell
& "C:\Program Files\MariaDB 12.3\bin\mysqldump.exe" -u root l2jmobiusinterlude > "C:\Users\Pandinha\codes\l2ServerTest\backups\backup_$(Get-Date -Format yyyyMMdd_HHmmss).sql"
```

(ou use `scripts/backup-database.ps1`)

### Restaurar de um backup

```powershell
Get-Content "CAMINHO\DO\backup.sql" -Raw | & "C:\Program Files\MariaDB 12.3\bin\mariadb.exe" -u root l2jmobiusinterlude
```

---

## 8. Comandos GM no jogo (alternativa ao banco)

Muitas coisas são mais rápidas e seguras dentro do jogo (não precisa parar o
servidor). Sempre **minúsculos**, prefixo `//`:

| Comando | Efeito |
|---|---|
| `//admin` | Abre o menu principal de GM |
| `//gm` | Liga/desliga o modo GM |
| `//setlevel 80` | Define o level do alvo |
| `//addexp 1000000` | Dá EXP |
| `//create_item 57 10000000` | Dá 10kk de adena |
| `//heal` | Cura HP/MP/CP |
| `//invul` | Invulnerabilidade |
| `//teleportto Giran` | Teleporta pra Giran |
| `//recall <nome>` | Traz um jogador até você |
| `//unstuck` | Solta personagem preso |
| `//reload <tipo>` | Recarrega configs sem reiniciar |

---

## Resumo rápido

1. **Consultar** → pode a qualquer hora.
2. **Alterar `characters`/`accounts`** → **pare o Game Server** antes.
3. **Dar item/adena e level** → prefira comandos `//` no jogo.
4. **Senha** → gere hash SHA-1+Base64 (script acima), nunca texto puro.
