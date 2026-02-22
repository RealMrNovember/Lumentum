# LUMENTUM — Faz Bazlı Yol Haritası ve İş Listesi

Bu dosya, LUMENTUM’in “en küçük yapı taşından uçtaki ürün deneyimine” kadar tüm adımlarını fazlar halinde ve eyleme dönük maddelerle listeler. Mantık, README’deki vizyon ve çekirdek sistemlerle tam uyumludur: ORP++ Engine, Cognitive Pacing System (CPS), Omni-Parser v2, Focus State, Insight Engine; teknoloji olarak Rust çekirdek, Flutter arayüz, FastAPI + Redis backend, arka planda karar veren AI katmanı.

## Faz 0 — Temeller ve Altyapı
- [ ] Geliştirme ortamını kur: Rust toolchain (MSVC/GNU), Python 3.12, pip, Flutter SDK
- [ ] Windows için gerekli derleyici/linker: Visual C++ Build Tools kur ve doğrula
- [ ] Proje workspace’i kur: core_engine, core_engine_cli, core_engine_py, api_service, mobile_app/flutter
- [ ] Ortak .gitignore ve temel dizin düzeni oluştur
- [ ] CI yapılandır: GitHub Actions (Rust test, Python backend test, Flutter build)
- [ ] Kod standartları: biçimlendirme (rustfmt), lint (clippy), pre-commit
- [ ] Güvenlik kuralları: sırların loglanmaması, PII koruması, güvenli config
- [ ] Log/metric ilkeleri: minimal, gizlilik odaklı, hata izleme altyapısı seçimi

## Faz 1 — Ignition (RSVP + ORP MVP, Local Only)
### Çekirdek Motor (Rust)
- [x] Tokenization: Unicode-uyumlu, noktalama/bağlaç/ek, kısaltma & sayı desteği
- [x] ORP++: hece temelli dinamik odak; teknik terimlerde çoklu odak noktası
- [x] “Tanıma anı” mikro gecikmeleri: kelime tanınma sinyallerine göre zamanlama
- [x] CPS: anlam yoğunluğu, dilbilgisel rol, cümle konumu, semantik ilişki ile hız
- [ ] Micro-timing buffer: akış halinde gecikme/sürat kontrolü
- [ ] Motor API: token, focus_index, pace_ms, bayraklar; stream çıktısı
- [ ] Birim testleri ve mikro kıyaslar (bench)
### Arayüz (Flutter)
- [ ] Tek merkezde render edilen 120Hz RSVP canvas
- [ ] ORP odak harfi/pozisyonunu görselleştir ve tipografi optimizasyonu
- [ ] Gesture tabanlı hız kontrolü; kullanıcının hissi “ben kontrol ediyorum”
- [ ] Yerel ayarlar: hız, font, tema; yorgunluğu azaltan minimal UI
### Backend (FastAPI)
- [x] /health ve /process uçları; yerel metin için akış işleme
- [x] Rust çekirdeğe köprü: pyo3 modülü (MSVC hazır olduğunda) veya CLI
- [x] Basit hata yönetimi ve giriş doğrulama
### Doğrulama
- [ ] MVP hissi: ORP farkı ve göz yorgunluğu farkının algılanması
- [ ] Örnek metinlerle hız/odak testleri

## Faz 2 — Library (EPUB/PDF, Profiller, Cloud Sync)
### Omni-Parser v2
- [ ] TXT akış normalizasyonu; başlık/paragraf ayrımı
- [ ] PDF → layout bağımsız akış: sütun tespiti, görsel/tabloların işlenmesi
- [ ] EPUB → metadata içe alma, chapter intelligence, dipnot/altyazı yönetimi
- [ ] Web URL → reklamsız, semantik temizleme, izleyici/çerez engelleme
- [ ] Kod blokları/tablolar → akıllı atlama ya da yavaşlatma politikaları
### Backend ve Depolama
- [ ] İçerik alma uçları: PDF/EPUB/Web kaynaklarından ingest API
- [ ] Kullanıcı profili ve kütüphane modeli; Redis/DB seçimi ve şema
- [ ] Cihazlar arası senkronizasyon: ilerleme, yer imi, ayarlar
- [ ] Basit yetkilendirme (çoklu oturum güvenliği)
### Arayüz Gelişmeleri
- [ ] Kütüphane listesi, import akışları, okuma durumu gösterimleri
- [ ] Hızlı arama/filtre ve kaldığın yerden devam
### Test ve Kalite
- [ ] Parser doğrulama setleri (çeşitli PDF/EPUB/Web örnekleri)
- [ ] Dayanıklılık/performans testleri; hata senaryoları

