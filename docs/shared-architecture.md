# Shared Architecture

Lumentum, çoklu platform stratejisini **Shared Brain** modeliyle uygular.

## Problem

Web, Android, iOS ve gelecekteki istemciler aynı okuma motorunu, lisans kurallarını ve kullanıcı verisini kullanmalı. Her platformda ayrı mantık yazmak tutarsızlık, bakım yükü ve lisans bypass riski yaratır.

## Çözüm: Tek Beyin, İnce İstemciler

```
┌─────────────────────────────────────────────────────────────┐
│                    SHARED (packages/)                        │
│  contracts ──► api ◄── core-engine                          │
│       │          │                                           │
│       └──── lumentum_shared (Dart SDK)                       │
└──────────────────────────┬──────────────────────────────────┘
                           │ HTTPS /api/*
        ┌──────────────────┼──────────────────┐
        ▼                  ▼                  ▼
   Flutter Web        Flutter Android     Flutter iOS
   (apps/flutter)     (aynı proje)        (aynı proje)
```

### Shared katmanı

- **contracts**: OpenAPI + JSON Schema — değişiklikler önce burada
- **core-engine**: Rust motor — tek kaynak doğruluk for pacing/ORP
- **api**: FastAPI — auth, license, reading; tüm istemciler buraya bağlanır
- **lumentum_shared**: Dart modeller + `LumentumApiClient`

### Apps katmanı

- Yalnızca UI, routing, platform özellikleri (bildirim, secure storage)
- `lumentum_shared` üzerinden veri çeker
- İş kuralı **kopyalanmaz**

## Sözleşme Önceliği

API veya model değiştiğinde sıra:

1. `packages/contracts/` güncelle
2. `packages/api/` uygula
3. `packages/lumentum_shared/` modelleri güncelle
4. `apps/` istemcileri adapte et

## Gelecek Platformlar

| Platform | Yaklaşım |
|----------|----------|
| Flutter (mevcut) | `lumentum_shared` doğrudan |
| Desktop native | OpenAPI'den SDK üret veya REST |
| Üçüncü parti entegrasyon | Public API + API key (Faz 4) |
| Başka Cicibyte uygulaması | Aynı `license.cicibyte.com` + opsiyonel Lumentum API |

## Anti-Pattern'ler (Yasak)

- İstemcide `pace_ms` veya `focus_index` hesaplama
- Platforma özel kullanıcı/lisans veritabanı
- `contracts` dışında JSON şekli tanımlama
- Motor mantığını JavaScript/Dart'a port etme (WASM hariç, planlı)
