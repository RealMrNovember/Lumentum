// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Lumentum';

  @override
  String get tagline => 'No solo leas. Absorbe.';

  @override
  String get language => 'Idioma';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get register => 'Crear cuenta';

  @override
  String get startTrial14Days => 'Prueba gratis 14 días';

  @override
  String get trialBadge => 'Prueba 14 días';

  @override
  String get email => 'Correo';

  @override
  String get password => 'Contraseña';

  @override
  String get firstName => 'Nombre';

  @override
  String get lastName => 'Apellido';

  @override
  String get noAccount => '¿No tienes cuenta?';

  @override
  String get hasAccount => '¿Ya tienes cuenta?';

  @override
  String get startReading => 'Empezar a leer';

  @override
  String get pasteText => 'Pega o escribe tu texto';

  @override
  String get process => 'Preparar';

  @override
  String get play => 'Reproducir';

  @override
  String get pause => 'Pausa';

  @override
  String get reset => 'Reiniciar';

  @override
  String get speed => 'Velocidad';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get licenseBlocked => 'Prueba expirada o licencia inactiva.';

  @override
  String trialActiveUntil(String date) {
    return 'Prueba activa hasta $date';
  }

  @override
  String welcomeUser(String name) {
    return 'Bienvenido, $name';
  }

  @override
  String get errorGeneric => 'Algo salió mal.';

  @override
  String get errorEmailRequired => 'Enter your email address.';

  @override
  String get errorEmailInvalid => 'Enter a valid email address.';

  @override
  String get errorPasswordRequired => 'Enter your password.';

  @override
  String get errorPasswordShort => 'Password must be at least 8 characters.';

  @override
  String get showcaseHeroTitle =>
      'Leer es lento.\nLa cognición no tiene por qué serlo.';

  @override
  String get showcaseHeroSubtitle =>
      'Una interfaz cognitiva para absorber información de forma óptima.';

  @override
  String get showcaseOrpLabel => 'Vista previa ORP++ en vivo';

  @override
  String get showcaseFeatureOrpTitle => 'Motor ORP++';

  @override
  String get showcaseFeatureOrpDesc =>
      'Punto de reconocimiento óptimo dinámico.';

  @override
  String get showcaseFeatureCpsTitle => 'Ritmo cognitivo';

  @override
  String get showcaseFeatureCpsDesc =>
      'La velocidad sigue la densidad del significado.';

  @override
  String get showcaseFeatureFocusTitle => 'Cero fatiga visual';

  @override
  String get showcaseFeatureFocusDesc => 'Un punto focal. Flujo puro.';

  @override
  String get showcaseCtaTitle => 'Siente la diferencia en 15 minutos';

  @override
  String get showcaseCtaSubtitle => 'Inicia tu prueba gratuita de 14 días.';

  @override
  String get showcaseFooter => '© Cicibyte · Lumentum Cognitive Reading Engine';

  @override
  String get navHome => 'Home';

  @override
  String get navLibrary => 'Library';

  @override
  String get navProfile => 'Profile';

  @override
  String get navSettings => 'Settings';

  @override
  String get libraryEmpty => 'No documents yet. Add text or open a demo.';

  @override
  String get addDocument => 'Add text';

  @override
  String get importPdf => 'Import PDF';

  @override
  String get pdfImportFailed =>
      'Could not import PDF. Try a text-based PDF or paste the text instead.';

  @override
  String get pdfImporting => 'Importing PDF…';

  @override
  String get pdfImportSuccess => 'added to library.';

  @override
  String get readingLanguage => 'Interface language';

  @override
  String get documentTitle => 'Title';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String wordCount(int count) {
    return '$count words';
  }

  @override
  String get licenseTitle => 'License';

  @override
  String get licenseKey => 'License key';

  @override
  String get activateLicense => 'Activate license';

  @override
  String get licenseActivateHint =>
      'Enter the key from your email or the admin panel.';

  @override
  String get licenseActivated => 'License activated successfully.';

  @override
  String get licenseStatus => 'Status';

  @override
  String get licensePlan => 'Plan';

  @override
  String get licenseExpires => 'Expires';

  @override
  String get refresh => 'Refresh';

  @override
  String get refreshLicense => 'Check license status';

  @override
  String get homeSubtitle =>
      'Your cognitive reading hub — library, speed training, and more.';

  @override
  String get librarySubtitle =>
      'Add PDFs or paste text. Everything you read lives here.';

  @override
  String get libraryEmptyTitle => 'Build your library';

  @override
  String get getStartedLibrary => 'Add your first document';

  @override
  String documentsCount(int count) {
    return '$count documents';
  }

  @override
  String get addToLibraryHint => 'PDF or pasted text';

  @override
  String get trainYourSpeed => 'Speed training';

  @override
  String sessionsCount(int count) {
    return '$count sessions completed';
  }

  @override
  String get comingSoonSocial => 'Community';

  @override
  String get comingSoonSocialHint => 'Share, friends & stories';

  @override
  String get comingSoonSocialLong =>
      'Soon you\'ll share PDFs by category, add friends, write stories, and like each other\'s work.';

  @override
  String get socialFeatureShare => 'Share PDFs by topic';

  @override
  String get socialFeatureCategories => 'Organize with categories';

  @override
  String get socialFeatureFriends => 'Add friends';

  @override
  String get socialFeatureStories => 'Write stories & like posts';

  @override
  String get continueReading => 'Continue reading';

  @override
  String get continueButton => 'Continue';

  @override
  String get importPdfHint => 'Extract text from a PDF file';

  @override
  String get pasteTextHint => 'Paste or type any text';

  @override
  String readingProgress(int percent) {
    return '$percent% complete';
  }

  @override
  String wordsPerMinute(int wpm) {
    return '~$wpm WPM';
  }

  @override
  String get tapToPlay => 'Tap center to play or pause';

  @override
  String get prepareFirst => 'Preparing your text…';

  @override
  String get navExplore => 'Explore';

  @override
  String get exploreSubtitle =>
      'Read, write and share stories — Wattpad meets cognitive reading.';

  @override
  String get exploreEmpty =>
      'No publications yet. Be the first to share your story.';

  @override
  String get writeContent => 'Write';

  @override
  String get writeFirstStory => 'Write your first story';

  @override
  String get searchPublications => 'Search titles or authors…';

  @override
  String get filterAll => 'All';

  @override
  String get contentTypeBook => 'Book';

  @override
  String get contentTypeArticle => 'Article';

  @override
  String get contentTypePoem => 'Poem';

  @override
  String get contentTypeNews => 'News';

  @override
  String get contentTypeNovel => 'Novel';

  @override
  String get contentTypeEncyclopedia => 'Encyclopedia';

  @override
  String get selectContentType => 'Content type';

  @override
  String get uploadCover => 'Upload cover image';

  @override
  String get publicationSummary => 'Summary';

  @override
  String get publicationBody => 'Content';

  @override
  String get publicationTags => 'Tags';

  @override
  String get publicationTagsHint => 'romance, sci-fi, history';

  @override
  String get publish => 'Publish';

  @override
  String get publicationPublished => 'Published successfully!';

  @override
  String get readWithLumentum => 'Read with Lumentum';

  @override
  String get commentsTitle => 'Comments';

  @override
  String get addCommentHint => 'Write a comment…';

  @override
  String get myWorks => 'My works';

  @override
  String get myWorksHint => 'Stories and articles you\'ve published';

  @override
  String get myWorksEmpty => 'You haven\'t published anything yet.';
}
