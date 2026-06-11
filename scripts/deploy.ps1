# Lumentum deploy → 31.40.199.47 (YALNIZCA lumentum.cicibyte.com)
param(
    [string]$Server = "root@31.40.199.47",
    [switch]$ApiOnly,
    [switch]$SkipBuild
)

$Root = Split-Path -Parent $PSScriptRoot
$Remote = "/www/wwwroot/lumentum.cicibyte.com"

if (-not $SkipBuild) {
    if ($ApiOnly) {
        & "$Root\scripts\build.ps1" -ApiOnly
    } else {
        & "$Root\scripts\build.ps1"
    }
}

Write-Host ">> Sunucu dizin iskeleti..." -ForegroundColor Cyan
ssh $Server "mkdir -p $Remote/{api,data,logs,scripts,backups,web} /www/server/panel/vhost/nginx/extension/lumentum.cicibyte.com"
scp "$Root\scripts\server-init.sh" "${Server}:${Remote}/scripts/"
ssh $Server "sed -i 's/\r$//' $Remote/scripts/server-init.sh; bash $Remote/scripts/server-init.sh"

Write-Host ">> API dosyalari..." -ForegroundColor Cyan
scp -r "$Root\packages\api\app" "${Server}:${Remote}/api/"
scp "$Root\packages\api\main.py" "${Server}:${Remote}/api/"
scp "$Root\packages\api\requirements.txt" "${Server}:${Remote}/api/"
scp "$Root\packages\api\.env.example" "${Server}:${Remote}/api/"

scp "$Root\deploy\systemd\lumentum-api.service" "${Server}:${Remote}/scripts/"
scp "$Root\deploy\nginx\lumentum-api.conf" "${Server}:${Remote}/scripts/"
scp "$Root\scripts\install-api-server.sh" "${Server}:${Remote}/scripts/"
scp "$Root\scripts\server-init.sh" "${Server}:${Remote}/scripts/"

if (-not $ApiOnly) {
    Write-Host ">> Web (Flutter build)..." -ForegroundColor Cyan
    $WebBuild = "$Root\apps\flutter\lumentum\build\web"
    if (-not (Test-Path $WebBuild)) {
        Write-Error "Web build yok. Once: .\scripts\build.ps1"
    }
    scp -r "$WebBuild\*" "${Server}:${Remote}/"
}

Write-Host ">> Sunucuda API kurulumu..." -ForegroundColor Cyan
ssh $Server "sed -i 's/\r$//' $Remote/scripts/install-api-server.sh; bash $Remote/scripts/install-api-server.sh"

Write-Host ">> Deploy tamamlandi: https://lumentum.cicibyte.com/api/health" -ForegroundColor Green
