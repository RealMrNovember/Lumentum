# Lumentum Contracts

Platformlar arası **tek sözleşme** katmanı. Web, Android, iOS ve gelecekteki tüm istemciler bu şemalara uyar.

## İlke

- İş mantığı ve veri şekilleri burada tanımlanır; istemciler kopyalamaz, **tüketir**.
- API değişiklikleri önce burada yapılır, sonra `packages/api` ve `packages/lumentum_shared` güncellenir.
- `openapi.yaml` kaynak doğruluk (source of truth) dosyasıdır.

## Dosyalar

| Dosya | Açıklama |
|-------|----------|
| `openapi.yaml` | REST API tam tanımı |
| `schemas/token.json` | Okuma motoru çıktısı (TokenData) |
| `schemas/user.json` | Kullanıcı kayıt/giriş modeli |
| `schemas/license.json` | Lisans durumu modeli |

## Yeni platform ekleme

1. `openapi.yaml` ve ilgili JSON şemayı oku
2. `packages/lumentum_shared` Dart modellerini kullan (Flutter) veya şemadan SDK üret
3. Yalnızca sunum katmanını yaz — mantık shared API'de kalır
