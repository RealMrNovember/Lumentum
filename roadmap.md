# LUMENTUM — Üretim Yol Haritası

> **Durum:** Canlı takip dosyası — tamamlanan maddeler `[x]`, bekleyenler `[ ]` ile işaretlenir.  
> **Son güncelleme:** 2026-06-11  
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

Sosyal özellikler, marketplace, gamification — Faz 4 sonrasına ertelenir.

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
| locale | Hayır | Varsayılan: tarayıcı/cihaz dili |

### 5.2 Auth Akışları

- [ ] Kayıt + e-posta doğrulama (sunucu mail server)
- [ ] Giriş (JWT access 15dk + refresh 30 gün)
- [ ] Şifre sıfırlama (e-posta linki)
- [ ] Oturum sonlandırma / tüm cihazlardan çıkış
- [ ] Mobil: secure storage (flutter_secure_storage)

### 5.3 Veri Modeli (özet)

```
users: id, email, password_hash, first_name, last_name, locale,
       email_verified, license_status, created_at, updated_at

sessions: id, user_id, device_id, platform, last_active

reading_progress: id, user_id, content_id, position, wpm_avg, updated_at
```

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

### 7.2 Backend Görevleri

- [x] Temel `/health` ve `/process` iskeleti
- [ ] Proje yapısını `api/app/` modüler yapıya taşı
- [ ] SQLAlchemy + Alembic migrations
- [ ] JWT auth middleware
- [ ] License client entegrasyonu
- [ ] E-posta servisi (aaPanel SMTP)
- [ ] Rate limiting (slowapi)
- [ ] Structured logging (Lumentum logs/ only)
- [ ] OpenAPI docs `/api/docs` (prod'da kısıtlı)
- [ ] CORS: yalnızca `lumentum.cicibyte.com` ve mobil deep link

---

## 8. Flutter İstemci (Web + Android + iOS)

### 8.1 Uygulama Modülleri

```
lib/
├── main.dart
├── app.dart                    # MaterialApp, routing, theme
├── core/
│   ├── api/                    # Dio HTTP client, interceptors
│   ├── auth/                   # Auth state, secure storage
│   ├── license/                # License gate, expiry UI
│   ├── i18n/                   # l10n ARB files
│   └── theme/                  # Dark/light, typography
├── features/
│   ├── onboarding/
│   ├── auth/                   # Login, register, verify
│   ├── reader/                 # RSVP canvas, ORP highlight
│   ├── library/                # İçerik listesi (Faz 2)
│   ├── settings/
│   └── profile/
└── shared/
    └── widgets/
```

### 8.2 RSVP Okuyucu Ekranı (Çekirdek UX)

- [ ] 120Hz hedefli merkezi kelime render
- [ ] ORP odak harfi renk/vurgu ile gösterim
- [ ] Gesture: sağa hızlan, sola yavaşla, uzun bas duraklat
- [ ] Altın kural: slider değişince CPS arka planda adapte olur
- [ ] Oturum sonu: kelime sayısı, ortalama WPM, süre

### 8.3 Platform Görevleri

- [ ] `main.dart` demo kodunu kaldır, Lumentum shell kur
- [ ] Web build → `lumentum.cicibyte.com/web/`
- [ ] Android APK imzalama (release keystore — Cicibyte)
- [ ] iOS IPA (Apple Developer hesabı gerekli)
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
# Rust motor
cargo test -p lumentum_core
cargo build --release -p core_engine_cli

# Backend
cd api_service
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8000

# Flutter
cd mobile_app/flutter/lumentum_reader
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

- [x] Git repo ve Rust workspace (`core_engine`, `core_engine_py`, `core_engine_cli`)
- [x] Temel motor pipeline (tokenizer, orp, pacing, engine)
- [x] FastAPI iskelet (`/health`, `/process`)
- [x] Flutter proje iskeleti (platformlar)
- [x] `roadmap.md` oluşturuldu
- [x] Kalıcı altyapı kuralları (`.cursor/rules/`)
- [ ] `README.md` ve `todo.md` yeniden yazılacak (roadmap ile uyumlu)
- [ ] Python 3.12 ortamı (PyO3 uyumluluğu)
- [ ] Flutter SDK kurulumu ve `flutter doctor` doğrulama
- [ ] `docs/` klasörü: `architecture.md`, `api-contract.md`, `license-integration.md`
- [ ] GitHub Actions CI (test only, deploy yok)

### Faz 1 — Ignition MVP (Web + Auth + Okuyucu)

**Hedef:** `lumentum.cicibyte.com` üzerinden kayıt, lisans, metin okuma.

#### Motor
- [ ] Gelişmiş tokenizer (Unicode)
- [ ] ORP++ v1 (hece heuristik)
- [ ] CPS v1 (bağlaç/uzunluk/büyük harf)
- [ ] PyO3 veya CLI production bridge

#### Backend
- [ ] Modüler FastAPI yapısı
- [ ] SQLite + kullanıcı modeli
- [ ] Auth (register, login, JWT, e-posta doğrulama)
- [ ] License client → `license.cicibyte.com`
- [ ] `/api/reading/process` (lisans korumalı)

#### Flutter
- [ ] Auth ekranları (kayıt: ad, soyad, e-posta, şifre)
- [ ] License gate (expired → blok ekranı)
- [ ] RSVP okuyucu ekranı
- [ ] Metin yapıştır / dosya aç (TXT)
- [ ] TR + EN i18n

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

### Faz 4 — Expansion

- [ ] Focus State (bildirim karartma, minimal UI)
- [ ] Publisher SDK
- [ ] Eğitim platformu REST API
- [ ] Premium planlar (license sunucusu tier'ları ile)

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

## 16. Sıradaki Hemen Yapılacaklar

Öncelik sırası (Faz 0 tamamlama → Faz 1 başlangıç):

1. [ ] `license.cicibyte.com` API endpoint'lerini doğrula ve `docs/license-integration.md` yaz
2. [ ] `README.md` ve `todo.md` roadmap ile senkronize et
3. [ ] Python 3.12 + PyO3 derlemesini düzelt
4. [ ] FastAPI modüler yapı (`api/app/`) — auth + license iskeleti
5. [ ] Flutter demo kaldır → auth + reader shell
6. [ ] Sunucuda Lumentum dizin yapısını kur (izole)
7. [ ] İlk staging deploy: `lumentum.cicibyte.com`

---

## Değişiklik Günlüğü

| Tarih | Değişiklik |
|-------|------------|
| 2026-06-11 | `roadmap.md` ilk sürüm — altyapı kuralları, mimari, faz planı, lisans akışı |
