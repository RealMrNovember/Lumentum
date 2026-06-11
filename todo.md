# LUMENTUM — Aktif İş Listesi

> Ana plan: [`roadmap.md`](roadmap.md) · Showcase: [`docs/showcase-site.md`](docs/showcase-site.md) · Lisans: [`docs/license-integration.md`](docs/license-integration.md)

## Öncelik Sırası

1. **Web** (test + showcase) → 2. **Android** → 3. **iOS**

---

## Şimdi — license.cicibyte.com panel (öncelik)

- [x] Sistem incelemesi (Filament v3, API akışı, DB şeması)
- [x] Lisans oluşturma: **e-posta + yetkili adı** alanları
- [x] **Süre aktivasyonda başlasın** (kod girilince süre başlar)
- [x] Tablo: e-posta, aktivasyon durumu, bitiş, filtreler
- [x] **Deploy** sunucuya (migration + cache clear)

## Lumentum uygulama (devam)

- [x] **Kütüphane** — demo metinler + metin ekleme
- [x] **Örnek uzun okuma** (EN/TR demo belgeleri)
- [x] **Ayarlar** sayfası (dil + çıkış)
- [x] **Profil** sayfası (e-posta, lisans süresi)
- [x] Uygulama içi **dil seçici** (Ayarlar)
- [x] **Lisans kodu aktivasyon** ekranı + API `/license/activate`
- [x] PDF içe aktarma (API extract-pdf + kütüphane)
- [x] Reader’da dil seçici (app bar)
- [x] **Modern UI** — kütüphane merkezli shell, alt navigasyon, gradient tema
- [x] Kütüphane ekranı — PDF/metin ekleme butonları, belge kartları
- [x] Okuyucu — immersive mod, hız kaydı, ilerleme + KPM, dokunmatik oynat
- [x] Okuma tercihleri (`ReadingPreferencesProvider`) — hız + son belge + oturum sayısı
- [x] Profil — topluluk özellikleri (yakında) önizlemesi
- [x] **Deploy** yeni web build → `lumentum.cicibyte.com`
- [x] Login düzeltmesi + detaylı hata yakalama (`AuthFailure`, `AuthErrorPanel`)
- [x] **Lumentum Studio** — Wattpad/Instagram tarzı paylaşım (API + UI)
- [x] İçerik türleri: kitap, makale, şiir, haber, roman, ansiklopedi
- [x] Kapak yükleme, beğeni, yorum, keşfet akışı, eserlerim

## Web & Showcase

- [x] Flutter SDK kur (`C:\flutter`, web enabled)
- [ ] Local test: showcase → 14 gün deneme kayıt → giriş → okuyucu
- [x] Showcase landing (hero, ORP demo, özellikler, Signup/Login CTA)
- [x] **14 günlük deneme** metinleri + kayıt akışı (`license/trial`)
- [x] **i18n:** TR, EN, DE, FR, ES + tarayıcı/cihaz dili + dil seçici
- [x] Showcase SEO meta + PWA manifest
- [x] Production API deploy (`/api/health` canlı)
- [x] Flutter web build + showcase deploy (sunucu kökü)
- [x] `license.cicibyte.com` entegrasyonu (`app_code: lumentum`)
- [x] cicibyte.com Our Products → `https://lumentum.cicibyte.com`

## Tamamlanan — Faz 0 / Faz 1 İskelet

- [x] Shared monorepo (`packages/` + `apps/`)
- [x] Rust motor pipeline
- [x] Modüler FastAPI (auth, license, reading)
- [x] `lumentum_shared` Dart SDK
- [x] Flutter auth + RSVP reader
- [x] Kalıcı altyapı kuralları + roadmap

## Sonra — Android & iOS

- [ ] Android APK debug build
- [ ] iOS TestFlight hazırlığı

## Sonra — Entegrasyonlar

- [ ] E-posta doğrulama (aaPanel mail)
- [ ] PyO3 Python 3.12 derlemesi
