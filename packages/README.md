# Lumentum Packages (Shared)

**Tek beyin, çok platform.** Tüm iş mantığı, veri sözleşmeleri ve motor bu dizinde yaşar. `apps/` altındaki istemciler yalnızca sunum katmanıdır.

```
packages/
├── core-engine/        # Rust — tokenizer, ORP++, CPS (sıfır maliyetli motor)
├── core-engine-py/     # PyO3 köprüsü → API
├── core-engine-cli/    # CLI köprüsü → API fallback
├── api/                # FastAPI — merkezi REST beyin
├── contracts/          # OpenAPI + JSON Schema — platformlar arası sözleşme
└── lumentum_shared/    # Dart SDK — modeller + API istemcisi (Flutter tüketir)
```

## Katman Kuralları

| Katman | Ne yapar | Ne yapmaz |
|--------|----------|-----------|
| `core-engine` | Metin işleme, tempo, odak | UI, HTTP, lisans |
| `api` | Auth, lisans proxy, okuma API | Widget, ekran |
| `contracts` | Veri şekli tanımı | Kod çalıştırmaz |
| `lumentum_shared` | HTTP client, JSON ↔ model | Ekran, tema |
| `apps/*` | UI, gesture, platform API | İş mantığı kopyalamaz |

## Veri Akışı

```
Metin → core-engine → TokenData[]
              ↑
         api (FastAPI)
              ↑
    lumentum_shared (Dart)
              ↑
   apps/flutter/lumentum (Web / APK / IPA)
```

## Yeni Platform Ekleme

1. `contracts/openapi.yaml` oku
2. Mevcut SDK'yı kullan (`lumentum_shared`) veya şemadan yeni SDK üret
3. `apps/<platform>/` altında ince istemci oluştur
4. **Asla** motor veya pacing mantığını istemciye kopyalama
