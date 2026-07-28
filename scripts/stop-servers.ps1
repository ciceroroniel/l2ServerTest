# Parar servidores L2J Mobius
Get-Process java -ErrorAction SilentlyContinue | Where-Object {
    $_.Path -like "*Eclipse Adoptium*"
} | Stop-Process -Force
Write-Host "Processos Java (Temurin) encerrados."
