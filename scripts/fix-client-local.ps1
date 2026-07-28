# Ajustar client L2Impact para servidor local (SEM remover DLLs)
# O client L2Impact exige L2VikosMemory.dll e EmuDev.dll para iniciar.
param(
    [string]$ClientPath = "E:\Servidores de Lineage pra Jogar\Server-Interlude-Test"
)

$ErrorActionPreference = "Stop"
$systemDir = Join-Path $ClientPath "system"

# Garantir que DLLs existem (restaurar de .bak se necessario)
foreach ($dll in @("L2VikosMemory.dll", "EmuDev.dll")) {
    $path = Join-Path $systemDir $dll
    $bak = "$path.bak"
    if (-not (Test-Path $path) -and (Test-Path $bak)) {
        Copy-Item $bak $path -Force
        Write-Host "Restaurado: $dll"
    }
}

# Desabilitar redirect para servidor remoto L2Impact (mantem DLLs carregadas)
$cfg = Join-Path $systemDir "L2VikosMemory.cfg"
if (Test-Path $cfg) {
    $content = Get-Content $cfg -Raw
    $content = $content -replace 'AltClientGuard=True', 'AltClientGuard=False'
    if ($content -notmatch 'AltClientGuard=False') {
        $content = $content -replace '\[Защита / Protection\]', "[Защита / Protection]`r`nAltClientGuard=False"
    }
    Set-Content $cfg $content -Encoding UTF8
    Write-Host "AltClientGuard=False (auth padrao via hosts -> localhost)"
}

# Launcher
$bat = Join-Path $ClientPath "start-l2-local.bat"
@(
    '@echo off',
    'cd /d "%~dp0system"',
    'start "" "l2.exe" -ip=127.0.0.1'
) | Set-Content $bat -Encoding ASCII

Write-Host ""
Write-Host "Client pronto. OBRIGATORIO configurar hosts como Admin:"
Write-Host "  c:\Users\cicer\Code\l2ServerTest\scripts\configure-hosts-admin.bat"
Write-Host ""
Write-Host "Login: admin / admin123 | Servidor: Bartz"
Write-Host ""
Write-Host "NOTA: Client L2Impact e feito para servidor proprio (L2Impact)."
Write-Host "Se login continuar falhando, use client Interlude limpo (sem Vikos/Impact)."
