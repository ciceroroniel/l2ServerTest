# Backup do banco L2J Mobius Interlude (MVP local)
# Uso: .\scripts\backup-database.ps1

$ErrorActionPreference = "Stop"
$envPath = Join-Path $PSScriptRoot "..\config\database.local.env"

if (-not (Test-Path $envPath)) {
    Write-Error "Arquivo de credenciais nao encontrado: $envPath"
}

Get-Content $envPath | ForEach-Object {
    if ($_ -match '^\s*([^#=]+?)\s*=\s*(.+?)\s*$') {
        Set-Variable -Name $matches[1] -Value $matches[2]
    }
}

$backupDir = Join-Path $PSScriptRoot "..\backups\database"
New-Item -ItemType Directory -Force -Path $backupDir | Out-Null

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$output = Join-Path $backupDir "${DB_NAME}_${timestamp}.sql"

Write-Host "Backup: $DB_NAME -> $output"
& mariadb-dump -u $DB_USER "-p$DB_PASSWORD" --single-transaction --routines --triggers $DB_NAME | Set-Content -Encoding UTF8 $output

$sizeMb = [math]::Round((Get-Item $output).Length / 1MB, 2)
Write-Host "Concluido ($sizeMb MB)"
