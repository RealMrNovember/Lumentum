# LUMENTUM — Üretim Yol Haritası

> **Durum:** Canlı takip dosyası — tamamlanan maddeler `[x]`, bekleyenler `[ ]` ile işaretlenir.  
> **Son güncelleme:** 2026-06-11 (Master Admin + Topluluk & Sosyal katman)  
> **Geliştirme:** Windows 10 (local) → Deploy: `31.40.199.47` (aaPanel)

---

## 0. Sabit Kurallar (Değişmez)

Bu kurallar projenin tüm fazlarında geçerlidir. `.cursor/rules/lumentum-infrastructure.mdc` dosyasında kalıcı olarak kayıtlıdır.

| Kural | Açıklama |
|-------|----------|
| Uygulama domaini | `https://lumentum.cicibyte.com` |
| Sunucu dizini | `/www/wwwroot/lumentum.cicibyte.com` |
| Lisans sunucusu | `https://license.cicibyte.com` |
| Lisans kimliği | Kayıtlı kullanıcının **e-posta** adresi |
| Lisans kayıt verisi | `email`, `first_name`, `last_name` → license sunucusuna |
| Sunucu izolasyonu | Lumentum dışındaki hiçbir sisteme müdahale yok |
| Platform | Web + Android (APK) + iOS (IPA) |
| Platform önceliği | **Web** (test) → **Android** → **iOS** |
| Dil | Çoklu dil; **Arapça hariç** |
| Ürün | Bilişsel okuma motoru (RSVP + ORP++ + CPS), sadece hızlı okuyucu değil |
| **Mimari** | **Shared Brain** — `packages/` tek beyin, `apps/` ince istemciler |

---

## 1. Sistem Vizyonu ve Çalışma Prensibi

### 1.1 Tek Cümlelik Vizyon

LUMENTUM, metni kelime kelime gösteren bir okuyucu değil; bilgiyi beynin algılayabileceği en optimal hız ve biçimde sunan bir **bilişsel arayüzdür**.

### 1.2 Altın Kural

Kullanıcı hızı kontrol ettiğini sanmalı; aslında motor (CPS + AI) arka planda karar vermelidir.

### 1.3 MVP Kabul Kriteri

Bir kullanıcı **15 dakikada** şunları hissetmeli:

- [ ] ORP odak farkı bariz
- [ ] Göz yorgunluğu azalıyor
- [ ] "Bu başka bir şey" hissi var

### 1.4 MVP'de Olmayanlar

Arkadaşlık, sosyal feed, master admin paneli, bildirimler, bölüm sistemi — **Faz 4 (Topluluk & Sosyal)**. Marketplace ve gamification — Faz 5 sonrasına ertelenir.

### 1.5 Ürün Katmanları (Güncel Vizyon)

```
┌─────────────────────────────────────────────────────────────────────────┐
│  KATMAN 4 — Topluluk & Sosyal (Faz 4)                                   │
│  Master Admin · Profil · Arkadaşlık · Feed · Bölümler · Bildirimler     │
├─────────────────────────────────────────────────────────────────────────┤
│  KATMAN 3 — Lumentum Studio (Faz 1–2, kısmen canlı)                    │
│  Yayın · Keşfet · Beğeni · Yorum · Kapak · PDF içe aktarma              │
├─────────────────────────────────────────────────────────────────────────┤
│  KATMAN 2 — Kütüphane & İçerik (Faz 2)                                  │
│  EPUB/PDF · Senkron · Kişisel okuma ilerlemesi                          │
├─────────────────────────────────────────────────────────────────────────┤
│  KATMAN 1 — Bilişsel Okuma Çekirdeği (Faz 1 MVP)                        │
│  RSVP + ORP++ + CPS · Auth · Lisans                                     │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Mimari Genel Bakış

### 2.1 Shared Brain Modeli (Zorunlu)

Çoklu platform stratejisi: **tek beyin (`packages/`), ince istemciler (`apps/`)**.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    packages/ — SHARED (TEK BEYİN)                         │
├─────────────────────────────────────────────────────────────────────────┤
│  contracts/          OpenAPI + JSON Schema — platformlar arası sözleşme │
│  core-engine/        Rust motor (tokenizer → ORP++ → CPS)               │
│  api/                FastAPI — merkezi REST API                           │
│  lumentum_shared/    Dart SDK (modeller + LumentumApiClient)            │
└───────────────────────────────┬─────────────────────────────────────────┘
                                │ HTTPS /api/*
        ┌───────────────────────┼───────────────────────┐
        ▼                       ▼                       ▼
┌───────────────┐     ┌───────────────┐     ┌───────────────┐
│  apps/flutter │     │  (gelecek)    │     │  (gelecek)    │
│  lumentum     │     │  başka client │     │  3rd party    │
│  Web/APK/IPA  │     │               │     │  API tüketici │
└───────────────┘     └───────────────┘     └───────────────┘
```

**Değişiklik sırası (asla tersine çevrilmez):**

1. `packages/contracts/` — şema ve OpenAPI güncelle
2. `packages/api/` — backend uygula
3. `packages/lumentum_shared/` — Dart modelleri ve client güncelle
4. `apps/*` — yalnızca UI adapte et

**Yasaklar:**

- İstemcide `pace_ms`, `focus_index` veya lisans mantığı hesaplama
- Platforma özel veri modeli tanımlama (`contracts` dışında)
- Motor kodunu Dart/JS'e kopyalama

Detay: `docs/shared-architecture.md`

### 2.2 Monorepo Dizin Yapısı

```
Lumentum/
├── packages/                    # SHARED — tek beyin
│   ├── core-engine/             # Rust motor
│   ├── core-engine-py/          # PyO3 köprüsü
│   ├── core-engine-cli/         # CLI köprüsü
│   ├── api/                     # FastAPI
│   ├── contracts/               # OpenAPI + JSON Schema
│   └── lumentum_shared/         # Dart SDK
├── apps/                        # PLATFORM — ince istemciler
│   └── flutter/lumentum/        # Web + Android + iOS
├── docs/
│   └── shared-architecture.md
├── roadmap.md
└── Cargo.toml
```

