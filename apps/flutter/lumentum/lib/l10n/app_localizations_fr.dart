// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Lumentum';

  @override
  String get tagline => 'Ne lisez pas. Absorbez.';

  @override
  String get language => 'Langue';

  @override
  String get login => 'Connexion';

  @override
  String get register => 'Créer un compte';

  @override
  String get startTrial14Days => 'Essai gratuit 14 jours';

  @override
  String get trialBadge => 'Essai 14 jours';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get firstName => 'Prénom';

  @override
  String get lastName => 'Nom';

  @override
  String get noAccount => 'Pas de compte ?';

  @override
  String get hasAccount => 'Déjà un compte ?';

  @override
  String get startReading => 'Commencer à lire';

  @override
  String get pasteText => 'Collez ou saisissez votre texte';

  @override
  String get process => 'Préparer';

  @override
  String get play => 'Lecture';

  @override
  String get pause => 'Pause';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get speed => 'Vitesse';

  @override
  String get logout => 'Déconnexion';

  @override
  String get licenseBlocked => 'Essai expiré ou licence inactive.';

  @override
  String trialActiveUntil(String date) {
    return 'Essai actif jusqu\'au $date';
  }

  @override
  String welcomeUser(String name) {
    return 'Bienvenue, $name';
  }

  @override
  String get errorGeneric => 'Une erreur s\'est produite.';

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
      'La lecture est lente.\nLa cognition ne doit pas l\'être.';

  @override
  String get showcaseHeroSubtitle =>
      'Une interface cognitive pour une absorption optimale de l\'information.';

  @override
  String get showcaseOrpLabel => 'Aperçu ORP++ en direct';

  @override
  String get showcaseFeatureOrpTitle => 'Moteur ORP++';

  @override
  String get showcaseFeatureOrpDesc =>
      'Point de reconnaissance optimal dynamique.';

  @override
  String get showcaseFeatureCpsTitle => 'Rythme cognitif';

  @override
  String get showcaseFeatureCpsDesc => 'La vitesse suit la densité du sens.';

  @override
  String get showcaseFeatureFocusTitle => 'Zéro fatigue oculaire';

  @override
  String get showcaseFeatureFocusDesc => 'Un seul point focal. Flux pur.';

  @override
  String get showcaseCtaTitle => 'Sentez la différence en 15 minutes';

  @override
  String get showcaseCtaSubtitle => 'Démarrez votre essai gratuit de 14 jours.';

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
