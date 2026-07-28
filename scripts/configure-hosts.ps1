# Adicionar entradas L2 ao hosts do Windows (requer Administrador)
# Uso: PowerShell como Admin -> .\scripts\configure-hosts.ps1

$ErrorActionPreference = "Stop"
$hostsFile = "$env:SystemRoot\System32\drivers\etc\hosts"
$entries = @(
    "127.0.0.1 l2authd.lineage2.com",
    "127.0.0.1 l2testauth.lineage2.com"
)

$content = Get-Content $hostsFile -Raw
$marker = "# L2J Mobius Localhost"

if ($content -match [regex]::Escape($marker)) {
    Write-Host "Entradas L2 ja existem no hosts."
    exit 0
}

$block = "`n$marker`n" + ($entries -join "`n") + "`n"
Add-Content -Path $hostsFile -Value $block -Encoding ASCII
Write-Host "Hosts atualizado:"
$entries | ForEach-Object { Write-Host "  $_" }
