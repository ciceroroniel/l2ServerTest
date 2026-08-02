# ==============================================================
# Deploy dos arquivos custom versionados (custom/datapack/**)
# para o datapack real do servidor.
#
# Copia para:
#   - source/L2J_Mobius_CT_0_Interlude/dist/game/data  (fonte-de-verdade)
#   - server/game/data                                  (runtime que roda)
#
# Uso: powershell -ExecutionPolicy Bypass -File scripts\deploy-custom.ps1
# Depois: reiniciar o Game Server (scripts\start-all.ps1) para aplicar.
# ==============================================================
$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
$srcMirror = Join-Path $root "custom\datapack"
$targets = @(
    (Join-Path $root "source\L2J_Mobius_CT_0_Interlude\dist\game\data"),
    (Join-Path $root "server\game\data")
)

if (-not (Test-Path $srcMirror)) { Write-Host "[!] Nao achei $srcMirror" -ForegroundColor Red; exit 1 }

$files = Get-ChildItem -Path $srcMirror -Recurse -File
foreach ($t in $targets) {
    if (-not (Test-Path $t)) { Write-Host "[skip] destino inexistente: $t" -ForegroundColor Yellow; continue }
    foreach ($f in $files) {
        $relative = $f.FullName.Substring($srcMirror.Length).TrimStart('\')
        $dest = Join-Path $t $relative
        New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null
        Copy-Item $f.FullName $dest -Force
        Write-Host "OK -> $dest"
    }
}
Write-Host "`nPronto. Reinicie o Game Server para aplicar (scripts\start-all.ps1)." -ForegroundColor Green
