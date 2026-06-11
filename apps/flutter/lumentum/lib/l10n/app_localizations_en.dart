// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Lumentum';

  @override
  String get tagline => 'Don\'t just read. Absorb.';

  @override
  String get language => 'Language';

  @override
  String get login => 'Sign in';

  @override
  String get register => 'Create account';

  @override
  String get startTrial14Days => 'Start 14-day free trial';

  @override
  String get trialBadge => '14-day trial';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get firstName => 'First name';

  @override
  String get lastName => 'Last name';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get hasAccount => 'Already have an account?';

  @override
  String get startReading => 'Start reading';

  @override
  String get pasteText => 'Paste or type your text';

  @override
  String get process => 'Prepare';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get reset => 'Reset';

  @override
  String get speed => 'Speed';

  @override
  String get logout => 'Sign out';

  @override
  String get licenseBlocked =>
      'Your trial has ended or your license is inactive. Contact support.';

  @override
  String trialActiveUntil(String date) {
    return 'Trial active until $date';
  }

  @override
  String welcomeUser(String name) {
    return 'Welcome, $name';
  }

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

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
      'Reading is slow.\nCognition doesn\'t have to be.';

  @override
  String get showcaseHeroSubtitle =>
      'A cognitive interface that delivers information at the speed and form your brain can truly absorb — not just another speed reader.';

  @override
  String get showcaseOrpLabel => 'ORP++ live preview';

  @override
  String get showcaseFeatureOrpTitle => 'ORP++ Engine';

  @override
  String get showcaseFeatureOrpDesc =>
      'Dynamic optimal recognition point — syllable-aware focus that adapts to each word.';

  @override
  String get showcaseFeatureCpsTitle => 'Cognitive Pacing';

  @override
  String get showcaseFeatureCpsDesc =>
      'Speed follows meaning density. Conjunctions accelerate; complex terms breathe.';

  @override
  String get showcaseFeatureFocusTitle => 'Zero Eye Strain';

  @override
  String get showcaseFeatureFocusDesc =>
      'One focal point. No scanning. No subvocalization drag. Just flow.';

  @override
  String get showcaseCtaTitle => 'Feel the difference in 15 minutes';

  @override
  String get showcaseCtaSubtitle =>
      'Start your 14-day free trial — no credit card required.';

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
