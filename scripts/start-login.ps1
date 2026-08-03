# Iniciar Login Server (headless)
$ErrorActionPreference = "Stop"
$env:JAVA_HOME = [Environment]::GetEnvironmentVariable("JAVA_HOME", "User")
$loginDir = Join-Path $PSScriptRoot "..\server\login"
$javaCfg = (Get-Content (Join-Path $loginDir "java.cfg") -Raw).Trim()
Start-Process -FilePath "$env:JAVA_HOME\bin\java.exe" -ArgumentList "$javaCfg -jar ..\libs\LoginServer.jar" -WorkingDirectory $loginDir -WindowStyle Minimized
Write-Host "Login Server iniciado em $loginDir"
