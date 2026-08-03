# Iniciar Game Server (headless) — iniciar Login Server antes
$ErrorActionPreference = "Stop"
$env:JAVA_HOME = [Environment]::GetEnvironmentVariable("JAVA_HOME", "User")
$gameDir = Join-Path $PSScriptRoot "..\server\game"
$javaCfg = (Get-Content (Join-Path $gameDir "java.cfg") -Raw).Trim()
Start-Process -FilePath "$env:JAVA_HOME\bin\java.exe" -ArgumentList "$javaCfg -jar ..\libs\GameServer.jar" -WorkingDirectory $gameDir -WindowStyle Minimized
Write-Host "Game Server iniciado em $gameDir"