### 2.3 Üretim Deploy Akışı

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         KULLANICI CİHAZLARI                              │
├──────────────────┬──────────────────┬───────────────────────────────────┤
│  Flutter Web     │  Flutter Android │  Flutter iOS                      │
│  lumentum.       │  (APK)           │  (IPA)                            │
│  cicibyte.com    │                  │                                   │
└────────┬─────────┴────────┬─────────┴──────────────┬────────────────────┘
         │                  │                        │
         └──────────────────┼────────────────────────┘
                            │ HTTPS — lumentum_shared → /api/*
                            ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  SUNUCU: 31.40.199.47 — aaPanel                                         │
│  /www/wwwroot/lumentum.cicibyte.com                                     │
├─────────────────────────────────────────────────────────────────────────┤
│  Nginx (Lumentum vhost only)                                            │
│    ├── /           → apps/flutter/lumentum web build                      │
│    ├── /api/*      → packages/api (uvicorn)                             │
│    └── /ws/*       → WebSocket (ileride)                                │
├─────────────────────────────────────────────────────────────────────────┤
│  packages/api — FastAPI                                                   │
│    ├── Auth, License proxy, Reading, Stats                              │
│    └── packages/core-engine bridge (PyO3 / CLI)                         │
├─────────────────────────────────────────────────────────────────────────┤
│  Lumentum SQLite/PostgreSQL (izole — paylaşımlı DB'ye dokunulmaz)       │
└─────────────────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  license.cicibyte.com — Merkezi Lisans (DOKUNULMAZ)                     │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.4 Teknoloji Yığını

| Katman | Teknoloji | Gerekçe |
|--------|-----------|---------|
| Çekirdek motor | Rust | Düşük gecikme, tokenization/ORP/CPS |
| Backend API | FastAPI + Python 3.12 | Hızlı geliştirme, Rust köprüsü (PyO3) |
| İstemci | Flutter 3.x | Web + Android + iOS tek kod tabanı |
| Veritabanı | SQLite (MVP) → PostgreSQL (prod) | İzole instance, aaPanel MySQL'e dokunulmaz |
| Reverse proxy | Nginx (aaPanel Lumentum site) | SSL, static, API routing |
| i18n | flutter_localizations + ARB | TR, EN, DE, FR, ES, … (Arapça yok) |
| CI/CD | GitHub Actions → SSH deploy | Sadece Lumentum dizinine rsync/scp |
| Mail | Sunucu mail server (aaPanel) | Kayıt doğrulama, şifre sıfırlama |

---

## 3. Domain ve Sunucu Yapılandırması

### 3.1 lumentum.cicibyte.com Dizin Yapısı (Hedef)

```
/www/wwwroot/lumentum.cicibyte.com/
├── web/                    # Flutter web build (index.html, assets)
├── api/                    # FastAPI uygulaması
│   ├── main.py
│   ├── app/
│   │   ├── auth/
│   │   ├── license/
│   │   ├── reading/
│   │   └── engine/
│   ├── requirements.txt
│   └── .env                # Lumentum secrets (git dışı)
├── engine/                 # Derlenmiş Rust binary / .so / pyd
├── data/                   # SQLite DB, upload cache (Lumentum-only)
├── logs/                   # Lumentum logları
└── scripts/
    ├── deploy.sh
    ├── restart-api.sh
    └── health-check.sh
```

### 3.2 Sunucu İzolasyon Kontrol Listesi

- [ ] Yalnızca `lumentum.cicibyte.com` site kaydı ve vhost düzenlenir
- [ ] API process adı ve portu Lumentum'a özel (ör. `127.0.0.1:18765`)
- [ ] Başka sitelerin nginx config dosyalarına dokunulmaz
- [ ] Paylaşımlı MySQL/Redis restart veya global config değişikliği yapılmaz
- [ ] Deploy scriptleri `chroot` mantığıyla yalnızca Lumentum dizinine yazar
- [ ] Rollback: önceki `web/` ve `api/` yedekleri Lumentum dizini içinde tutulur

### 3.3 SSL ve Nginx

- [ ] aaPanel üzerinden `lumentum.cicibyte.com` için Let's Encrypt SSL
- [ ] Nginx: `/` → `web/`, `/api/` → uvicorn upstream
- [ ] Güvenlik başlıkları: HSTS, X-Content-Type-Options, CSP (Flutter web uyumlu)
- [ ] Gzip/Brotli static asset sıkıştırma

---

## 4. Lisans Sistemi Entegrasyonu

### 4.1 Temel İlke

Lumentum lisansı **e-posta adresine** bağlıdır. Kullanıcı kayıt olurken ad, soyad ve e-posta hem Lumentum veritabanına hem de `license.cicibyte.com`'a iletilir.

### 4.2 Kayıt Akışı

```
Kullanıcı (Web/Mobil)
    │
    ▼
[Lumentum Kayıt Formu]
    email, password, first_name, last_name
    │
    ▼
POST /api/auth/register (Lumentum Backend)
    │
    ├──► Lumentum DB: kullanıcı oluştur (email_verified=false)
    │
    ├──► POST license.cicibyte.com/api/... (server-to-server)
    │       Body: { email, first_name, last_name, product: "lumentum" }
    │       Response: { license_id, status, plan }
    │
    ├──► Mail server: doğrulama e-postası gönder
    │
    └──► Response: { message: "E-postanızı doğrulayın" }
```

### 4.3 Giriş ve Lisans Kontrolü

```
Kullanıcı giriş (email + password)
    │
    ▼
JWT access + refresh token üret
    │
    ▼
Her oturum açılışında veya 24 saatte bir:
    GET/POST license.cicibyte.com → lisans durumu
    │
    ├── active  → tam erişim
    ├── trial   → kısıtlı erişim (politika license sunucusundan)
    ├── expired → okuma durur, yenileme ekranı
    └── revoked → hesap askıya alınır
```

### 4.4 Lisans API Sözleşmesi (license.cicibyte.com — doğrulanacak)

> **Not:** Aşağıdaki endpoint'ler license sunucusunun gerçek API'si ile eşleştirilecek. İlk deploy öncesi `license.cicibyte.com` dokümantasyonu okunacak.

| Endpoint (tahmini) | Metod | Gövde | Açıklama |
|--------------------|-------|-------|----------|
| `/api/v1/register` | POST | `email, first_name, last_name, product_id` | Yeni lisans kaydı |
| `/api/v1/validate` | POST | `email, product_id` | Lisans durumu sorgula |
| `/api/v1/heartbeat` | POST | `email, product_id, device_id` | Periyodik doğrulama |

### 4.5 Lisans Entegrasyon Görevleri

- [ ] `license.cicibyte.com` API dokümantasyonunu al ve endpoint'leri doğrula
- [ ] `api/app/license/client.py` — HTTP client (timeout, retry, circuit breaker)
- [ ] `api/app/license/service.py` — register, validate, cache (kısa TTL)
- [ ] Kayıt akışında license sunucusuna ad/soyad/e-posta gönderimi
- [ ] JWT claim'lerine `license_status` ve `plan_tier` ekleme
- [ ] Lisans süresi dolduğunda Flutter'da yenileme/yükseltme ekranı
- [ ] Offline tolerans: mobilde 72 saat grace period (policy ile)
- [ ] License API anahtarı `.env`'de; asla client'a sızmaz

---

## 5. Kimlik Doğrulama ve Kullanıcı Yönetimi

### 5.1 Kayıt Alanları

| Alan | Zorunlu | Not |
|------|---------|-----|
| email | Evet | Lisans anahtarı; benzersiz |
| password | Evet | min 8 karakter, bcrypt hash |
| first_name | Evet | License sunucusuna gider |
| last_name | Evet | License sunucusuna gider |
| birth_date | Evet | Yaş hesaplama; master admin görünür |
| country_code | Evet | ISO 3166-1 alpha-2 (ör. TR, DE); master admin görünür |
| locale | Hayır | Varsayılan: tarayıcı/cihaz dili |

### 5.2 Auth Akışları

- [ ] Kayıt + e-posta doğrulama (sunucu mail server)
- [ ] Giriş (JWT access 15dk + refresh 30 gün)
- [ ] Şifre sıfırlama (e-posta linki)
- [ ] Oturum sonlandırma / tüm cihazlardan çıkış
- [ ] Mobil: secure storage (flutter_secure_storage)

### 5.3 Veri Modeli (özet)

```
users: id, email, password_hash, first_name, last_name, birth_date,
       country_code, locale, role (user|master_admin), avatar_url,
       bio, email_verified, license_status, created_at, updated_at

sessions: id, user_id, device_id, platform, last_active

reading_progress: id, user_id, content_id, chapter_id?, position,
                  wpm_avg, updated_at

friendships: id, requester_id, addressee_id, status (pending|accepted|blocked),
             created_at, updated_at

notifications: id, user_id, type, payload_json, read_at, created_at

publication_chapters: id, publication_id, order_index, title, body,
                      word_count, created_at

reading_progress_chapter: id, user_id, chapter_id, position, updated_at
```

**Master Admin bootstrap:** İlk deploy'da `mozkarci1991@gmail.com` e-postası `role=master_admin` olarak seed edilir. Ek master admin yalnızca mevcut master admin tarafından atanabilir.

---

## 6. Çekirdek Motor (Rust — lumentum_core)

### 6.1 Pipeline

```
Ham metin
  → Omni-Parser (format normalize)
  → Tokenizer (Unicode, noktalama, kısaltma)
  → ORP++ (hece bazlı dinamik odak indeksi)
  → CPS (anlam yoğunluğu → pace_ms)
  → TokenData { token, focus_index, pace_ms, flags }
  → Flutter RSVP Canvas
```

### 6.2 Modül Görevleri

| Modül | Hedef davranış | Durum |
|-------|----------------|-------|
| `tokenizer.rs` | Unicode word boundary, TR/EN ekler | [ ] Geliştirilecek |
| `orp.rs` | Hece bazlı ORP++, teknik terim çoklu odak | [ ] Geliştirilecek |
| `pacing.rs` | Bağlaç hızlanır, karmaşık kelime yavaşlar | [x] Temel iskelet |
| `engine.rs` | Pipeline orkestrasyon | [x] Temel |
| `parser/txt` | Paragraf/başlık normalizasyon | [ ] |
| `parser/epub` | Metadata + chapter | [ ] Placeholder |
| `parser/pdf` | Layout-bağımsız akış | [ ] Placeholder |
| `parser/web` | Semantik temizleme | [ ] Placeholder |

### 6.3 Motor Görevleri

- [ ] Unicode-aware tokenizer
- [ ] Türkçe/İngilizce bağlaç ve edat listesi (CPS)
- [ ] Hece tabanlı ORP++ algoritması
- [ ] Cümle sonu ek gecikme (noktalama)
- [ ] `TokenData`'ya `flags` alanı (cümle_sonu, teknik_terim, atla)
- [ ] WASM derlemesi (Flutter web'de tarayıcı içi motor — opsiyonel Faz 1b)
- [ ] PyO3 modülü Python 3.12 ile derleme
- [ ] Benchmark suite (latency < 5ms / 1000 kelime hedef)

---

## 7. Backend API (FastAPI)

### 7.1 Endpoint Planı

| Endpoint | Metod | Auth | Açıklama |
|----------|-------|------|----------|
| `/api/health` | GET | Hayır | Sağlık + motor durumu |
| `/api/auth/register` | POST | Hayır | Kayıt + license kayıt |
| `/api/auth/login` | POST | Hayır | JWT döner |
| `/api/auth/verify-email` | GET | Hayır | E-posta doğrulama |
| `/api/auth/forgot-password` | POST | Hayır | Sıfırlama maili |
| `/api/auth/reset-password` | POST | Hayır | Yeni şifre |
| `/api/auth/me` | GET | Evet | Profil + lisans durumu |
| `/api/license/status` | GET | Evet | Güncel lisans sorgusu |
| `/api/reading/process` | POST | Evet | Metin → TokenData[] |
| `/api/reading/sessions` | POST | Evet | Oturum başlat/bitir |
| `/api/reading/progress` | GET/PUT | Evet | İlerleme senkron |
| `/api/content/import` | POST | Evet | TXT yükle (Faz 2: EPUB/PDF) |
| `/api/users/me/avatar` | PUT | Evet | Profil fotoğrafı yükle |
| `/api/users/{id}` | GET | Evet | Kamu profil (avatar, ad, eserler) |
| `/api/friends/search` | GET | Evet | İsim/e-posta ile kullanıcı ara |
| `/api/friends/requests` | POST/GET | Evet | Arkadaşlık isteği gönder/listele |
| `/api/friends` | GET | Evet | Arkadaş listesi |
| `/api/feed` | GET | Evet | Kişiselleştirilmiş sosyal feed |
| `/api/studio/publications/{id}/chapters` | GET/POST | Evet | Bölüm listesi / yeni bölüm |
| `/api/studio/import-pdf` | POST | Evet | PDF → otomatik bölüm + yayın |
| `/api/notifications` | GET/PUT | Evet | Bildirimler / okundu işaretle |
| `/api/admin/dashboard` | GET | Master Admin | Toplam kullanıcı, istatistikler |
| `/api/admin/users` | GET | Master Admin | Tüm kullanıcılar (yaş, ülke, avatar) |
| `/api/admin/users/{id}` | GET | Master Admin | Kullanıcı detayı + sosyal graf |

### 7.2 Backend Görevleri

- [x] Temel `/api/health` ve `/api/reading/process` iskeleti
- [x] `packages/api/app/` modüler yapı (auth, license, reading, engine)
- [x] OpenAPI sözleşmesi (`packages/contracts/openapi.yaml`)
- [x] SQLAlchemy + SQLite kullanıcı modeli
- [x] JWT auth (`/api/auth/register`, `/login`, `/me`)
- [x] License client iskeleti (mock + license.cicibyte.com hazır)
- [x] CORS (debug modda web test için açık)
- [ ] Alembic migrations
- [ ] E-posta servisi (aaPanel SMTP)
- [ ] Rate limiting (slowapi)
- [ ] Structured logging (Lumentum logs/ only)
- [ ] OpenAPI docs `/api/docs` (prod'da kısıtlı)
- [ ] CORS: yalnızca `lumentum.cicibyte.com` ve mobil deep link

---

## 8. Flutter İstemci — İnce Platform Katmanı (`apps/flutter/lumentum`)

> API ve modeller `packages/lumentum_shared` üzerinden gelir. Bu dizinde iş mantığı yazılmaz.

### 8.1 Uygulama Modülleri

```
apps/flutter/lumentum/lib/
├── main.dart
├── app.dart                    # MaterialApp, routing, theme
├── core/
│   ├── auth/                   # Auth state, secure storage
│   ├── license/                # License gate UI (veri: shared API)
│   ├── i18n/                   # l10n ARB files
│   └── theme/                  # Dark/light, typography
├── features/
│   ├── onboarding/
│   ├── auth/                   # Login, register, verify ekranları
│   ├── reader/                 # RSVP canvas, ORP highlight
│   ├── library/                # İçerik listesi (Faz 2)
│   ├── studio/                 # Yayın, keşfet, eserlerim (kısmen canlı)
│   ├── social/                 # Arkadaş ara, feed, bildirimler (Faz 4)
│   ├── admin/                  # Master admin paneli (Faz 4)
│   ├── settings/
│   └── profile/                # Avatar, bio, yaş/ülke görüntüleme
└── shared/
    └── widgets/

packages/lumentum_shared/       # ← API client + TokenData (ortak beyin)
```

### 8.2 RSVP Okuyucu Ekranı (Çekirdek UX)

- [ ] 120Hz hedefli merkezi kelime render
- [ ] ORP odak harfi renk/vurgu ile gösterim
- [ ] Gesture: sağa hızlan, sola yavaşla, uzun bas duraklat
- [ ] Altın kural: slider değişince CPS arka planda adapte olur
- [ ] Oturum sonu: kelime sayısı, ortalama WPM, süre

### 8.3 Platform Görevleri (Öncelik: Web → Android → iOS)

- [x] `main.dart` demo kaldırıldı — Lumentum shell (auth + home + reader)
- [x] `lumentum_shared` entegrasyonu (API client + modeller)
- [x] RSVP okuyucu ekranı (ORP vurgu, hız slider, play/pause)
- [x] Auth ekranları (kayıt: ad, soyad, e-posta, şifre)
- [x] TR + EN i18n (ARB)
- [x] Web-first local config (`LumentumConfig.local` → port 8000)
- [ ] Web build → `lumentum.cicibyte.com/web/` (production deploy)
- [ ] Android APK imzalama (release keystore — Cicibyte) — **Faz 1b**
- [ ] iOS IPA (Apple Developer hesabı gerekli) — **Faz 1c**
- [ ] Deep link: `lumentum://` ve `https://lumentum.cicibyte.com/app/`
- [ ] PWA manifest (web install desteği)

---

## 9. Çoklu Dil Desteği (i18n)

### 9.1 Desteklenecek Diller (Faz 1)

- [ ] Türkçe (tr) — birincil
- [ ] İngilizce (en)
- [ ] Almanca (de)
- [ ] Fransızca (fr)
- [ ] İspanyolca (es)

### 9.2 Faz 2 Ek Diller

- [ ] İtalyanca (it)
- [ ] Portekizce (pt)
- [ ] Rusça (ru)
- [ ] Japonca (ja)
- [ ] Korece (ko)
- [ ] Çince Basitleştirilmiş (zh)

### 9.3 Bilinçli Hariç Tutulan

- **Arapça (ar)** — RTL + ORP uyumsuzluğu; desteklenmez

### 9.4 i18n Görevleri

- [ ] `flutter gen-l10n` ARB dosya yapısı
- [ ] Tüm UI stringleri ARB'ye taşı
- [ ] Locale seçici (ayarlar)
- [ ] CPS tokenizer dil paketi seçimi (locale → motor dil profili)
- [ ] Tarih/sayı formatları `intl` paketi

---

## 10. Güvenlik

- [ ] HTTPS zorunlu (tüm domainler)
- [ ] JWT secret, license API key, DB URL → `.env` (gitignore)
- [ ] Şifreler bcrypt; asla loglanmaz
- [ ] Rate limit: login 5/dk, register 3/saat/IP
- [ ] Input validation (Pydantic + Flutter form validators)
- [ ] CSP, XSS, CSRF koruması (web)
- [ ] Mobil: certificate pinning (opsiyonel Faz 2)
- [ ] PII minimizasyonu; analytics anonim

---

## 11. Deploy ve CI/CD

### 11.1 Local Geliştirme (Windows 10)

```powershell
# Rust motor (packages/core-engine)
cargo test -p lumentum_core
cargo build --release -p core_engine_cli

# Shared Dart SDK
cd packages/lumentum_shared
dart test

# Backend (packages/api)
cd packages/api
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8000

# Flutter ince istemci (apps/flutter/lumentum)
cd apps/flutter/lumentum
flutter pub get
flutter run -d chrome   # web
flutter run             # cihaz
```

### 11.2 Production Deploy Akışı

```
git push main
    → GitHub Actions
        → cargo build --release
        → flutter build web
        → pytest (api)
        → rsync/scp → 31.40.199.47:/www/wwwroot/lumentum.cicibyte.com/
        → SSH: scripts/restart-api.sh (Lumentum only)
        → health-check.sh
```

### 11.3 Deploy Görevleri

- [ ] `scripts/deploy.sh` — yalnızca Lumentum dizinine yazar
- [ ] GitHub Actions workflow (`.github/workflows/deploy.yml`)
- [ ] SSH key GitHub Secrets'a eklenir
- [ ] Pre-deploy backup (`web/`, `api/` → `backups/YYYYMMDD/`)
- [ ] Post-deploy smoke test (`/api/health`)
- [ ] Flutter web `base href` = `/` prod ayarı

---

## 12. Faz Planı ve İlerleme

### Faz 0 — Temel ve Altyapı

- [x] Git repo ve Rust workspace (`packages/core-engine`, `core-engine-py`, `core-engine-cli`)
- [x] Temel motor pipeline (tokenizer, orp, pacing, engine)
- [x] FastAPI iskelet (`/api/health`, `/api/reading/process`)
- [x] Flutter proje iskeleti (`apps/flutter/lumentum`)
- [x] `roadmap.md` oluşturuldu
- [x] Kalıcı altyapı kuralları (`.cursor/rules/`)
- [x] **Shared monorepo yapısı** (`packages/` + `apps/`)
- [x] **Contracts katmanı** (`packages/contracts/` — OpenAPI + JSON Schema)
- [x] **Dart shared SDK** (`packages/lumentum_shared/` — modeller + API client)
- [x] `docs/shared-architecture.md`
- [ ] `README.md` ve `todo.md` yeniden yazılacak (roadmap ile uyumlu)
- [ ] Python 3.12 ortamı (PyO3 uyumluluğu)
- [ ] Flutter SDK kurulumu ve `flutter doctor` doğrulama
- [ ] `docs/license-integration.md` (license.cicibyte.com API doğrulama)
- [ ] GitHub Actions CI (cargo test + dart test + pytest)

### Faz 1 — Ignition MVP (Web + Auth + Okuyucu)

**Hedef:** `lumentum.cicibyte.com` üzerinden kayıt, lisans, metin okuma.

#### Motor
- [ ] Gelişmiş tokenizer (Unicode)
- [ ] ORP++ v1 (hece heuristik)
- [ ] CPS v1 (bağlaç/uzunluk/büyük harf)
- [ ] PyO3 veya CLI production bridge

#### Backend
- [x] Modüler FastAPI yapısı
- [x] SQLite + kullanıcı modeli
- [x] Auth (register, login, JWT)
- [x] License client → `license.cicibyte.com` (mock mod aktif)
- [x] `/api/reading/process` (lisans korumalı)
- [ ] E-posta doğrulama (aaPanel mail server)

#### Flutter Web (öncelik 1)
- [x] Auth ekranları (kayıt: ad, soyad, e-posta, şifre)
- [x] License gate (expired → blok ekranı)
- [x] RSVP okuyucu ekranı
- [x] Metin yapıştır (TXT)
- [x] TR + EN i18n
- [ ] Uçtan uca web testi (local)

#### Flutter Android (öncelik 2)
- [ ] APK debug build ve cihaz testi

#### Flutter iOS (öncelik 3)
- [ ] IPA / TestFlight hazırlığı

#### Sunucu
- [ ] `lumentum.cicibyte.com` dizin yapısı kurulumu
- [ ] Nginx + SSL
- [ ] API systemd/supervisor servisi (izole port)
- [ ] İlk production deploy
- [ ] Mail server ile doğrulama e-postası testi

#### MVP Doğrulama
- [ ] Uçtan uca: kayıt → e-posta doğrula → giriş → lisans aktif → okuma
- [ ] 15 dakikalık kullanıcı testi

### Faz 2 — Library (EPUB/PDF, Senkron, Mobil Mağaza)

- [ ] Omni-Parser v2: EPUB, PDF gerçek implementasyon
- [ ] Kütüphane UI (import, liste, devam et)
- [ ] Okuma ilerlemesi bulut senkronu
- [ ] Android APK release (Play Store hazırlık)
- [ ] iOS IPA (TestFlight)
- [ ] Ek diller (de, fr, es, it, pt)
- [ ] PostgreSQL geçişi (opsiyonel)

### Faz 3 — Insight (Analitik ve Adaptif AI)

- [ ] Okuma oturumu metrikleri (WPM, fatigue score)
- [ ] Gün/saat performans grafikleri
- [ ] NLP difficulty scoring (backend AI worker)
- [ ] Kişisel hız profili → CPS otomatik ayar
- [ ] Dashboard ekranı

### Faz 4 — Topluluk & Sosyal Katman

**Hedef:** Master admin yönetimi, zengin profiller, arkadaşlık, kişisel feed, uzun roman bölümleri, PDF'ten otomatik yayın, bildirimler.

#### 4a — Kayıt & Profil Temeli
- [ ] Kayıt formuna `birth_date` (yaş) ve `country_code` (ülke seçici) ekle
- [ ] Yaş doğrulama (min 13, COPPA/GDPR uyumlu politika)
- [ ] Ülke listesi: ISO 3166-1, i18n ülke adları
- [ ] `users` tablosuna `birth_date`, `country_code`, `avatar_url`, `bio`, `role` migration
- [ ] Profil fotoğrafı yükleme (JPEG/PNG/WebP, max 2 MB, kare kırpma UI)
- [ ] Avatar URL servisi (`/api/users/avatars/{filename}`)
- [ ] Profil ekranı: avatar, ad, ülke, yaş (gizlilik ayarı opsiyonel Faz 4b)
- [ ] Studio yorum/beğeni/keşfet kartlarında yazar avatarı göster

#### 4b — Master Admin Paneli
- [ ] Bootstrap seed: `mozkarci1991@gmail.com` → `role=master_admin`
- [ ] `require_master_admin` dependency (JWT + role kontrolü)
- [ ] Admin dashboard: toplam kullanıcı, bugünkü kayıtlar, aktif lisans, ülke dağılımı
- [ ] Kullanıcı listesi: arama, filtre (ülke, lisans durumu, kayıt tarihi)
- [ ] Kullanıcı detay: ad, e-posta, yaş, ülke, avatar, lisans, arkadaş sayısı, yayın sayısı
- [ ] Master admin tüm profil fotoğraflarını ve sosyal grafiği görebilir
- [ ] Flutter `/admin` rotası — yalnızca master_admin rolünde görünür
- [ ] Admin audit log kim, ne zaman, hangi kullanıcıya baktı

#### 4c — Arkadaşlık Sistemi
- [ ] `friendships` tablosu + durum makinesi (pending → accepted | blocked)
- [ ] Kullanıcı arama: ad, soyad, e-posta (kısmi eşleşme; e-posta gizlilik ayarı)
- [ ] Arkadaşlık isteği gönder / kabul et / reddet / engelle
- [ ] Arkadaş listesi ekranı
- [ ] Karşılıklı arkadaş önerisi (aynı ülke, benzer okuma — basit heuristic)
- [ ] Master admin: tüm arkadaşlık ilişkilerini listeleyebilir

#### 4d — Kişiselleştirilmiş Sosyal Feed
- [ ] `/api/feed` — arkadaşların yayınları + beğenileri + yeni bölümler
- [ ] Feed sıralama: kronolojik + hafif relevance (ortak arkadaş etkileşimi)
- [ ] Feed kart tipleri: yeni yayın, yeni bölüm, beğeni, yorum
- [ ] Flutter feed sekmesi (Studio keşfet ile birleşik veya ayrı "Akış" sekmesi)
- [ ] Sonsuz kaydırma (cursor pagination)
- [ ] Master admin: global feed önizlemesi (moderasyon için)

#### 4e — Bölüm / Chapter Sistemi (Uzun Romanlar)
- [ ] `publication_chapters` tablosu — `publications` ile 1:N ilişki
- [ ] Yayın türü `roman` için bölüm zorunlu modu
- [ ] Bölüm CRUD: başlık, sıra, gövde metni, kelime sayısı
- [ ] Okuyucuda bölüm seçici + bölüm bazlı ilerleme senkronu
- [ ] Keşfet/feed'de "Bölüm 12 yayınlandı" kartı
- [ ] Taslak bölüm → yayınla akışı (Wattpad tarzı seri yayın)

#### 4f — PDF'ten Otomatik Yayın
- [ ] `POST /api/studio/import-pdf` — mevcut PDF extract pipeline'ını genişlet
- [ ] PDF → metin çıkarım → otomatik bölüm bölme (sayfa/başlık heuristic)
- [ ] Kapak: PDF ilk sayfa thumbnail veya kullanıcı seçimi
- [ ] İçerik türü, etiketler, görünürlük (public/friends/private) seçimi
- [ ] Tek tıkla Studio'ya yayınla + kütüphaneye ekle
- [ ] Web: mevcut `pdf_file_picker` entegrasyonu ile birleştir

#### 4g — Bildirimler
- [ ] `notifications` tablosu + tür enum (friend_request, friend_accept, like, comment, new_chapter, system)
- [ ] In-app bildirim merkezi (zil ikonu + okunmamış sayaç)
- [ ] Bildirim tercihleri (ayarlar: hangi türler açık)
- [ ] WebSocket veya SSE ile anlık push (Faz 4g-2)
- [ ] Mobil: FCM (Android) + APNs (iOS) — Faz 1b/1c ile paralel
- [ ] E-posta bildirimi (opsiyonel): arkadaşlık isteği, haftalık özet

#### Faz 4 Contracts & SDK
- [ ] `packages/contracts/` — UserProfile, Friendship, FeedItem, Chapter, Notification şemaları
- [ ] OpenAPI güncelle (admin, friends, feed, chapters, notifications)
- [ ] `lumentum_shared` modelleri + API client metodları
- [ ] Flutter UI (admin, social, notifications)

### Faz 5 — Expansion

- [ ] Focus State (bildirim karartma, minimal UI)
- [ ] Publisher SDK
- [ ] Eğitim platformu REST API
- [ ] Premium planlar (license sunucusu tier'ları ile)
- [ ] Marketplace ve gamification

---

## 13. Test Stratejisi

| Katman | Araç | Kapsam |
|--------|------|--------|
| Rust motor | `cargo test`, criterion bench | Tokenizer, ORP, CPS |
| Backend | pytest, httpx | Auth, license mock, reading API |
| Flutter | widget test, integration_test | Auth flow, reader render |
| E2E | Playwright (web) | Kayıt → okuma akışı |
| Lisans | Mock server | license.cicibyte.com contract test |

- [ ] Motor unit testleri genişlet
- [ ] License client mock testleri
- [ ] Auth integration testleri
- [ ] Flutter reader widget testi
- [ ] E2E smoke (staging)

---

## 14. İzleme ve Operasyon (Lumentum-only)

- [ ] `/api/health` — motor, DB, license reachability
- [ ] Lumentum log rotasyonu (`logs/`, 30 gün)
- [ ] Hata izleme (Sentry veya self-hosted, Lumentum projesi)
- [ ] Uptime ping (dış servis → `lumentum.cicibyte.com/api/health`)
- [ ] Deploy sonrası otomatik health check

---

## 15. Riskler ve Azaltma

| Risk | Etki | Azaltma |
|------|------|---------|
| Sunucuda diğer sistemlere yanlışlıkla müdahale | Yüksek | Deploy scriptleri path kilidi; code review |
| license.cicibyte.com API değişikliği | Orta | Adapter pattern; contract test |
| PyO3 / Python sürüm uyumsuzluğu | Orta | Python 3.12 pin; CLI fallback |
| Flutter web performans (120Hz) | Orta | WASM motor; Canvas optimizasyonu |
| iOS dağıtım sertifikaları | Orta | Erken Apple Developer kurulum |
| Arapça talebi | Düşük | Bilinçli hariç; dokümante |

---

## 16. Showcase Sitesi (`lumentum.cicibyte.com` kök)

> **Öncelik:** Mevcut Faz 1 iskeleti tamamlandıktan hemen sonra — production deploy öncesi showcase zorunlu.

`lumentum.cicibyte.com` yalnızca uygulama değil; Lumentum'u temsil eden **modern, efektli, kaliteli showcase** olmalıdır. Kullanıcılar siteden **Signup/Login** ile doğrudan uygulamaya geçer.

Detay: `docs/showcase-site.md`

### 16.1 Gereksinimler

- [x] Premium koyu tema, animasyonlu gradient arka plan
- [x] Hero bölümü + ürün vizyonu metni
- [x] Canlı ORP++ demo önizlemesi
- [x] Özellik kartları (ORP++, CPS, Göz yorgunluğu)
- [x] Signup / Login CTA'ları → auth → uygulama
- [x] Oturum açık kullanıcı → doğrudan HomeScreen
- [ ] Parallax / scroll animasyonları (ince ayar)
- [ ] Demo video veya interaktif okuma önizlemesi (15 sn)
- [ ] Çoklu dil showcase metinleri (DE, FR, ES — Faz 2)
- [ ] SEO meta, Open Graph, favicon seti
- [ ] Lighthouse performans ≥ 90 (web)
- [x] Production deploy → `lumentum.cicibyte.com`

### 16.2 Akış

```
Misafir → Showcase (/) → Sign up / Sign in → Home → Reader
Oturumlu → Home (showcase atlanır)
```

---

## 17. Sıradaki Hemen Yapılacaklar

Öncelik sırası:

1. [ ] Flutter SDK kurulumu + local web test (showcase → kayıt → okuma)
2. [ ] Showcase ince ayar (animasyon, SEO, favicon)
3. [x] Sunucuda Lumentum dizin yapısını kur (izole)
4. [x] Production API deploy → `lumentum.cicibyte.com/api/*`
5. [x] Flutter web build + showcase deploy → `lumentum.cicibyte.com/`
6. [ ] `license.cicibyte.com` API doğrulama + `docs/license-integration.md`
7. [ ] Python 3.12 + PyO3 derlemesi (sunucu motoru)
8. [ ] Android APK test — **Faz 1b**
9. [ ] iOS IPA — **Faz 1c**
10. [ ] Faz 4 planlama: kayıt alanları (yaş/ülke) + profil avatar API tasarımı

---

## 18. Master Admin, Topluluk ve Sosyal Katman (Detaylı Kurgu)

> **Faz:** 4 · **Bağımlılık:** Faz 1 auth + Studio iskeleti (kısmen canlı)  
> **Master Admin:** `mozkarci1991@gmail.com` — bootstrap seed, tek kaynak doğrulama

### 18.1 Rol ve Yetki Modeli

| Rol | Yetki |
|-----|-------|
| `user` | Kendi profili, arkadaşlık, feed, yayın, bildirimler |
| `master_admin` | Tüm kullanıcıları görüntüleme, istatistik dashboard, sosyal graf salt okunur erişim, moderasyon (gelecek) |

**Güvenlik ilkeleri:**

- Master admin JWT claim'inde `role: master_admin` taşınır; client'ta role kontrolü yeterli değil — her `/api/admin/*` endpoint'inde sunucu tarafı doğrulama zorunlu
- Master admin e-postası `.env` `MASTER_ADMIN_EMAIL` ile seed; production'da hardcode yok
- Admin paneli Flutter web'de `/admin` rotası; 403 durumunda sessiz yönlendirme (panel varlığı sızdırılmaz)
- Kullanıcı PII (yaş, ülke): master admin tam erişim; diğer kullanıcılara yalnızca profil gizlilik ayarına göre (varsayılan: yaş gizli, ülke görünür)

### 18.2 Kayıt Akışı (Genişletilmiş)

```
[Kayıt Formu]
  email, password, first_name, last_name
  birth_date (date picker — min 13 yaş)
  country_code (dropdown — bayrak + ülke adı, i18n)
    │
    ▼
POST /api/auth/register
    │
    ├──► Lumentum DB: user oluştur (birth_date, country_code)
    ├──► license.cicibyte.com: email, first_name, last_name (değişmez)
    ├──► mozkarci1991@gmail.com ise → role=master_admin otomatik
    └──► Hoş geldin e-postası + profil tamamlama yönlendirmesi (avatar opsiyonel)
```

### 18.3 Profil Fotoğrafı

```
Kullanıcı → Profil → Fotoğraf değiştir
    │
    ▼
PUT /api/users/me/avatar (multipart, max 2 MB)
    │
    ├──► Resize 256×256 + 64×64 thumbnail (Pillow)
    ├──► data/uploads/avatars/{user_id}.webp
    └──► users.avatar_url = "/api/users/avatars/{user_id}.webp"

Görünürlük:
  - Profil sayfası, arkadaş listesi, feed kartları, yorumlar, Studio yazar kartı
  - Master admin: tüm avatar URL'leri admin kullanıcı listesinde
  - Varsayılan: initials avatar (ad/soyad harfleri) avatar yoksa
```

### 18.4 Arkadaşlık ve Arama

```
[Arkadaş Ara ekranı]
  Arama kutusu → GET /api/friends/search?q=...
    │
    ├── Sonuç: avatar, ad, ülke, ortak arkadaş sayısı
    └── "Ekle" → POST /api/friends/requests { addressee_id }

[İstek geldi]
  Bildirim → Kabul / Reddet
    │
    └── Kabul → status=accepted, her iki tarafa bildirim

Durum makinesi:
  (none) → pending → accepted
                  → blocked (her iki yön engellenir)
                  → rejected (tekrar istek gönderilebilir, cooldown 24s)
```

### 18.5 Kişiselleştirilmiş Sosyal Feed

Mevcut **Lumentum Studio** keşfet akışına ek olarak, **"Akış"** sekmesi arkadaş odaklıdır:

| Feed öğesi | Kaynak | Sıralama ağırlığı |
|------------|--------|-------------------|
| Arkadaş yeni yayın | `publications` WHERE author IN friends | Yüksek |
| Arkadaş yeni bölüm | `publication_chapters` | Yüksek |
| Arkadaş beğenisi | `publication_likes` | Orta |
| Arkadaş yorumu | `publication_comments` | Orta |
| Keşfet önerisi | Global explore (düşük karışım) | Düşük |

Algoritma (v1 — basit, şeffaf):

1. Son 7 gün arkadaş aktiviteleri, `created_at DESC`
2. Aynı yazar ardışık kartları grupla (max 2)
3. Kullanıcı etkileşimi yoksa keşfet'ten 1 öneri her 5 kartta bir

Master admin: `/api/admin/feed/global` ile tüm platform aktivitesini izler.

### 18.6 Bölüm / Chapter Sistemi

Uzun romanlar (`content_type=roman`) tek parça metin yerine bölüm serisi olarak yönetilir:

```
Publication (roman)
  ├── Chapter 1 — "Başlangıç"     (published)
  ├── Chapter 2 — "Yolculuk"      (published)
  ├── Chapter 3 — "..."           (draft)
  └── ...

Okuyucu:
  - Bölüm listesi drawer
  - Bölüm bazlı reading_progress
  - "Son okunan: Bölüm 2, %67"
  - Yeni bölüm → push/in-app bildirim (takipçilere)
```

Studio yazma ekranı: "Tek parça" / "Bölümlü seri" modu seçimi.

### 18.7 PDF'ten Otomatik Yayın

Mevcut PDF içe aktarma (`extract-pdf` + kütüphane) Studio ile birleştirilir:

```
PDF seç (web file picker / mobil)
    │
    ▼
POST /api/studio/import-pdf
    │
    ├──► Rust/Python PDF extract → ham metin
    ├──► Bölüm bölme:
    │       • "Bölüm N" / "Chapter N" başlık pattern
    │       • veya her N sayfa (kullanıcı ayarlanabilir)
    ├──► Kapak: PDF sayfa 1 render veya varsayılan gradient
    ├──► Metadata: başlık (dosya adı), tür, etiketler
    └──► Response: Publication + chapters[] → Studio'da taslak

Kullanıcı → Önizle → Düzenle → Yayınla
```

### 18.8 Bildirim Mimarisi

```
                    ┌─────────────────┐
                    │  Event Bus      │
                    │  (in-process)   │
                    └────────┬────────┘
                             │
     friend_request ─────────┼───────── new_chapter
     like, comment ──────────┼───────── system
                             ▼
                    ┌─────────────────┐
                    │ notifications   │
                    │ tablosu         │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              ▼              ▼              ▼
        In-app (poll/    WebSocket/     FCM/APNs
         SSE v1)          SSE v2         (mobil)
```

Bildirim türleri ve tetikleyiciler:

| Tür | Tetikleyici | Varsayılan |
|-----|-------------|------------|
| `friend_request` | Arkadaşlık isteği | Açık |
| `friend_accept` | İstek kabul | Açık |
| `publication_like` | Eser beğenildi | Açık |
| `publication_comment` | Yorum yapıldı | Açık |
| `new_chapter` | Takip edilen seride yeni bölüm | Açık |
| `system` | Lisans, bakım | Açık (kapatılamaz) |

### 18.9 Mimari Diyagram (Sosyal Katman)

```
┌────────────── Flutter App ──────────────┐
│ Profile │ Friends │ Feed │ Admin*     │
│ Studio  │ Notifications (zil)          │
└──────────────────┬──────────────────────┘
                   │ lumentum_shared
                   ▼
┌────────────── FastAPI ──────────────────┐
│ auth │ users │ friends │ feed          │
│ studio (+ chapters) │ admin* │ notify  │
└──────────────────┬──────────────────────┘
                   ▼
         SQLite/PostgreSQL + uploads/
         (avatars, covers, pdfs)

* Admin: master_admin role only
```

### 18.10 Faz 4 Uygulama Sırası (Önerilen)

1. **4a** Kayıt (yaş/ülke) + profil avatar — diğer modüllerin temeli
2. **4b** Master admin panel — erken doğrulama için
3. **4e** Bölüm sistemi — Studio roman akışını tamamlar
4. **4f** PDF otomatik yayın — bölüm sistemi üzerine inşa
5. **4c** Arkadaşlık — feed öncesi sosyal graf
6. **4d** Kişisel feed — arkadaş + bölüm olayları
7. **4g** Bildirimler — tüm olayları bağlar

---

## Değişiklik Günlüğü

| Tarih | Değişiklik |
|-------|------------|
| 2026-06-11 | `roadmap.md` ilk sürüm — altyapı kuralları, mimari, faz planı, lisans akışı |
| 2026-06-11 | **Shared Brain** monorepo: `packages/` + `apps/`, contracts, lumentum_shared SDK |
| 2026-06-11 | Faz 1 iskelet: modüler API, auth, license, Flutter web shell + RSVP reader |
| 2026-06-11 | Showcase sitesi: landing, ORP demo, Signup/Login CTA (`docs/showcase-site.md`) |
| 2026-06-11 | **Faz 4 — Topluluk & Sosyal:** Master Admin (`mozkarci1991@gmail.com`), yaş/ülke kayıt, profil fotoğrafı, arkadaşlık, kişisel feed, bölüm sistemi, PDF otomatik yayın, bildirimler |