## Faz 3 — Insight (Analitik, Raporlar, Adaptif Hız AI)
### Insight Engine
- [ ] Gün/saat bazlı performans toplanması
- [ ] İçerik türüne göre hız & anlayış skorlaması
- [ ] Mental fatigue score ve geri bildirim ekranları
- [ ] Görsel analitik: ego okşayan ama faydalı grafikler
### AI Katmanı
- [ ] NLP difficulty scoring; konu/terim yoğunluğu analizi
- [ ] Sentence complexity detection; uzun/karmaşık cümlelerin yavaşlatılması
- [ ] Kişisel hız profili çıkarımı; arka planda karar verip CPS’yi ayarlama
- [ ] “AI önermez, karar verir” ilkesine uyum ve açıklanabilirlik sınırları
### Backend Analitik
- [ ] Veri işleme boru hattı; anonimleştirme ve gizlilik
- [ ] Dashboard API’leri ve rapor üretimi

## Faz 4 — Expansion (Publisher SDK, Eğitim API, Premium)
- [ ] Publisher SDK: gömülebilir widget ve dokümantasyon
- [ ] Eğitim platformları için REST API: hız profilleri, içerik adaptasyonu
- [ ] Premium abonelik modeli: planlar, lisanslama, ödeme akışları
- [ ] Rate limit / kota ve kimlik doğrulama politikaları

## Faz X — Focus State (Bilişsel İzolasyon)
- [ ] Bildirim karartma ve odak modu
- [ ] Göz hizasına kilitlenen minimal UI ayarları
- [ ] Oturum sonrası mental yorgunluk puanı ve öneriler

## Platformlar ve Dağıtım
- [ ] Flutter ile iOS/Android/Desktop parity
- [ ] Masaüstü paketleri: Windows/Mac/Linux için paketleme ve imzalama
- [ ] Mağaza yayınları ve güncelleme altyapısı

## Performans ve Güvenlik (Kesitsel)
- [ ] Gecikme bütçeleri: engine→UI toplam gecikme hedefleri
- [ ] Streaming/async tasarım: backpressure ve hatasız akış
- [ ] Bellek ve CPU profilleri; flamegraph/bench rutinleri
- [ ] PII koruması; veri sınırlama ve şifreleme
- [ ] Sır yönetimi: .env/secret vault, asla loglama yok

## Erişilebilirlik ve I18N
- [ ] Çok dil desteği: TR/EN öncelikli, dil algılama
- [ ] Bidi/CJK/Arabic yazı sistemleriyle ORP uyarlaması
- [ ] Yüksek kontrast, font seçenekleri, klavye/ekran okuyucu uyumu

## DevOps ve Kalite
- [ ] CI/CD: test/build/release otomasyonu; artefact yayınlama
- [ ] Sürümleme ve değişiklik günlüğü (changelog)
- [ ] Hata izleme ve telemetri (gizlilik odaklı)
- [ ] Yedekleme ve geri yükleme prosedürleri

## MVP Kabul Kriterleri (README ile uyumlu)
- [ ] Kullanıcı 15 dakikada farkı hissediyor
- [ ] ORP farkı bariz
- [ ] Göz yorgunluğu azalıyor
- [ ] “Bu başka bir şey” hissi var

## Yapılmışlar (İlk Kurulum)
- [x] Depo klonlandı ve çalışma dizini hazırlandı
- [x] Rust çekirdek motorun temel modülleri (tokenizer, orp, pacing, engine)
- [x] FastAPI backend iskeleti ve /health, /process uçları
- [x] Rust CLI köprüsü ile backend entegrasyonu
- [x] Python embedded + pip kurulumu; bağımlılıklar yüklendi
- [x] Çekirdek motor testleri çalıştırıldı
- [x] Backend ayağa kaldırıldı ve doğrulandı

## Sonraki Yakın Adımlar
- [ ] Flutter SDK kurulumunu tamamla ve flutter doctor çıktısını al
- [x] /process yanıtını yapılandırılmış JSON (token, focus_index, pace_ms) yap
- [x] Omni-Parser v2 için TXT/EPUB/PDF modüllerinin iskeletini çıkar
- [x] Pyo3 (MSVC) ile native Python modülünü derle ve backend’e doğrudan bağla
- [ ] Basit performans bench’leri ekle ve hedef latansiyi ölç

