# Importar schema L2J Mobius (login + game)
# Uso: .\scripts\import-database.ps1
# Requer: MariaDB rodando, credenciais em config/database.local.env

$ErrorActionPreference = "Stop"
$envPath = Join-Path $PSScriptRoot "..\config\database.local.env"
$sqlBase = Join-Path $PSScriptRoot "..\server\db_installer\sql"

if (-not (Test-Path $envPath)) {
    Write-Error "Arquivo de credenciais nao encontrado: $envPath"
}

Get-Content $envPath | ForEach-Object {
    if ($_ -match '^\s*([^#=]+?)\s*=\s*(.+?)\s*$') {
        Set-Variable -Name $matches[1] -Value $matches[2]
    }
}

foreach ($type in @("login", "game")) {
    $dir = Join-Path $sqlBase $type
    $files = Get-ChildItem "$dir\*.sql" | Sort-Object Name
    Write-Host "=== $type ($($files.Count) arquivos) ==="
    foreach ($f in $files) {
        Write-Host "  -> $($f.Name)"
        Get-Content $f.FullName -Raw | mariadb -u $DB_USER "-p$DB_PASSWORD" $DB_NAME
        if ($LASTEXITCODE -ne 0) { throw "Falha em $($f.Name)" }
    }
}

Write-Host "Importacao concluida."
