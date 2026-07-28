# Criar contas de teste no banco (login server)
# Uso: .\scripts\create-test-accounts.ps1

$ErrorActionPreference = "Stop"
$envPath = Join-Path $PSScriptRoot "..\config\database.local.env"
$accPath = Join-Path $PSScriptRoot "..\config\accounts.local.env"

function Read-EnvFile($path) {
    $vars = @{}
    Get-Content $path | ForEach-Object {
        if ($_ -match '^\s*([^#=]+?)\s*=\s*(.+?)\s*$') {
            $vars[$matches[1]] = $matches[2]
        }
    }
    return $vars
}

function Get-PasswordHash([string]$password) {
    $sha = [System.Security.Cryptography.SHA1]::Create()
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($password)
    return [Convert]::ToBase64String($sha.ComputeHash($bytes))
}

$db = Read-EnvFile $envPath
$acc = Read-EnvFile $accPath

$accounts = @(
    @{ Login = $acc.PLAYER_LOGIN; Password = $acc.PLAYER_PASSWORD; AccessLevel = 0 },
    @{ Login = $acc.GM_LOGIN; Password = $acc.GM_PASSWORD; AccessLevel = 100 }
)

foreach ($a in $accounts) {
    $hash = Get-PasswordHash $a.Password
    $sql = @"
INSERT INTO accounts (login, password, accessLevel, lastactive, lastServer)
VALUES ('$($a.Login)', '$hash', $($a.AccessLevel), UNIX_TIMESTAMP()*1000, 1)
ON DUPLICATE KEY UPDATE password='$hash', accessLevel=$($a.AccessLevel);
"@
    $sql | mariadb -u $db.DB_USER "-p$($db.DB_PASSWORD)" $db.DB_NAME
    Write-Host "Conta: $($a.Login) (accessLevel=$($a.AccessLevel))"
}

Write-Host "Contas criadas/atualizadas."
