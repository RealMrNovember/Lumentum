# lumentum.cicibyte.com — Showcase Sitesi

## Amaç

`lumentum.cicibyte.com` kök adresi yalnızca bir uygulama girişi değil; Lumentum'u temsil eden **modern, efektli ve kaliteli bir showcase** olmalıdır.

## Gereksinimler

- Ürün vizyonunu yansıtan premium görsel dil (koyu tema, ORP vurgusu, akıcı animasyonlar)
- Bilişsel okuma motorunun farkını anlatan hero + özellik bölümleri
- Canlı ORP demo önizlemesi (odak harfi vurgusu)
- **Signup / Login** CTA'ları — tek tıkla auth akışına, ardından uygulamaya
- Oturum açık kullanıcı showcase yerine doğrudan uygulama ana ekranına yönlendirilir
- Mobil uyumlu responsive layout (web öncelikli, Android/iOS'ta da çalışır)

## Teknik

- Kaynak: `apps/flutter/lumentum/lib/features/showcase/`
- Production deploy: Flutter web build → `/www/wwwroot/lumentum.cicibyte.com/web/`
- API: aynı domain `/api/*` → `packages/api`
- Showcase ve uygulama **tek Flutter web build** içinde (shared mimari korunur)

## Akış

```
lumentum.cicibyte.com/
    ├── / (veya #/)     → ShowcaseScreen (misafir)
    ├── Sign up         → RegisterScreen → HomeScreen → Reader
    └── Sign in         → LoginScreen → HomeScreen → Reader
```
