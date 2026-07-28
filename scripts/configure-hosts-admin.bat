@echo off
:: Execute este arquivo como Administrador (clique direito)
powershell -ExecutionPolicy Bypass -File "%~dp0configure-hosts.ps1"
pause
