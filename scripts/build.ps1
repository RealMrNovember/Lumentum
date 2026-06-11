# Lumentum local build (Windows)
param(
    [switch]$ApiOnly,
    [switch]$WebOnly
)

$Root = Split-Path -Parent $PSScriptRoot
$env:Path = "C:\flutter\bin;" + $env:Path
Set-Location $Root

function Build-Rust {
    Write-Host ">> Rust CLI (release)..." -ForegroundColor Cyan
    cargo build --release -p core_engine_cli
}

function Build-Api {
    Write-Host ">> API paketi hazir..." -ForegroundColor Cyan
    # Sunucuda venv ile kurulur; local test icin:
    Push-Location "$Root\packages\api"
    if (-not (Test-Path .venv)) { python -m venv .venv }
    .\.venv\Scripts\pip install -q -r requirements.txt
    Pop-Location
}

function Build-Web {
    $flutter = Get-Command flutter -ErrorAction SilentlyContinue
    if (-not $flutter) {
        Write-Host "Flutter SDK bulunamadi. Kurulum: https://docs.flutter.dev/get-started/install/windows" -ForegroundColor Yellow
        exit 1
    }
    Write-Host ">> Flutter web (release)..." -ForegroundColor Cyan
    Push-Location "$Root\apps\flutter\lumentum"
    flutter pub get
    flutter gen-l10n 2>$null
    flutter build web --release --base-href /
    Pop-Location
    Write-Host ">> Build: apps\flutter\lumentum\build\web" -ForegroundColor Green
}

if (-not $WebOnly) { Build-Rust; Build-Api }
if (-not $ApiOnly) { Build-Web }

Write-Host ">> Build tamamlandi." -ForegroundColor Green
