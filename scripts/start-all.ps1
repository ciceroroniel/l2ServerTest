# Sobe TODO o servidor na ordem correta: MariaDB -> Login -> Game
# Uso: powershell -ExecutionPolicy Bypass -File scripts\start-all.ps1
# Ou (mais facil): clique duplo em start-all.bat na raiz do projeto.

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
$mariaBin = "C:\Program Files\MariaDB 12.3\bin"

function Test-Port($port) {
    return (Test-NetConnection 127.0.0.1 -Port $port -WarningAction SilentlyContinue).TcpTestSucceeded
}

function Wait-Port($port, $label, $timeoutSec) {
    $elapsed = 0
    while (-not (Test-Port $port)) {
        Start-Sleep -Seconds 2
        $elapsed += 2
        if ($elapsed -ge $timeoutSec) {
            Write-Host "  [!] $label (porta $port) nao subiu em $timeoutSec s." -ForegroundColor Red
            return $false
        }
    }
    Write-Host "  [OK] $label online (porta $port)." -ForegroundColor Green
    return $true
}

Write-Host "==============================================="
Write-Host " Subindo servidor L2 Interlude (ordem correta)"
Write-Host "==============================================="

# 1) MariaDB
Write-Host "`n[1/3] MariaDB..."
if (Test-Port 3306) {
    Write-Host "  [OK] MariaDB ja estava rodando (porta 3306)." -ForegroundColor Green
} else {
    Start-Process "$mariaBin\mariadbd.exe" -ArgumentList '--defaults-file="C:\Program Files\MariaDB 12.3\data\my.ini"' -WindowStyle Hidden
    if (-not (Wait-Port 3306 "MariaDB" 30)) { Write-Host "Abortando: banco nao subiu." -ForegroundColor Red; exit 1 }
}

# 2) Login Server
Write-Host "`n[2/3] Login Server..."
if (Test-Port 2106) {
    Write-Host "  [OK] Login ja estava rodando (porta 2106)." -ForegroundColor Green
} else {
    & (Join-Path $PSScriptRoot "start-login.ps1")
    if (-not (Wait-Port 2106 "Login Server" 30)) { Write-Host "Abortando: login nao subiu." -ForegroundColor Red; exit 1 }
}

# 3) Game Server
Write-Host "`n[3/3] Game Server (pode levar 1-2 min)..."
if (Test-Port 7777) {
    Write-Host "  [OK] Game ja estava rodando (porta 7777)." -ForegroundColor Green
} else {
    & (Join-Path $PSScriptRoot "start-game.ps1")
    Wait-Port 7777 "Game Server" 180 | Out-Null
}

Write-Host "`n==============================================="
Write-Host " Status final:"
$portas = @{ "3306 MariaDB" = 3306; "2106 Login" = 2106; "9014 Login-Game" = 9014; "7777 Game" = 7777 }
foreach ($k in ($portas.Keys | Sort-Object)) {
    $status = if (Test-Port $portas[$k]) { "ONLINE " } else { "OFFLINE" }
    Write-Host ("  {0}  {1}" -f $status, $k)
}
Write-Host "==============================================="
Write-Host "Pronto! Abra o jogo e logue no servidor Bartz."
