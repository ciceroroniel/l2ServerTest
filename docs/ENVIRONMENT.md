# Ambiente Local — L2 Interlude MVP

**Atualizado:** 2026-07-27

## Stack instalada

| Componente | Versão | Caminho / Notas |
|---|---|---|
| Git | 2.55.0.windows.2 | Sistema |
| JDK (ativo) | 25.0.3 Temurin | `C:\Program Files\Eclipse Adoptium\jdk-25.0.3.9-hotspot` |
| JDK 8 (legado) | 1.8.0_492 Temurin | Mantido instalado; não usar para L2J Mobius |
| Apache Ant | 1.10.15 | `C:\Users\cicer\Tools\apache-ant` |
| MariaDB | 12.3.2 | `C:\Program Files\MariaDB 12.3` |

## Variáveis de ambiente (User)

- `JAVA_HOME` → JDK 25
- `ANT_HOME` → `C:\Users\cicer\Tools\apache-ant`
- `Path` → inclui `%JAVA_HOME%\bin`, `%ANT_HOME%\bin`, MariaDB `bin`

## Validação executada

```powershell
java -version      # openjdk 25.0.3
javac -version     # javac 25.0.3
ant -version       # Apache Ant 1.10.15
mariadb --version  # 12.3.2-MariaDB
mariadb -u root -e "SELECT VERSION();"  # OK — porta 3306
```

## Source escolhida

Ver [SOURCE_DECISION.md](SOURCE_DECISION.md) — **L2J Mobius CT_0_Interlude**

Repositório: https://gitlab.com/MobiusDevelopment/L2J_Mobius

## MariaDB — serviço Windows

O instalador winget registrou os binários e inicializou o datadir, mas **não registrou o serviço Windows** (requer admin).

Para registrar o serviço (PowerShell **como Administrador**):

```powershell
& "C:\Program Files\MariaDB 12.3\bin\mysqld.exe" --install MariaDB --defaults-file="C:\Program Files\MariaDB 12.3\data\my.ini"
Start-Service MariaDB
```

Alternativa temporária (sem serviço):

```powershell
Start-Process "C:\Program Files\MariaDB 12.3\bin\mysqld.exe" -ArgumentList '--defaults-file="C:\Program Files\MariaDB 12.3\data\my.ini"' -WindowStyle Hidden
```

## Próxima etapa (Fase 3)

1. Clonar branch Interlude do L2J Mobius
2. Importar no IntelliJ IDEA
3. Compilar com `ant jar`
4. Configurar banco e servidores
