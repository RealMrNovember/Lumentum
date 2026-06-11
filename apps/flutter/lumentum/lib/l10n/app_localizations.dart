import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Lumentum'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Don\'t just read. Absorb.'**
  String get tagline;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get register;

  /// No description provided for @startTrial14Days.
  ///
  /// In en, this message translates to:
  /// **'Start 14-day free trial'**
  String get startTrial14Days;

  /// No description provided for @trialBadge.
  ///
  /// In en, this message translates to:
  /// **'14-day trial'**
  String get trialBadge;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @hasAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get hasAccount;

  /// No description provided for @startReading.
  ///
  /// In en, this message translates to:
  /// **'Start reading'**
  String get startReading;

  /// No description provided for @pasteText.
  ///
  /// In en, this message translates to:
  /// **'Paste or type your text'**
  String get pasteText;

  /// No description provided for @process.
  ///
  /// In en, this message translates to:
  /// **'Prepare'**
  String get process;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speed;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logout;

  /// No description provided for @licenseBlocked.
  ///
  /// In en, this message translates to:
  /// **'Your trial has ended or your license is inactive. Contact support.'**
  String get licenseBlocked;

  /// No description provided for @trialActiveUntil.
  ///
  /// In en, this message translates to:
  /// **'Trial active until {date}'**
  String trialActiveUntil(String date);

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcomeUser(String name);

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address.'**
  String get errorEmailRequired;

  /// No description provided for @errorEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get errorEmailInvalid;

  /// No description provided for @errorPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get errorPasswordRequired;

  /// No description provided for @errorPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get errorPasswordShort;

  /// No description provided for @showcaseHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading is slow.\nCognition doesn\'t have to be.'**
  String get showcaseHeroTitle;

  /// No description provided for @showcaseHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A cognitive interface that delivers information at the speed and form your brain can truly absorb — not just another speed reader.'**
  String get showcaseHeroSubtitle;

  /// No description provided for @showcaseOrpLabel.
  ///
  /// In en, this message translates to:
  /// **'ORP++ live preview'**
  String get showcaseOrpLabel;

  /// No description provided for @showcaseFeatureOrpTitle.
  ///
  /// In en, this message translates to:
  /// **'ORP++ Engine'**
  String get showcaseFeatureOrpTitle;

  /// No description provided for @showcaseFeatureOrpDesc.
  ///
  /// In en, this message translates to:
  /// **'Dynamic optimal recognition point — syllable-aware focus that adapts to each word.'**
  String get showcaseFeatureOrpDesc;

  /// No description provided for @showcaseFeatureCpsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cognitive Pacing'**
  String get showcaseFeatureCpsTitle;

  /// No description provided for @showcaseFeatureCpsDesc.
  ///
  /// In en, this message translates to:
  /// **'Speed follows meaning density. Conjunctions accelerate; complex terms breathe.'**
  String get showcaseFeatureCpsDesc;

  /// No description provided for @showcaseFeatureFocusTitle.
  ///
  /// In en, this message translates to:
  /// **'Zero Eye Strain'**
  String get showcaseFeatureFocusTitle;

  /// No description provided for @showcaseFeatureFocusDesc.
  ///
  /// In en, this message translates to:
  /// **'One focal point. No scanning. No subvocalization drag. Just flow.'**
  String get showcaseFeatureFocusDesc;

  /// No description provided for @showcaseCtaTitle.
  ///
  /// In en, this message translates to:
  /// **'Feel the difference in 15 minutes'**
  String get showcaseCtaTitle;

  /// No description provided for @showcaseCtaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your 14-day free trial — no credit card required.'**
  String get showcaseCtaSubtitle;

  /// No description provided for @showcaseFooter.
  ///
  /// In en, this message translates to:
  /// **'© Cicibyte · Lumentum Cognitive Reading Engine'**
  String get showcaseFooter;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @libraryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No documents yet. Add text or open a demo.'**
  String get libraryEmpty;

  /// No description provided for @addDocument.
  ///
  /// In en, this message translates to:
  /// **'Add text'**
  String get addDocument;

  /// No description provided for @importPdf.
  ///
  /// In en, this message translates to:
  /// **'Import PDF'**
  String get importPdf;

  /// No description provided for @pdfImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not import PDF. Try a text-based PDF or paste the text instead.'**
  String get pdfImportFailed;

  /// No description provided for @pdfImporting.
  ///
  /// In en, this message translates to:
  /// **'Importing PDF…'**
  String get pdfImporting;

  /// No description provided for @readingLanguage.
  ///
  /// In en, this message translates to:
  /// **'Interface language'**
  String get readingLanguage;

  /// No description provided for @documentTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get documentTitle;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @wordCount.
  ///
  /// In en, this message translates to:
  /// **'{count} words'**
  String wordCount(int count);

  /// No description provided for @licenseTitle.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get licenseTitle;

  /// No description provided for @licenseKey.
  ///
  /// In en, this message translates to:
  /// **'License key'**
  String get licenseKey;

  /// No description provided for @activateLicense.
  ///
  /// In en, this message translates to:
  /// **'Activate license'**
  String get activateLicense;

  /// No description provided for @licenseActivateHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the key from your email or the admin panel.'**
  String get licenseActivateHint;

  /// No description provided for @licenseActivated.
  ///
  /// In en, this message translates to:
  /// **'License activated successfully.'**
  String get licenseActivated;

  /// No description provided for @licenseStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get licenseStatus;

  /// No description provided for @licensePlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get licensePlan;

  /// No description provided for @licenseExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get licenseExpires;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @refreshLicense.
  ///
  /// In en, this message translates to:
  /// **'Check license status'**
  String get refreshLicense;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your cognitive reading hub — library, speed training, and more.'**
  String get homeSubtitle;

  /// No description provided for @librarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add PDFs or paste text. Everything you read lives here.'**
  String get librarySubtitle;

  /// No description provided for @libraryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Build your library'**
  String get libraryEmptyTitle;

  /// No description provided for @getStartedLibrary.
  ///
  /// In en, this message translates to:
  /// **'Add your first document'**
  String get getStartedLibrary;

  /// No description provided for @documentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} documents'**
  String documentsCount(int count);

  /// No description provided for @addToLibraryHint.
  ///
  /// In en, this message translates to:
  /// **'PDF or pasted text'**
  String get addToLibraryHint;

  /// No description provided for @trainYourSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed training'**
  String get trainYourSpeed;

  /// No description provided for @sessionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions completed'**
  String sessionsCount(int count);

  /// No description provided for @comingSoonSocial.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get comingSoonSocial;

  /// No description provided for @comingSoonSocialHint.
  ///
  /// In en, this message translates to:
  /// **'Share, friends & stories'**
  String get comingSoonSocialHint;

  /// No description provided for @comingSoonSocialLong.
  ///
  /// In en, this message translates to:
  /// **'Soon you\'ll share PDFs by category, add friends, write stories, and like each other\'s work.'**
  String get comingSoonSocialLong;

  /// No description provided for @socialFeatureShare.
  ///
  /// In en, this message translates to:
  /// **'Share PDFs by topic'**
  String get socialFeatureShare;

  /// No description provided for @socialFeatureCategories.
  ///
  /// In en, this message translates to:
  /// **'Organize with categories'**
  String get socialFeatureCategories;

  /// No description provided for @socialFeatureFriends.
  ///
  /// In en, this message translates to:
  /// **'Add friends'**
  String get socialFeatureFriends;

  /// No description provided for @socialFeatureStories.
  ///
  /// In en, this message translates to:
  /// **'Write stories & like posts'**
  String get socialFeatureStories;

  /// No description provided for @continueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue reading'**
  String get continueReading;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @importPdfHint.
  ///
  /// In en, this message translates to:
  /// **'Extract text from a PDF file'**
  String get importPdfHint;

  /// No description provided for @pasteTextHint.
  ///
  /// In en, this message translates to:
  /// **'Paste or type any text'**
  String get pasteTextHint;

  /// No description provided for @readingProgress.
  ///
  /// In en, this message translates to:
  /// **'{percent}% complete'**
  String readingProgress(int percent);

  /// No description provided for @wordsPerMinute.
  ///
  /// In en, this message translates to:
  /// **'~{wpm} WPM'**
  String wordsPerMinute(int wpm);

  /// No description provided for @tapToPlay.
  ///
  /// In en, this message translates to:
  /// **'Tap center to play or pause'**
  String get tapToPlay;

  /// No description provided for @prepareFirst.
  ///
  /// In en, this message translates to:
  /// **'Preparing your text…'**
  String get prepareFirst;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @exploreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read, write and share stories — Wattpad meets cognitive reading.'**
  String get exploreSubtitle;

  /// No description provided for @exploreEmpty.
  ///
  /// In en, this message translates to:
  /// **'No publications yet. Be the first to share your story.'**
  String get exploreEmpty;

  /// No description provided for @writeContent.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get writeContent;

  /// No description provided for @writeFirstStory.
  ///
  /// In en, this message translates to:
  /// **'Write your first story'**
  String get writeFirstStory;

  /// No description provided for @searchPublications.
  ///
  /// In en, this message translates to:
  /// **'Search titles or authors…'**
  String get searchPublications;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @contentTypeBook.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get contentTypeBook;

  /// No description provided for @contentTypeArticle.
  ///
  /// In en, this message translates to:
  /// **'Article'**
  String get contentTypeArticle;

  /// No description provided for @contentTypePoem.
  ///
  /// In en, this message translates to:
  /// **'Poem'**
  String get contentTypePoem;

  /// No description provided for @contentTypeNews.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get contentTypeNews;

  /// No description provided for @contentTypeNovel.
  ///
  /// In en, this message translates to:
  /// **'Novel'**
  String get contentTypeNovel;

  /// No description provided for @contentTypeEncyclopedia.
  ///
  /// In en, this message translates to:
  /// **'Encyclopedia'**
  String get contentTypeEncyclopedia;

  /// No description provided for @selectContentType.
  ///
  /// In en, this message translates to:
  /// **'Content type'**
  String get selectContentType;

  /// No description provided for @uploadCover.
  ///
  /// In en, this message translates to:
  /// **'Upload cover image'**
  String get uploadCover;

  /// No description provided for @publicationSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get publicationSummary;

  /// No description provided for @publicationBody.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get publicationBody;

  /// No description provided for @publicationTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get publicationTags;

  /// No description provided for @publicationTagsHint.
  ///
  /// In en, this message translates to:
  /// **'romance, sci-fi, history'**
  String get publicationTagsHint;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @publicationPublished.
  ///
  /// In en, this message translates to:
  /// **'Published successfully!'**
  String get publicationPublished;

  /// No description provided for @readWithLumentum.
  ///
  /// In en, this message translates to:
  /// **'Read with Lumentum'**
  String get readWithLumentum;

  /// No description provided for @commentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commentsTitle;

  /// No description provided for @addCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Write a comment…'**
  String get addCommentHint;

  /// No description provided for @myWorks.
  ///
  /// In en, this message translates to:
  /// **'My works'**
  String get myWorks;

  /// No description provided for @myWorksHint.
  ///
  /// In en, this message translates to:
  /// **'Stories and articles you\'ve published'**
  String get myWorksHint;

  /// No description provided for @myWorksEmpty.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t published anything yet.'**
  String get myWorksEmpty;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
