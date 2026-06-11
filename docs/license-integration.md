# license.cicibyte.com — Lumentum Entegrasyonu

## Uygulama Kaydı

| Alan | Değer |
|------|-------|
| Ad | Lumentum |
| Kod (`app_code`) | `lumentum` |
| Durum | **Active** olmalı |

## API

Tüm isteklerde header: `X-Api-Key: <LICENSE_API_KEY>`

| Endpoint | Açıklama |
|----------|----------|
| `POST /api/v1/license/trial` | 14 günlük deneme başlat |
| `POST /api/v1/license/verify` | Lisans doğrula (login, heartbeat) — `/check` Cloudflare’de engellenir |
| `POST /api/v1/license/activate` | Lisans anahtarı ile aktivasyon (e-posta eşleşmesi) |

### Aktivasyon isteği (panelden oluşturulan kod)

```json
{
  "app_code": "lumentum",
  "license_key": "CB-XXXX-XXXX-XXXX-XXXX",
  "hwid": "<cihaz-uuid>",
  "email": "user@example.com",
  "client_name": "Ad Soyad",
  "platform": "web"
}
```

Panelde **“Süre aktivasyonda başlasın”** açıksa, süre kullanıcı kodu ilk kez girdiğinde başlar.

### Trial isteği

```json
{
  "app_code": "lumentum",
  "hwid": "<cihaz-uuid>",
  "email": "user@example.com",
  "client_name": "Ad Soyad",
  "platform": "web"
}
```

Yanıt `data.status`: `active` · `data.type`: `trial` · `data.expires_at`: ISO8601 (+14 gün)

## Lumentum Akışı

1. Kayıt → `license/trial` + kullanıcı DB
2. Giriş → `license/check`
3. Okuma → JWT + `license_status == active`

## Yapılandırma

`packages/api/.env`:

```
LICENSE_MOCK=false
LICENSE_API_URL=https://license.cicibyte.com
LICENSE_API_KEY=...
LICENSE_PRODUCT_ID=lumentum
```
