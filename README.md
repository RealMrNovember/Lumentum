# LUMENTUM

**The Cognitive Reading Engine** — Don't just read. Absorb.

## Yapı

```
packages/          # Shared brain (motor, API, contracts, Dart SDK)
apps/flutter/      # Thin clients (Web → Android → iOS)
```

Detay: [`roadmap.md`](roadmap.md) · [`docs/shared-architecture.md`](docs/shared-architecture.md)

## Hızlı Başlangıç (Windows)

### 1. API (local)

```powershell
cd packages\api
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8000
```

### 2. Flutter Web (showcase + uygulama)

Flutter SDK: `C:\flutter` (PATH'e ekle: `C:\flutter\bin`). Kurulum yoksa: [Flutter Windows](https://docs.flutter.dev/get-started/install/windows)

```powershell
$env:Path = "C:\flutter\bin;" + $env:Path
```

Ardından:

```powershell
cd apps\flutter\lumentum
flutter pub get
flutter run -d chrome
```

### 3. Production deploy

```powershell
.\scripts\build.ps1          # Flutter + API hazırlık
.\scripts\deploy.ps1         # Tam deploy (web + API)
.\scripts\deploy.ps1 -ApiOnly  # Yalnızca API
```

**Canlı:** https://lumentum.cicibyte.com · API: `/api/health`

## Platform Önceliği

1. **Web** (showcase + uygulama) — `lumentum.cicibyte.com`
2. **Android** (APK)
3. **iOS** (IPA)

## Kurallar

- Lisans: `license.cicibyte.com` · e-posta + ad + soyad
- Sunucu: yalnızca `/www/wwwroot/lumentum.cicibyte.com`
- Arapça dil desteği yok (bilinçli)
