# Configurar client Lineage 2 Interlude para localhost
# Uso: .\scripts\configure-client.ps1 -ClientPath "D:\Lineage2\Interlude"
param(
    [Parameter(Mandatory = $true)]
    [string]$ClientPath
)

$ErrorActionPreference = "Stop"
$systemDir = Join-Path $ClientPath "system"

if (-not (Test-Path $systemDir)) {
    Write-Error "Pasta 'system' nao encontrada em: $ClientPath"
}

# Backup da pasta system
$backupDir = Join-Path $ClientPath ("system_backup_" + (Get-Date -Format "yyyyMMdd_HHmmss"))
Write-Host "Backup: $systemDir -> $backupDir"
Copy-Item $systemDir $backupDir -Recurse

# Criar atalho/script de launch
$l2Exe = Join-Path $systemDir "l2.exe"
if (-not (Test-Path $l2Exe)) {
    $l2Bin = Join-Path $systemDir "l2.bin"
    if (Test-Path $l2Bin) {
        Copy-Item $l2Bin $l2Exe -Force
        Write-Host "Criado l2.exe a partir de l2.bin"
    } else {
        Write-Error "l2.exe ou l2.bin nao encontrado em $systemDir"
    }
}

$launchScript = Join-Path $ClientPath "start-l2-local.bat"
@(
    '@echo off',
    'cd /d "%~dp0system"',
    'start "" "l2.exe" -ip=127.0.0.1'
) | Set-Content $launchScript -Encoding ASCII

Write-Host ""
Write-Host "=== Client configurado ==="
Write-Host "Atalho criado: $launchScript"
Write-Host ""
Write-Host "IMPORTANTE: adicione ao arquivo hosts (como Administrador):"
Write-Host "  127.0.0.1 l2authd.lineage2.com"
Write-Host "  127.0.0.1 l2testauth.lineage2.com"
Write-Host ""
Write-Host "Ou execute: .\scripts\configure-hosts.ps1 (requer admin)"
Write-Host ""
Write-Host "Protocolo exigido pelo servidor: 746 (Interlude CT2.0)"
