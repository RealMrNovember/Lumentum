// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Lumentum';

  @override
  String get tagline => 'Sadece okuma. Özümse.';

  @override
  String get language => 'Dil';

  @override
  String get login => 'Giriş yap';

  @override
  String get register => 'Hesap oluştur';

  @override
  String get startTrial14Days => '14 gün ücretsiz dene';

  @override
  String get trialBadge => '14 gün deneme';

  @override
  String get email => 'E-posta';

  @override
  String get password => 'Şifre';

  @override
  String get firstName => 'Ad';

  @override
  String get lastName => 'Soyad';

  @override
  String get noAccount => 'Hesabın yok mu?';

  @override
  String get hasAccount => 'Zaten hesabın var mı?';

  @override
  String get startReading => 'Okumaya başla';

  @override
  String get pasteText => 'Metnini yapıştır veya yaz';

  @override
  String get process => 'Hazırla';

  @override
  String get play => 'Başlat';

  @override
  String get pause => 'Duraklat';

  @override
  String get reset => 'Sıfırla';

  @override
  String get speed => 'Hız';

  @override
  String get logout => 'Çıkış';

  @override
  String get licenseBlocked =>
      'Deneme süren doldu veya lisansın aktif değil. Destek ile iletişime geç.';

  @override
  String trialActiveUntil(String date) {
    return 'Deneme süresi: $date';
  }

  @override
  String welcomeUser(String name) {
    return 'Hoş geldin, $name';
  }

  @override
  String get errorGeneric => 'Bir şeyler ters gitti. Tekrar dene.';

  @override
  String get errorEmailRequired => 'E-posta adresini gir.';

  @override
  String get errorEmailInvalid => 'Geçerli bir e-posta adresi gir.';

  @override
  String get errorPasswordRequired => 'Şifreni gir.';

  @override
  String get errorPasswordShort => 'Şifre en az 8 karakter olmalı.';

  @override
  String get showcaseHeroTitle =>
      'Okumak yavaştır.\nBilişin öyle olmak zorunda değil.';

  @override
  String get showcaseHeroSubtitle =>
      'Bilgiyi beyninin gerçekten özümseyebileceği hız ve biçimde sunan bilişsel arayüz — sıradan bir hızlı okuyucu değil.';

  @override
  String get showcaseOrpLabel => 'ORP++ canlı önizleme';

  @override
  String get showcaseFeatureOrpTitle => 'ORP++ Motor';

  @override
  String get showcaseFeatureOrpDesc =>
      'Dinamik optimal tanıma noktası — hece farkındalıklı, kelimeye uyumlu odak.';

  @override
  String get showcaseFeatureCpsTitle => 'Bilişsel Tempo';

  @override
  String get showcaseFeatureCpsDesc =>
      'Hız anlam yoğunluğunu izler. Bağlaçlar hızlanır; karmaşık terimler nefes alır.';

  @override
  String get showcaseFeatureFocusTitle => 'Sıfır Göz Yorgunluğu';

  @override
  String get showcaseFeatureFocusDesc =>
      'Tek odak noktası. Tarama yok. Subvocalization yükü yok. Sadece akış.';

  @override
  String get showcaseCtaTitle => 'Farkı 15 dakikada hisset';

  @override
  String get showcaseCtaSubtitle =>
      '14 günlük ücretsiz denemeni başlat — kredi kartı gerekmez.';

  @override
  String get showcaseFooter => '© Cicibyte · Lumentum Bilişsel Okuma Motoru';

  @override
  String get navHome => 'Ana sayfa';

  @override
  String get navLibrary => 'Kütüphane';

  @override
  String get navProfile => 'Profil';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get libraryEmpty => 'Henüz belge yok. Metin ekleyin veya demoyu açın.';

  @override
  String get addDocument => 'Metin ekle';

  @override
  String get importPdf => 'PDF içe aktar';

  @override
  String get pdfImportFailed =>
      'PDF içe aktarılamadı. Metin tabanlı bir PDF deneyin veya metni yapıştırın.';

  @override
  String get pdfImporting => 'PDF içe aktarılıyor…';

  @override
  String get readingLanguage => 'Arayüz dili';

  @override
  String get documentTitle => 'Başlık';

  @override
  String get save => 'Kaydet';

  @override
  String get cancel => 'İptal';

  @override
  String wordCount(int count) {
    return '$count kelime';
  }

  @override
  String get licenseTitle => 'Lisans';

  @override
  String get licenseKey => 'Lisans anahtarı';

  @override
  String get activateLicense => 'Lisansı aktive et';

  @override
  String get licenseActivateHint =>
      'E-postanızdaki veya yönetim panelindeki anahtarı girin.';

  @override
  String get licenseActivated => 'Lisans başarıyla aktive edildi.';

  @override
  String get licenseStatus => 'Durum';

  @override
  String get licensePlan => 'Plan';

  @override
  String get licenseExpires => 'Bitiş';

  @override
  String get refresh => 'Yenile';

  @override
  String get refreshLicense => 'Lisans durumunu kontrol et';

  @override
  String get homeSubtitle =>
      'Bilişsel okuma merkezin — kütüphane, hız antrenmanı ve daha fazlası.';

  @override
  String get librarySubtitle =>
      'PDF ekle veya metin yapıştır. Okuduğun her şey burada.';

  @override
  String get libraryEmptyTitle => 'Kütüphaneni oluştur';

  @override
  String get getStartedLibrary => 'İlk belgeni ekle';

  @override
  String documentsCount(int count) {
    return '$count belge';
  }

  @override
  String get addToLibraryHint => 'PDF veya yapıştırılmış metin';

  @override
  String get trainYourSpeed => 'Hız antrenmanı';

  @override
  String sessionsCount(int count) {
    return '$count oturum tamamlandı';
  }

  @override
  String get comingSoonSocial => 'Topluluk';

  @override
  String get comingSoonSocialHint => 'Paylaş, arkadaşlar ve hikayeler';

  @override
  String get comingSoonSocialLong =>
      'Yakında PDF\'leri konuya göre paylaşabilecek, arkadaş ekleyebilecek, hikaye yazabilecek ve birbirinizin içeriklerini beğenebileceksiniz.';

  @override
  String get socialFeatureShare => 'PDF\'leri konuya göre paylaş';

  @override
  String get socialFeatureCategories => 'Kategorilerle düzenle';

  @override
  String get socialFeatureFriends => 'Arkadaş ekle';

  @override
  String get socialFeatureStories => 'Hikaye yaz ve beğen';

  @override
  String get continueReading => 'Okumaya devam et';

  @override
  String get continueButton => 'Devam';

  @override
  String get importPdfHint => 'PDF dosyasından metin çıkar';

  @override
  String get pasteTextHint => 'Herhangi bir metni yapıştır veya yaz';

  @override
  String readingProgress(int percent) {
    return '%$percent tamamlandı';
  }

  @override
  String wordsPerMinute(int wpm) {
    return '~$wpm KPM';
  }

  @override
  String get tapToPlay => 'Oynatmak veya duraklatmak için ortaya dokun';

  @override
  String get prepareFirst => 'Metnin hazırlanıyor…';

  @override
  String get navExplore => 'Keşfet';

  @override
  String get exploreSubtitle =>
      'Oku, yaz ve paylaş — Wattpad ile bilişsel okumanın buluştuğu yer.';

  @override
  String get exploreEmpty =>
      'Henüz paylaşılmış içerik yok. İlk hikayeyi sen yaz.';

  @override
  String get writeContent => 'Yaz';

  @override
  String get writeFirstStory => 'İlk hikayeni yaz';

  @override
  String get searchPublications => 'Başlık veya yazar ara…';

  @override
  String get filterAll => 'Tümü';

  @override
  String get contentTypeBook => 'Kitap';

  @override
  String get contentTypeArticle => 'Makale';

  @override
  String get contentTypePoem => 'Şiir';

  @override
  String get contentTypeNews => 'Haber';

  @override
  String get contentTypeNovel => 'Roman';

  @override
  String get contentTypeEncyclopedia => 'Ansiklopedi';

  @override
  String get selectContentType => 'İçerik türü';

  @override
  String get uploadCover => 'Kapak görseli yükle';

  @override
  String get publicationSummary => 'Özet';

  @override
  String get publicationBody => 'İçerik';

  @override
  String get publicationTags => 'Etiketler';

  @override
  String get publicationTagsHint => 'aşk, bilim-kurgu, tarih';

  @override
  String get publish => 'Yayınla';

  @override
  String get publicationPublished => 'Başarıyla yayınlandı!';

  @override
  String get readWithLumentum => 'Lumentum ile oku';

  @override
  String get commentsTitle => 'Yorumlar';

  @override
  String get addCommentHint => 'Yorum yaz…';

  @override
  String get myWorks => 'Eserlerim';

  @override
  String get myWorksHint => 'Yayınladığın hikaye ve makaleler';

  @override
  String get myWorksEmpty => 'Henüz bir şey yayınlamadın.';
}
