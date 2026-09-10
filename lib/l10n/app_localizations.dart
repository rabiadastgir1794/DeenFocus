import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_az.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

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
    Locale('ar'),
    Locale('az'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('nl'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Deen Focus'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Faith. Focus. Consistency'**
  String get appTagline;

  /// No description provided for @welcomeGreeting.
  ///
  /// In en, this message translates to:
  /// **'ASSALAMU ALAIKUM'**
  String get welcomeGreeting;

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'Prayer Mode. Child Mode. Sleep Mode.'**
  String get welcomeTagline;

  /// No description provided for @welcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Where faith meets focus. Protect your prayers, silence distractions, and grow closer to Allah — every day.'**
  String get welcomeDescription;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @continueForFree.
  ///
  /// In en, this message translates to:
  /// **'Maybe later — explore the app first'**
  String get continueForFree;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Start My 7-Day Free Trial'**
  String get getStarted;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @locationRequired.
  ///
  /// In en, this message translates to:
  /// **'Location Required'**
  String get locationRequired;

  /// No description provided for @locationRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Location access is required to calculate accurate prayer times and Qibla direction. You must enable it to use the app.'**
  String get locationRequiredMessage;

  /// No description provided for @notificationsRequired.
  ///
  /// In en, this message translates to:
  /// **'Notifications Required'**
  String get notificationsRequired;

  /// No description provided for @notificationsRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Notifications are required to receive prayer time alerts and reminders.'**
  String get notificationsRequiredMessage;

  /// No description provided for @sectTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Sect'**
  String get sectTitle;

  /// No description provided for @sectSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This helps us personalize your experience'**
  String get sectSubtitle;

  /// No description provided for @sectSunni.
  ///
  /// In en, this message translates to:
  /// **'Sunni'**
  String get sectSunni;

  /// No description provided for @sectShia.
  ///
  /// In en, this message translates to:
  /// **'Shia'**
  String get sectShia;

  /// No description provided for @sectPreferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get sectPreferNotToSay;

  /// No description provided for @nameTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s Your Name?'**
  String get nameTitle;

  /// No description provided for @nameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s personalize your greeting'**
  String get nameSubtitle;

  /// No description provided for @namePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get namePlaceholder;

  /// No description provided for @locationTitle.
  ///
  /// In en, this message translates to:
  /// **'Find Your Qibla'**
  String get locationTitle;

  /// No description provided for @locationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable location for accurate Qibla, prayer times and nearby masjids.'**
  String get locationSubtitle;

  /// No description provided for @locationButton.
  ///
  /// In en, this message translates to:
  /// **'Allow Location Access'**
  String get locationButton;

  /// No description provided for @locationManualEntry.
  ///
  /// In en, this message translates to:
  /// **'Enter your city manually'**
  String get locationManualEntry;

  /// No description provided for @locationOrDivider.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get locationOrDivider;

  /// No description provided for @locationPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'We respect your privacy'**
  String get locationPrivacyTitle;

  /// No description provided for @locationPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'We use your location only to show accurate Qibla direction, prayer times and nearby masjids.\nWe never store or share your location.'**
  String get locationPrivacyBody;

  /// No description provided for @locationFeaturePrayerTimesTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer times'**
  String get locationFeaturePrayerTimesTitle;

  /// No description provided for @locationFeatureQiblaTitle.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get locationFeatureQiblaTitle;

  /// No description provided for @locationFeatureMasjidsTitle.
  ///
  /// In en, this message translates to:
  /// **'Masjids'**
  String get locationFeatureMasjidsTitle;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Never Miss a Prayer'**
  String get notificationsTitle;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adhan alerts, focus reminders and daily dhikr — delivered right when you need them.'**
  String get notificationsSubtitle;

  /// No description provided for @notificationsButton.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get notificationsButton;

  /// No description provided for @notificationsMaybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get notificationsMaybeLater;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications are enabled'**
  String get notificationsEnabled;

  /// No description provided for @notificationsPreviewDate.
  ///
  /// In en, this message translates to:
  /// **'Friday, 10 July'**
  String get notificationsPreviewDate;

  /// No description provided for @notificationsPreviewTime.
  ///
  /// In en, this message translates to:
  /// **'6:42'**
  String get notificationsPreviewTime;

  /// No description provided for @notificationsPreviewNow.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get notificationsPreviewNow;

  /// No description provided for @notificationsPreviewMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'2m ago'**
  String get notificationsPreviewMinutesAgo;

  /// No description provided for @notificationsPreviewHourAgo.
  ///
  /// In en, this message translates to:
  /// **'1h ago'**
  String get notificationsPreviewHourAgo;

  /// No description provided for @notificationsPreviewAdhanTitle.
  ///
  /// In en, this message translates to:
  /// **'Maghrib Adhan'**
  String get notificationsPreviewAdhanTitle;

  /// No description provided for @notificationsPreviewAdhanBody.
  ///
  /// In en, this message translates to:
  /// **'It\'s time to pray.'**
  String get notificationsPreviewAdhanBody;

  /// No description provided for @notificationsPreviewDhikrTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Dhikr'**
  String get notificationsPreviewDhikrTitle;

  /// No description provided for @notificationsPreviewDhikrBody.
  ///
  /// In en, this message translates to:
  /// **'SubhanAllah — take a moment.'**
  String get notificationsPreviewDhikrBody;

  /// No description provided for @notificationsPreviewStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get notificationsPreviewStreakTitle;

  /// No description provided for @notificationsPreviewStreakBody.
  ///
  /// In en, this message translates to:
  /// **'7 days of complete prayers.'**
  String get notificationsPreviewStreakBody;

  /// No description provided for @screenTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable Screen Time'**
  String get screenTimeTitle;

  /// No description provided for @screenTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This is what lets Deen Focus pause distracting apps during Salah, sleep time and child mode.'**
  String get screenTimeSubtitle;

  /// No description provided for @screenTimeButton.
  ///
  /// In en, this message translates to:
  /// **'Allow Screen Time Access'**
  String get screenTimeButton;

  /// No description provided for @screenTimePrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Deen Focus never reads your data — it only pauses the apps you choose.'**
  String get screenTimePrivacyNote;

  /// No description provided for @onboardingSelectAppsTitlePrefix.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get onboardingSelectAppsTitlePrefix;

  /// No description provided for @onboardingSelectAppsTitleAccent.
  ///
  /// In en, this message translates to:
  /// **'Apps to Lock'**
  String get onboardingSelectAppsTitleAccent;

  /// No description provided for @onboardingSelectAppsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select the apps you want to lock when it\'s time to pray.'**
  String get onboardingSelectAppsSubtitle;

  /// No description provided for @onboardingSelectAppsButton.
  ///
  /// In en, this message translates to:
  /// **'Select Apps'**
  String get onboardingSelectAppsButton;

  /// No description provided for @onboardingSelectAppsSkipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for Now'**
  String get onboardingSelectAppsSkipForNow;

  /// No description provided for @onboardingSelectAppsPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re in control'**
  String get onboardingSelectAppsPrivacyTitle;

  /// No description provided for @onboardingSelectAppsPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'We never read your data. We only lock the apps you choose.'**
  String get onboardingSelectAppsPrivacyBody;

  /// No description provided for @onboardingSelectAppsMockAllApps.
  ///
  /// In en, this message translates to:
  /// **'All Apps & Categories'**
  String get onboardingSelectAppsMockAllApps;

  /// No description provided for @onboardingSelectAppsMockPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get onboardingSelectAppsMockPhotos;

  /// No description provided for @onboardingSelectAppsMockNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get onboardingSelectAppsMockNotes;

  /// No description provided for @onboardingSelectAppsMockMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get onboardingSelectAppsMockMusic;

  /// No description provided for @onboardingSelectAppsMockSafari.
  ///
  /// In en, this message translates to:
  /// **'Safari'**
  String get onboardingSelectAppsMockSafari;

  /// No description provided for @onboardingSelectAppsMockPodcasts.
  ///
  /// In en, this message translates to:
  /// **'Podcasts'**
  String get onboardingSelectAppsMockPodcasts;

  /// No description provided for @screenTimeStepOf.
  ///
  /// In en, this message translates to:
  /// **'STEP {current} OF {total}'**
  String screenTimeStepOf(int current, int total);

  /// No description provided for @screenTimeStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Open the Screen Time prompt'**
  String get screenTimeStep1Title;

  /// No description provided for @screenTimeStep1Body.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Allow Screen Time Access\' — your device will show its own permission sheet.'**
  String get screenTimeStep1Body;

  /// No description provided for @screenTimeStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Tap Continue, then Allow'**
  String get screenTimeStep2Title;

  /// No description provided for @screenTimeStep2Body.
  ///
  /// In en, this message translates to:
  /// **'Approve the request so Deen Focus can pause apps at the right moments.'**
  String get screenTimeStep2Body;

  /// No description provided for @screenTimeStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Choose apps to lock'**
  String get screenTimeStep3Title;

  /// No description provided for @screenTimeStep3Body.
  ///
  /// In en, this message translates to:
  /// **'Pick the apps that distract you most — social, games, video, anything.'**
  String get screenTimeStep3Body;

  /// No description provided for @screenTimeStep4Title.
  ///
  /// In en, this message translates to:
  /// **'You\'re protected'**
  String get screenTimeStep4Title;

  /// No description provided for @screenTimeStep4Body.
  ///
  /// In en, this message translates to:
  /// **'Apps lock automatically during Salah, sleep time and child mode.'**
  String get screenTimeStep4Body;

  /// No description provided for @screenTimePromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Screen Time'**
  String get screenTimePromptTitle;

  /// No description provided for @screenTimePromptMessage.
  ///
  /// In en, this message translates to:
  /// **'\'{appName}\' would like to access Screen Time'**
  String screenTimePromptMessage(String appName);

  /// No description provided for @screenTimeDontAllow.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Allow'**
  String get screenTimeDontAllow;

  /// No description provided for @screenTimePromptContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get screenTimePromptContinue;

  /// No description provided for @screenTimeAppInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get screenTimeAppInstagram;

  /// No description provided for @screenTimeAppTikTok.
  ///
  /// In en, this message translates to:
  /// **'TikTok'**
  String get screenTimeAppTikTok;

  /// No description provided for @screenTimeAppYouTube.
  ///
  /// In en, this message translates to:
  /// **'YouTube'**
  String get screenTimeAppYouTube;

  /// No description provided for @screenTimeAppGames.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get screenTimeAppGames;

  /// No description provided for @screenTimeAndroidStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Open Usage Access settings'**
  String get screenTimeAndroidStep1Title;

  /// No description provided for @screenTimeAndroidStep1Body.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Allow Screen Time Access\' — your device will open Usage Access for Deen Focus.'**
  String get screenTimeAndroidStep1Body;

  /// No description provided for @screenTimeAndroidStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Enable Accessibility'**
  String get screenTimeAndroidStep2Title;

  /// No description provided for @screenTimeAndroidStep2Body.
  ///
  /// In en, this message translates to:
  /// **'Turn on the Deen Focus service so apps can pause during Salah, sleep, and child mode.'**
  String get screenTimeAndroidStep2Body;

  /// No description provided for @screenTimeAndroidStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Choose apps to lock'**
  String get screenTimeAndroidStep3Title;

  /// No description provided for @screenTimeAndroidStep3Body.
  ///
  /// In en, this message translates to:
  /// **'Pick the apps that distract you most — social, games, video, anything.'**
  String get screenTimeAndroidStep3Body;

  /// No description provided for @screenTimeAndroidStep4Title.
  ///
  /// In en, this message translates to:
  /// **'You\'re protected'**
  String get screenTimeAndroidStep4Title;

  /// No description provided for @screenTimeAndroidStep4Body.
  ///
  /// In en, this message translates to:
  /// **'Apps lock automatically during Salah, sleep time and child mode.'**
  String get screenTimeAndroidStep4Body;

  /// No description provided for @screenTimeAndroidUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'Usage access'**
  String get screenTimeAndroidUsageTitle;

  /// No description provided for @screenTimeAndroidUsageMessage.
  ///
  /// In en, this message translates to:
  /// **'Allow Deen Focus to track which other apps are being used.'**
  String get screenTimeAndroidUsageMessage;

  /// No description provided for @screenTimeAndroidAccessibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get screenTimeAndroidAccessibilityTitle;

  /// No description provided for @screenTimeAndroidAccessibilityMessage.
  ///
  /// In en, this message translates to:
  /// **'Deen Focus needs Accessibility to pause distracting apps during focus sessions.'**
  String get screenTimeAndroidAccessibilityMessage;

  /// No description provided for @screenTimeAndroidPermit.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get screenTimeAndroidPermit;

  /// No description provided for @screenTimeAndroidEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get screenTimeAndroidEnable;

  /// No description provided for @screenTimeAndroidNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get screenTimeAndroidNotNow;

  /// No description provided for @focusModesTitle.
  ///
  /// In en, this message translates to:
  /// **'Everything in One App'**
  String get focusModesTitle;

  /// No description provided for @focusModesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore all that Deen Focus offers. Tap a focus mode to see how it works.'**
  String get focusModesSubtitle;

  /// No description provided for @onboardingWidgetsLiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Your prayers, always within reach'**
  String get onboardingWidgetsLiveTitle;

  /// No description provided for @onboardingWidgetsLiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay connected with what matters most — right from your Home Screen or Lock Screen.'**
  String get onboardingWidgetsLiveSubtitle;

  /// No description provided for @onboardingWidgetsLiveSubtitleAndroid.
  ///
  /// In en, this message translates to:
  /// **'Stay connected with what matters most — right from your Home Screen.'**
  String get onboardingWidgetsLiveSubtitleAndroid;

  /// No description provided for @onboardingWidgetsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Widgets'**
  String get onboardingWidgetsSectionTitle;

  /// No description provided for @onboardingWidgetsSectionBodyPrefix.
  ///
  /// In en, this message translates to:
  /// **'Check your next prayer, streaks, and progress '**
  String get onboardingWidgetsSectionBodyPrefix;

  /// No description provided for @onboardingWidgetsSectionBodyEmphasis.
  ///
  /// In en, this message translates to:
  /// **'at a glance.'**
  String get onboardingWidgetsSectionBodyEmphasis;

  /// No description provided for @onboardingLiveActivitiesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Activities'**
  String get onboardingLiveActivitiesSectionTitle;

  /// No description provided for @onboardingLiveActivitiesSectionBodyPrefix.
  ///
  /// In en, this message translates to:
  /// **'See your upcoming prayer updates in '**
  String get onboardingLiveActivitiesSectionBodyPrefix;

  /// No description provided for @onboardingLiveActivitiesSectionBodyEmphasis.
  ///
  /// In en, this message translates to:
  /// **'real time'**
  String get onboardingLiveActivitiesSectionBodyEmphasis;

  /// No description provided for @onboardingLiveActivitiesSectionBodySuffix.
  ///
  /// In en, this message translates to:
  /// **' on your Lock Screen and Dynamic Island.'**
  String get onboardingLiveActivitiesSectionBodySuffix;

  /// No description provided for @onboardingWidgetsLiveTrustPrefix.
  ///
  /// In en, this message translates to:
  /// **'Designed to help you stay '**
  String get onboardingWidgetsLiveTrustPrefix;

  /// No description provided for @onboardingWidgetsLiveTrustEmphasis.
  ///
  /// In en, this message translates to:
  /// **'consistent'**
  String get onboardingWidgetsLiveTrustEmphasis;

  /// No description provided for @onboardingWidgetsLiveTrustSuffix.
  ///
  /// In en, this message translates to:
  /// **' and never miss what matters most.'**
  String get onboardingWidgetsLiveTrustSuffix;

  /// No description provided for @onboardingWidgetsMockStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get onboardingWidgetsMockStreak;

  /// No description provided for @onboardingWidgetsMockStreakValue.
  ///
  /// In en, this message translates to:
  /// **'12 days'**
  String get onboardingWidgetsMockStreakValue;

  /// No description provided for @onboardingWidgetsMockFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get onboardingWidgetsMockFocus;

  /// No description provided for @onboardingWidgetsMockFocusValue.
  ///
  /// In en, this message translates to:
  /// **'25 min'**
  String get onboardingWidgetsMockFocusValue;

  /// No description provided for @onboardingWidgetsLiveLockDate.
  ///
  /// In en, this message translates to:
  /// **'Tuesday, 6 May'**
  String get onboardingWidgetsLiveLockDate;

  /// No description provided for @onboardingWidgetsLiveLockTime.
  ///
  /// In en, this message translates to:
  /// **'9:41'**
  String get onboardingWidgetsLiveLockTime;

  /// No description provided for @onboardingWidgetsLiveNextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr 12:45 PM in 02:15:32'**
  String get onboardingWidgetsLiveNextPrayer;

  /// No description provided for @focusModesSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'FOCUS MODES · TAP TO LEARN MORE'**
  String get focusModesSectionLabel;

  /// No description provided for @focusPrayerTrackingSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'PRAYER & TRACKING'**
  String get focusPrayerTrackingSectionLabel;

  /// No description provided for @focusLearningHubSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'LEARNING HUB'**
  String get focusLearningHubSectionLabel;

  /// No description provided for @focusMoreSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'MORE'**
  String get focusMoreSectionLabel;

  /// No description provided for @focusPrayerModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Mode'**
  String get focusPrayerModeTitle;

  /// No description provided for @focusPrayerModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Block distracting apps automatically during Salah so you can pray with full khushu.'**
  String get focusPrayerModeDescription;

  /// No description provided for @focusPrayerModeBullet1.
  ///
  /// In en, this message translates to:
  /// **'Auto-locks apps at prayer time'**
  String get focusPrayerModeBullet1;

  /// No description provided for @focusPrayerModeBullet2.
  ///
  /// In en, this message translates to:
  /// **'Unlocks when you\'re done'**
  String get focusPrayerModeBullet2;

  /// No description provided for @focusPrayerModeBullet3.
  ///
  /// In en, this message translates to:
  /// **'Builds focus & consistency'**
  String get focusPrayerModeBullet3;

  /// No description provided for @focusSleepModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Sleep Mode'**
  String get focusSleepModeTitle;

  /// No description provided for @focusSleepModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Wind down the halal way. Block apps at bedtime so you rest well and wake for Fajr.'**
  String get focusSleepModeDescription;

  /// No description provided for @focusSleepModeBullet1.
  ///
  /// In en, this message translates to:
  /// **'Auto-blocks apps at bedtime'**
  String get focusSleepModeBullet1;

  /// No description provided for @focusSleepModeBullet2.
  ///
  /// In en, this message translates to:
  /// **'Gentle Fajr wake reminders'**
  String get focusSleepModeBullet2;

  /// No description provided for @focusSleepModeBullet3.
  ///
  /// In en, this message translates to:
  /// **'Protects your sleep & Fajr'**
  String get focusSleepModeBullet3;

  /// No description provided for @focusChildModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Child Mode'**
  String get focusChildModeTitle;

  /// No description provided for @focusChildModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Handing your phone to your child? Instantly lock apps so they only see what\'s safe.'**
  String get focusChildModeDescription;

  /// No description provided for @focusChildModeBullet1.
  ///
  /// In en, this message translates to:
  /// **'One-tap safe mode'**
  String get focusChildModeBullet1;

  /// No description provided for @focusChildModeBullet2.
  ///
  /// In en, this message translates to:
  /// **'Passcode-protected exit'**
  String get focusChildModeBullet2;

  /// No description provided for @focusChildModeBullet3.
  ///
  /// In en, this message translates to:
  /// **'Peace of mind, every time'**
  String get focusChildModeBullet3;

  /// No description provided for @restrictedModeSalahTitle.
  ///
  /// In en, this message translates to:
  /// **'Salah Time'**
  String get restrictedModeSalahTitle;

  /// No description provided for @restrictedModeSalahMessage.
  ///
  /// In en, this message translates to:
  /// **'It\'s time to step away from distractions and answer the call to prayer.'**
  String get restrictedModeSalahMessage;

  /// No description provided for @restrictedModeSalahInfo.
  ///
  /// In en, this message translates to:
  /// **'Take this moment to connect with Allah.'**
  String get restrictedModeSalahInfo;

  /// No description provided for @restrictedModeSalahQuote.
  ///
  /// In en, this message translates to:
  /// **'Establish prayer for My remembrance.'**
  String get restrictedModeSalahQuote;

  /// No description provided for @restrictedModeSalahQuoteSource.
  ///
  /// In en, this message translates to:
  /// **'Quran 20:14'**
  String get restrictedModeSalahQuoteSource;

  /// No description provided for @restrictedModeSalahCta.
  ///
  /// In en, this message translates to:
  /// **'Start Salah'**
  String get restrictedModeSalahCta;

  /// No description provided for @restrictedModeChildTitle.
  ///
  /// In en, this message translates to:
  /// **'Child Focus Mode'**
  String get restrictedModeChildTitle;

  /// No description provided for @restrictedModeChildMessage.
  ///
  /// In en, this message translates to:
  /// **'A safer, more balanced space for focused screen time.'**
  String get restrictedModeChildMessage;

  /// No description provided for @restrictedModeChildInfo.
  ///
  /// In en, this message translates to:
  /// **'Some apps are temporarily unavailable.'**
  String get restrictedModeChildInfo;

  /// No description provided for @restrictedModeChildQuote.
  ///
  /// In en, this message translates to:
  /// **'Teach your children prayer when they are seven.'**
  String get restrictedModeChildQuote;

  /// No description provided for @restrictedModeChildQuoteSource.
  ///
  /// In en, this message translates to:
  /// **'Hadith - Abu Dawood'**
  String get restrictedModeChildQuoteSource;

  /// No description provided for @restrictedModeChildCta.
  ///
  /// In en, this message translates to:
  /// **'Stay Protected'**
  String get restrictedModeChildCta;

  /// No description provided for @restrictedModeNightTitle.
  ///
  /// In en, this message translates to:
  /// **'Night Focus Mode'**
  String get restrictedModeNightTitle;

  /// No description provided for @restrictedModeNightMessage.
  ///
  /// In en, this message translates to:
  /// **'It\'s time to rest and disconnect from digital distractions.'**
  String get restrictedModeNightMessage;

  /// No description provided for @restrictedModeNightInfo.
  ///
  /// In en, this message translates to:
  /// **'Put your device aside and enjoy a peaceful night.'**
  String get restrictedModeNightInfo;

  /// No description provided for @restrictedModeNightQuote.
  ///
  /// In en, this message translates to:
  /// **'And We made your sleep a means for rest.'**
  String get restrictedModeNightQuote;

  /// No description provided for @restrictedModeNightQuoteSource.
  ///
  /// In en, this message translates to:
  /// **'Quran 78:9'**
  String get restrictedModeNightQuoteSource;

  /// No description provided for @restrictedModeNightCta.
  ///
  /// In en, this message translates to:
  /// **'Good Night'**
  String get restrictedModeNightCta;

  /// No description provided for @restrictedModeAppsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Some apps are temporarily unavailable.'**
  String get restrictedModeAppsUnavailable;

  /// No description provided for @focusModeGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get focusModeGotIt;

  /// No description provided for @focusFeaturePrayerTimesTitle.
  ///
  /// In en, this message translates to:
  /// **'Accurate Prayer Times'**
  String get focusFeaturePrayerTimesTitle;

  /// No description provided for @focusFeaturePrayerTimesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adhan & reminders'**
  String get focusFeaturePrayerTimesSubtitle;

  /// No description provided for @focusFeatureStreaksTitle.
  ///
  /// In en, this message translates to:
  /// **'Streaks'**
  String get focusFeatureStreaksTitle;

  /// No description provided for @focusFeatureStreaksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay consistent'**
  String get focusFeatureStreaksSubtitle;

  /// No description provided for @focusFeatureChecklistTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Checklist'**
  String get focusFeatureChecklistTitle;

  /// No description provided for @focusFeatureChecklistSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Build good habits'**
  String get focusFeatureChecklistSubtitle;

  /// No description provided for @focusFeatureQiblaTitle.
  ///
  /// In en, this message translates to:
  /// **'Qibla & Masjid'**
  String get focusFeatureQiblaTitle;

  /// No description provided for @focusFeatureQiblaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Direction & mosques'**
  String get focusFeatureQiblaSubtitle;

  /// No description provided for @focusFeatureQuranTitle.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get focusFeatureQuranTitle;

  /// No description provided for @focusFeatureQuranSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Translations, Juzz & pages'**
  String get focusFeatureQuranSubtitle;

  /// No description provided for @focusFeatureHadithTitle.
  ///
  /// In en, this message translates to:
  /// **'Hadith'**
  String get focusFeatureHadithTitle;

  /// No description provided for @focusFeatureHadithSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Authentic collections'**
  String get focusFeatureHadithSubtitle;

  /// No description provided for @focusFeatureDuasTitle.
  ///
  /// In en, this message translates to:
  /// **'Duas'**
  String get focusFeatureDuasTitle;

  /// No description provided for @focusFeatureDuasSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily supplications'**
  String get focusFeatureDuasSubtitle;

  /// No description provided for @focusFeatureTasbihTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasbih'**
  String get focusFeatureTasbihTitle;

  /// No description provided for @focusFeatureTasbihSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Digital dhikr counter'**
  String get focusFeatureTasbihSubtitle;

  /// No description provided for @focusFeatureAiTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Companion'**
  String get focusFeatureAiTitle;

  /// No description provided for @focusFeatureAiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask about your Deen'**
  String get focusFeatureAiSubtitle;

  /// No description provided for @focusFeatureInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get focusFeatureInsightsTitle;

  /// No description provided for @focusFeatureInsightsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly & monthly stats'**
  String get focusFeatureInsightsSubtitle;

  /// No description provided for @investTitle.
  ///
  /// In en, this message translates to:
  /// **'Invest in Deen'**
  String get investTitle;

  /// No description provided for @investSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The best investment isn\'t in things that fade — it\'s in what draws you closer to Allah. Try everything free for 7 days.'**
  String get investSubtitle;

  /// No description provided for @investPremiumUnlocked.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM UNLOCKED'**
  String get investPremiumUnlocked;

  /// No description provided for @investTrialPill.
  ///
  /// In en, this message translates to:
  /// **'✨ 7 days free — cancel anytime before it ends'**
  String get investTrialPill;

  /// No description provided for @investNoCommitment.
  ///
  /// In en, this message translates to:
  /// **'No commitment. Cancel anytime.'**
  String get investNoCommitment;

  /// No description provided for @investFeatureAiTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Islamic Assistant'**
  String get investFeatureAiTitle;

  /// No description provided for @investFeatureAiBody.
  ///
  /// In en, this message translates to:
  /// **'Ask anything about your Deen — answers rooted in authentic sources.'**
  String get investFeatureAiBody;

  /// No description provided for @investFeaturePrayerModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Full-Screen Prayer Mode'**
  String get investFeaturePrayerModeTitle;

  /// No description provided for @investFeaturePrayerModeBody.
  ///
  /// In en, this message translates to:
  /// **'A calm, distraction-free screen that calls you to Salah.'**
  String get investFeaturePrayerModeBody;

  /// No description provided for @investFeatureAppBlockingTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced App Blocking'**
  String get investFeatureAppBlockingTitle;

  /// No description provided for @investFeatureAppBlockingBody.
  ///
  /// In en, this message translates to:
  /// **'Granular control over which apps lock, and exactly when.'**
  String get investFeatureAppBlockingBody;

  /// No description provided for @investFeatureNightModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Night Discipline Mode'**
  String get investFeatureNightModeTitle;

  /// No description provided for @investFeatureNightModeBody.
  ///
  /// In en, this message translates to:
  /// **'Wind down on time, sleep better, and wake up for Fajr.'**
  String get investFeatureNightModeBody;

  /// No description provided for @investFeaturePlannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Planner & Progress'**
  String get investFeaturePlannerTitle;

  /// No description provided for @investFeaturePlannerBody.
  ///
  /// In en, this message translates to:
  /// **'Streaks, insights and journals that keep you consistent.'**
  String get investFeaturePlannerBody;

  /// No description provided for @investFeatureToolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Exclusive Islamic Tools'**
  String get investFeatureToolsTitle;

  /// No description provided for @investFeatureToolsBody.
  ///
  /// In en, this message translates to:
  /// **'Hijri calendar, Duas, Tasbih, 99 Names and more.'**
  String get investFeatureToolsBody;

  /// No description provided for @investFeatureThemesTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium Themes & Updates'**
  String get investFeatureThemesTitle;

  /// No description provided for @investFeatureThemesBody.
  ///
  /// In en, this message translates to:
  /// **'Beautiful themes plus every new feature we ship.'**
  String get investFeatureThemesBody;

  /// No description provided for @investFeatureTajweedTitle.
  ///
  /// In en, this message translates to:
  /// **'Master Tajweed'**
  String get investFeatureTajweedTitle;

  /// No description provided for @investFeatureTajweedBody.
  ///
  /// In en, this message translates to:
  /// **'Improve your recitation with guided lessons and real-time feedback.'**
  String get investFeatureTajweedBody;

  /// No description provided for @socialProofPrefix.
  ///
  /// In en, this message translates to:
  /// **'Join '**
  String get socialProofPrefix;

  /// No description provided for @socialProofHighlight.
  ///
  /// In en, this message translates to:
  /// **'10,000+'**
  String get socialProofHighlight;

  /// No description provided for @socialProofSuffix.
  ///
  /// In en, this message translates to:
  /// **' Muslims growing with DeenFocus'**
  String get socialProofSuffix;

  /// No description provided for @mostPopular.
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get mostPopular;

  /// No description provided for @monthlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthlyLabel;

  /// No description provided for @yearlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearlyLabel;

  /// No description provided for @lifetimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get lifetimeLabel;

  /// No description provided for @featureNoAds.
  ///
  /// In en, this message translates to:
  /// **'Removes all ads'**
  String get featureNoAds;

  /// No description provided for @featureSupport.
  ///
  /// In en, this message translates to:
  /// **'Priority support'**
  String get featureSupport;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Deenly Home'**
  String get homeTitle;

  /// No description provided for @homeSalam.
  ///
  /// In en, this message translates to:
  /// **'Assalamu Alaikum'**
  String get homeSalam;

  /// No description provided for @homeDailyVerseFallback.
  ///
  /// In en, this message translates to:
  /// **'Indeed, with hardship comes ease.'**
  String get homeDailyVerseFallback;

  /// No description provided for @homeAppsLocked.
  ///
  /// In en, this message translates to:
  /// **'Apps Locked'**
  String get homeAppsLocked;

  /// No description provided for @homeAppsUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Apps Unlocked'**
  String get homeAppsUnlocked;

  /// No description provided for @homeTapToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Tap to unlock apps temporarily'**
  String get homeTapToUnlock;

  /// No description provided for @homeTapToRelock.
  ///
  /// In en, this message translates to:
  /// **'Tap to relock blocked apps now'**
  String get homeTapToRelock;

  /// No description provided for @homeRelock.
  ///
  /// In en, this message translates to:
  /// **'Relock'**
  String get homeRelock;

  /// No description provided for @homeUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get homeUnlock;

  /// No description provided for @homePrayerModeActive.
  ///
  /// In en, this message translates to:
  /// **'Prayer Mode Active'**
  String get homePrayerModeActive;

  /// No description provided for @homeActivatePrayerMode.
  ///
  /// In en, this message translates to:
  /// **'Activate Prayer Mode'**
  String get homeActivatePrayerMode;

  /// No description provided for @homeAppsBlockedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Apps are blocked. Tap to deactivate.'**
  String get homeAppsBlockedSubtitle;

  /// No description provided for @homeBlockDistractingApps.
  ///
  /// In en, this message translates to:
  /// **'Block distracting apps during Salah.'**
  String get homeBlockDistractingApps;

  /// No description provided for @homeQiblaDirection.
  ///
  /// In en, this message translates to:
  /// **'Qibla Direction'**
  String get homeQiblaDirection;

  /// No description provided for @homeLocationMissingForQibla.
  ///
  /// In en, this message translates to:
  /// **'Enable location to calculate Qibla direction.'**
  String get homeLocationMissingForQibla;

  /// No description provided for @homeQiblaSubtitleGuiding.
  ///
  /// In en, this message translates to:
  /// **'Guiding you toward the Qibla'**
  String get homeQiblaSubtitleGuiding;

  /// No description provided for @homeToMakkah.
  ///
  /// In en, this message translates to:
  /// **'to Makkah'**
  String get homeToMakkah;

  /// No description provided for @homeFindMasjid.
  ///
  /// In en, this message translates to:
  /// **'Find Masjid Near Me'**
  String get homeFindMasjid;

  /// No description provided for @quickActionsMasjidFinder.
  ///
  /// In en, this message translates to:
  /// **'Masjid Finder'**
  String get quickActionsMasjidFinder;

  /// No description provided for @homeSearchNearbyMosques.
  ///
  /// In en, this message translates to:
  /// **'Search nearby mosques.'**
  String get homeSearchNearbyMosques;

  /// No description provided for @homePrayerStreak.
  ///
  /// In en, this message translates to:
  /// **'Prayer Progress'**
  String get homePrayerStreak;

  /// No description provided for @homePrayersInARow.
  ///
  /// In en, this message translates to:
  /// **'{count} prayers in a row'**
  String homePrayersInARow(int count);

  /// No description provided for @homeDayStreakCount.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String homeDayStreakCount(int count);

  /// No description provided for @homeInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get homeInsights;

  /// No description provided for @homeOpenStreakDetails.
  ///
  /// In en, this message translates to:
  /// **'Open streak details.'**
  String get homeOpenStreakDetails;

  /// No description provided for @homeTodaysPrayers.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Prayers'**
  String get homeTodaysPrayers;

  /// No description provided for @homePrayerTimesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Prayer times are unavailable right now.'**
  String get homePrayerTimesUnavailable;

  /// No description provided for @homeNextPrayerIn.
  ///
  /// In en, this message translates to:
  /// **'Next prayer in'**
  String get homeNextPrayerIn;

  /// No description provided for @homeTapPrayerToMark.
  ///
  /// In en, this message translates to:
  /// **'Tap a prayer to mark it prayed, qada, or missed.'**
  String get homeTapPrayerToMark;

  /// No description provided for @homeSetLocation.
  ///
  /// In en, this message translates to:
  /// **'Set location'**
  String get homeSetLocation;

  /// No description provided for @homeEditPrayerSettings.
  ///
  /// In en, this message translates to:
  /// **'Edit prayer settings'**
  String get homeEditPrayerSettings;

  /// No description provided for @homePrayerFajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get homePrayerFajr;

  /// No description provided for @homePrayerSunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get homePrayerSunrise;

  /// No description provided for @homePrayerDhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get homePrayerDhuhr;

  /// No description provided for @homePrayerAsr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get homePrayerAsr;

  /// No description provided for @homePrayerMaghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get homePrayerMaghrib;

  /// No description provided for @homePrayerIsha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get homePrayerIsha;

  /// No description provided for @homeWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get homeWeek;

  /// No description provided for @homeMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get homeMonth;

  /// No description provided for @homeThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Deen Highlights This Week'**
  String get homeThisWeek;

  /// No description provided for @homeJummahMubarak.
  ///
  /// In en, this message translates to:
  /// **'Jummah Mubarak'**
  String get homeJummahMubarak;

  /// No description provided for @homeJummahReminder.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget Surah Al-Kahf.'**
  String get homeJummahReminder;

  /// No description provided for @hijriYear.
  ///
  /// In en, this message translates to:
  /// **'AH'**
  String get hijriYear;

  /// No description provided for @hijriMonthMuharram.
  ///
  /// In en, this message translates to:
  /// **'Muharram'**
  String get hijriMonthMuharram;

  /// No description provided for @hijriMonthSafar.
  ///
  /// In en, this message translates to:
  /// **'Safar'**
  String get hijriMonthSafar;

  /// No description provided for @hijriMonthRabiAlAwwal.
  ///
  /// In en, this message translates to:
  /// **'Rabi\' al-Awwal'**
  String get hijriMonthRabiAlAwwal;

  /// No description provided for @hijriMonthRabiAlThani.
  ///
  /// In en, this message translates to:
  /// **'Rabi\' al-Thani'**
  String get hijriMonthRabiAlThani;

  /// No description provided for @hijriMonthJumadaAlAwwal.
  ///
  /// In en, this message translates to:
  /// **'Jumada al-Awwal'**
  String get hijriMonthJumadaAlAwwal;

  /// No description provided for @hijriMonthJumadaAlThani.
  ///
  /// In en, this message translates to:
  /// **'Jumada al-Thani'**
  String get hijriMonthJumadaAlThani;

  /// No description provided for @hijriMonthRajab.
  ///
  /// In en, this message translates to:
  /// **'Rajab'**
  String get hijriMonthRajab;

  /// No description provided for @hijriMonthShaban.
  ///
  /// In en, this message translates to:
  /// **'Sha\'ban'**
  String get hijriMonthShaban;

  /// No description provided for @hijriMonthRamadan.
  ///
  /// In en, this message translates to:
  /// **'Ramadan'**
  String get hijriMonthRamadan;

  /// No description provided for @hijriMonthShawwal.
  ///
  /// In en, this message translates to:
  /// **'Shawwal'**
  String get hijriMonthShawwal;

  /// No description provided for @hijriMonthDhuAlQadah.
  ///
  /// In en, this message translates to:
  /// **'Dhu al-Qi\'dah'**
  String get hijriMonthDhuAlQadah;

  /// No description provided for @hijriMonthDhuAlHijjah.
  ///
  /// In en, this message translates to:
  /// **'Dhu al-Hijjah'**
  String get hijriMonthDhuAlHijjah;

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Islamic Calendar'**
  String get calendarTitle;

  /// No description provided for @calendarBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get calendarBack;

  /// No description provided for @calendarToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get calendarToday;

  /// No description provided for @calendarTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get calendarTomorrow;

  /// No description provided for @calendarDaysAway.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String calendarDaysAway(int days);

  /// No description provided for @calendarNoEventsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'No Islamic events this week.'**
  String get calendarNoEventsThisWeek;

  /// No description provided for @calendarNoEventsBlessing.
  ///
  /// In en, this message translates to:
  /// **'May Allah bless your week with peace and goodness.'**
  String get calendarNoEventsBlessing;

  /// No description provided for @calendarNoUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'No upcoming Islamic events found.'**
  String get calendarNoUpcomingEvents;

  /// No description provided for @calendarUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Islamic Events'**
  String get calendarUpcomingEvents;

  /// No description provided for @calendarUpcomingThisYear.
  ///
  /// In en, this message translates to:
  /// **'Upcoming This Year'**
  String get calendarUpcomingThisYear;

  /// No description provided for @calendarThisWeekObservances.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get calendarThisWeekObservances;

  /// No description provided for @calendarLegendCycleDays.
  ///
  /// In en, this message translates to:
  /// **'Cycle days (streak protected)'**
  String get calendarLegendCycleDays;

  /// No description provided for @calendarMoonIlluminated.
  ///
  /// In en, this message translates to:
  /// **'{percent}% illuminated'**
  String calendarMoonIlluminated(int percent);

  /// No description provided for @calendarMoonNew.
  ///
  /// In en, this message translates to:
  /// **'New Moon'**
  String get calendarMoonNew;

  /// No description provided for @calendarMoonWaxingCrescent.
  ///
  /// In en, this message translates to:
  /// **'Waxing Crescent'**
  String get calendarMoonWaxingCrescent;

  /// No description provided for @calendarMoonFirstQuarter.
  ///
  /// In en, this message translates to:
  /// **'First Quarter'**
  String get calendarMoonFirstQuarter;

  /// No description provided for @calendarMoonWaxingGibbous.
  ///
  /// In en, this message translates to:
  /// **'Waxing Gibbous'**
  String get calendarMoonWaxingGibbous;

  /// No description provided for @calendarMoonFull.
  ///
  /// In en, this message translates to:
  /// **'Full Moon'**
  String get calendarMoonFull;

  /// No description provided for @calendarMoonWaningGibbous.
  ///
  /// In en, this message translates to:
  /// **'Waning Gibbous'**
  String get calendarMoonWaningGibbous;

  /// No description provided for @calendarMoonLastQuarter.
  ///
  /// In en, this message translates to:
  /// **'Last Quarter'**
  String get calendarMoonLastQuarter;

  /// No description provided for @calendarMoonWaningCrescent.
  ///
  /// In en, this message translates to:
  /// **'Waning Crescent'**
  String get calendarMoonWaningCrescent;

  /// No description provided for @calendarEventRamadanBegins.
  ///
  /// In en, this message translates to:
  /// **'Ramadan Begins'**
  String get calendarEventRamadanBegins;

  /// No description provided for @calendarEventRamadanBeginsDesc.
  ///
  /// In en, this message translates to:
  /// **'Month of fasting'**
  String get calendarEventRamadanBeginsDesc;

  /// No description provided for @calendarEventLaylatAlQadr.
  ///
  /// In en, this message translates to:
  /// **'Laylat al-Qadr'**
  String get calendarEventLaylatAlQadr;

  /// No description provided for @calendarEventLaylatAlQadrDesc.
  ///
  /// In en, this message translates to:
  /// **'Night of Power'**
  String get calendarEventLaylatAlQadrDesc;

  /// No description provided for @calendarEventEidAlFitr.
  ///
  /// In en, this message translates to:
  /// **'Eid al-Fitr'**
  String get calendarEventEidAlFitr;

  /// No description provided for @calendarEventEidAlFitrDesc.
  ///
  /// In en, this message translates to:
  /// **'Festival of Breaking the Fast'**
  String get calendarEventEidAlFitrDesc;

  /// No description provided for @calendarEventDayOfArafah.
  ///
  /// In en, this message translates to:
  /// **'Day of Arafah'**
  String get calendarEventDayOfArafah;

  /// No description provided for @calendarEventDayOfArafahDesc.
  ///
  /// In en, this message translates to:
  /// **'Day of standing at Arafah'**
  String get calendarEventDayOfArafahDesc;

  /// No description provided for @calendarEventEidAlAdha.
  ///
  /// In en, this message translates to:
  /// **'Eid al-Adha'**
  String get calendarEventEidAlAdha;

  /// No description provided for @calendarEventEidAlAdhaDesc.
  ///
  /// In en, this message translates to:
  /// **'Festival of Sacrifice'**
  String get calendarEventEidAlAdhaDesc;

  /// No description provided for @calendarEventIslamicNewYear.
  ///
  /// In en, this message translates to:
  /// **'Islamic New Year'**
  String get calendarEventIslamicNewYear;

  /// No description provided for @calendarEventIslamicNewYearDesc.
  ///
  /// In en, this message translates to:
  /// **'1st of Muharram'**
  String get calendarEventIslamicNewYearDesc;

  /// No description provided for @calendarEventMawlid.
  ///
  /// In en, this message translates to:
  /// **'Mawlid an-Nabi'**
  String get calendarEventMawlid;

  /// No description provided for @calendarEventMawlidDesc.
  ///
  /// In en, this message translates to:
  /// **'Birth of the Prophet'**
  String get calendarEventMawlidDesc;

  /// No description provided for @calendarEventAshura.
  ///
  /// In en, this message translates to:
  /// **'Ashura'**
  String get calendarEventAshura;

  /// No description provided for @calendarEventAshuraDesc.
  ///
  /// In en, this message translates to:
  /// **'10th of Muharram'**
  String get calendarEventAshuraDesc;

  /// No description provided for @calendarEventJumuah.
  ///
  /// In en, this message translates to:
  /// **'Jumu\'ah'**
  String get calendarEventJumuah;

  /// No description provided for @calendarEventJumuahDesc.
  ///
  /// In en, this message translates to:
  /// **'Friday congregational prayer'**
  String get calendarEventJumuahDesc;

  /// No description provided for @calendarEventWhiteDays.
  ///
  /// In en, this message translates to:
  /// **'White Days'**
  String get calendarEventWhiteDays;

  /// No description provided for @calendarEventWhiteDaysDesc.
  ///
  /// In en, this message translates to:
  /// **'Recommended fasting days'**
  String get calendarEventWhiteDaysDesc;

  /// No description provided for @cycleModeActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cycle is a pause, not a stop.'**
  String get cycleModeActiveTitle;

  /// No description provided for @cycleModeActiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Dhikr • Tasbih • Quran listening'**
  String get cycleModeActiveSubtitle;

  /// No description provided for @cycleModeStreakProtected.
  ///
  /// In en, this message translates to:
  /// **'Prayer streak is protected during your cycle'**
  String get cycleModeStreakProtected;

  /// No description provided for @cycleModeCalendarHighlighted.
  ///
  /// In en, this message translates to:
  /// **'Calendar days are highlighted in pink'**
  String get cycleModeCalendarHighlighted;

  /// No description provided for @cycleModeAutoEndInfo.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Ends today} =1{Automatically ends tomorrow} other{Automatically ends in {days} days}}'**
  String cycleModeAutoEndInfo(int days);

  /// No description provided for @cycleModeSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cycle Mode'**
  String get cycleModeSettingsTitle;

  /// No description provided for @cycleModeStartDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get cycleModeStartDateLabel;

  /// No description provided for @cycleModeLengthLabel.
  ///
  /// In en, this message translates to:
  /// **'Cycle length'**
  String get cycleModeLengthLabel;

  /// No description provided for @cycleModeLengthValue.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String cycleModeLengthValue(int count);

  /// No description provided for @cycleModePauseStreaksLabel.
  ///
  /// In en, this message translates to:
  /// **'Protect prayer streak'**
  String get cycleModePauseStreaksLabel;

  /// No description provided for @cycleModeExcludeFromStatisticsLabel.
  ///
  /// In en, this message translates to:
  /// **'Exclude from statistics'**
  String get cycleModeExcludeFromStatisticsLabel;

  /// No description provided for @cycleModeSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get cycleModeSaveButton;

  /// No description provided for @cycleModeEditButton.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get cycleModeEditButton;

  /// No description provided for @cycleModeChangeStartDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Change start date?'**
  String get cycleModeChangeStartDateTitle;

  /// No description provided for @cycleModeChangeStartDateMessage.
  ///
  /// In en, this message translates to:
  /// **'Changing the start date will recalculate your active Cycle Mode window. Days outside the new range may no longer be treated as cycle days.'**
  String get cycleModeChangeStartDateMessage;

  /// No description provided for @cycleModeChangeStartDateConfirm.
  ///
  /// In en, this message translates to:
  /// **'Change start date'**
  String get cycleModeChangeStartDateConfirm;

  /// No description provided for @prayerReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Did you pray {prayer}?'**
  String prayerReminderTitle(String prayer);

  /// No description provided for @prayerReminderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep your streak alive by logging your prayer.'**
  String get prayerReminderSubtitle;

  /// No description provided for @prayerReminderYesButton.
  ///
  /// In en, this message translates to:
  /// **'Yes, Alhamdulillah'**
  String get prayerReminderYesButton;

  /// No description provided for @prayerReminderLaterButton.
  ///
  /// In en, this message translates to:
  /// **'I\'ll mark later'**
  String get prayerReminderLaterButton;

  /// No description provided for @prayerNotificationSubtitleFajr.
  ///
  /// In en, this message translates to:
  /// **'“Indeed, the recitation of dawn is ever witnessed.” — Qur’an 17:78'**
  String get prayerNotificationSubtitleFajr;

  /// No description provided for @prayerNotificationSubtitleDhuhr.
  ///
  /// In en, this message translates to:
  /// **'“Establish prayer at the decline of the sun...” — Qur’an 17:78'**
  String get prayerNotificationSubtitleDhuhr;

  /// No description provided for @prayerNotificationSubtitleAsr.
  ///
  /// In en, this message translates to:
  /// **'“Guard strictly the prayers, especially the middle prayer.” — Qur’an 2:238'**
  String get prayerNotificationSubtitleAsr;

  /// No description provided for @prayerNotificationSubtitleMaghrib.
  ///
  /// In en, this message translates to:
  /// **'“So glorify Allah when you reach the evening...” — Qur’an 30:17'**
  String get prayerNotificationSubtitleMaghrib;

  /// No description provided for @prayerNotificationSubtitleIsha.
  ///
  /// In en, this message translates to:
  /// **'“Establish prayer -  until the darkness of the night.” — Qur’an 17:78'**
  String get prayerNotificationSubtitleIsha;

  /// No description provided for @prayerNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'It\'s time for {prayerName}'**
  String prayerNotificationTitle(String prayerName);

  /// No description provided for @homeTrialBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Free for 7 days — become a better Muslim ✨'**
  String get homeTrialBannerTitle;

  /// No description provided for @homeTrialBannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every feature unlocked. Start your journey today.'**
  String get homeTrialBannerSubtitle;

  /// No description provided for @homeFocusModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus Mode'**
  String get homeFocusModeTitle;

  /// No description provided for @homeFocusModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Block distracting apps during Salah'**
  String get homeFocusModeSubtitle;

  /// No description provided for @homeLivePrayerUpdatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Prayer Updates'**
  String get homeLivePrayerUpdatesTitle;

  /// No description provided for @homeLivePrayerUpdatesBody.
  ///
  /// In en, this message translates to:
  /// **'See your current and next prayer on your Lock Screen & Dynamic Island.'**
  String get homeLivePrayerUpdatesBody;

  /// No description provided for @homeLivePrayerUpdatesCta.
  ///
  /// In en, this message translates to:
  /// **'Enable Live Updates'**
  String get homeLivePrayerUpdatesCta;

  /// No description provided for @homeWidgetsPromoTitle.
  ///
  /// In en, this message translates to:
  /// **'Widgets'**
  String get homeWidgetsPromoTitle;

  /// No description provided for @homeWidgetsPromoBody.
  ///
  /// In en, this message translates to:
  /// **'See your daily verse and prayer times on your Home Screen.'**
  String get homeWidgetsPromoBody;

  /// No description provided for @homeWidgetsPromoCta.
  ///
  /// In en, this message translates to:
  /// **'Add Widget'**
  String get homeWidgetsPromoCta;

  /// No description provided for @focusModeShortSalah.
  ///
  /// In en, this message translates to:
  /// **'Salah'**
  String get focusModeShortSalah;

  /// No description provided for @focusModeShortNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get focusModeShortNight;

  /// No description provided for @focusModeShortChild.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get focusModeShortChild;

  /// No description provided for @focusModeLabelSalah.
  ///
  /// In en, this message translates to:
  /// **'Salah mode'**
  String get focusModeLabelSalah;

  /// No description provided for @focusModeLabelNight.
  ///
  /// In en, this message translates to:
  /// **'Night mode'**
  String get focusModeLabelNight;

  /// No description provided for @focusModeLabelChild.
  ///
  /// In en, this message translates to:
  /// **'Child mode'**
  String get focusModeLabelChild;

  /// No description provided for @homeFocusModeNamesTwo.
  ///
  /// In en, this message translates to:
  /// **'{first} and {second} Modes are enabled'**
  String homeFocusModeNamesTwo(String first, String second);

  /// No description provided for @homeFocusModeNamesThree.
  ///
  /// In en, this message translates to:
  /// **'{first}, {second}, and {third} Modes are enabled'**
  String homeFocusModeNamesThree(String first, String second, String third);

  /// No description provided for @cycleModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Cycle Mode'**
  String get cycleModeTitle;

  /// No description provided for @cycleModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For menstruation — pause prayers, keep your streak'**
  String get cycleModeSubtitle;

  /// No description provided for @dailyChecklistTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Checklist'**
  String get dailyChecklistTitle;

  /// No description provided for @dailyChecklistSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your daily spiritual goals'**
  String get dailyChecklistSubtitle;

  /// No description provided for @dailyChecklistProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} completed'**
  String dailyChecklistProgress(int completed, int total);

  /// No description provided for @dailyChecklistSectionPrayer.
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get dailyChecklistSectionPrayer;

  /// No description provided for @dailyChecklistSectionQuranDhikr.
  ///
  /// In en, this message translates to:
  /// **'Quran & Dhikr'**
  String get dailyChecklistSectionQuranDhikr;

  /// No description provided for @dailyChecklistSectionGoodDeeds.
  ///
  /// In en, this message translates to:
  /// **'Good deeds'**
  String get dailyChecklistSectionGoodDeeds;

  /// No description provided for @dailyChecklistSectionDistraction.
  ///
  /// In en, this message translates to:
  /// **'Personal discipline'**
  String get dailyChecklistSectionDistraction;

  /// No description provided for @dailyChecklistFajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get dailyChecklistFajr;

  /// No description provided for @dailyChecklistTahajjud.
  ///
  /// In en, this message translates to:
  /// **'Tahajjud'**
  String get dailyChecklistTahajjud;

  /// No description provided for @dailyChecklistQuran.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get dailyChecklistQuran;

  /// No description provided for @dailyChecklistMorningAdhkar.
  ///
  /// In en, this message translates to:
  /// **'Morning Adhkar'**
  String get dailyChecklistMorningAdhkar;

  /// No description provided for @dailyChecklistEveningAdhkar.
  ///
  /// In en, this message translates to:
  /// **'Evening Adhkar'**
  String get dailyChecklistEveningAdhkar;

  /// No description provided for @dailyChecklistDhikr.
  ///
  /// In en, this message translates to:
  /// **'Dhikr'**
  String get dailyChecklistDhikr;

  /// No description provided for @dailyChecklistCharity.
  ///
  /// In en, this message translates to:
  /// **'Charity'**
  String get dailyChecklistCharity;

  /// No description provided for @dailyChecklistSmileAtSomeone.
  ///
  /// In en, this message translates to:
  /// **'Smile at someone'**
  String get dailyChecklistSmileAtSomeone;

  /// No description provided for @dailyChecklistFamilyCall.
  ///
  /// In en, this message translates to:
  /// **'Family call'**
  String get dailyChecklistFamilyCall;

  /// No description provided for @dailyChecklistNoMusicToday.
  ///
  /// In en, this message translates to:
  /// **'No music today'**
  String get dailyChecklistNoMusicToday;

  /// No description provided for @dailyChecklistNoSocialMediaBeforeIsha.
  ///
  /// In en, this message translates to:
  /// **'No social media before Isha'**
  String get dailyChecklistNoSocialMediaBeforeIsha;

  /// No description provided for @focusScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Focus Score'**
  String get focusScoreTitle;

  /// No description provided for @focusScorePrayer.
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get focusScorePrayer;

  /// No description provided for @focusScoreQuran.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get focusScoreQuran;

  /// No description provided for @focusScoreDhikr.
  ///
  /// In en, this message translates to:
  /// **'Dhikr'**
  String get focusScoreDhikr;

  /// No description provided for @focusScoreDistraction.
  ///
  /// In en, this message translates to:
  /// **'Distraction control'**
  String get focusScoreDistraction;

  /// No description provided for @insightsBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get insightsBack;

  /// No description provided for @insightsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Insights'**
  String get insightsTitle;

  /// No description provided for @insightsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your Deen progress'**
  String get insightsSubtitle;

  /// No description provided for @insightsPrayerRate.
  ///
  /// In en, this message translates to:
  /// **'Prayer rate'**
  String get insightsPrayerRate;

  /// No description provided for @insightsDayStreak.
  ///
  /// In en, this message translates to:
  /// **'Day streak'**
  String get insightsDayStreak;

  /// No description provided for @insightsBestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best streak'**
  String get insightsBestStreak;

  /// No description provided for @insightsWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get insightsWeekly;

  /// No description provided for @insightsMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get insightsMonthly;

  /// No description provided for @insightsPrayersCompleted.
  ///
  /// In en, this message translates to:
  /// **'Prayers completed'**
  String get insightsPrayersCompleted;

  /// No description provided for @insightsRestoreStreak.
  ///
  /// In en, this message translates to:
  /// **'Restore my streak — last 24 hours'**
  String get insightsRestoreStreak;

  /// No description provided for @focusScoreBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Prayer {prayerPercent}% · Quran {quranPercent}% · Dhikr {dhikrPercent}% · Distraction control {distractionPercent}%'**
  String focusScoreBreakdown(
    int prayerPercent,
    int quranPercent,
    int dhikrPercent,
    int distractionPercent,
  );

  /// No description provided for @quickActionsCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get quickActionsCalendar;

  /// No description provided for @quickActionsCalendarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View Islamic dates'**
  String get quickActionsCalendarSubtitle;

  /// No description provided for @quickActionsSupportUs.
  ///
  /// In en, this message translates to:
  /// **'Donations'**
  String get quickActionsSupportUs;

  /// No description provided for @quickActionsSupportUsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us grow'**
  String get quickActionsSupportUsSubtitle;

  /// No description provided for @quickActionsSupportUsMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you for considering to support DeenFocus! Support features coming soon.'**
  String get quickActionsSupportUsMessage;

  /// No description provided for @supportUsTitle.
  ///
  /// In en, this message translates to:
  /// **'Support DeenFocus'**
  String get supportUsTitle;

  /// No description provided for @supportUsHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Support DeenFocus'**
  String get supportUsHeroTitle;

  /// No description provided for @supportUsHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Your support helps us keep improving DeenFocus and contribute to meaningful causes.'**
  String get supportUsHeroBody;

  /// No description provided for @supportUsFundSection.
  ///
  /// In en, this message translates to:
  /// **'Your support helps fund'**
  String get supportUsFundSection;

  /// No description provided for @supportUsFundSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We use your support to create more good.'**
  String get supportUsFundSectionSubtitle;

  /// No description provided for @supportUsFundFeature1Title.
  ///
  /// In en, this message translates to:
  /// **'New Features'**
  String get supportUsFundFeature1Title;

  /// No description provided for @supportUsFundFeature1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Build and improve meaningful DeenFocus features.'**
  String get supportUsFundFeature1Subtitle;

  /// No description provided for @supportUsFundFeature2Title.
  ///
  /// In en, this message translates to:
  /// **'Bug Fixes'**
  String get supportUsFundFeature2Title;

  /// No description provided for @supportUsFundFeature2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep the app stable, fast and reliable for everyone.'**
  String get supportUsFundFeature2Subtitle;

  /// No description provided for @supportUsFundFeature3Title.
  ///
  /// In en, this message translates to:
  /// **'People in Need'**
  String get supportUsFundFeature3Title;

  /// No description provided for @supportUsFundFeature3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Support efforts that help people facing hardship and difficult times.'**
  String get supportUsFundFeature3Subtitle;

  /// No description provided for @supportUsFundFeature4Title.
  ///
  /// In en, this message translates to:
  /// **'Charity & Community'**
  String get supportUsFundFeature4Title;

  /// No description provided for @supportUsFundFeature4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Contribute towards charitable initiatives and community support.'**
  String get supportUsFundFeature4Subtitle;

  /// No description provided for @supportUsNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'NEED HELP?'**
  String get supportUsNeedHelp;

  /// No description provided for @supportUsWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Chat on WhatsApp'**
  String get supportUsWhatsApp;

  /// No description provided for @supportUsEmailSupport.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get supportUsEmailSupport;

  /// No description provided for @supportUsChooseAmountTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a support amount'**
  String get supportUsChooseAmountTitle;

  /// No description provided for @supportUsChooseAmountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can support multiple times.'**
  String get supportUsChooseAmountSubtitle;

  /// No description provided for @supportUsSecurePaymentNote.
  ///
  /// In en, this message translates to:
  /// **'Secure one-time payment · No recurring charges'**
  String get supportUsSecurePaymentNote;

  /// No description provided for @supportUsTrustBanner.
  ///
  /// In en, this message translates to:
  /// **'Secure • One-time Support • You can support multiple times'**
  String get supportUsTrustBanner;

  /// No description provided for @supportUsImpactSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Where your support makes a difference'**
  String get supportUsImpactSectionTitle;

  /// No description provided for @supportUsImpactSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every contribution has a lasting impact.'**
  String get supportUsImpactSectionSubtitle;

  /// No description provided for @supportUsImpactPalestine.
  ///
  /// In en, this message translates to:
  /// **'Support & Awareness for Palestine'**
  String get supportUsImpactPalestine;

  /// No description provided for @supportUsImpactNeedy.
  ///
  /// In en, this message translates to:
  /// **'Helping Those in Need'**
  String get supportUsImpactNeedy;

  /// No description provided for @supportUsImpactCommunity.
  ///
  /// In en, this message translates to:
  /// **'Charity & Community Support'**
  String get supportUsImpactCommunity;

  /// No description provided for @supportUsImpactExperience.
  ///
  /// In en, this message translates to:
  /// **'Better DeenFocus Experience'**
  String get supportUsImpactExperience;

  /// No description provided for @supportUsImpactFeatures.
  ///
  /// In en, this message translates to:
  /// **'New Features & Upgrades'**
  String get supportUsImpactFeatures;

  /// No description provided for @supportUsImpactQuran.
  ///
  /// In en, this message translates to:
  /// **'Quran & Islamic Learning'**
  String get supportUsImpactQuran;

  /// No description provided for @supportUsImpactServers.
  ///
  /// In en, this message translates to:
  /// **'Servers & App Reliability'**
  String get supportUsImpactServers;

  /// No description provided for @supportUsCta.
  ///
  /// In en, this message translates to:
  /// **'Support DeenFocus with {amount}'**
  String supportUsCta(String amount);

  /// No description provided for @supportUsWhatsAppPrefill.
  ///
  /// In en, this message translates to:
  /// **'Assalamu alaikum, I need help with DeenFocus.'**
  String get supportUsWhatsAppPrefill;

  /// No description provided for @supportUsWhatsAppQuestionHowTo.
  ///
  /// In en, this message translates to:
  /// **'How do I use DeenFocus?'**
  String get supportUsWhatsAppQuestionHowTo;

  /// No description provided for @supportUsWhatsAppQuestionFeature.
  ///
  /// In en, this message translates to:
  /// **'I need help with a feature'**
  String get supportUsWhatsAppQuestionFeature;

  /// No description provided for @supportUsWhatsAppQuestionSubscription.
  ///
  /// In en, this message translates to:
  /// **'I have a problem with my subscription'**
  String get supportUsWhatsAppQuestionSubscription;

  /// No description provided for @supportUsEmailSubject.
  ///
  /// In en, this message translates to:
  /// **'DeenFocus support request'**
  String get supportUsEmailSubject;

  /// No description provided for @supportUsLaunchUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not open that app on this device.'**
  String get supportUsLaunchUnavailable;

  /// No description provided for @supportUsLaunchFailed.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get supportUsLaunchFailed;

  /// No description provided for @supportUsThankYouTitle.
  ///
  /// In en, this message translates to:
  /// **'JazakAllah khair'**
  String get supportUsThankYouTitle;

  /// No description provided for @supportUsThankYouBody.
  ///
  /// In en, this message translates to:
  /// **'Thank you for supporting DeenFocus. You can support again anytime.'**
  String get supportUsThankYouBody;

  /// No description provided for @supportUsPurchasePending.
  ///
  /// In en, this message translates to:
  /// **'Your support is pending. We\'ll confirm it once Apple completes the purchase.'**
  String get supportUsPurchasePending;

  /// No description provided for @supportUsPurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t complete your support payment. Please try again.'**
  String get supportUsPurchaseFailed;

  /// No description provided for @supportUsProductUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This support amount isn\'t available right now. Please try again later.'**
  String get supportUsProductUnavailable;

  /// No description provided for @homeAiChatDescription.
  ///
  /// In en, this message translates to:
  /// **'Ask anything about prayer times, Quran, and Islamic guidance.'**
  String get homeAiChatDescription;

  /// No description provided for @homeDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get homeDay;

  /// No description provided for @homeDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get homeDays;

  /// No description provided for @homeNoEventsFoundForDay.
  ///
  /// In en, this message translates to:
  /// **'No events found for this day.'**
  String get homeNoEventsFoundForDay;

  /// No description provided for @homeMarkPrayerAs.
  ///
  /// In en, this message translates to:
  /// **'{prayerName} — mark as'**
  String homeMarkPrayerAs(String prayerName);

  /// No description provided for @homeMarkPrayerPrayedOnTime.
  ///
  /// In en, this message translates to:
  /// **'Prayed on time'**
  String get homeMarkPrayerPrayedOnTime;

  /// No description provided for @homeMarkPrayerQada.
  ///
  /// In en, this message translates to:
  /// **'Qada (made up)'**
  String get homeMarkPrayerQada;

  /// No description provided for @homeMarkPrayerMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get homeMarkPrayerMissed;

  /// No description provided for @homePrayerSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'{prayerName} Settings'**
  String homePrayerSettingsTitle(String prayerName);

  /// No description provided for @homePrayerSettingsPrayerTime.
  ///
  /// In en, this message translates to:
  /// **'Prayer Time'**
  String get homePrayerSettingsPrayerTime;

  /// No description provided for @homePrayerSettingsNotification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get homePrayerSettingsNotification;

  /// No description provided for @homePrayerSettingsAboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Virtues, rulings and more'**
  String get homePrayerSettingsAboutSubtitle;

  /// No description provided for @homePrayerSettingsInfoBanner.
  ///
  /// In en, this message translates to:
  /// **'These settings are only for {prayerName}. You can set different preferences for each prayer.'**
  String homePrayerSettingsInfoBanner(String prayerName);

  /// No description provided for @homeEditPrayerTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit {prayerName} Time'**
  String homeEditPrayerTimeTitle(String prayerName);

  /// No description provided for @homeEditPrayerTimeCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current Time'**
  String get homeEditPrayerTimeCurrent;

  /// No description provided for @homeEditPrayerTimeSelectNew.
  ///
  /// In en, this message translates to:
  /// **'Select new time'**
  String get homeEditPrayerTimeSelectNew;

  /// No description provided for @homeEditPrayerTimeNote.
  ///
  /// In en, this message translates to:
  /// **'This custom time applies only to {prayerName}. Adjust it if your local masjid or calculation differs.'**
  String homeEditPrayerTimeNote(String prayerName);

  /// No description provided for @homeEditPrayerTimeSave.
  ///
  /// In en, this message translates to:
  /// **'Save Time'**
  String get homeEditPrayerTimeSave;

  /// No description provided for @homeEditPrayerTimeReset.
  ///
  /// In en, this message translates to:
  /// **'Reset to calculated time'**
  String get homeEditPrayerTimeReset;

  /// No description provided for @homeNotificationForPrayer.
  ///
  /// In en, this message translates to:
  /// **'Notification for {prayerName}'**
  String homeNotificationForPrayer(String prayerName);

  /// No description provided for @homeNotificationSoundLabel.
  ///
  /// In en, this message translates to:
  /// **'Notification Sound'**
  String get homeNotificationSoundLabel;

  /// No description provided for @homeNotificationSoundFullAdhan.
  ///
  /// In en, this message translates to:
  /// **'Full Adhan'**
  String get homeNotificationSoundFullAdhan;

  /// No description provided for @homeNotificationSoundFullAdhanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play the complete Adhan'**
  String get homeNotificationSoundFullAdhanSubtitle;

  /// No description provided for @homeNotificationSoundBeep.
  ///
  /// In en, this message translates to:
  /// **'Beep'**
  String get homeNotificationSoundBeep;

  /// No description provided for @homeNotificationSoundBeepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A short notification tone'**
  String get homeNotificationSoundBeepSubtitle;

  /// No description provided for @homeNotificationSoundMute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get homeNotificationSoundMute;

  /// No description provided for @homeNotificationSoundMuteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No sound'**
  String get homeNotificationSoundMuteSubtitle;

  /// No description provided for @homeNotificationEnableLabel.
  ///
  /// In en, this message translates to:
  /// **'Enable Notification'**
  String get homeNotificationEnableLabel;

  /// No description provided for @homeNotificationEnableSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get notified at {prayerName} time'**
  String homeNotificationEnableSubtitle(String prayerName);

  /// No description provided for @homeAboutPrayerTitle.
  ///
  /// In en, this message translates to:
  /// **'About {prayerName}'**
  String homeAboutPrayerTitle(String prayerName);

  /// No description provided for @homeAboutPrayerTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get homeAboutPrayerTimeLabel;

  /// No description provided for @homeAboutPrayerRakatLabel.
  ///
  /// In en, this message translates to:
  /// **'Rakat'**
  String get homeAboutPrayerRakatLabel;

  /// No description provided for @homeAboutPrayerVirtuesLabel.
  ///
  /// In en, this message translates to:
  /// **'Virtues'**
  String get homeAboutPrayerVirtuesLabel;

  /// No description provided for @homeAboutPrayerReferenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get homeAboutPrayerReferenceLabel;

  /// No description provided for @homeAboutFajrTiming.
  ///
  /// In en, this message translates to:
  /// **'Begins at true dawn (Fajr Sadiq) and ends at sunrise.'**
  String get homeAboutFajrTiming;

  /// No description provided for @homeAboutFajrRakat.
  ///
  /// In en, this message translates to:
  /// **'2 Sunnah + 2 Fard'**
  String get homeAboutFajrRakat;

  /// No description provided for @homeAboutFajrVirtue.
  ///
  /// In en, this message translates to:
  /// **'Whoever prays Fajr is under the protection of Allah.'**
  String get homeAboutFajrVirtue;

  /// No description provided for @homeAboutFajrReference.
  ///
  /// In en, this message translates to:
  /// **'\"The two rak\'ahs of Fajr are better than the world and all it contains.\" (Sahih Muslim)'**
  String get homeAboutFajrReference;

  /// No description provided for @homeAboutDhuhrTiming.
  ///
  /// In en, this message translates to:
  /// **'Begins once the sun passes its zenith and lasts until Asr begins.'**
  String get homeAboutDhuhrTiming;

  /// No description provided for @homeAboutDhuhrRakat.
  ///
  /// In en, this message translates to:
  /// **'4 Sunnah + 4 Fard + 2 Sunnah'**
  String get homeAboutDhuhrRakat;

  /// No description provided for @homeAboutDhuhrVirtue.
  ///
  /// In en, this message translates to:
  /// **'Part of the 12 voluntary rak\'ahs a day for which Allah builds a house in Paradise.'**
  String get homeAboutDhuhrVirtue;

  /// No description provided for @homeAboutDhuhrReference.
  ///
  /// In en, this message translates to:
  /// **'\"Whoever prays twelve rak\'ahs during a day and a night will have a house built for him in Paradise.\" (Sahih Muslim)'**
  String get homeAboutDhuhrReference;

  /// No description provided for @homeAboutAsrTiming.
  ///
  /// In en, this message translates to:
  /// **'Begins when an object\'s shadow equals its length and lasts until sunset.'**
  String get homeAboutAsrTiming;

  /// No description provided for @homeAboutAsrRakat.
  ///
  /// In en, this message translates to:
  /// **'4 Fard'**
  String get homeAboutAsrRakat;

  /// No description provided for @homeAboutAsrVirtue.
  ///
  /// In en, this message translates to:
  /// **'Guarding this prayer is singled out for special reward and warning.'**
  String get homeAboutAsrVirtue;

  /// No description provided for @homeAboutAsrReference.
  ///
  /// In en, this message translates to:
  /// **'\"Whoever misses the Asr prayer, it is as if he lost his family and his wealth.\" (Sahih al-Bukhari)'**
  String get homeAboutAsrReference;

  /// No description provided for @homeAboutMaghribTiming.
  ///
  /// In en, this message translates to:
  /// **'Begins right after sunset and lasts until the red twilight disappears.'**
  String get homeAboutMaghribTiming;

  /// No description provided for @homeAboutMaghribRakat.
  ///
  /// In en, this message translates to:
  /// **'3 Fard + 2 Sunnah'**
  String get homeAboutMaghribRakat;

  /// No description provided for @homeAboutMaghribVirtue.
  ///
  /// In en, this message translates to:
  /// **'A time when supplications are especially encouraged.'**
  String get homeAboutMaghribVirtue;

  /// No description provided for @homeAboutMaghribReference.
  ///
  /// In en, this message translates to:
  /// **'\"There are two occasions when a fasting person rejoices... when he breaks his fast.\" (Sahih al-Bukhari, on the Maghrib fast-breaking)'**
  String get homeAboutMaghribReference;

  /// No description provided for @homeAboutIshaTiming.
  ///
  /// In en, this message translates to:
  /// **'Begins once the twilight fully disappears and lasts until midnight (or Fajr, per some views).'**
  String get homeAboutIshaTiming;

  /// No description provided for @homeAboutIshaRakat.
  ///
  /// In en, this message translates to:
  /// **'4 Fard + 2 Sunnah + Witr'**
  String get homeAboutIshaRakat;

  /// No description provided for @homeAboutIshaVirtue.
  ///
  /// In en, this message translates to:
  /// **'Praying Isha in congregation is equivalent to standing half the night in prayer.'**
  String get homeAboutIshaVirtue;

  /// No description provided for @homeAboutIshaReference.
  ///
  /// In en, this message translates to:
  /// **'\"Whoever prays Isha in congregation, it is as if he prayed half the night.\" (Sahih Muslim)'**
  String get homeAboutIshaReference;

  /// No description provided for @backToOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Back to Onboarding'**
  String get backToOnboarding;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get tabFocus;

  /// No description provided for @tabTasbih.
  ///
  /// In en, this message translates to:
  /// **'Tasbih'**
  String get tabTasbih;

  /// No description provided for @tabQuran.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get tabQuran;

  /// No description provided for @tabLearn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get tabLearn;

  /// No description provided for @quranLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load Quran data'**
  String get quranLoadFailed;

  /// No description provided for @quranTabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read and explore the Holy Quran'**
  String get quranTabSubtitle;

  /// No description provided for @quranTabSubtitleExtended.
  ///
  /// In en, this message translates to:
  /// **'Read, listen and perfect your tajweed'**
  String get quranTabSubtitleExtended;

  /// No description provided for @quranSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search surah...'**
  String get quranSearchHint;

  /// No description provided for @quranSearchHintExtended.
  ///
  /// In en, this message translates to:
  /// **'Search surah or meaning...'**
  String get quranSearchHintExtended;

  /// No description provided for @quranNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get quranNoResults;

  /// No description provided for @quranNoSurahsFound.
  ///
  /// In en, this message translates to:
  /// **'No surahs found'**
  String get quranNoSurahsFound;

  /// No description provided for @quranVersesLabel.
  ///
  /// In en, this message translates to:
  /// **'verses'**
  String get quranVersesLabel;

  /// No description provided for @quranSurahHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{name} • {count} verses'**
  String quranSurahHeaderSubtitle(String name, int count);

  /// No description provided for @quranTextOptions.
  ///
  /// In en, this message translates to:
  /// **'Text options'**
  String get quranTextOptions;

  /// No description provided for @quranEnglishAndArabic.
  ///
  /// In en, this message translates to:
  /// **'English and Arabic'**
  String get quranEnglishAndArabic;

  /// No description provided for @quranArabicOnly.
  ///
  /// In en, this message translates to:
  /// **'Arabic only'**
  String get quranArabicOnly;

  /// No description provided for @quranIncreaseFont.
  ///
  /// In en, this message translates to:
  /// **'Increase font'**
  String get quranIncreaseFont;

  /// No description provided for @quranDecreaseFont.
  ///
  /// In en, this message translates to:
  /// **'Decrease font'**
  String get quranDecreaseFont;

  /// No description provided for @quranPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get quranPause;

  /// No description provided for @quranPlaySurah.
  ///
  /// In en, this message translates to:
  /// **'Play surah'**
  String get quranPlaySurah;

  /// No description provided for @quranAudioNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Audio requires internet.'**
  String get quranAudioNoInternet;

  /// No description provided for @quranAudioTimeout.
  ///
  /// In en, this message translates to:
  /// **'Audio load timed out. Check your connection.'**
  String get quranAudioTimeout;

  /// No description provided for @quranSurahLabel.
  ///
  /// In en, this message translates to:
  /// **'Surah'**
  String get quranSurahLabel;

  /// No description provided for @quranModeSurah.
  ///
  /// In en, this message translates to:
  /// **'Surah'**
  String get quranModeSurah;

  /// No description provided for @quranModeJuz.
  ///
  /// In en, this message translates to:
  /// **'Juz'**
  String get quranModeJuz;

  /// No description provided for @quranModePage.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get quranModePage;

  /// No description provided for @quranSwitchToPageView.
  ///
  /// In en, this message translates to:
  /// **'Page view'**
  String get quranSwitchToPageView;

  /// No description provided for @quranSwitchToSurahView.
  ///
  /// In en, this message translates to:
  /// **'Surah view'**
  String get quranSwitchToSurahView;

  /// No description provided for @quranJuzLabel.
  ///
  /// In en, this message translates to:
  /// **'Juz'**
  String get quranJuzLabel;

  /// No description provided for @quranPageLabel.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get quranPageLabel;

  /// No description provided for @quranContinueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get quranContinueReading;

  /// No description provided for @quranPreviousAyah.
  ///
  /// In en, this message translates to:
  /// **'Previous ayah'**
  String get quranPreviousAyah;

  /// No description provided for @quranNextAyah.
  ///
  /// In en, this message translates to:
  /// **'Next ayah'**
  String get quranNextAyah;

  /// No description provided for @quranPreviousJuz.
  ///
  /// In en, this message translates to:
  /// **'Previous Juz'**
  String get quranPreviousJuz;

  /// No description provided for @quranNextJuz.
  ///
  /// In en, this message translates to:
  /// **'Next Juz'**
  String get quranNextJuz;

  /// No description provided for @quranPreviousPage.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get quranPreviousPage;

  /// No description provided for @quranNextPage.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get quranNextPage;

  /// No description provided for @quranMarkPageRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get quranMarkPageRead;

  /// No description provided for @quranPageMarkedRead.
  ///
  /// In en, this message translates to:
  /// **'Page {page} marked as read'**
  String quranPageMarkedRead(int page);

  /// No description provided for @quranMushafComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get quranMushafComplete;

  /// No description provided for @quranPageEmpty.
  ///
  /// In en, this message translates to:
  /// **'No ayahs on this page'**
  String get quranPageEmpty;

  /// No description provided for @quranTranslationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Translation not available for this ayah'**
  String get quranTranslationUnavailable;

  /// No description provided for @quranJuzProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of Juz {juz}'**
  String quranJuzProgressLabel(int percent, int juz);

  /// No description provided for @quranBookmarksTitle.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get quranBookmarksTitle;

  /// No description provided for @quranBookmarksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet'**
  String get quranBookmarksEmpty;

  /// No description provided for @quranBookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get quranBookmark;

  /// No description provided for @quranBookmarkSaved.
  ///
  /// In en, this message translates to:
  /// **'Bookmark saved'**
  String get quranBookmarkSaved;

  /// No description provided for @quranBookmarkRemoved.
  ///
  /// In en, this message translates to:
  /// **'Bookmark removed'**
  String get quranBookmarkRemoved;

  /// No description provided for @quranBookmarkCount.
  ///
  /// In en, this message translates to:
  /// **'{count} saved'**
  String quranBookmarkCount(int count);

  /// No description provided for @quranQuickTajweed.
  ///
  /// In en, this message translates to:
  /// **'Tajweed drill'**
  String get quranQuickTajweed;

  /// No description provided for @quranQuickTajweedSub.
  ///
  /// In en, this message translates to:
  /// **'Recite & score'**
  String get quranQuickTajweedSub;

  /// No description provided for @quranLastListened.
  ///
  /// In en, this message translates to:
  /// **'Last listened'**
  String get quranLastListened;

  /// No description provided for @quranNoneYet.
  ///
  /// In en, this message translates to:
  /// **'None yet'**
  String get quranNoneYet;

  /// No description provided for @quranOpenPage.
  ///
  /// In en, this message translates to:
  /// **'Open page'**
  String get quranOpenPage;

  /// No description provided for @quranOpenJuz.
  ///
  /// In en, this message translates to:
  /// **'Open Juz'**
  String get quranOpenJuz;

  /// No description provided for @quranOpenAyah.
  ///
  /// In en, this message translates to:
  /// **'Open ayah'**
  String get quranOpenAyah;

  /// No description provided for @quranReadingToolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading tools'**
  String get quranReadingToolsTitle;

  /// No description provided for @quranQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quranQuickActions;

  /// No description provided for @quranReadingToolsHint.
  ///
  /// In en, this message translates to:
  /// **'Tafsir, color Tajweed, word-by-word, and extra reciters coming soon.'**
  String get quranReadingToolsHint;

  /// No description provided for @quranCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get quranCopy;

  /// No description provided for @quranShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get quranShare;

  /// No description provided for @quranCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get quranCopied;

  /// No description provided for @quranShareCopiedHint.
  ///
  /// In en, this message translates to:
  /// **'Copied — paste to share'**
  String get quranShareCopiedHint;

  /// No description provided for @quranColorTajweed.
  ///
  /// In en, this message translates to:
  /// **'Color Tajweed'**
  String get quranColorTajweed;

  /// No description provided for @quranTafsir.
  ///
  /// In en, this message translates to:
  /// **'Tafsir'**
  String get quranTafsir;

  /// No description provided for @quranWordByWord.
  ///
  /// In en, this message translates to:
  /// **'Word-by-word'**
  String get quranWordByWord;

  /// No description provided for @quranReciters.
  ///
  /// In en, this message translates to:
  /// **'Reciters'**
  String get quranReciters;

  /// No description provided for @quranComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get quranComingSoon;

  /// No description provided for @tajweedDisabledHint.
  ///
  /// In en, this message translates to:
  /// **'Enable AI Tajweed Practice in Reading Settings'**
  String get tajweedDisabledHint;

  /// No description provided for @readingSettingsTajweedPractice.
  ///
  /// In en, this message translates to:
  /// **'AI Quran Tajweed'**
  String get readingSettingsTajweedPractice;

  /// No description provided for @readingSettingsTajweedPracticeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recite ayahs and get feedback'**
  String get readingSettingsTajweedPracticeSubtitle;

  /// No description provided for @readingSettingsTajweedSeeHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'See how it works'**
  String get readingSettingsTajweedSeeHowItWorks;

  /// No description provided for @quranSeeHowAiQuranTajweedWorks.
  ///
  /// In en, this message translates to:
  /// **'see how AI Quran Tajweed works'**
  String get quranSeeHowAiQuranTajweedWorks;

  /// No description provided for @readingSettingsTajweedDeleteModel.
  ///
  /// In en, this message translates to:
  /// **'Delete AI model'**
  String get readingSettingsTajweedDeleteModel;

  /// No description provided for @readingSettingsTajweedDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete AI Quran Tajweed model?'**
  String get readingSettingsTajweedDeleteConfirmTitle;

  /// No description provided for @readingSettingsTajweedDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You won\'t be able to practice tajweed until you download the AI model again. This also frees storage on your device.'**
  String get readingSettingsTajweedDeleteConfirmBody;

  /// No description provided for @readingSettingsTajweedDeleteConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get readingSettingsTajweedDeleteConfirmAction;

  /// No description provided for @readingSettingsTajweedDeleted.
  ///
  /// In en, this message translates to:
  /// **'AI Tajweed model deleted'**
  String get readingSettingsTajweedDeleted;

  /// No description provided for @readingSettingsTajweedDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the AI Tajweed model'**
  String get readingSettingsTajweedDeleteFailed;

  /// No description provided for @readingSettingsTajweedFreePreviewTranslation.
  ///
  /// In en, this message translates to:
  /// **'In the name of Allah, the Entirely Merciful, the Especially Merciful.'**
  String get readingSettingsTajweedFreePreviewTranslation;

  /// No description provided for @quranAudioSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Audio settings'**
  String get quranAudioSettingsTitle;

  /// No description provided for @quranPlaybackSpeed.
  ///
  /// In en, this message translates to:
  /// **'Playback speed'**
  String get quranPlaybackSpeed;

  /// No description provided for @quranVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get quranVolume;

  /// No description provided for @quranRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get quranRepeat;

  /// No description provided for @quranRepeatOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get quranRepeatOff;

  /// No description provided for @quranRepeatAyah.
  ///
  /// In en, this message translates to:
  /// **'Ayah'**
  String get quranRepeatAyah;

  /// No description provided for @quranRepeatSurah.
  ///
  /// In en, this message translates to:
  /// **'Surah'**
  String get quranRepeatSurah;

  /// No description provided for @readingSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading Settings'**
  String get readingSettingsTitle;

  /// No description provided for @readingSettingsArabicFontSize.
  ///
  /// In en, this message translates to:
  /// **'Arabic font size'**
  String get readingSettingsArabicFontSize;

  /// No description provided for @readingSettingsTranslationFontSize.
  ///
  /// In en, this message translates to:
  /// **'Translation font size'**
  String get readingSettingsTranslationFontSize;

  /// No description provided for @readingSettingsLineSpacing.
  ///
  /// In en, this message translates to:
  /// **'Line spacing'**
  String get readingSettingsLineSpacing;

  /// No description provided for @readingSettingsDefaultMode.
  ///
  /// In en, this message translates to:
  /// **'Default reading mode'**
  String get readingSettingsDefaultMode;

  /// No description provided for @readingSettingsRememberPosition.
  ///
  /// In en, this message translates to:
  /// **'Remember last position'**
  String get readingSettingsRememberPosition;

  /// No description provided for @readingSettingsScript.
  ///
  /// In en, this message translates to:
  /// **'Arabic script'**
  String get readingSettingsScript;

  /// No description provided for @readingSettingsScriptUthmani.
  ///
  /// In en, this message translates to:
  /// **'Uthmani (Hafs)'**
  String get readingSettingsScriptUthmani;

  /// No description provided for @readingSettingsScriptIndopak.
  ///
  /// In en, this message translates to:
  /// **'IndoPak (Hafs)'**
  String get readingSettingsScriptIndopak;

  /// No description provided for @readingSettingsArabicFont.
  ///
  /// In en, this message translates to:
  /// **'Arabic font'**
  String get readingSettingsArabicFont;

  /// No description provided for @readingSettingsFontUthmanic.
  ///
  /// In en, this message translates to:
  /// **'Uthmanic Hafs'**
  String get readingSettingsFontUthmanic;

  /// No description provided for @readingSettingsFontNooreHuda.
  ///
  /// In en, this message translates to:
  /// **'Noore Huda'**
  String get readingSettingsFontNooreHuda;

  /// No description provided for @readingSettingsFontSystem.
  ///
  /// In en, this message translates to:
  /// **'System (native)'**
  String get readingSettingsFontSystem;

  /// No description provided for @readingSettingsShowTranslation.
  ///
  /// In en, this message translates to:
  /// **'Show translation'**
  String get readingSettingsShowTranslation;

  /// No description provided for @readingSettingsShowTransliteration.
  ///
  /// In en, this message translates to:
  /// **'Show transliteration'**
  String get readingSettingsShowTransliteration;

  /// No description provided for @readingSettingsTranslationSection.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get readingSettingsTranslationSection;

  /// No description provided for @readingSettingsTranslationLabel.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get readingSettingsTranslationLabel;

  /// No description provided for @readingSettingsTranslationCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get readingSettingsTranslationCurrent;

  /// No description provided for @readingSettingsInstalledTranslations.
  ///
  /// In en, this message translates to:
  /// **'Installed'**
  String get readingSettingsInstalledTranslations;

  /// No description provided for @readingSettingsAvailableTranslations.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get readingSettingsAvailableTranslations;

  /// No description provided for @readingSettingsTranslationInstalled.
  ///
  /// In en, this message translates to:
  /// **'Installed'**
  String get readingSettingsTranslationInstalled;

  /// No description provided for @readingSettingsTranslationSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get readingSettingsTranslationSelected;

  /// No description provided for @readingSettingsTranslationDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get readingSettingsTranslationDownload;

  /// No description provided for @readingSettingsTranslationInstalling.
  ///
  /// In en, this message translates to:
  /// **'Installing…'**
  String get readingSettingsTranslationInstalling;

  /// No description provided for @readingSettingsTranslationDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading…'**
  String get readingSettingsTranslationDownloading;

  /// No description provided for @readingSettingsLayoutTheme.
  ///
  /// In en, this message translates to:
  /// **'Quran layout'**
  String get readingSettingsLayoutTheme;

  /// No description provided for @readingSettingsLayoutClassic.
  ///
  /// In en, this message translates to:
  /// **'Mushaf'**
  String get readingSettingsLayoutClassic;

  /// No description provided for @readingSettingsLayoutSimple.
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get readingSettingsLayoutSimple;

  /// No description provided for @readingSettingsLayoutColor.
  ///
  /// In en, this message translates to:
  /// **'Color Quran'**
  String get readingSettingsLayoutColor;

  /// No description provided for @readingSettingsColorTheme.
  ///
  /// In en, this message translates to:
  /// **'Reading theme'**
  String get readingSettingsColorTheme;

  /// No description provided for @readingSettingsColorThemeParchment.
  ///
  /// In en, this message translates to:
  /// **'Parchment'**
  String get readingSettingsColorThemeParchment;

  /// No description provided for @readingSettingsColorThemeEmerald.
  ///
  /// In en, this message translates to:
  /// **'Emerald'**
  String get readingSettingsColorThemeEmerald;

  /// No description provided for @readingSettingsColorThemeMidnight.
  ///
  /// In en, this message translates to:
  /// **'Midnight'**
  String get readingSettingsColorThemeMidnight;

  /// No description provided for @readingSettingsPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get readingSettingsPreview;

  /// No description provided for @readingSettingsResetHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset reading data'**
  String get readingSettingsResetHistoryTitle;

  /// No description provided for @readingSettingsResetHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Clears continue reading, page progress, bookmarks, and quick actions'**
  String get readingSettingsResetHistorySubtitle;

  /// No description provided for @readingSettingsResetHistoryConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset reading data?'**
  String get readingSettingsResetHistoryConfirmTitle;

  /// No description provided for @readingSettingsResetHistoryConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This removes continue reading, page completion progress, bookmarks, last listened, and last Tajweed shortcuts. Your display and translation settings are kept.'**
  String get readingSettingsResetHistoryConfirmBody;

  /// No description provided for @readingSettingsResetHistoryDone.
  ///
  /// In en, this message translates to:
  /// **'Reading data cleared'**
  String get readingSettingsResetHistoryDone;

  /// No description provided for @readingSettingsResetHistoryButton.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get readingSettingsResetHistoryButton;

  /// No description provided for @readingSettingsTranslationDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not download {name}. Try again when online.'**
  String readingSettingsTranslationDownloadFailed(String name);

  /// No description provided for @readingSettingsTranslationSizeMb.
  ///
  /// In en, this message translates to:
  /// **'{size} MB'**
  String readingSettingsTranslationSizeMb(String size);

  /// No description provided for @tajweedListenToAyah.
  ///
  /// In en, this message translates to:
  /// **'Listen to ayah'**
  String get tajweedListenToAyah;

  /// No description provided for @tajweedStartReciting.
  ///
  /// In en, this message translates to:
  /// **'Start reciting'**
  String get tajweedStartReciting;

  /// No description provided for @tajweedTapToStop.
  ///
  /// In en, this message translates to:
  /// **'Tap to stop'**
  String get tajweedTapToStop;

  /// No description provided for @tajweedListeningHint.
  ///
  /// In en, this message translates to:
  /// **'Listening... recite clearly'**
  String get tajweedListeningHint;

  /// No description provided for @tajweedStopAnalyse.
  ///
  /// In en, this message translates to:
  /// **'Stop & analyse'**
  String get tajweedStopAnalyse;

  /// No description provided for @tajweedWordAccuracyLabel.
  ///
  /// In en, this message translates to:
  /// **'WORD ACCURACY'**
  String get tajweedWordAccuracyLabel;

  /// No description provided for @tajweedWordReviewLabel.
  ///
  /// In en, this message translates to:
  /// **'WORD REVIEW'**
  String get tajweedWordReviewLabel;

  /// No description provided for @tajweedResultEncouragement.
  ///
  /// In en, this message translates to:
  /// **'Beautiful effort — keep practicing your tajweed.'**
  String get tajweedResultEncouragement;

  /// No description provided for @quranReciteCheckTajweed.
  ///
  /// In en, this message translates to:
  /// **'Recite & check tajweed'**
  String get quranReciteCheckTajweed;

  /// No description provided for @quranTajweedLegendGhunnah.
  ///
  /// In en, this message translates to:
  /// **'Ghunnah'**
  String get quranTajweedLegendGhunnah;

  /// No description provided for @quranTajweedLegendGhunnahDesc.
  ///
  /// In en, this message translates to:
  /// **'Nasal hold, 2 counts'**
  String get quranTajweedLegendGhunnahDesc;

  /// No description provided for @quranTajweedLegendQalqalah.
  ///
  /// In en, this message translates to:
  /// **'Qalqalah'**
  String get quranTajweedLegendQalqalah;

  /// No description provided for @quranTajweedLegendQalqalahDesc.
  ///
  /// In en, this message translates to:
  /// **'Echo bounce'**
  String get quranTajweedLegendQalqalahDesc;

  /// No description provided for @quranTajweedLegendMadd.
  ///
  /// In en, this message translates to:
  /// **'Madd'**
  String get quranTajweedLegendMadd;

  /// No description provided for @quranTajweedLegendMaddDesc.
  ///
  /// In en, this message translates to:
  /// **'Prolong the vowel'**
  String get quranTajweedLegendMaddDesc;

  /// No description provided for @quranTajweedLegendIdgham.
  ///
  /// In en, this message translates to:
  /// **'Idgham'**
  String get quranTajweedLegendIdgham;

  /// No description provided for @quranTajweedLegendIdghamDesc.
  ///
  /// In en, this message translates to:
  /// **'Merge letters'**
  String get quranTajweedLegendIdghamDesc;

  /// No description provided for @quranTajweedLegendIkhfa.
  ///
  /// In en, this message translates to:
  /// **'Ikhfa'**
  String get quranTajweedLegendIkhfa;

  /// No description provided for @quranTajweedLegendIkhfaDesc.
  ///
  /// In en, this message translates to:
  /// **'Hide the noon'**
  String get quranTajweedLegendIkhfaDesc;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @tasbihBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get tasbihBack;

  /// No description provided for @tasbihTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasbih'**
  String get tasbihTabTitle;

  /// No description provided for @tasbihChooseOrAddSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select a dhikr or create your own'**
  String get tasbihChooseOrAddSubtitle;

  /// No description provided for @tasbihAddCustomTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Dhikr'**
  String get tasbihAddCustomTitle;

  /// No description provided for @tasbihEditCustomTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Custom Dhikr'**
  String get tasbihEditCustomTitle;

  /// No description provided for @tasbihArabicOrDhikrHint.
  ///
  /// In en, this message translates to:
  /// **'Arabic text or any dhikr'**
  String get tasbihArabicOrDhikrHint;

  /// No description provided for @tasbihTransliterationOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'Transliteration (optional)'**
  String get tasbihTransliterationOptionalHint;

  /// No description provided for @tasbihMeaningOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'Meaning (optional)'**
  String get tasbihMeaningOptionalHint;

  /// No description provided for @tasbihNoTransliteration.
  ///
  /// In en, this message translates to:
  /// **'No transliteration'**
  String get tasbihNoTransliteration;

  /// No description provided for @tasbihTotalCount.
  ///
  /// In en, this message translates to:
  /// **'Total Count'**
  String get tasbihTotalCount;

  /// No description provided for @tasbihGrandTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Tasbih'**
  String get tasbihGrandTotalLabel;

  /// No description provided for @tasbihTapMe.
  ///
  /// In en, this message translates to:
  /// **'Tap Me'**
  String get tasbihTapMe;

  /// No description provided for @tasbihReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get tasbihReset;

  /// No description provided for @tasbihRestart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get tasbihRestart;

  /// No description provided for @tasbihCurrentCount.
  ///
  /// In en, this message translates to:
  /// **'Current Count'**
  String get tasbihCurrentCount;

  /// No description provided for @tasbihResetTotal.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get tasbihResetTotal;

  /// No description provided for @tasbihLoopLabel.
  ///
  /// In en, this message translates to:
  /// **'Loop {number}'**
  String tasbihLoopLabel(int number);

  /// No description provided for @tasbihCurrentDhikr.
  ///
  /// In en, this message translates to:
  /// **'Current Dhikr'**
  String get tasbihCurrentDhikr;

  /// No description provided for @tasbihViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get tasbihViewAll;

  /// No description provided for @tasbihSaveSession.
  ///
  /// In en, this message translates to:
  /// **'Save session'**
  String get tasbihSaveSession;

  /// No description provided for @tasbihSessionSaved.
  ///
  /// In en, this message translates to:
  /// **'Session saved'**
  String get tasbihSessionSaved;

  /// No description provided for @tasbihSwipeHint.
  ///
  /// In en, this message translates to:
  /// **'Slide beads through the center · reverse to undo'**
  String get tasbihSwipeHint;

  /// No description provided for @tasbihEditGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Set goal'**
  String get tasbihEditGoalTitle;

  /// No description provided for @tasbihCustomGoalHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a number (e.g. 33)'**
  String get tasbihCustomGoalHint;

  /// No description provided for @tasbihSoundOn.
  ///
  /// In en, this message translates to:
  /// **'Sound on'**
  String get tasbihSoundOn;

  /// No description provided for @tasbihSoundOff.
  ///
  /// In en, this message translates to:
  /// **'Sound off'**
  String get tasbihSoundOff;

  /// No description provided for @tasbihSessionSummary.
  ///
  /// In en, this message translates to:
  /// **'Total this session {total} · Goal {goal} · Loops completed {loops}'**
  String tasbihSessionSummary(int total, int goal, int loops);

  /// No description provided for @focusModeActivated.
  ///
  /// In en, this message translates to:
  /// **'Focus Mode Activated'**
  String get focusModeActivated;

  /// No description provided for @focusSetUpHomeCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up Focus mode'**
  String get focusSetUpHomeCardTitle;

  /// No description provided for @focusTabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay focused when it matters most'**
  String get focusTabSubtitle;

  /// No description provided for @focusChooseAppsEnableMode.
  ///
  /// In en, this message translates to:
  /// **'Choose apps and enable focus mode'**
  String get focusChooseAppsEnableMode;

  /// No description provided for @focusNotifAppsLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Apps Locked'**
  String get focusNotifAppsLockedTitle;

  /// No description provided for @focusNotifAppsUnlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Apps Unlocked'**
  String get focusNotifAppsUnlockedTitle;

  /// No description provided for @focusNotifNightModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Night Mode On'**
  String get focusNotifNightModeTitle;

  /// No description provided for @focusNotifGoodMorningTitle.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get focusNotifGoodMorningTitle;

  /// No description provided for @focusNotifAppsNowAvailableBody.
  ///
  /// In en, this message translates to:
  /// **'Apps are now available.'**
  String get focusNotifAppsNowAvailableBody;

  /// No description provided for @focusNotifSalahLockedBody.
  ///
  /// In en, this message translates to:
  /// **'Apps are locked during Salah.'**
  String get focusNotifSalahLockedBody;

  /// No description provided for @focusNotifSalahCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Salah Complete'**
  String get focusNotifSalahCompleteTitle;

  /// No description provided for @focusNotifSalahCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'Apps are now unlocked. May your prayer be accepted.'**
  String get focusNotifSalahCompleteBody;

  /// No description provided for @focusNotifSalahPrayerTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'{prayerName} Time'**
  String focusNotifSalahPrayerTimeTitle(String prayerName);

  /// No description provided for @focusNotifSalahPrayerMomentBody.
  ///
  /// In en, this message translates to:
  /// **'Take a moment for {prayerName} prayer.'**
  String focusNotifSalahPrayerMomentBody(String prayerName);

  /// No description provided for @focusNotifNightLockedBody.
  ///
  /// In en, this message translates to:
  /// **'Night mode is on. Let your mind and body rest.'**
  String get focusNotifNightLockedBody;

  /// No description provided for @focusNotifGenericLockedBody.
  ///
  /// In en, this message translates to:
  /// **'Selected apps are locked.'**
  String get focusNotifGenericLockedBody;

  /// No description provided for @focusNotifMorningUnlockBody.
  ///
  /// In en, this message translates to:
  /// **'Good morning! Apps are now available.'**
  String get focusNotifMorningUnlockBody;

  /// No description provided for @widgetDailyVerseTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Verse'**
  String get widgetDailyVerseTitle;

  /// No description provided for @widgetOpenAppTimelineHint.
  ///
  /// In en, this message translates to:
  /// **'Open Deen Focus to prepare your daily verse and prayer widget data.'**
  String get widgetOpenAppTimelineHint;

  /// No description provided for @widgetSetLocationForPrayers.
  ///
  /// In en, this message translates to:
  /// **'Set your location in Deen Focus to load prayers and the daily verse.'**
  String get widgetSetLocationForPrayers;

  /// No description provided for @widgetPrayerProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Prayer Progress'**
  String get widgetPrayerProgressTitle;

  /// No description provided for @widgetPrayerProgressCount.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total}'**
  String widgetPrayerProgressCount(int completed, int total);

  /// No description provided for @widgetPrayersCompletedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'prayers completed.'**
  String get widgetPrayersCompletedSubtitle;

  /// No description provided for @widgetPrayersLeftToday.
  ///
  /// In en, this message translates to:
  /// **'Keep going — {count} prayers left today'**
  String widgetPrayersLeftToday(int count);

  /// No description provided for @widgetAllPrayersDoneToday.
  ///
  /// In en, this message translates to:
  /// **'Alhamdulillah — all prayers complete today'**
  String get widgetAllPrayersDoneToday;

  /// No description provided for @focusChildModeActive.
  ///
  /// In en, this message translates to:
  /// **'Child Mode Active'**
  String get focusChildModeActive;

  /// No description provided for @focusSalahAndNightModeActive.
  ///
  /// In en, this message translates to:
  /// **'Salah and Night Mode Active'**
  String get focusSalahAndNightModeActive;

  /// No description provided for @focusSalahModeActive.
  ///
  /// In en, this message translates to:
  /// **'Salah Mode Active'**
  String get focusSalahModeActive;

  /// No description provided for @focusNightModeActive.
  ///
  /// In en, this message translates to:
  /// **'Night Mode Active'**
  String get focusNightModeActive;

  /// No description provided for @focusAppsToBlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Apps to Block'**
  String get focusAppsToBlockTitle;

  /// No description provided for @focusAppliesAllModes.
  ///
  /// In en, this message translates to:
  /// **'Applies to all focus modes'**
  String get focusAppliesAllModes;

  /// No description provided for @focusScreenTimeRequiredSelectApps.
  ///
  /// In en, this message translates to:
  /// **'Screen Time access is required to view and select apps.'**
  String get focusScreenTimeRequiredSelectApps;

  /// No description provided for @focusAcceptAccessibilityDisclosure.
  ///
  /// In en, this message translates to:
  /// **'Please accept the accessibility disclosure to continue.'**
  String get focusAcceptAccessibilityDisclosure;

  /// No description provided for @focusSelectAppsToBlock.
  ///
  /// In en, this message translates to:
  /// **'Select apps to block'**
  String get focusSelectAppsToBlock;

  /// No description provided for @focusLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get focusLoading;

  /// No description provided for @focusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get focusOpen;

  /// No description provided for @focusHide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get focusHide;

  /// No description provided for @focusLoad.
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get focusLoad;

  /// No description provided for @focusShow.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get focusShow;

  /// No description provided for @focusSalahFocusModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Salah Focus Mode'**
  String get focusSalahFocusModeTitle;

  /// No description provided for @focusBlockAppsDuringPrayer.
  ///
  /// In en, this message translates to:
  /// **'Block apps during prayer'**
  String get focusBlockAppsDuringPrayer;

  /// No description provided for @focusNightDisciplineTitle.
  ///
  /// In en, this message translates to:
  /// **'Night Discipline'**
  String get focusNightDisciplineTitle;

  /// No description provided for @focusSleepLabel.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get focusSleepLabel;

  /// No description provided for @focusWakeLabel.
  ///
  /// In en, this message translates to:
  /// **'Wake'**
  String get focusWakeLabel;

  /// No description provided for @focusBlockAppsImmediately.
  ///
  /// In en, this message translates to:
  /// **'Block apps immediately'**
  String get focusBlockAppsImmediately;

  /// No description provided for @focusEnableAndroidAppBlocking.
  ///
  /// In en, this message translates to:
  /// **'Enable Android app blocking'**
  String get focusEnableAndroidAppBlocking;

  /// No description provided for @focusEnableAndroidAppBlockingMessage.
  ///
  /// In en, this message translates to:
  /// **'To block other apps on Android, Deenly needs its accessibility permission turned on. We will open the correct settings screen for you.'**
  String get focusEnableAndroidAppBlockingMessage;

  /// No description provided for @focusAccessibilityDisclosureTitle.
  ///
  /// In en, this message translates to:
  /// **'Accessibility permission disclosure'**
  String get focusAccessibilityDisclosureTitle;

  /// No description provided for @focusAccessibilityDisclosureMessage.
  ///
  /// In en, this message translates to:
  /// **'Deenly uses Android Accessibility to enforce Focus mode app blocking.\n\nWhy we need it: to detect when you open an app you selected for blocking.\n\nHow we use it: only to identify the foreground app and show the Focus block screen for selected apps. We do not use it to read typed text or personal content.'**
  String get focusAccessibilityDisclosureMessage;

  /// No description provided for @focusNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get focusNotNow;

  /// No description provided for @focusIUnderstand.
  ///
  /// In en, this message translates to:
  /// **'I understand'**
  String get focusIUnderstand;

  /// No description provided for @focusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get focusDone;

  /// No description provided for @focusNightDisciplineCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Build better night habits'**
  String get focusNightDisciplineCardSubtitle;

  /// No description provided for @focusPrayerBlockingDescription.
  ///
  /// In en, this message translates to:
  /// **'Apps will be blocked during prayer and unlock automatically after 15 minutes, or you can unlock them anytime from the home screen.'**
  String get focusPrayerBlockingDescription;

  /// No description provided for @focusPrayerBlockingDescriptionIos.
  ///
  /// In en, this message translates to:
  /// **'Apps will be blocked during prayer, or you can unlock them anytime from the home screen.'**
  String get focusPrayerBlockingDescriptionIos;

  /// No description provided for @focusNightBlockingDescription.
  ///
  /// In en, this message translates to:
  /// **'Apps will be blocked during your sleep cycle and unlock automatically, or you can unlock them anytime from the home screen'**
  String get focusNightBlockingDescription;

  /// No description provided for @focusChildBlockingDescription.
  ///
  /// In en, this message translates to:
  /// **'Apps are blocked instantly in Child Mode. Unlock them using the toggle or from the home screen'**
  String get focusChildBlockingDescription;

  /// No description provided for @settingsEditUsername.
  ///
  /// In en, this message translates to:
  /// **'Edit Username'**
  String get settingsEditUsername;

  /// No description provided for @settingsEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get settingsEnterYourName;

  /// No description provided for @settingsPremiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Deen Focus Premium'**
  String get settingsPremiumTitle;

  /// No description provided for @settingsPremiumSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock all features'**
  String get settingsPremiumSubtitle;

  /// No description provided for @settingsManageSubscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage subscription'**
  String get settingsManageSubscriptionTitle;

  /// No description provided for @settingsManageSubscriptionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View plan or update billing'**
  String get settingsManageSubscriptionSubtitle;

  /// No description provided for @settingsUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get settingsUsernameLabel;

  /// No description provided for @settingsLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get settingsLocationLabel;

  /// No description provided for @settingsDarkModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingsDarkModeLabel;

  /// No description provided for @settingsAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About Deen Focus'**
  String get settingsAboutTitle;

  /// No description provided for @settingsRateDeenFocus.
  ///
  /// In en, this message translates to:
  /// **'Rate DeenFocus ⭐'**
  String get settingsRateDeenFocus;

  /// No description provided for @settingsContactUsTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get settingsContactUsTitle;

  /// No description provided for @settingsSavingLocation.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get settingsSavingLocation;

  /// No description provided for @settingsSaveLocation.
  ///
  /// In en, this message translates to:
  /// **'Save Location'**
  String get settingsSaveLocation;

  /// No description provided for @settingsAboutTagline.
  ///
  /// In en, this message translates to:
  /// **'Focus. Discipline. Consistency.'**
  String get settingsAboutTagline;

  /// No description provided for @settingsAboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Deen Focus helps you stay connected to your faith while managing daily distractions in a modern world.'**
  String get settingsAboutDescription;

  /// No description provided for @settingsAboutFeature1.
  ///
  /// In en, this message translates to:
  /// **'Prayer times with reminders'**
  String get settingsAboutFeature1;

  /// No description provided for @settingsAboutFeature2.
  ///
  /// In en, this message translates to:
  /// **'Qibla direction anytime'**
  String get settingsAboutFeature2;

  /// No description provided for @settingsAboutFeature3.
  ///
  /// In en, this message translates to:
  /// **'Quran and Tasbih for daily dhikr'**
  String get settingsAboutFeature3;

  /// No description provided for @settingsAboutFeature4.
  ///
  /// In en, this message translates to:
  /// **'Nearby mosques'**
  String get settingsAboutFeature4;

  /// No description provided for @settingsAboutFeature5.
  ///
  /// In en, this message translates to:
  /// **'Smart focus modes for Salah, sleep, and family time'**
  String get settingsAboutFeature5;

  /// No description provided for @settingsAboutFocusDescription.
  ///
  /// In en, this message translates to:
  /// **'Smart focus modes help you block distractions during Salah, sleep, and important moments, so you can stay present and disciplined.'**
  String get settingsAboutFocusDescription;

  /// No description provided for @settingsAboutFooter.
  ///
  /// In en, this message translates to:
  /// **'Stay consistent. Stay mindful. Stay connected to your Deen.'**
  String get settingsAboutFooter;

  /// No description provided for @settingsAboutOffersHeading.
  ///
  /// In en, this message translates to:
  /// **'What Deen Focus offers'**
  String get settingsAboutOffersHeading;

  /// No description provided for @settingsAboutNewBadge.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get settingsAboutNewBadge;

  /// No description provided for @settingsAboutFooterCard.
  ///
  /// In en, this message translates to:
  /// **'Smart tools to help you stay mindful, consistent, and connected to your Deen — every day.'**
  String get settingsAboutFooterCard;

  /// No description provided for @settingsAboutOfferPrayerTimesTitle.
  ///
  /// In en, this message translates to:
  /// **'Accurate Prayer Times'**
  String get settingsAboutOfferPrayerTimesTitle;

  /// No description provided for @settingsAboutOfferPrayerTimesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Timely prayer alerts and beautiful widgets to keep you on track.'**
  String get settingsAboutOfferPrayerTimesSubtitle;

  /// No description provided for @settingsAboutOfferPrayerStreaksTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Streaks'**
  String get settingsAboutOfferPrayerStreaksTitle;

  /// No description provided for @settingsAboutOfferPrayerStreaksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Build consistency and grow in your Deen with daily and overall streak tracking.'**
  String get settingsAboutOfferPrayerStreaksSubtitle;

  /// No description provided for @settingsAboutOfferCycleModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Cycle Mode'**
  String get settingsAboutOfferCycleModeTitle;

  /// No description provided for @settingsAboutOfferCycleModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For menstruation — pause prayers, keep your streak, and maintain your journey.'**
  String get settingsAboutOfferCycleModeSubtitle;

  /// No description provided for @settingsAboutOfferQuranTajweedTitle.
  ///
  /// In en, this message translates to:
  /// **'Al Quran Tajweed'**
  String get settingsAboutOfferQuranTajweedTitle;

  /// No description provided for @settingsAboutOfferQuranTajweedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read, listen, and practice Tajweed with our AI-powered real-time feedback.'**
  String get settingsAboutOfferQuranTajweedSubtitle;

  /// No description provided for @settingsAboutOfferLiveActivitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Activities'**
  String get settingsAboutOfferLiveActivitiesTitle;

  /// No description provided for @settingsAboutOfferLiveActivitiesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay updated with ongoing prayers and focus sessions right from your Lock Screen.'**
  String get settingsAboutOfferLiveActivitiesSubtitle;

  /// No description provided for @settingsAboutOfferQiblaTitle.
  ///
  /// In en, this message translates to:
  /// **'Qibla & Masjid Finder'**
  String get settingsAboutOfferQiblaTitle;

  /// No description provided for @settingsAboutOfferQiblaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find Qibla direction anytime and discover nearby mosques wherever you are.'**
  String get settingsAboutOfferQiblaSubtitle;

  /// No description provided for @settingsAboutOfferFocusModesTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus Modes'**
  String get settingsAboutOfferFocusModesTitle;

  /// No description provided for @settingsAboutOfferFocusModesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Block distracting apps during Salah, sleep, study, or family time.'**
  String get settingsAboutOfferFocusModesSubtitle;

  /// No description provided for @settingsAboutOfferTasbihTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasbih & Dhikr'**
  String get settingsAboutOfferTasbihTitle;

  /// No description provided for @settingsAboutOfferTasbihSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Digital Tasbih to help you remember Allah throughout the day.'**
  String get settingsAboutOfferTasbihSubtitle;

  /// No description provided for @settingsAboutOfferCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Islamic Calendar'**
  String get settingsAboutOfferCalendarTitle;

  /// No description provided for @settingsAboutOfferCalendarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hijri calendar with important Islamic dates and reminders.'**
  String get settingsAboutOfferCalendarSubtitle;

  /// No description provided for @settingsAboutGridNamesTitle.
  ///
  /// In en, this message translates to:
  /// **'99 Names of Allah'**
  String get settingsAboutGridNamesTitle;

  /// No description provided for @settingsAboutGridNamesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn and reflect on Asma ul-Husna.'**
  String get settingsAboutGridNamesSubtitle;

  /// No description provided for @settingsAboutGridDuasTitle.
  ///
  /// In en, this message translates to:
  /// **'Duas & Adhkar'**
  String get settingsAboutGridDuasTitle;

  /// No description provided for @settingsAboutGridDuasSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Morning, evening and daily duas.'**
  String get settingsAboutGridDuasSubtitle;

  /// No description provided for @settingsAboutGridPrayerTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer & Methods'**
  String get settingsAboutGridPrayerTitle;

  /// No description provided for @settingsAboutGridPrayerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn Salah, Wudu, Hajj and more.'**
  String get settingsAboutGridPrayerSubtitle;

  /// No description provided for @settingsAboutGridFiqhTitle.
  ///
  /// In en, this message translates to:
  /// **'Fiqh & Traditions'**
  String get settingsAboutGridFiqhTitle;

  /// No description provided for @settingsAboutGridFiqhSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore authentic Islamic knowledge.'**
  String get settingsAboutGridFiqhSubtitle;

  /// No description provided for @settingsEnableSystemNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable system notifications to turn this on.'**
  String get settingsEnableSystemNotifications;

  /// No description provided for @appDemoTitle.
  ///
  /// In en, this message translates to:
  /// **'App Demo'**
  String get appDemoTitle;

  /// No description provided for @appDemoLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load the demo video.'**
  String get appDemoLoadFailed;

  /// No description provided for @appDemoRestartHint.
  ///
  /// In en, this message translates to:
  /// **'Video needs a full app restart (hot restart can break playback).'**
  String get appDemoRestartHint;

  /// No description provided for @appDemoPreviewLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load the demo.'**
  String get appDemoPreviewLoadFailed;

  /// No description provided for @appDemoTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get appDemoTryAgain;

  /// No description provided for @appDemoWatchLabel.
  ///
  /// In en, this message translates to:
  /// **'Watch demo'**
  String get appDemoWatchLabel;

  /// No description provided for @homeAiChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Deen Focus AI'**
  String get homeAiChatTitle;

  /// No description provided for @homeAiAskQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'Ask a question...'**
  String get homeAiAskQuestionHint;

  /// No description provided for @homeAiSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get homeAiSend;

  /// No description provided for @homeAiErrorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Sorry, I ran into an issue while connecting to Deen Focus AI.'**
  String get homeAiErrorPrefix;

  /// No description provided for @homeAiEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask anything about Islam'**
  String get homeAiEmptyTitle;

  /// No description provided for @homeAiEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer times, Quran, Hadith, Islamic events, and spiritual guidance'**
  String get homeAiEmptySubtitle;

  /// No description provided for @onboardingTypeCityName.
  ///
  /// In en, this message translates to:
  /// **'Type your city name..'**
  String get onboardingTypeCityName;

  /// No description provided for @onboardingNoLocationsFound.
  ///
  /// In en, this message translates to:
  /// **'No locations found'**
  String get onboardingNoLocationsFound;

  /// No description provided for @onboardingTryAnotherCityName.
  ///
  /// In en, this message translates to:
  /// **'Try another city name.'**
  String get onboardingTryAnotherCityName;

  /// No description provided for @qiblaCompassUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Compass unavailable on this device'**
  String get qiblaCompassUnavailable;

  /// No description provided for @qiblaFacing.
  ///
  /// In en, this message translates to:
  /// **'✓ Facing Qibla'**
  String get qiblaFacing;

  /// No description provided for @qiblaTurnToFind.
  ///
  /// In en, this message translates to:
  /// **'Turn to find Qibla'**
  String get qiblaTurnToFind;

  /// No description provided for @qiblaDistanceToMakkah.
  ///
  /// In en, this message translates to:
  /// **'Distance to Makkah'**
  String get qiblaDistanceToMakkah;

  /// No description provided for @qiblaFromNorth.
  ///
  /// In en, this message translates to:
  /// **'from North'**
  String get qiblaFromNorth;

  /// No description provided for @qiblaNorthShort.
  ///
  /// In en, this message translates to:
  /// **'N'**
  String get qiblaNorthShort;

  /// No description provided for @qiblaSouthShort.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get qiblaSouthShort;

  /// No description provided for @qiblaEastShort.
  ///
  /// In en, this message translates to:
  /// **'E'**
  String get qiblaEastShort;

  /// No description provided for @qiblaWestShort.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get qiblaWestShort;

  /// No description provided for @nearbyMosquesTitle.
  ///
  /// In en, this message translates to:
  /// **'Mosques found nearby'**
  String get nearbyMosquesTitle;

  /// No description provided for @nearbyMosquesTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get nearbyMosquesTryAgain;

  /// No description provided for @nearbyMosquesOpenGoogle.
  ///
  /// In en, this message translates to:
  /// **'Open in Google Maps'**
  String get nearbyMosquesOpenGoogle;

  /// No description provided for @nearbyMosquesOpenApple.
  ///
  /// In en, this message translates to:
  /// **'Open in Apple Maps'**
  String get nearbyMosquesOpenApple;

  /// No description provided for @nearbyMosquesNoMosquesFoundWithin.
  ///
  /// In en, this message translates to:
  /// **'No mosques found within'**
  String get nearbyMosquesNoMosquesFoundWithin;

  /// No description provided for @nearbyMosquesSearchRadius.
  ///
  /// In en, this message translates to:
  /// **'Search radius: {radiusKm} km'**
  String nearbyMosquesSearchRadius(int radiusKm);

  /// No description provided for @nearbyMosquesMapPreviewUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Map preview unavailable right now.'**
  String get nearbyMosquesMapPreviewUnavailable;

  /// No description provided for @nearbyMosquesWaitingForLocation.
  ///
  /// In en, this message translates to:
  /// **'Waiting for your location.'**
  String get nearbyMosquesWaitingForLocation;

  /// No description provided for @nearbyMosquesFetchingLocation.
  ///
  /// In en, this message translates to:
  /// **'Fetching your location…'**
  String get nearbyMosquesFetchingLocation;

  /// No description provided for @nearbyMosquesCurrentLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Current location'**
  String get nearbyMosquesCurrentLocationLabel;

  /// No description provided for @nearbyMosquesAppearAfterLoad.
  ///
  /// In en, this message translates to:
  /// **'Nearby mosques will appear here once results load.'**
  String get nearbyMosquesAppearAfterLoad;

  /// No description provided for @nearbyMosquesNoneWithinRadius.
  ///
  /// In en, this message translates to:
  /// **'No mosques found within {radiusKm} km'**
  String nearbyMosquesNoneWithinRadius(int radiusKm);

  /// No description provided for @nearbyMosquesLocationRequired.
  ///
  /// In en, this message translates to:
  /// **'Location access is required to find nearby mosques.'**
  String get nearbyMosquesLocationRequired;

  /// No description provided for @nearbyMosquesPermissionOff.
  ///
  /// In en, this message translates to:
  /// **'Location permission is turned off. Enable it in settings to see nearby mosques.'**
  String get nearbyMosquesPermissionOff;

  /// No description provided for @nearbyMosquesLocationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'We could not read your current location right now.'**
  String get nearbyMosquesLocationUnavailable;

  /// No description provided for @nearbyMosquesLiveUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Live update failed. Showing last saved results. Pull to refresh.'**
  String get nearbyMosquesLiveUpdateFailed;

  /// No description provided for @nearbyMosquesPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location access was denied. Enable it in Settings to see nearby mosques.'**
  String get nearbyMosquesPermissionDenied;

  /// No description provided for @nearbyMosquesLocationTurnedOff.
  ///
  /// In en, this message translates to:
  /// **'Location is turned off on this device. Turn it on in Settings, then try again.'**
  String get nearbyMosquesLocationTurnedOff;

  /// No description provided for @nearbyMosquesPermissionProcessing.
  ///
  /// In en, this message translates to:
  /// **'Location permission is still being processed. Please try again in a moment.'**
  String get nearbyMosquesPermissionProcessing;

  /// No description provided for @nearbyMosquesRequestTimeout.
  ///
  /// In en, this message translates to:
  /// **'The request took too long. Check your internet connection and try again.'**
  String get nearbyMosquesRequestTimeout;

  /// No description provided for @nearbyMosquesOfflineOrUnreachable.
  ///
  /// In en, this message translates to:
  /// **'No internet connection or the service is unreachable. Check your connection and try again.'**
  String get nearbyMosquesOfflineOrUnreachable;

  /// No description provided for @nearbyMosquesFormatError.
  ///
  /// In en, this message translates to:
  /// **'We could not read the mosque list right now. Please try again later.'**
  String get nearbyMosquesFormatError;

  /// No description provided for @nearbyMosquesPlatformError.
  ///
  /// In en, this message translates to:
  /// **'We could not complete that step. Check your connection and try again.'**
  String get nearbyMosquesPlatformError;

  /// No description provided for @nearbyMosquesSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get nearbyMosquesSomethingWentWrong;

  /// No description provided for @nearbyMosquesEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Nothing listed within {radiusKm} km on OpenStreetMap for this spot. Try again later or move farther.'**
  String nearbyMosquesEmptyHint(int radiusKm);

  /// No description provided for @nearbyMosquesFoundWithin.
  ///
  /// In en, this message translates to:
  /// **'{count} mosques found within {radiusKm} km'**
  String nearbyMosquesFoundWithin(int count, int radiusKm);

  /// No description provided for @nearbyMosquesCountNearby.
  ///
  /// In en, this message translates to:
  /// **'{count} mosques nearby'**
  String nearbyMosquesCountNearby(int count);

  /// No description provided for @nearbyMosquesResultsMeta.
  ///
  /// In en, this message translates to:
  /// **'Within {radiusKm} km · Sorted by distance'**
  String nearbyMosquesResultsMeta(int radiusKm);

  /// No description provided for @nearbyMosquesDirections.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get nearbyMosquesDirections;

  /// No description provided for @nearbyMosquesDenominationSunni.
  ///
  /// In en, this message translates to:
  /// **'Sunni'**
  String get nearbyMosquesDenominationSunni;

  /// No description provided for @nearbyMosquesDenominationShia.
  ///
  /// In en, this message translates to:
  /// **'Shia'**
  String get nearbyMosquesDenominationShia;

  /// No description provided for @nearbyMosquesDenominationAhlEHadith.
  ///
  /// In en, this message translates to:
  /// **'Ahl-e-Hadith'**
  String get nearbyMosquesDenominationAhlEHadith;

  /// No description provided for @nearbyMosquesDenominationNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Denomination not specified'**
  String get nearbyMosquesDenominationNotSpecified;

  /// No description provided for @tasbihDeleteDhikrTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete dhikr?'**
  String get tasbihDeleteDhikrTitle;

  /// No description provided for @tasbihDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get tasbihDelete;

  /// No description provided for @focusAndroidBlockingNotReady.
  ///
  /// In en, this message translates to:
  /// **'Android app blocking is still getting ready. Keep accessibility enabled and give it a moment to connect.'**
  String get focusAndroidBlockingNotReady;

  /// No description provided for @focusNoAppsSelectedSnack.
  ///
  /// In en, this message translates to:
  /// **'No apps selected. Please select apps to block first.'**
  String get focusNoAppsSelectedSnack;

  /// No description provided for @focusDiagnosticButton.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic'**
  String get focusDiagnosticButton;

  /// No description provided for @focusDiagnosticTitle.
  ///
  /// In en, this message translates to:
  /// **'Test App Lock'**
  String get focusDiagnosticTitle;

  /// No description provided for @focusDiagnosticIntro.
  ///
  /// In en, this message translates to:
  /// **'Temporarily lock your selected apps for 60 seconds using the same App Lock used by Focus mode. Open a blocked app to confirm the DeenFocus lock screen appears.'**
  String get focusDiagnosticIntro;

  /// No description provided for @focusDiagnosticIntroWithApp.
  ///
  /// In en, this message translates to:
  /// **'Temporarily lock your selected apps for 60 seconds. Try opening {appName} to confirm the DeenFocus lock screen appears.'**
  String focusDiagnosticIntroWithApp(String appName);

  /// No description provided for @focusDiagnosticStart.
  ///
  /// In en, this message translates to:
  /// **'Start Test'**
  String get focusDiagnosticStart;

  /// No description provided for @focusDiagnosticEndEarly.
  ///
  /// In en, this message translates to:
  /// **'End Test'**
  String get focusDiagnosticEndEarly;

  /// No description provided for @focusDiagnosticRunning.
  ///
  /// In en, this message translates to:
  /// **'App Lock is on for {seconds}s. Switch to a selected app to test the lock screen.'**
  String focusDiagnosticRunning(int seconds);

  /// No description provided for @focusDiagnosticSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Test completed'**
  String get focusDiagnosticSuccessTitle;

  /// No description provided for @focusDiagnosticSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'App Lock was activated with your selected apps. If you saw the DeenFocus lock screen, App Lock is working.'**
  String get focusDiagnosticSuccessBody;

  /// No description provided for @focusDiagnosticCancelledTitle.
  ///
  /// In en, this message translates to:
  /// **'Test ended'**
  String get focusDiagnosticCancelledTitle;

  /// No description provided for @focusDiagnosticCancelledBody.
  ///
  /// In en, this message translates to:
  /// **'The diagnostic lock was turned off. Your Focus modes and schedules were not changed.'**
  String get focusDiagnosticCancelledBody;

  /// No description provided for @focusDiagnosticMissingAppsTitle.
  ///
  /// In en, this message translates to:
  /// **'Select apps first'**
  String get focusDiagnosticMissingAppsTitle;

  /// No description provided for @focusDiagnosticMissingAppsBody.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one app to block before running the App Lock test.'**
  String get focusDiagnosticMissingAppsBody;

  /// No description provided for @focusDiagnosticMissingPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission needed'**
  String get focusDiagnosticMissingPermissionTitle;

  /// No description provided for @focusDiagnosticMissingPermissionBodyIos.
  ///
  /// In en, this message translates to:
  /// **'Screen Time access is required to block apps. Allow Screen Time, then try again.'**
  String get focusDiagnosticMissingPermissionBodyIos;

  /// No description provided for @focusDiagnosticMissingPermissionBodyAndroid.
  ///
  /// In en, this message translates to:
  /// **'Android Accessibility must be enabled for DeenFocus so App Lock can block selected apps.'**
  String get focusDiagnosticMissingPermissionBodyAndroid;

  /// No description provided for @focusDiagnosticFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not start test'**
  String get focusDiagnosticFailedTitle;

  /// No description provided for @focusDiagnosticFailedBody.
  ///
  /// In en, this message translates to:
  /// **'App Lock did not activate. Check permissions and selected apps, then try again.'**
  String get focusDiagnosticFailedBody;

  /// No description provided for @focusDiagnosticClose.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get focusDiagnosticClose;

  /// No description provided for @focusScreenTimeRequiredBlockIphone.
  ///
  /// In en, this message translates to:
  /// **'Screen Time access is required to block apps on iPhone.'**
  String get focusScreenTimeRequiredBlockIphone;

  /// No description provided for @focusModeUpdateFailedSnack.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while updating Focus mode. Please try again.'**
  String get focusModeUpdateFailedSnack;

  /// No description provided for @focusLoadingInstalledApps.
  ///
  /// In en, this message translates to:
  /// **'Loading installed apps...'**
  String get focusLoadingInstalledApps;

  /// No description provided for @focusNoInstalledAppsToShow.
  ///
  /// In en, this message translates to:
  /// **'No installed apps available to show.'**
  String get focusNoInstalledAppsToShow;

  /// No description provided for @homeAiSuggestion1.
  ///
  /// In en, this message translates to:
  /// **'What is Ramadan?'**
  String get homeAiSuggestion1;

  /// No description provided for @homeAiSuggestion2.
  ///
  /// In en, this message translates to:
  /// **'Prayer times'**
  String get homeAiSuggestion2;

  /// No description provided for @homeAiSuggestion3.
  ///
  /// In en, this message translates to:
  /// **'Quran reading plan'**
  String get homeAiSuggestion3;

  /// No description provided for @homeAiDeveloperPrompt.
  ///
  /// In en, this message translates to:
  /// **'You are a knowledgeable and respectful Islamic scholar assistant. Help users learn about Islamic traditions, holidays, prayers, Quran study, and spiritual practices. Be warm, concise, educational, and culturally sensitive. If the user asks something outside Islamic guidance, answer helpfully without pretending religious certainty.'**
  String get homeAiDeveloperPrompt;

  /// No description provided for @homeAiErrorMissingApiKey.
  ///
  /// In en, this message translates to:
  /// **'Missing API configuration.'**
  String get homeAiErrorMissingApiKey;

  /// No description provided for @homeAiErrorApi.
  ///
  /// In en, this message translates to:
  /// **'API error {statusCode}: {detail}'**
  String homeAiErrorApi(String statusCode, String detail);

  /// No description provided for @homeAiErrorEmptyResponse.
  ///
  /// In en, this message translates to:
  /// **'No response returned from the assistant.'**
  String get homeAiErrorEmptyResponse;

  /// No description provided for @homeAiErrorEmptyContent.
  ///
  /// In en, this message translates to:
  /// **'Empty response content.'**
  String get homeAiErrorEmptyContent;

  /// No description provided for @settingsPrayerCalculationSection.
  ///
  /// In en, this message translates to:
  /// **'Prayer Calculation'**
  String get settingsPrayerCalculationSection;

  /// No description provided for @settingsCalculationMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Calculation Method'**
  String get settingsCalculationMethodTitle;

  /// No description provided for @settingsAsrCalculationTitle.
  ///
  /// In en, this message translates to:
  /// **'Asr Calculation'**
  String get settingsAsrCalculationTitle;

  /// No description provided for @calculationMethodSectionMajorOrgs.
  ///
  /// In en, this message translates to:
  /// **'Major Islamic Organizations'**
  String get calculationMethodSectionMajorOrgs;

  /// No description provided for @calculationMethodSectionMiddleEast.
  ///
  /// In en, this message translates to:
  /// **'Middle East'**
  String get calculationMethodSectionMiddleEast;

  /// No description provided for @calculationMethodSectionAsiaPacific.
  ///
  /// In en, this message translates to:
  /// **'Asia Pacific'**
  String get calculationMethodSectionAsiaPacific;

  /// No description provided for @calculationMethodSectionSpecial.
  ///
  /// In en, this message translates to:
  /// **'Special Methods'**
  String get calculationMethodSectionSpecial;

  /// No description provided for @asrMethodStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get asrMethodStandard;

  /// No description provided for @asrMethodStandardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shafi, Maliki, Hanbali'**
  String get asrMethodStandardSubtitle;

  /// No description provided for @asrMethodHanafi.
  ///
  /// In en, this message translates to:
  /// **'Hanafi'**
  String get asrMethodHanafi;

  /// No description provided for @homeLocationChangedTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Changed'**
  String get homeLocationChangedTitle;

  /// No description provided for @homeLocationChangedMessage.
  ///
  /// In en, this message translates to:
  /// **'You appear to be in {city}. Update your prayer location for accurate times?'**
  String homeLocationChangedMessage(String city);

  /// No description provided for @homeLocationChangedNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get homeLocationChangedNotNow;

  /// No description provided for @homeLocationChangedUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get homeLocationChangedUpdate;

  /// No description provided for @homeYourNewLocation.
  ///
  /// In en, this message translates to:
  /// **'your new location'**
  String get homeYourNewLocation;

  /// No description provided for @insightsPrayerStreak.
  ///
  /// In en, this message translates to:
  /// **'Prayer count'**
  String get insightsPrayerStreak;

  /// No description provided for @insightsPrayerStreakCount.
  ///
  /// In en, this message translates to:
  /// **'{count} prayers'**
  String insightsPrayerStreakCount(int count);

  /// No description provided for @insightsPrayersInARow.
  ///
  /// In en, this message translates to:
  /// **'Completed prayers'**
  String get insightsPrayersInARow;

  /// No description provided for @insightsDaysInARow.
  ///
  /// In en, this message translates to:
  /// **'Days in a row'**
  String get insightsDaysInARow;

  /// No description provided for @insightsChipUpToday.
  ///
  /// In en, this message translates to:
  /// **'↑ {count}'**
  String insightsChipUpToday(int count);

  /// No description provided for @insightsChipDayUp.
  ///
  /// In en, this message translates to:
  /// **'↑ 1 today'**
  String get insightsChipDayUp;

  /// No description provided for @insightsWeeklyCompletion.
  ///
  /// In en, this message translates to:
  /// **'Weekly completion'**
  String get insightsWeeklyCompletion;

  /// No description provided for @insightsMonthlyCompletion.
  ///
  /// In en, this message translates to:
  /// **'Monthly completion'**
  String get insightsMonthlyCompletion;

  /// No description provided for @insightsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get insightsThisWeek;

  /// No description provided for @insightsThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get insightsThisMonth;

  /// No description provided for @insightsOverall.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get insightsOverall;

  /// No description provided for @insightsRateExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get insightsRateExcellent;

  /// No description provided for @insightsRateGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get insightsRateGood;

  /// No description provided for @insightsRateFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get insightsRateFair;

  /// No description provided for @insightsRateStart.
  ///
  /// In en, this message translates to:
  /// **'Keep going'**
  String get insightsRateStart;

  /// No description provided for @insightsPrayersCompletedWeekly.
  ///
  /// In en, this message translates to:
  /// **'Prayers completed (weekly)'**
  String get insightsPrayersCompletedWeekly;

  /// No description provided for @insightsPrayersCompletedMonthly.
  ///
  /// In en, this message translates to:
  /// **'Prayers completed (monthly)'**
  String get insightsPrayersCompletedMonthly;

  /// No description provided for @insightsCompletionSummary.
  ///
  /// In en, this message translates to:
  /// **'You completed {done} out of {possible} prayers.\nAlhamdulillah — keep going!'**
  String insightsCompletionSummary(int done, int possible);

  /// No description provided for @insightsFocusExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent — keep it up!'**
  String get insightsFocusExcellent;

  /// No description provided for @insightsFocusKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep building your focus'**
  String get insightsFocusKeepGoing;

  /// No description provided for @insightsTodaysPrayers.
  ///
  /// In en, this message translates to:
  /// **'Today\'s prayers'**
  String get insightsTodaysPrayers;

  /// No description provided for @insightsPrayersCompletedLabel.
  ///
  /// In en, this message translates to:
  /// **'Prayers completed — Alhamdulillah!'**
  String get insightsPrayersCompletedLabel;

  /// No description provided for @insightsCycleModeActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Cycle mode active'**
  String get insightsCycleModeActiveLabel;

  /// No description provided for @insightsProtectedByCycleMode.
  ///
  /// In en, this message translates to:
  /// **'Your streak is protected.'**
  String get insightsProtectedByCycleMode;

  /// No description provided for @insightsCurrentPrayerStreak.
  ///
  /// In en, this message translates to:
  /// **'Current prayer count'**
  String get insightsCurrentPrayerStreak;

  /// No description provided for @insightsBestPrayerStreak.
  ///
  /// In en, this message translates to:
  /// **'Best prayer streak'**
  String get insightsBestPrayerStreak;

  /// No description provided for @insightsCurrentDayStreak.
  ///
  /// In en, this message translates to:
  /// **'Current day streak'**
  String get insightsCurrentDayStreak;

  /// No description provided for @insightsCycleProtectedDays.
  ///
  /// In en, this message translates to:
  /// **'Cycle protected days'**
  String get insightsCycleProtectedDays;

  /// No description provided for @insightsAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get insightsAchievements;

  /// No description provided for @insightsAchieved.
  ///
  /// In en, this message translates to:
  /// **'Achieved'**
  String get insightsAchieved;

  /// No description provided for @insightsMyProgress.
  ///
  /// In en, this message translates to:
  /// **'My progress'**
  String get insightsMyProgress;

  /// No description provided for @insightsLevelNumber.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String insightsLevelNumber(int level);

  /// No description provided for @insightsXpProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} / {next} XP'**
  String insightsXpProgress(String current, String next);

  /// No description provided for @insightsXpTotal.
  ///
  /// In en, this message translates to:
  /// **'{xp} XP'**
  String insightsXpTotal(String xp);

  /// No description provided for @insightsXpToNext.
  ///
  /// In en, this message translates to:
  /// **'{xp} XP to Level {level}'**
  String insightsXpToNext(String xp, int level);

  /// No description provided for @insightsMaxLevel.
  ///
  /// In en, this message translates to:
  /// **'MAX LEVEL'**
  String get insightsMaxLevel;

  /// No description provided for @insightsAchievementsUnlocked.
  ///
  /// In en, this message translates to:
  /// **'{unlocked} / {total} unlocked'**
  String insightsAchievementsUnlocked(int unlocked, int total);

  /// No description provided for @insightsAchievementUnlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievement Unlocked'**
  String get insightsAchievementUnlockedTitle;

  /// No description provided for @insightsLevelUpTitle.
  ///
  /// In en, this message translates to:
  /// **'LEVEL UP'**
  String get insightsLevelUpTitle;

  /// No description provided for @achievementFirstPrayer.
  ///
  /// In en, this message translates to:
  /// **'First Prayer'**
  String get achievementFirstPrayer;

  /// No description provided for @achievementFajrChampion.
  ///
  /// In en, this message translates to:
  /// **'Fajr Champion'**
  String get achievementFajrChampion;

  /// No description provided for @achievementFiveADay.
  ///
  /// In en, this message translates to:
  /// **'Five-a-Day'**
  String get achievementFiveADay;

  /// No description provided for @achievementPerfectWeek.
  ///
  /// In en, this message translates to:
  /// **'Perfect Week'**
  String get achievementPerfectWeek;

  /// No description provided for @achievementPerfectMonth.
  ///
  /// In en, this message translates to:
  /// **'Perfect Month'**
  String get achievementPerfectMonth;

  /// No description provided for @achievementQuranDevotee.
  ///
  /// In en, this message translates to:
  /// **'Quran Devotee'**
  String get achievementQuranDevotee;

  /// No description provided for @achievementDhikrStarter.
  ///
  /// In en, this message translates to:
  /// **'Dhikr Starter'**
  String get achievementDhikrStarter;

  /// No description provided for @achievementNightWorshipper.
  ///
  /// In en, this message translates to:
  /// **'Night Worshipper'**
  String get achievementNightWorshipper;

  /// No description provided for @achievementMasjidCompanion.
  ///
  /// In en, this message translates to:
  /// **'Masjid Companion'**
  String get achievementMasjidCompanion;

  /// No description provided for @achievementDistractionDefender.
  ///
  /// In en, this message translates to:
  /// **'Distraction Defender'**
  String get achievementDistractionDefender;

  /// No description provided for @achievementCycleGuardian.
  ///
  /// In en, this message translates to:
  /// **'Cycle Guardian'**
  String get achievementCycleGuardian;

  /// No description provided for @achievementProtectedMonth.
  ///
  /// In en, this message translates to:
  /// **'Protected Month'**
  String get achievementProtectedMonth;

  /// No description provided for @achievementSixMonthJourney.
  ///
  /// In en, this message translates to:
  /// **'Six-Month Journey'**
  String get achievementSixMonthJourney;

  /// No description provided for @achievementDeenFocusMaster.
  ///
  /// In en, this message translates to:
  /// **'DeenFocus Master'**
  String get achievementDeenFocusMaster;

  /// No description provided for @insightsCycleModeFooter.
  ///
  /// In en, this message translates to:
  /// **'Cycle Mode days are protected and not counted as streak breaks. You have {days} protected day(s) available.'**
  String insightsCycleModeFooter(int days);

  /// No description provided for @insightsCycleModeFooterOff.
  ///
  /// In en, this message translates to:
  /// **'Enable Cycle Mode to protect your streak during rest days.'**
  String get insightsCycleModeFooterOff;

  /// No description provided for @achievementFirstPrayerStreak.
  ///
  /// In en, this message translates to:
  /// **'First Prayer'**
  String get achievementFirstPrayerStreak;

  /// No description provided for @achievementSevenPrayerStreak.
  ///
  /// In en, this message translates to:
  /// **'Seven Prayer Streak'**
  String get achievementSevenPrayerStreak;

  /// No description provided for @achievementThirtyPrayerStreak.
  ///
  /// In en, this message translates to:
  /// **'Thirty Prayer Streak'**
  String get achievementThirtyPrayerStreak;

  /// No description provided for @achievementFajrWarrior.
  ///
  /// In en, this message translates to:
  /// **'Fajr Warrior'**
  String get achievementFajrWarrior;

  /// No description provided for @achievementQuranReader.
  ///
  /// In en, this message translates to:
  /// **'Quran Reader'**
  String get achievementQuranReader;

  /// No description provided for @achievementDhikrMaster.
  ///
  /// In en, this message translates to:
  /// **'Dhikr Master'**
  String get achievementDhikrMaster;

  /// No description provided for @achievementConsistencyChampion.
  ///
  /// In en, this message translates to:
  /// **'Consistency Champion'**
  String get achievementConsistencyChampion;

  /// No description provided for @prayerCompletionAlhamdulillah.
  ///
  /// In en, this message translates to:
  /// **'Alhamdulillah!'**
  String get prayerCompletionAlhamdulillah;

  /// No description provided for @prayerCompletionCompleted.
  ///
  /// In en, this message translates to:
  /// **'{prayer} has been completed'**
  String prayerCompletionCompleted(String prayer);

  /// No description provided for @prayerCompletionStreakIncreased.
  ///
  /// In en, this message translates to:
  /// **'Your prayer count has increased'**
  String get prayerCompletionStreakIncreased;

  /// No description provided for @prayerCompletionKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Every prayer brings you closer to Allah. Keep going!'**
  String get prayerCompletionKeepGoing;

  /// No description provided for @prayerCompletionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get prayerCompletionContinue;

  /// No description provided for @prayerCompletionNextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Next prayer in {when}'**
  String prayerCompletionNextPrayer(String when);

  /// No description provided for @prayerCompletionMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes'**
  String prayerCompletionMinutes(int minutes);

  /// No description provided for @prayerCompletionHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String prayerCompletionHoursMinutes(int hours, int minutes);

  /// No description provided for @weekdayLetterMon.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get weekdayLetterMon;

  /// No description provided for @weekdayLetterTue.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get weekdayLetterTue;

  /// No description provided for @weekdayLetterWed.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get weekdayLetterWed;

  /// No description provided for @weekdayLetterThu.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get weekdayLetterThu;

  /// No description provided for @weekdayLetterFri.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get weekdayLetterFri;

  /// No description provided for @weekdayLetterSat.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get weekdayLetterSat;

  /// No description provided for @weekdayLetterSun.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get weekdayLetterSun;

  /// No description provided for @focusHomeBlockingNightAndSalah.
  ///
  /// In en, this message translates to:
  /// **'Night Discipline and Salah mode are blocking selected apps.'**
  String get focusHomeBlockingNightAndSalah;

  /// No description provided for @focusHomeBlockingNight.
  ///
  /// In en, this message translates to:
  /// **'Night Discipline is blocking selected apps.'**
  String get focusHomeBlockingNight;

  /// No description provided for @focusHomeBlockingSalah.
  ///
  /// In en, this message translates to:
  /// **'Salah mode is blocking selected apps.'**
  String get focusHomeBlockingSalah;

  /// No description provided for @focusHomeAppsBlockedNow.
  ///
  /// In en, this message translates to:
  /// **'Selected apps are blocked right now.'**
  String get focusHomeAppsBlockedNow;

  /// No description provided for @focusHomeModeEnabled.
  ///
  /// In en, this message translates to:
  /// **'{mode} is enabled.'**
  String focusHomeModeEnabled(String mode);

  /// No description provided for @focusHomeModesEnabled.
  ///
  /// In en, this message translates to:
  /// **'{modes} are enabled.'**
  String focusHomeModesEnabled(String modes);

  /// No description provided for @focusHomeChooseMode.
  ///
  /// In en, this message translates to:
  /// **'Choose a mode to protect your attention.'**
  String get focusHomeChooseMode;

  /// No description provided for @focusStatusSelectApps.
  ///
  /// In en, this message translates to:
  /// **'Select apps to start'**
  String get focusStatusSelectApps;

  /// No description provided for @focusStatusBlockingNightAndSalah.
  ///
  /// In en, this message translates to:
  /// **'Night Discipline and Salah mode are blocking apps now'**
  String get focusStatusBlockingNightAndSalah;

  /// No description provided for @focusStatusBlockingNight.
  ///
  /// In en, this message translates to:
  /// **'Night Discipline is blocking apps now'**
  String get focusStatusBlockingNight;

  /// No description provided for @focusStatusBlockingSalah.
  ///
  /// In en, this message translates to:
  /// **'Salah mode is blocking apps now'**
  String get focusStatusBlockingSalah;

  /// No description provided for @focusStatusAppsLocked.
  ///
  /// In en, this message translates to:
  /// **'Apps are locked now'**
  String get focusStatusAppsLocked;

  /// No description provided for @focusStatusUnlockedUntil.
  ///
  /// In en, this message translates to:
  /// **'Unlocked until {time}'**
  String focusStatusUnlockedUntil(String time);

  /// No description provided for @focusStatusNoMode.
  ///
  /// In en, this message translates to:
  /// **'No focus mode enabled'**
  String get focusStatusNoMode;

  /// No description provided for @focusStatusReadyToLock.
  ///
  /// In en, this message translates to:
  /// **'Ready to lock {targets}'**
  String focusStatusReadyToLock(String targets);

  /// No description provided for @homeCountdownHms.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m {seconds}s'**
  String homeCountdownHms(int hours, int minutes, int seconds);

  /// No description provided for @appLockDemoIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'See how App Lock works'**
  String get appLockDemoIntroTitle;

  /// No description provided for @appLockDemoIntroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay in DeenFocus. On the next screen, tap Instagram to see it pause at prayer time.'**
  String get appLockDemoIntroSubtitle;

  /// No description provided for @appLockDemoStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start the demo'**
  String get appLockDemoStartButton;

  /// No description provided for @appLockDemoTryOpeningApp.
  ///
  /// In en, this message translates to:
  /// **'Try opening Instagram'**
  String get appLockDemoTryOpeningApp;

  /// No description provided for @appLockDemoSalahModeBadge.
  ///
  /// In en, this message translates to:
  /// **'SALAH MODE'**
  String get appLockDemoSalahModeBadge;

  /// No description provided for @appLockDemoTimeToPray.
  ///
  /// In en, this message translates to:
  /// **'It’s time to pray'**
  String get appLockDemoTimeToPray;

  /// No description provided for @appLockDemoRemainingTime.
  ///
  /// In en, this message translates to:
  /// **'Remaining time: {time}'**
  String appLockDemoRemainingTime(String time);

  /// No description provided for @appLockDemoIvePrayed.
  ///
  /// In en, this message translates to:
  /// **'I’ve prayed {prayerName}'**
  String appLockDemoIvePrayed(String prayerName);

  /// No description provided for @appLockDemoAlhamdulillah.
  ///
  /// In en, this message translates to:
  /// **'Alhamdulillah'**
  String get appLockDemoAlhamdulillah;

  /// No description provided for @appLockDemoPrayerCompleted.
  ///
  /// In en, this message translates to:
  /// **'{prayerName} completed'**
  String appLockDemoPrayerCompleted(String prayerName);

  /// No description provided for @appLockDemoStreakIncreased.
  ///
  /// In en, this message translates to:
  /// **'Your prayer count increased'**
  String get appLockDemoStreakIncreased;

  /// No description provided for @appLockDemoPrayerStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'PRAYER STREAK'**
  String get appLockDemoPrayerStreakLabel;

  /// No description provided for @appLockDemoDayStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'DAY STREAK'**
  String get appLockDemoDayStreakLabel;

  /// No description provided for @appLockDemoNextPrayerIn.
  ///
  /// In en, this message translates to:
  /// **'Next prayer in {minutes} minutes'**
  String appLockDemoNextPrayerIn(String minutes);

  /// No description provided for @appLockDemoStreakMotivation.
  ///
  /// In en, this message translates to:
  /// **'Keep going! Your consistency brings you closer to Allah.'**
  String get appLockDemoStreakMotivation;

  /// No description provided for @appLockDemoCompletionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pray. Check in once.\nGet back to your day.'**
  String get appLockDemoCompletionSubtitle;

  /// No description provided for @appLockDemoCompletionBody.
  ///
  /// In en, this message translates to:
  /// **'App Lock gently pauses selected apps during Salah so you can focus on prayer — then continue when you’re ready.'**
  String get appLockDemoCompletionBody;

  /// No description provided for @appLockDemoContinueSetup.
  ///
  /// In en, this message translates to:
  /// **'Continue setup'**
  String get appLockDemoContinueSetup;

  /// No description provided for @appLockDemoAppMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get appLockDemoAppMessages;

  /// No description provided for @appLockDemoAppCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get appLockDemoAppCalendar;

  /// No description provided for @appLockDemoAppPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get appLockDemoAppPhotos;

  /// No description provided for @appLockDemoAppCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get appLockDemoAppCamera;

  /// No description provided for @appLockDemoAppMail.
  ///
  /// In en, this message translates to:
  /// **'Mail'**
  String get appLockDemoAppMail;

  /// No description provided for @appLockDemoAppMaps.
  ///
  /// In en, this message translates to:
  /// **'Maps'**
  String get appLockDemoAppMaps;

  /// No description provided for @appLockDemoAppWeather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get appLockDemoAppWeather;

  /// No description provided for @appLockDemoAppClock.
  ///
  /// In en, this message translates to:
  /// **'Clock'**
  String get appLockDemoAppClock;

  /// No description provided for @appLockDemoAppNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get appLockDemoAppNotes;

  /// No description provided for @appLockDemoAppSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get appLockDemoAppSettings;

  /// No description provided for @appLockDemoAppMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get appLockDemoAppMusic;

  /// No description provided for @appLockDemoAppInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get appLockDemoAppInstagram;

  /// No description provided for @settingsPrayerUpdatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Updates'**
  String get settingsPrayerUpdatesTitle;

  /// No description provided for @settingsPrayerUpdatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Live Activity for your next prayer on the Lock Screen'**
  String get settingsPrayerUpdatesSubtitle;

  /// No description provided for @liveActivitySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Activities'**
  String get liveActivitySectionTitle;

  /// No description provided for @liveActivityStayUpdatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay updated at a glance'**
  String get liveActivityStayUpdatedTitle;

  /// No description provided for @liveActivityStayUpdatedBody.
  ///
  /// In en, this message translates to:
  /// **'See your next prayer and its time directly on your Lock Screen.'**
  String get liveActivityStayUpdatedBody;

  /// No description provided for @liveActivityEnableLabel.
  ///
  /// In en, this message translates to:
  /// **'Enable Live Activity'**
  String get liveActivityEnableLabel;

  /// No description provided for @liveActivityPromptNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get liveActivityPromptNotNow;

  /// No description provided for @liveActivityUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Live Activities are not available on this device.'**
  String get liveActivityUnsupported;

  /// No description provided for @liveActivityPermissionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications so prayer updates can appear on your Lock Screen.'**
  String get liveActivityPermissionNeeded;

  /// No description provided for @liveActivityPermissionButton.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get liveActivityPermissionButton;

  /// No description provided for @liveActivityStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Live Activity is on'**
  String get liveActivityStatusActive;

  /// No description provided for @liveActivityStatusOff.
  ///
  /// In en, this message translates to:
  /// **'Live Activity is off'**
  String get liveActivityStatusOff;

  /// No description provided for @liveActivityEnabledPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Activity is on'**
  String get liveActivityEnabledPromptTitle;

  /// No description provided for @liveActivityEnabledPromptBodyIos.
  ///
  /// In en, this message translates to:
  /// **'Prayer updates are now on your Lock Screen and Dynamic Island. Lock your phone to see your current and next prayer anytime.'**
  String get liveActivityEnabledPromptBodyIos;

  /// No description provided for @liveActivityEnabledPromptBodyAndroid.
  ///
  /// In en, this message translates to:
  /// **'Prayer updates now show as an ongoing notification. Lock your phone or pull down the notification shade to check anytime.'**
  String get liveActivityEnabledPromptBodyAndroid;

  /// No description provided for @liveActivityEnabledPromptButton.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get liveActivityEnabledPromptButton;

  /// No description provided for @liveActivityNowLabel.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get liveActivityNowLabel;

  /// No description provided for @liveActivityUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated at {time}'**
  String liveActivityUpdatedAt(String time);

  /// No description provided for @liveActivityNextAt.
  ///
  /// In en, this message translates to:
  /// **'{prayer} at {time}'**
  String liveActivityNextAt(String prayer, String time);

  /// No description provided for @settingsPrayerAlarmsTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Alarms'**
  String get settingsPrayerAlarmsTitle;

  /// No description provided for @settingsPrayerAlarmsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Full prayer alarms that can break through Silent Mode'**
  String get settingsPrayerAlarmsSubtitle;

  /// No description provided for @prayerAlarmsMasterLabel.
  ///
  /// In en, this message translates to:
  /// **'Enable Prayer Alarms'**
  String get prayerAlarmsMasterLabel;

  /// No description provided for @prayerAlarmsMasterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule a native alarm for each selected prayer'**
  String get prayerAlarmsMasterSubtitle;

  /// No description provided for @prayerAlarmsSnoozeLabel.
  ///
  /// In en, this message translates to:
  /// **'Snooze duration'**
  String get prayerAlarmsSnoozeLabel;

  /// No description provided for @prayerAlarmsSnoozeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes'**
  String prayerAlarmsSnoozeMinutes(int minutes);

  /// No description provided for @prayerAlarmsPerPrayerSection.
  ///
  /// In en, this message translates to:
  /// **'Alarms by prayer'**
  String get prayerAlarmsPerPrayerSection;

  /// No description provided for @prayerAlarmsPermissionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Allow alarm permission so prayer alarms can fire on time.'**
  String get prayerAlarmsPermissionNeeded;

  /// No description provided for @prayerAlarmsPermissionButton.
  ///
  /// In en, this message translates to:
  /// **'Allow alarms'**
  String get prayerAlarmsPermissionButton;

  /// No description provided for @prayerAlarmsFsiNeeded.
  ///
  /// In en, this message translates to:
  /// **'Allow full-screen alarms so they can appear over the lock screen. Without this, alarms still notify as a banner.'**
  String get prayerAlarmsFsiNeeded;

  /// No description provided for @prayerAlarmsFsiButton.
  ///
  /// In en, this message translates to:
  /// **'Full-screen settings'**
  String get prayerAlarmsFsiButton;

  /// No description provided for @prayerAlarmsUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Native prayer alarms are not available on this device. Soft prayer notifications still work.'**
  String get prayerAlarmsUnsupported;

  /// No description provided for @prayerAlarmsIosFallback.
  ///
  /// In en, this message translates to:
  /// **'On this iOS version, soft prayer notifications are used instead of AlarmKit.'**
  String get prayerAlarmsIosFallback;

  /// No description provided for @prayerAlarmsDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Alarm permission required'**
  String get prayerAlarmsDeniedTitle;

  /// No description provided for @prayerAlarmsDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'Prayer Alarms stay off until you allow alarm permission. Soft prayer notifications are unaffected.'**
  String get prayerAlarmsDeniedMessage;

  /// No description provided for @prayerAlarmsOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get prayerAlarmsOpenSettings;

  /// No description provided for @prayerAlarmsStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Alarms are ready to schedule'**
  String get prayerAlarmsStatusReady;

  /// No description provided for @prayerAlarmsStatusNeedsPermission.
  ///
  /// In en, this message translates to:
  /// **'Permission needed — alarms are not active'**
  String get prayerAlarmsStatusNeedsPermission;

  /// No description provided for @prayerAlarmsStatusFallback.
  ///
  /// In en, this message translates to:
  /// **'Using soft notifications on this device'**
  String get prayerAlarmsStatusFallback;

  /// No description provided for @prayerAlarmsStatusFsiOptional.
  ///
  /// In en, this message translates to:
  /// **'Alarms are on. Enable full-screen for lock-screen takeover.'**
  String get prayerAlarmsStatusFsiOptional;

  /// No description provided for @prayerAlarmsCancel.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get prayerAlarmsCancel;

  /// No description provided for @homePrayerAlarmEnableLabel.
  ///
  /// In en, this message translates to:
  /// **'Prayer Alarm'**
  String get homePrayerAlarmEnableLabel;

  /// No description provided for @homePrayerAlarmEnableSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ring a native alarm at {prayerName}'**
  String homePrayerAlarmEnableSubtitle(String prayerName);

  /// No description provided for @prayerAlarmBadge.
  ///
  /// In en, this message translates to:
  /// **'Prayer Alarm'**
  String get prayerAlarmBadge;

  /// No description provided for @prayerAlarmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Time to Pray'**
  String get prayerAlarmSubtitle;

  /// No description provided for @prayerAlarmTitle.
  ///
  /// In en, this message translates to:
  /// **'{prayerName} — Time to Pray'**
  String prayerAlarmTitle(String prayerName);

  /// No description provided for @prayerAlarmIvePrayed.
  ///
  /// In en, this message translates to:
  /// **'I\'ve Prayed'**
  String get prayerAlarmIvePrayed;

  /// No description provided for @prayerAlarmDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get prayerAlarmDismiss;

  /// No description provided for @prayerAlarmSnooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze'**
  String get prayerAlarmSnooze;

  /// No description provided for @appLockDemoAppPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get appLockDemoAppPhone;

  /// No description provided for @appLockDemoAppSafari.
  ///
  /// In en, this message translates to:
  /// **'Safari'**
  String get appLockDemoAppSafari;

  /// No description provided for @appLockDemoAppFaceTime.
  ///
  /// In en, this message translates to:
  /// **'FaceTime'**
  String get appLockDemoAppFaceTime;

  /// No description provided for @appLockDemoAppReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get appLockDemoAppReminders;

  /// No description provided for @appLockDemoAppAppStore.
  ///
  /// In en, this message translates to:
  /// **'App Store'**
  String get appLockDemoAppAppStore;

  /// No description provided for @appLockDemoAppBooks.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get appLockDemoAppBooks;

  /// No description provided for @appLockDemoAppHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get appLockDemoAppHealth;

  /// No description provided for @appLockDemoAppWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get appLockDemoAppWallet;

  /// No description provided for @appLockDemoAppChrome.
  ///
  /// In en, this message translates to:
  /// **'Chrome'**
  String get appLockDemoAppChrome;

  /// No description provided for @settingsAppDemoLabel.
  ///
  /// In en, this message translates to:
  /// **'App Demo'**
  String get settingsAppDemoLabel;

  /// No description provided for @settingsAppDemoChooseModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Experience App Lock'**
  String get settingsAppDemoChooseModeTitle;

  /// No description provided for @settingsAppDemoChooseModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a Focus Mode and see how selected apps pause — without leaving DeenFocus.'**
  String get settingsAppDemoChooseModeSubtitle;

  /// No description provided for @appLockDemoDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get appLockDemoDone;

  /// No description provided for @appLockDemoSleepIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'See how Sleep Mode works'**
  String get appLockDemoSleepIntroTitle;

  /// No description provided for @appLockDemoSleepIntroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay in DeenFocus. On the next screen, tap Instagram to see it pause at bedtime.'**
  String get appLockDemoSleepIntroSubtitle;

  /// No description provided for @appLockDemoSleepModeBadge.
  ///
  /// In en, this message translates to:
  /// **'SLEEP MODE'**
  String get appLockDemoSleepModeBadge;

  /// No description provided for @appLockDemoSleepLockTitle.
  ///
  /// In en, this message translates to:
  /// **'Time to wind down'**
  String get appLockDemoSleepLockTitle;

  /// No description provided for @appLockDemoSleepLockCta.
  ///
  /// In en, this message translates to:
  /// **'I’m ready to rest'**
  String get appLockDemoSleepLockCta;

  /// No description provided for @appLockDemoSleepCompleted.
  ///
  /// In en, this message translates to:
  /// **'Sleep Mode protected'**
  String get appLockDemoSleepCompleted;

  /// No description provided for @appLockDemoSleepRewardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your night protection increased'**
  String get appLockDemoSleepRewardSubtitle;

  /// No description provided for @appLockDemoSleepStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'NIGHT STREAK'**
  String get appLockDemoSleepStreakLabel;

  /// No description provided for @appLockDemoSleepRewardFooter.
  ///
  /// In en, this message translates to:
  /// **'Fajr reminder set for morning'**
  String get appLockDemoSleepRewardFooter;

  /// No description provided for @appLockDemoSleepMotivation.
  ///
  /// In en, this message translates to:
  /// **'Rest well tonight so you can rise for Fajr with energy.'**
  String get appLockDemoSleepMotivation;

  /// No description provided for @appLockDemoSleepCompletionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quiet nights.\nClear mornings.'**
  String get appLockDemoSleepCompletionSubtitle;

  /// No description provided for @appLockDemoSleepCompletionBody.
  ///
  /// In en, this message translates to:
  /// **'Sleep Mode gently pauses selected apps at night so you can rest — then continue when you’re ready.'**
  String get appLockDemoSleepCompletionBody;

  /// No description provided for @appLockDemoChildIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'See how Child Mode works'**
  String get appLockDemoChildIntroTitle;

  /// No description provided for @appLockDemoChildIntroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay in DeenFocus. On the next screen, tap Instagram to see it lock when Child Mode is on.'**
  String get appLockDemoChildIntroSubtitle;

  /// No description provided for @appLockDemoChildModeBadge.
  ///
  /// In en, this message translates to:
  /// **'CHILD MODE'**
  String get appLockDemoChildModeBadge;

  /// No description provided for @appLockDemoChildLockTitle.
  ///
  /// In en, this message translates to:
  /// **'Apps are protected'**
  String get appLockDemoChildLockTitle;

  /// No description provided for @appLockDemoChildLockDetail.
  ///
  /// In en, this message translates to:
  /// **'Selected apps stay locked while Child Mode is on'**
  String get appLockDemoChildLockDetail;

  /// No description provided for @appLockDemoChildLockCta.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get appLockDemoChildLockCta;

  /// No description provided for @appLockDemoChildCompleted.
  ///
  /// In en, this message translates to:
  /// **'Child Mode active'**
  String get appLockDemoChildCompleted;

  /// No description provided for @appLockDemoChildRewardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your protection streak increased'**
  String get appLockDemoChildRewardSubtitle;

  /// No description provided for @appLockDemoChildStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'SAFE STREAK'**
  String get appLockDemoChildStreakLabel;

  /// No description provided for @appLockDemoChildRewardFooter.
  ///
  /// In en, this message translates to:
  /// **'Exit anytime with your passcode'**
  String get appLockDemoChildRewardFooter;

  /// No description provided for @appLockDemoChildMotivation.
  ///
  /// In en, this message translates to:
  /// **'Peace of mind every time you hand over your phone.'**
  String get appLockDemoChildMotivation;

  /// No description provided for @appLockDemoChildCompletionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One tap safe mode.\nOnly what you allow.'**
  String get appLockDemoChildCompletionSubtitle;

  /// No description provided for @appLockDemoChildCompletionBody.
  ///
  /// In en, this message translates to:
  /// **'Child Mode locks selected apps so your child only sees what’s safe — then you unlock when you’re ready.'**
  String get appLockDemoChildCompletionBody;

  /// No description provided for @appLockDemoSleepCompletionTitle.
  ///
  /// In en, this message translates to:
  /// **'Rest well tonight'**
  String get appLockDemoSleepCompletionTitle;

  /// No description provided for @appLockDemoChildCompletionTitle.
  ///
  /// In en, this message translates to:
  /// **'Peace of mind'**
  String get appLockDemoChildCompletionTitle;

  /// No description provided for @settingsAppDemoPrayerCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pause distractions at Salah so you can pray with presence.'**
  String get settingsAppDemoPrayerCardSubtitle;

  /// No description provided for @settingsAppDemoSleepCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Protect your nights so rest comes easier — and Fajr feels lighter.'**
  String get settingsAppDemoSleepCardSubtitle;

  /// No description provided for @settingsAppDemoChildCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hand over your phone knowing only allowed apps stay open.'**
  String get settingsAppDemoChildCardSubtitle;

  /// No description provided for @settingsAppDemoHomeFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay connected at a glance'**
  String get settingsAppDemoHomeFeaturesTitle;

  /// No description provided for @settingsAppDemoHomeFeaturesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See how Home Screen widgets and Live Activity keep prayer times close — without opening the app.'**
  String get settingsAppDemoHomeFeaturesSubtitle;

  /// No description provided for @settingsAppDemoWidgetsCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily verse and prayer times on your Home Screen, always up to date.'**
  String get settingsAppDemoWidgetsCardSubtitle;

  /// No description provided for @settingsAppDemoLiveActivityCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Current and next prayer on your Lock Screen and Dynamic Island.'**
  String get settingsAppDemoLiveActivityCardSubtitle;

  /// No description provided for @settingsAppDemoTajweedCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recite an ayah and get instant tajweed feedback.'**
  String get settingsAppDemoTajweedCardSubtitle;

  /// No description provided for @featureDemoTajweedTitle.
  ///
  /// In en, this message translates to:
  /// **'Tajweed'**
  String get featureDemoTajweedTitle;

  /// No description provided for @featureDemoTajweedIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'See how Tajweed practice works'**
  String get featureDemoTajweedIntroTitle;

  /// No description provided for @featureDemoTajweedIntroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay in DeenFocus. Open Tajweed drill, recite an ayah, and see word-by-word feedback.'**
  String get featureDemoTajweedIntroSubtitle;

  /// No description provided for @featureDemoTajweedQuranCallout.
  ///
  /// In en, this message translates to:
  /// **'Tap Tajweed drill to start'**
  String get featureDemoTajweedQuranCallout;

  /// No description provided for @featureDemoTajweedLegendCallout.
  ///
  /// In en, this message translates to:
  /// **'Color highlights show tajweed rules as you read'**
  String get featureDemoTajweedLegendCallout;

  /// No description provided for @featureDemoTajweedReciteCallout.
  ///
  /// In en, this message translates to:
  /// **'Tap Recite & check tajweed'**
  String get featureDemoTajweedReciteCallout;

  /// No description provided for @featureDemoTajweedDownloadCallout.
  ///
  /// In en, this message translates to:
  /// **'One-time download so practice works offline'**
  String get featureDemoTajweedDownloadCallout;

  /// No description provided for @featureDemoTajweedMicCallout.
  ///
  /// In en, this message translates to:
  /// **'Tap the mic and start reciting'**
  String get featureDemoTajweedMicCallout;

  /// No description provided for @featureDemoTajweedResultCallout.
  ///
  /// In en, this message translates to:
  /// **'See which words were correct, missed, or need work'**
  String get featureDemoTajweedResultCallout;

  /// No description provided for @featureDemoTajweedCompletionTitle.
  ///
  /// In en, this message translates to:
  /// **'Tajweed, ready'**
  String get featureDemoTajweedCompletionTitle;

  /// No description provided for @featureDemoTajweedCompletionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recite with confidence, anytime.'**
  String get featureDemoTajweedCompletionSubtitle;

  /// No description provided for @featureDemoTajweedCompletionBody.
  ///
  /// In en, this message translates to:
  /// **'Open Quran → Tajweed drill to practice any ayah with on-device scoring — fully offline after the first download.'**
  String get featureDemoTajweedCompletionBody;

  /// No description provided for @featureDemoTajweedSurahName.
  ///
  /// In en, this message translates to:
  /// **'Al-Fatihah'**
  String get featureDemoTajweedSurahName;

  /// No description provided for @featureDemoTajweedBaqarahName.
  ///
  /// In en, this message translates to:
  /// **'Al-Baqarah'**
  String get featureDemoTajweedBaqarahName;

  /// No description provided for @featureDemoTajweedSurahListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'7 verses • Meccan'**
  String get featureDemoTajweedSurahListSubtitle;

  /// No description provided for @featureDemoTajweedBaqarahSubtitle.
  ///
  /// In en, this message translates to:
  /// **'286 verses • Medinan'**
  String get featureDemoTajweedBaqarahSubtitle;

  /// No description provided for @featureDemoTajweedSurahHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Al-Fatihah • 7 verses'**
  String get featureDemoTajweedSurahHeaderSubtitle;

  /// No description provided for @featureDemoTajweedSurahMeta.
  ///
  /// In en, this message translates to:
  /// **'SURAH 1 • MECCAN'**
  String get featureDemoTajweedSurahMeta;

  /// No description provided for @featureDemoTajweedAyahTranslation.
  ///
  /// In en, this message translates to:
  /// **'In the name of Allah, the Entirely Merciful, the Especially Merciful.'**
  String get featureDemoTajweedAyahTranslation;

  /// No description provided for @featureDemoTajweedPracticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Al-Fatihah · 1:1'**
  String get featureDemoTajweedPracticeTitle;

  /// No description provided for @featureDemoTajweedPreparingTitle.
  ///
  /// In en, this message translates to:
  /// **'Preparing AI model'**
  String get featureDemoTajweedPreparingTitle;

  /// No description provided for @featureDemoTajweedPreparingBody.
  ///
  /// In en, this message translates to:
  /// **'One-time download so Tajweed practice works fully offline afterwards. This only happens once.'**
  String get featureDemoTajweedPreparingBody;

  /// No description provided for @featureDemoTajweedResultEncouragement.
  ///
  /// In en, this message translates to:
  /// **'Keep practicing — listen to the reference and try again.'**
  String get featureDemoTajweedResultEncouragement;

  /// No description provided for @featureDemoTajweedStatCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get featureDemoTajweedStatCorrect;

  /// No description provided for @featureDemoTajweedStatPronunciation.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation'**
  String get featureDemoTajweedStatPronunciation;

  /// No description provided for @featureDemoTajweedStatWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong word'**
  String get featureDemoTajweedStatWrong;

  /// No description provided for @featureDemoTajweedStatMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get featureDemoTajweedStatMissed;

  /// No description provided for @featureDemoTajweedStatExtra.
  ///
  /// In en, this message translates to:
  /// **'Extra'**
  String get featureDemoTajweedStatExtra;

  /// No description provided for @featureDemoContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get featureDemoContinue;

  /// No description provided for @featureDemoSampleStatusTime.
  ///
  /// In en, this message translates to:
  /// **'9:41'**
  String get featureDemoSampleStatusTime;

  /// No description provided for @featureDemoOfferWidgetManualBody.
  ///
  /// In en, this message translates to:
  /// **'Your device doesn’t allow apps to place widgets automatically. Add the Large DeenFocus widget from your Home Screen widget gallery.'**
  String get featureDemoOfferWidgetManualBody;

  /// No description provided for @featureDemoOfferWidgetManualTitle.
  ///
  /// In en, this message translates to:
  /// **'Add the widget from your Home Screen'**
  String get featureDemoOfferWidgetManualTitle;

  /// No description provided for @featureDemoOfferNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get featureDemoOfferNo;

  /// No description provided for @featureDemoOfferYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get featureDemoOfferYes;

  /// No description provided for @featureDemoOfferLiveActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Want to enable Live Activity on your device?'**
  String get featureDemoOfferLiveActivityTitle;

  /// No description provided for @featureDemoOfferWidgetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Want to add this widget to your Home Screen?'**
  String get featureDemoOfferWidgetsTitle;

  /// No description provided for @featureDemoWidgetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Widgets'**
  String get featureDemoWidgetsTitle;

  /// No description provided for @featureDemoWidgetsIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'See your Home Screen widgets'**
  String get featureDemoWidgetsIntroTitle;

  /// No description provided for @featureDemoWidgetsIntroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay in DeenFocus. Long-press the Home Screen, add a widget, and try all three sizes.'**
  String get featureDemoWidgetsIntroSubtitle;

  /// No description provided for @featureDemoWidgetsShowcaseCallout.
  ///
  /// In en, this message translates to:
  /// **'Long-press the Home Screen to edit widgets'**
  String get featureDemoWidgetsShowcaseCallout;

  /// No description provided for @featureDemoWidgetsDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Glanceable prayer guidance'**
  String get featureDemoWidgetsDetailsTitle;

  /// No description provided for @featureDemoWidgetsDetailsBody.
  ///
  /// In en, this message translates to:
  /// **'Your Medium widget shows today’s verse and all five prayer times — refreshed when you open DeenFocus.'**
  String get featureDemoWidgetsDetailsBody;

  /// No description provided for @featureDemoWidgetsCompletionTitle.
  ///
  /// In en, this message translates to:
  /// **'Widgets, ready'**
  String get featureDemoWidgetsCompletionTitle;

  /// No description provided for @featureDemoWidgetsCompletionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Faith reminders on your Home Screen.'**
  String get featureDemoWidgetsCompletionSubtitle;

  /// No description provided for @featureDemoWidgetsCompletionBody.
  ///
  /// In en, this message translates to:
  /// **'Add DeenFocus widgets from your phone’s widget gallery after this demo — then open the app once to sync.'**
  String get featureDemoWidgetsCompletionBody;

  /// No description provided for @featureDemoWidgetsHomeHint.
  ///
  /// In en, this message translates to:
  /// **'Wednesday, 13 August'**
  String get featureDemoWidgetsHomeHint;

  /// No description provided for @featureDemoWidgetSampleDate.
  ///
  /// In en, this message translates to:
  /// **'Wed, Aug 13'**
  String get featureDemoWidgetSampleDate;

  /// No description provided for @featureDemoWidgetSampleVerse.
  ///
  /// In en, this message translates to:
  /// **'It is You we worship and You we ask for help.'**
  String get featureDemoWidgetSampleVerse;

  /// No description provided for @featureDemoWidgetSampleSource.
  ///
  /// In en, this message translates to:
  /// **'Surah 1:5'**
  String get featureDemoWidgetSampleSource;

  /// No description provided for @featureDemoLiveActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Activity'**
  String get featureDemoLiveActivityTitle;

  /// No description provided for @featureDemoLiveActivityIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'See Live Activity in action'**
  String get featureDemoLiveActivityIntroTitle;

  /// No description provided for @featureDemoLiveActivityIntroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay in DeenFocus. Enable Live Activity in Settings, then see Lock Screen and Dynamic Island updates.'**
  String get featureDemoLiveActivityIntroSubtitle;

  /// No description provided for @featureDemoLiveActivityShowcaseCallout.
  ///
  /// In en, this message translates to:
  /// **'Tap Prayer Calculation'**
  String get featureDemoLiveActivityShowcaseCallout;

  /// No description provided for @featureDemoLiveActivityDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer updates, always visible'**
  String get featureDemoLiveActivityDetailsTitle;

  /// No description provided for @featureDemoLiveActivityDetailsBody.
  ///
  /// In en, this message translates to:
  /// **'Live Activity keeps Maghrib, Isha, and the countdown close on your Lock Screen — turn it on in Settings anytime.'**
  String get featureDemoLiveActivityDetailsBody;

  /// No description provided for @featureDemoLiveActivityCompletionTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Activity, ready'**
  String get featureDemoLiveActivityCompletionTitle;

  /// No description provided for @featureDemoLiveActivityCompletionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Next prayer, always nearby.'**
  String get featureDemoLiveActivityCompletionSubtitle;

  /// No description provided for @featureDemoLiveActivityCompletionBody.
  ///
  /// In en, this message translates to:
  /// **'Enable Live Activity in Settings → Prayer Calculation to show prayer updates on your Lock Screen.'**
  String get featureDemoLiveActivityCompletionBody;

  /// No description provided for @featureDemoLiveActivityLockHint.
  ///
  /// In en, this message translates to:
  /// **'Wednesday, 13 August'**
  String get featureDemoLiveActivityLockHint;

  /// No description provided for @featureDemoLiveActivitySampleTime.
  ///
  /// In en, this message translates to:
  /// **'6:48 PM'**
  String get featureDemoLiveActivitySampleTime;

  /// No description provided for @featureDemoLiveActivitySampleNextTime.
  ///
  /// In en, this message translates to:
  /// **'8:11 PM'**
  String get featureDemoLiveActivitySampleNextTime;

  /// No description provided for @featureDemoWidgetsIntroSubtitleIos.
  ///
  /// In en, this message translates to:
  /// **'Stay in DeenFocus. Long-press the Home Screen, add a widget, and try all three sizes.'**
  String get featureDemoWidgetsIntroSubtitleIos;

  /// No description provided for @featureDemoWidgetsIntroSubtitleAndroid.
  ///
  /// In en, this message translates to:
  /// **'Stay in DeenFocus. Long-press the Home Screen, open the widget picker, and try all three sizes.'**
  String get featureDemoWidgetsIntroSubtitleAndroid;

  /// No description provided for @featureDemoWidgetsLongPressCalloutIos.
  ///
  /// In en, this message translates to:
  /// **'Long-press the Home Screen to edit widgets'**
  String get featureDemoWidgetsLongPressCalloutIos;

  /// No description provided for @featureDemoWidgetsLongPressCalloutAndroid.
  ///
  /// In en, this message translates to:
  /// **'Long-press the Home Screen to edit widgets'**
  String get featureDemoWidgetsLongPressCalloutAndroid;

  /// No description provided for @featureDemoWidgetsAddCallout.
  ///
  /// In en, this message translates to:
  /// **'Tap + to choose a DeenFocus widget'**
  String get featureDemoWidgetsAddCallout;

  /// No description provided for @featureDemoWidgetsAddSlotLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Widget'**
  String get featureDemoWidgetsAddSlotLabel;

  /// No description provided for @featureDemoWidgetsGalleryTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a DeenFocus widget'**
  String get featureDemoWidgetsGalleryTitle;

  /// No description provided for @featureDemoWidgetsGallerySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Switch between Small, Medium, and Large — then add it to your Home Screen.'**
  String get featureDemoWidgetsGallerySubtitle;

  /// No description provided for @featureDemoWidgetsAddCta.
  ///
  /// In en, this message translates to:
  /// **'Add Widget'**
  String get featureDemoWidgetsAddCta;

  /// No description provided for @featureDemoWidgetsAddCtaAndroid.
  ///
  /// In en, this message translates to:
  /// **'Add widget'**
  String get featureDemoWidgetsAddCtaAndroid;

  /// No description provided for @featureDemoWidgetsChangeCta.
  ///
  /// In en, this message translates to:
  /// **'Change size'**
  String get featureDemoWidgetsChangeCta;

  /// No description provided for @featureDemoWidgetSizeSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get featureDemoWidgetSizeSmall;

  /// No description provided for @featureDemoWidgetSizeMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get featureDemoWidgetSizeMedium;

  /// No description provided for @featureDemoWidgetSizeLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get featureDemoWidgetSizeLarge;

  /// No description provided for @featureDemoWidgetSizeSmallSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Compact prayer times at a glance'**
  String get featureDemoWidgetSizeSmallSubtitle;

  /// No description provided for @featureDemoWidgetSizeMediumSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily verse plus all five prayers'**
  String get featureDemoWidgetSizeMediumSubtitle;

  /// No description provided for @featureDemoWidgetSizeLargeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer progress with today’s schedule'**
  String get featureDemoWidgetSizeLargeSubtitle;

  /// No description provided for @featureDemoLiveActivityIntroSubtitleIos.
  ///
  /// In en, this message translates to:
  /// **'Stay in DeenFocus. Enable Live Activity in Settings, then see Lock Screen and Dynamic Island updates.'**
  String get featureDemoLiveActivityIntroSubtitleIos;

  /// No description provided for @featureDemoLiveActivityIntroSubtitleAndroid.
  ///
  /// In en, this message translates to:
  /// **'Stay in DeenFocus. Enable Live Activity in Settings, then see the ongoing prayer notification and shade.'**
  String get featureDemoLiveActivityIntroSubtitleAndroid;

  /// No description provided for @featureDemoLiveOpenPrayerCalcCallout.
  ///
  /// In en, this message translates to:
  /// **'Tap Prayer Calculation'**
  String get featureDemoLiveOpenPrayerCalcCallout;

  /// No description provided for @featureDemoLiveEnableToggleCallout.
  ///
  /// In en, this message translates to:
  /// **'Turn on Enable Live Activity'**
  String get featureDemoLiveEnableToggleCallout;

  /// No description provided for @featureDemoLiveLockScreenCallout.
  ///
  /// In en, this message translates to:
  /// **'Your prayer Live Activity on the Lock Screen'**
  String get featureDemoLiveLockScreenCallout;

  /// No description provided for @featureDemoLiveCompactTitle.
  ///
  /// In en, this message translates to:
  /// **'Compact Dynamic Island'**
  String get featureDemoLiveCompactTitle;

  /// No description provided for @featureDemoLiveCompactCallout.
  ///
  /// In en, this message translates to:
  /// **'Current prayer stays visible at the top'**
  String get featureDemoLiveCompactCallout;

  /// No description provided for @featureDemoLiveExpandCta.
  ///
  /// In en, this message translates to:
  /// **'Expand Dynamic Island'**
  String get featureDemoLiveExpandCta;

  /// No description provided for @featureDemoLiveExpandedTitle.
  ///
  /// In en, this message translates to:
  /// **'Expanded Dynamic Island'**
  String get featureDemoLiveExpandedTitle;

  /// No description provided for @featureDemoLiveExpandedCallout.
  ///
  /// In en, this message translates to:
  /// **'See current time and the next prayer together'**
  String get featureDemoLiveExpandedCallout;

  /// No description provided for @featureDemoLiveActivityCompletionSubtitleIos.
  ///
  /// In en, this message translates to:
  /// **'Lock Screen and Dynamic Island, ready.'**
  String get featureDemoLiveActivityCompletionSubtitleIos;

  /// No description provided for @featureDemoLiveActivityCompletionSubtitleAndroid.
  ///
  /// In en, this message translates to:
  /// **'Ongoing prayer updates, ready.'**
  String get featureDemoLiveActivityCompletionSubtitleAndroid;

  /// No description provided for @featureDemoLiveActivityCompletionBodyIos.
  ///
  /// In en, this message translates to:
  /// **'Enable Live Activity in Settings → Prayer Calculation to show prayer updates on your Lock Screen and Dynamic Island.'**
  String get featureDemoLiveActivityCompletionBodyIos;

  /// No description provided for @featureDemoLiveActivityCompletionBodyAndroid.
  ///
  /// In en, this message translates to:
  /// **'Enable Live Activity in Settings → Prayer Calculation to show an ongoing prayer notification on Android.'**
  String get featureDemoLiveActivityCompletionBodyAndroid;

  /// No description provided for @featureDemoAndroidStatusBarHint.
  ///
  /// In en, this message translates to:
  /// **'Ongoing notification'**
  String get featureDemoAndroidStatusBarHint;

  /// No description provided for @featureDemoAndroidOngoingTitle.
  ///
  /// In en, this message translates to:
  /// **'Live prayer notification'**
  String get featureDemoAndroidOngoingTitle;

  /// No description provided for @featureDemoAndroidOngoingCallout.
  ///
  /// In en, this message translates to:
  /// **'Silent ongoing update — current and next prayer'**
  String get featureDemoAndroidOngoingCallout;

  /// No description provided for @featureDemoAndroidOpenShadeCta.
  ///
  /// In en, this message translates to:
  /// **'Open notification shade'**
  String get featureDemoAndroidOpenShadeCta;

  /// No description provided for @featureDemoAndroidShadeTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification shade'**
  String get featureDemoAndroidShadeTitle;

  /// No description provided for @featureDemoAndroidShadeCallout.
  ///
  /// In en, this message translates to:
  /// **'Expand to see the full current and next prayer status'**
  String get featureDemoAndroidShadeCallout;

  /// No description provided for @featureDemoAndroidOngoingBadge.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get featureDemoAndroidOngoingBadge;

  /// No description provided for @appLockDemoOfferPrayerTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to try Prayer Mode?'**
  String get appLockDemoOfferPrayerTitle;

  /// No description provided for @appLockDemoOfferSleepTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to try Sleep Mode?'**
  String get appLockDemoOfferSleepTitle;

  /// No description provided for @appLockDemoOfferChildTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to try Child Mode?'**
  String get appLockDemoOfferChildTitle;

  /// No description provided for @appLockDemoOfferPrayerCta.
  ///
  /// In en, this message translates to:
  /// **'Enable Prayer Mode'**
  String get appLockDemoOfferPrayerCta;

  /// No description provided for @appLockDemoOfferSleepCta.
  ///
  /// In en, this message translates to:
  /// **'Enable Sleep Mode'**
  String get appLockDemoOfferSleepCta;

  /// No description provided for @appLockDemoOfferChildCta.
  ///
  /// In en, this message translates to:
  /// **'Enable Child Mode'**
  String get appLockDemoOfferChildCta;

  /// No description provided for @appLockDemoOfferNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get appLockDemoOfferNotNow;

  /// No description provided for @nightlyWrapUpPrayersTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish today\'s prayers'**
  String get nightlyWrapUpPrayersTitle;

  /// No description provided for @nightlyWrapUpPrayersBody.
  ///
  /// In en, this message translates to:
  /// **'Mark any unfinished or missed prayers to protect your Prayer Count.'**
  String get nightlyWrapUpPrayersBody;

  /// No description provided for @nightlyWrapUpChecklistTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your Daily Checklist'**
  String get nightlyWrapUpChecklistTitle;

  /// No description provided for @nightlyWrapUpChecklistBody.
  ///
  /// In en, this message translates to:
  /// **'A few checklist items are still open — wrap up your day with intention.'**
  String get nightlyWrapUpChecklistBody;

  /// No description provided for @nightlyWrapUpBothTitle.
  ///
  /// In en, this message translates to:
  /// **'Wrap up your day'**
  String get nightlyWrapUpBothTitle;

  /// No description provided for @nightlyWrapUpBothBody.
  ///
  /// In en, this message translates to:
  /// **'Mark remaining prayers and finish your Daily Checklist before the day ends.'**
  String get nightlyWrapUpBothBody;

  /// No description provided for @cycleModeEndedNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Cycle Mode has ended'**
  String get cycleModeEndedNotificationTitle;

  /// No description provided for @cycleModeEndedNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Your Cycle Mode is now off. You can resume praying. If you want to change your Cycle Mode dates, tap here to edit them.'**
  String get cycleModeEndedNotificationBody;

  /// No description provided for @libraryHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Islamic Library'**
  String get libraryHomeTitle;

  /// No description provided for @libraryHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn Hadith, duas, the 99 Names, and more'**
  String get libraryHomeSubtitle;

  /// No description provided for @libraryHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Islamic Library'**
  String get libraryHubTitle;

  /// No description provided for @libraryModuleQuran.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get libraryModuleQuran;

  /// No description provided for @libraryModuleQuranSub.
  ///
  /// In en, this message translates to:
  /// **'Read, listen, and practice tajweed'**
  String get libraryModuleQuranSub;

  /// No description provided for @libraryModuleHadith.
  ///
  /// In en, this message translates to:
  /// **'Hadith'**
  String get libraryModuleHadith;

  /// No description provided for @libraryModuleHadithSub.
  ///
  /// In en, this message translates to:
  /// **'Collections from authentic sources'**
  String get libraryModuleHadithSub;

  /// No description provided for @libraryModuleDuas.
  ///
  /// In en, this message translates to:
  /// **'Duas & Adhkar'**
  String get libraryModuleDuas;

  /// No description provided for @libraryModuleDuasSub.
  ///
  /// In en, this message translates to:
  /// **'Morning, evening, and daily remembrance'**
  String get libraryModuleDuasSub;

  /// No description provided for @libraryModulePrayerMethods.
  ///
  /// In en, this message translates to:
  /// **'Prayer & Islamic Methods'**
  String get libraryModulePrayerMethods;

  /// No description provided for @libraryModulePrayerMethodsSub.
  ///
  /// In en, this message translates to:
  /// **'Wudu, salah, hajj, and more'**
  String get libraryModulePrayerMethodsSub;

  /// No description provided for @libraryModuleFiqh.
  ///
  /// In en, this message translates to:
  /// **'Fiqh & Traditions'**
  String get libraryModuleFiqh;

  /// No description provided for @libraryModuleFiqhSub.
  ///
  /// In en, this message translates to:
  /// **'Sunni, Shia, madhabs, Ahl-e Hadith, and more'**
  String get libraryModuleFiqhSub;

  /// No description provided for @libraryModuleNames.
  ///
  /// In en, this message translates to:
  /// **'99 Names of Allah'**
  String get libraryModuleNames;

  /// No description provided for @libraryModuleNamesSub.
  ///
  /// In en, this message translates to:
  /// **'Learn and reflect on Asma ul-Husna'**
  String get libraryModuleNamesSub;

  /// No description provided for @libraryModulePillarsIslam.
  ///
  /// In en, this message translates to:
  /// **'Pillars of Islam'**
  String get libraryModulePillarsIslam;

  /// No description provided for @libraryModulePillarsIslamSub.
  ///
  /// In en, this message translates to:
  /// **'The five foundations of faith in action'**
  String get libraryModulePillarsIslamSub;

  /// No description provided for @libraryModulePillarsIman.
  ///
  /// In en, this message translates to:
  /// **'Pillars of Iman'**
  String get libraryModulePillarsIman;

  /// No description provided for @libraryModulePillarsImanSub.
  ///
  /// In en, this message translates to:
  /// **'The six articles of belief'**
  String get libraryModulePillarsImanSub;

  /// No description provided for @libraryModuleProphets.
  ///
  /// In en, this message translates to:
  /// **'Prophet Muhammad'**
  String get libraryModuleProphets;

  /// No description provided for @libraryModuleProphetsSub.
  ///
  /// In en, this message translates to:
  /// **'His life, mission, and timeless lessons'**
  String get libraryModuleProphetsSub;

  /// No description provided for @libraryModuleOccasions.
  ///
  /// In en, this message translates to:
  /// **'Islamic Occasions'**
  String get libraryModuleOccasions;

  /// No description provided for @libraryModuleOccasionsSub.
  ///
  /// In en, this message translates to:
  /// **'Ramadan, Eid, Hajj, and sacred days'**
  String get libraryModuleOccasionsSub;

  /// No description provided for @libraryKeyLesson.
  ///
  /// In en, this message translates to:
  /// **'Key lesson'**
  String get libraryKeyLesson;

  /// No description provided for @libraryCardProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String libraryCardProgress(int current, int total);

  /// No description provided for @libraryPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get libraryPrevious;

  /// No description provided for @libraryNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get libraryNext;

  /// No description provided for @libraryBookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get libraryBookmark;

  /// No description provided for @libraryCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get libraryCopy;

  /// No description provided for @libraryShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get libraryShare;

  /// No description provided for @libraryCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get libraryCopied;

  /// No description provided for @libraryShareCopiedHint.
  ///
  /// In en, this message translates to:
  /// **'Copied — paste to share'**
  String get libraryShareCopiedHint;

  /// No description provided for @libraryShareReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get libraryShareReference;

  /// No description provided for @contentShareIntro.
  ///
  /// In en, this message translates to:
  /// **'Hey there! 👋 Check out DeenFocus — an app for Quran, Salah, and learning. I’m sharing this content from the app with you. 🤍'**
  String get contentShareIntro;

  /// No description provided for @contentShareExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore DeenFocus:'**
  String get contentShareExplore;

  /// No description provided for @contentShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t share right now. Please try again.'**
  String get contentShareFailed;

  /// No description provided for @libraryBookmarkSaved.
  ///
  /// In en, this message translates to:
  /// **'Bookmark saved'**
  String get libraryBookmarkSaved;

  /// No description provided for @libraryBookmarkRemoved.
  ///
  /// In en, this message translates to:
  /// **'Bookmark removed'**
  String get libraryBookmarkRemoved;

  /// No description provided for @libraryTranslation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get libraryTranslation;

  /// No description provided for @libraryTransliteration.
  ///
  /// In en, this message translates to:
  /// **'Transliteration'**
  String get libraryTransliteration;

  /// No description provided for @libraryMeaning.
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get libraryMeaning;

  /// No description provided for @libraryBookmarksTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved learning items'**
  String get libraryBookmarksTitle;

  /// No description provided for @libraryBookmarksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hadith, duas, names, fiqh, and more'**
  String get libraryBookmarksSubtitle;

  /// No description provided for @libraryBookmarksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No saved items yet. Tap Bookmark on any learning item to save it here.'**
  String get libraryBookmarksEmpty;

  /// No description provided for @libraryMarkCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark completed'**
  String get libraryMarkCompleted;

  /// No description provided for @librarySectionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get librarySectionCompleted;

  /// No description provided for @libraryReflection.
  ///
  /// In en, this message translates to:
  /// **'Reflection'**
  String get libraryReflection;

  /// No description provided for @libraryComingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get libraryComingSoonTitle;

  /// No description provided for @libraryComingSoonBody.
  ///
  /// In en, this message translates to:
  /// **'This module is being prepared. Check back in a future update.'**
  String get libraryComingSoonBody;

  /// No description provided for @librarySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search…'**
  String get librarySearchHint;

  /// No description provided for @libraryHubSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search Learning…'**
  String get libraryHubSearchHint;

  /// No description provided for @libraryHubSearchSections.
  ///
  /// In en, this message translates to:
  /// **'Sections'**
  String get libraryHubSearchSections;

  /// No description provided for @libraryHubSearchTopics.
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get libraryHubSearchTopics;

  /// No description provided for @librarySearchEmpty.
  ///
  /// In en, this message translates to:
  /// **'No matching items'**
  String get librarySearchEmpty;

  /// No description provided for @libraryItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String libraryItemCount(int count);

  /// No description provided for @librarySearchResultCount.
  ///
  /// In en, this message translates to:
  /// **'{shown} of {total}'**
  String librarySearchResultCount(int shown, int total);

  /// No description provided for @libraryContinueFrom.
  ///
  /// In en, this message translates to:
  /// **'Continue · {number}'**
  String libraryContinueFrom(int number);

  /// No description provided for @libraryInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get libraryInProgress;

  /// No description provided for @libraryReference.
  ///
  /// In en, this message translates to:
  /// **'Reference: {source}'**
  String libraryReference(String source);

  /// No description provided for @libraryDuaCount.
  ///
  /// In en, this message translates to:
  /// **'{count} duas'**
  String libraryDuaCount(int count);

  /// No description provided for @libraryDuaCategoryMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get libraryDuaCategoryMorning;

  /// No description provided for @libraryDuaCategoryEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get libraryDuaCategoryEvening;

  /// No description provided for @libraryDuaCategoryDailyLife.
  ///
  /// In en, this message translates to:
  /// **'Daily Life'**
  String get libraryDuaCategoryDailyLife;

  /// No description provided for @libraryDuaCategorySleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get libraryDuaCategorySleep;

  /// No description provided for @libraryDuaCategoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get libraryDuaCategoryFood;

  /// No description provided for @libraryDuaCategoryTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get libraryDuaCategoryTravel;

  /// No description provided for @libraryDuaCategoryIllness.
  ///
  /// In en, this message translates to:
  /// **'Illness'**
  String get libraryDuaCategoryIllness;

  /// No description provided for @libraryDuaCategoryProtection.
  ///
  /// In en, this message translates to:
  /// **'Protection'**
  String get libraryDuaCategoryProtection;

  /// No description provided for @libraryDuaCategoryForgiveness.
  ///
  /// In en, this message translates to:
  /// **'Forgiveness'**
  String get libraryDuaCategoryForgiveness;

  /// No description provided for @libraryDuaCategoryParents.
  ///
  /// In en, this message translates to:
  /// **'Parents'**
  String get libraryDuaCategoryParents;

  /// No description provided for @libraryHadithCount.
  ///
  /// In en, this message translates to:
  /// **'{count} hadith'**
  String libraryHadithCount(int count);

  /// No description provided for @libraryHadithNarrator.
  ///
  /// In en, this message translates to:
  /// **'Narrator:'**
  String get libraryHadithNarrator;

  /// No description provided for @libraryHadithSource.
  ///
  /// In en, this message translates to:
  /// **'Source:'**
  String get libraryHadithSource;

  /// No description provided for @libraryHadithCollectionBukhari.
  ///
  /// In en, this message translates to:
  /// **'Sahih al-Bukhari'**
  String get libraryHadithCollectionBukhari;

  /// No description provided for @libraryHadithCollectionMuslim.
  ///
  /// In en, this message translates to:
  /// **'Sahih Muslim'**
  String get libraryHadithCollectionMuslim;

  /// No description provided for @libraryHadithCollectionRiyad.
  ///
  /// In en, this message translates to:
  /// **'Riyad us-Saliheen'**
  String get libraryHadithCollectionRiyad;

  /// No description provided for @libraryHadithCollectionNawawi.
  ///
  /// In en, this message translates to:
  /// **'40 Hadith Nawawi'**
  String get libraryHadithCollectionNawawi;

  /// No description provided for @libraryHadithCollectionHisnul.
  ///
  /// In en, this message translates to:
  /// **'Hisnul Muslim'**
  String get libraryHadithCollectionHisnul;

  /// No description provided for @libraryGuideStepCount.
  ///
  /// In en, this message translates to:
  /// **'{count} steps'**
  String libraryGuideStepCount(int count);

  /// No description provided for @libraryGuideStepLabel.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String libraryGuideStepLabel(int current, int total);

  /// No description provided for @libraryGuideWudu.
  ///
  /// In en, this message translates to:
  /// **'Wudu'**
  String get libraryGuideWudu;

  /// No description provided for @libraryGuideSalah.
  ///
  /// In en, this message translates to:
  /// **'Salah'**
  String get libraryGuideSalah;

  /// No description provided for @libraryGuideGhusl.
  ///
  /// In en, this message translates to:
  /// **'Ghusl'**
  String get libraryGuideGhusl;

  /// No description provided for @libraryGuideTayammum.
  ///
  /// In en, this message translates to:
  /// **'Tayammum'**
  String get libraryGuideTayammum;

  /// No description provided for @libraryGuideJanazah.
  ///
  /// In en, this message translates to:
  /// **'Janazah Prayer'**
  String get libraryGuideJanazah;

  /// No description provided for @libraryGuideUmrah.
  ///
  /// In en, this message translates to:
  /// **'Umrah'**
  String get libraryGuideUmrah;

  /// No description provided for @libraryGuideHajj.
  ///
  /// In en, this message translates to:
  /// **'Hajj'**
  String get libraryGuideHajj;

  /// No description provided for @libraryGuideFasting.
  ///
  /// In en, this message translates to:
  /// **'Fasting'**
  String get libraryGuideFasting;

  /// No description provided for @libraryGuideZakat.
  ///
  /// In en, this message translates to:
  /// **'Zakat'**
  String get libraryGuideZakat;

  /// No description provided for @libraryGuideTawbah.
  ///
  /// In en, this message translates to:
  /// **'Tawbah'**
  String get libraryGuideTawbah;

  /// No description provided for @libraryOccasionImportance.
  ///
  /// In en, this message translates to:
  /// **'Importance'**
  String get libraryOccasionImportance;

  /// No description provided for @libraryOccasionVirtues.
  ///
  /// In en, this message translates to:
  /// **'Virtues'**
  String get libraryOccasionVirtues;

  /// No description provided for @libraryOccasionRecommendedActs.
  ///
  /// In en, this message translates to:
  /// **'Recommended acts'**
  String get libraryOccasionRecommendedActs;

  /// No description provided for @libraryFiqhOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get libraryFiqhOverview;

  /// No description provided for @libraryFiqhKeyPoints.
  ///
  /// In en, this message translates to:
  /// **'Key points'**
  String get libraryFiqhKeyPoints;

  /// No description provided for @libraryFiqhDifferences.
  ///
  /// In en, this message translates to:
  /// **'Notable differences'**
  String get libraryFiqhDifferences;

  /// No description provided for @libraryFiqhCommonGround.
  ///
  /// In en, this message translates to:
  /// **'Common ground'**
  String get libraryFiqhCommonGround;

  /// No description provided for @insightsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get insightsCompleted;

  /// No description provided for @insightsInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get insightsInProgress;

  /// No description provided for @insightsKeepGoingTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep going!'**
  String get insightsKeepGoingTitle;

  /// No description provided for @insightsKeepGoingBody.
  ///
  /// In en, this message translates to:
  /// **'You\'re making great progress. Every prayer counts.'**
  String get insightsKeepGoingBody;

  /// No description provided for @insightsAchievementsUnlockedLabel.
  ///
  /// In en, this message translates to:
  /// **'Achievements Unlocked'**
  String get insightsAchievementsUnlockedLabel;

  /// No description provided for @insightsAchievementsCount.
  ///
  /// In en, this message translates to:
  /// **'{unlocked} / {total}'**
  String insightsAchievementsCount(int unlocked, int total);

  /// No description provided for @achievementDescFirstPrayer.
  ///
  /// In en, this message translates to:
  /// **'Prayed your first prayer.'**
  String get achievementDescFirstPrayer;

  /// No description provided for @achievementDescSevenPrayerStreak.
  ///
  /// In en, this message translates to:
  /// **'Complete 7 prayers in a row.'**
  String get achievementDescSevenPrayerStreak;

  /// No description provided for @achievementDescThirtyPrayerStreak.
  ///
  /// In en, this message translates to:
  /// **'Complete 30 prayers in a row.'**
  String get achievementDescThirtyPrayerStreak;

  /// No description provided for @achievementDescFajrWarrior.
  ///
  /// In en, this message translates to:
  /// **'Pray Fajr on 14 days.'**
  String get achievementDescFajrWarrior;

  /// No description provided for @achievementDescFajrChampion.
  ///
  /// In en, this message translates to:
  /// **'Pray Fajr on 30 days.'**
  String get achievementDescFajrChampion;

  /// No description provided for @achievementDescFiveADay.
  ///
  /// In en, this message translates to:
  /// **'Complete all five prayers in one day.'**
  String get achievementDescFiveADay;

  /// No description provided for @achievementDescPerfectWeek.
  ///
  /// In en, this message translates to:
  /// **'Complete every prayer for 7 days in a row.'**
  String get achievementDescPerfectWeek;

  /// No description provided for @achievementDescPerfectMonth.
  ///
  /// In en, this message translates to:
  /// **'Complete every prayer for 30 days in a row.'**
  String get achievementDescPerfectMonth;

  /// No description provided for @achievementDescQuranReader.
  ///
  /// In en, this message translates to:
  /// **'Read Quran on 7 days.'**
  String get achievementDescQuranReader;

  /// No description provided for @achievementDescQuranDevotee.
  ///
  /// In en, this message translates to:
  /// **'Read Quran on 30 days.'**
  String get achievementDescQuranDevotee;

  /// No description provided for @achievementDescDhikrStarter.
  ///
  /// In en, this message translates to:
  /// **'Complete dhikr on 7 days.'**
  String get achievementDescDhikrStarter;

  /// No description provided for @achievementDescDhikrMaster.
  ///
  /// In en, this message translates to:
  /// **'Complete dhikr on 30 days.'**
  String get achievementDescDhikrMaster;

  /// No description provided for @achievementDescNightWorshipper.
  ///
  /// In en, this message translates to:
  /// **'Pray Tahajjud on 7 days.'**
  String get achievementDescNightWorshipper;

  /// No description provided for @achievementDescMasjidCompanion.
  ///
  /// In en, this message translates to:
  /// **'Visit the masjid 7 times.'**
  String get achievementDescMasjidCompanion;

  /// No description provided for @achievementDescDistractionDefender.
  ///
  /// In en, this message translates to:
  /// **'Stay distraction-free for 7 days.'**
  String get achievementDescDistractionDefender;

  /// No description provided for @achievementDescCycleGuardian.
  ///
  /// In en, this message translates to:
  /// **'Protect your streak with Cycle Mode for 7 days.'**
  String get achievementDescCycleGuardian;

  /// No description provided for @achievementDescProtectedMonth.
  ///
  /// In en, this message translates to:
  /// **'Protect your streak with Cycle Mode for 30 days.'**
  String get achievementDescProtectedMonth;

  /// No description provided for @achievementDescConsistencyChampion.
  ///
  /// In en, this message translates to:
  /// **'Stay consistent for 100 days.'**
  String get achievementDescConsistencyChampion;

  /// No description provided for @achievementDescSixMonthJourney.
  ///
  /// In en, this message translates to:
  /// **'Keep going for 180 days.'**
  String get achievementDescSixMonthJourney;

  /// No description provided for @achievementDescDeenFocusMaster.
  ///
  /// In en, this message translates to:
  /// **'Reach DeenFocus Master (Level 15).'**
  String get achievementDescDeenFocusMaster;

  /// No description provided for @dailyChecklistOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get dailyChecklistOptional;

  /// No description provided for @dailyChecklistIstighfar.
  ///
  /// In en, this message translates to:
  /// **'Istighfar'**
  String get dailyChecklistIstighfar;

  /// No description provided for @dailyChecklistSalawat.
  ///
  /// In en, this message translates to:
  /// **'Salawat / Durood'**
  String get dailyChecklistSalawat;

  /// No description provided for @dailyChecklistControlAngerSpeakKindly.
  ///
  /// In en, this message translates to:
  /// **'Control anger / Speak kindly'**
  String get dailyChecklistControlAngerSpeakKindly;

  /// No description provided for @digitalBalanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Digital Balance'**
  String get digitalBalanceTitle;

  /// No description provided for @digitalBalanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See where your time is going'**
  String get digitalBalanceSubtitle;

  /// No description provided for @digitalBalanceViewCta.
  ///
  /// In en, this message translates to:
  /// **'View Digital Balance →'**
  String get digitalBalanceViewCta;

  /// No description provided for @digitalBalanceTodayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get digitalBalanceTodayLabel;

  /// No description provided for @digitalBalanceDeenFocus.
  ///
  /// In en, this message translates to:
  /// **'DeenFocus'**
  String get digitalBalanceDeenFocus;

  /// No description provided for @digitalBalanceOtherApps.
  ///
  /// In en, this message translates to:
  /// **'Other apps'**
  String get digitalBalanceOtherApps;

  /// No description provided for @digitalBalanceTodayPhoneTime.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Phone Time'**
  String get digitalBalanceTodayPhoneTime;

  /// No description provided for @digitalBalanceWhereTimeGoes.
  ///
  /// In en, this message translates to:
  /// **'Where Your Time Goes'**
  String get digitalBalanceWhereTimeGoes;

  /// No description provided for @digitalBalanceViewAllApps.
  ///
  /// In en, this message translates to:
  /// **'View All Apps'**
  String get digitalBalanceViewAllApps;

  /// No description provided for @digitalBalanceAllAppsTitle.
  ///
  /// In en, this message translates to:
  /// **'All Apps'**
  String get digitalBalanceAllAppsTitle;

  /// No description provided for @digitalBalanceNoApps.
  ///
  /// In en, this message translates to:
  /// **'No app usage recorded for today yet.'**
  String get digitalBalanceNoApps;

  /// No description provided for @digitalBalanceDeenVsDigital.
  ///
  /// In en, this message translates to:
  /// **'Deen vs. Digital Time'**
  String get digitalBalanceDeenVsDigital;

  /// No description provided for @digitalBalanceYourWeek.
  ///
  /// In en, this message translates to:
  /// **'Your Week'**
  String get digitalBalanceYourWeek;

  /// No description provided for @digitalBalanceThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get digitalBalanceThisWeek;

  /// No description provided for @digitalBalancePhoneUsageLegend.
  ///
  /// In en, this message translates to:
  /// **'Phone usage'**
  String get digitalBalancePhoneUsageLegend;

  /// No description provided for @digitalBalanceDailyInsight.
  ///
  /// In en, this message translates to:
  /// **'Daily Insight'**
  String get digitalBalanceDailyInsight;

  /// No description provided for @digitalBalanceInsightKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Every minute spent strengthening your Deen matters.'**
  String get digitalBalanceInsightKeepGoing;

  /// No description provided for @digitalBalanceInsightWeekHigher.
  ///
  /// In en, this message translates to:
  /// **'Your DeenFocus time is higher this week than last week. MashaAllah!'**
  String get digitalBalanceInsightWeekHigher;

  /// No description provided for @digitalBalanceInsightQuietDay.
  ///
  /// In en, this message translates to:
  /// **'A quiet day so far. Time in DeenFocus will appear here.'**
  String get digitalBalanceInsightQuietDay;

  /// No description provided for @digitalBalanceGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Deen Time Goal'**
  String get digitalBalanceGoalTitle;

  /// No description provided for @digitalBalanceAdjustGoal.
  ///
  /// In en, this message translates to:
  /// **'Adjust Goal'**
  String get digitalBalanceAdjustGoal;

  /// No description provided for @digitalBalanceGoalReached.
  ///
  /// In en, this message translates to:
  /// **'You reached today\'s Deen time goal. MashaAllah!'**
  String get digitalBalanceGoalReached;

  /// No description provided for @digitalBalanceGoalSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Deen time'**
  String get digitalBalanceGoalSheetTitle;

  /// No description provided for @digitalBalanceGoalCustomHint.
  ///
  /// In en, this message translates to:
  /// **'Minutes per day'**
  String get digitalBalanceGoalCustomHint;

  /// No description provided for @digitalBalanceGoalSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get digitalBalanceGoalSave;

  /// No description provided for @digitalBalanceGoal15.
  ///
  /// In en, this message translates to:
  /// **'15 min'**
  String get digitalBalanceGoal15;

  /// No description provided for @digitalBalanceGoal30.
  ///
  /// In en, this message translates to:
  /// **'30 min'**
  String get digitalBalanceGoal30;

  /// No description provided for @digitalBalanceGoal45.
  ///
  /// In en, this message translates to:
  /// **'45 min'**
  String get digitalBalanceGoal45;

  /// No description provided for @digitalBalanceGoal60.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get digitalBalanceGoal60;

  /// No description provided for @digitalBalancePermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Understand Your Digital Habits'**
  String get digitalBalancePermissionTitle;

  /// No description provided for @digitalBalancePermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Allow DeenFocus to access your app usage information so you can see where your time goes and how much time you\'re giving to your Deen.'**
  String get digitalBalancePermissionBody;

  /// No description provided for @digitalBalanceEnableUsage.
  ///
  /// In en, this message translates to:
  /// **'Enable App Usage'**
  String get digitalBalanceEnableUsage;

  /// No description provided for @digitalBalanceMaybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get digitalBalanceMaybeLater;

  /// No description provided for @digitalBalanceUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'App usage isn\'t available here'**
  String get digitalBalanceUnavailableTitle;

  /// No description provided for @digitalBalanceUnavailableBody.
  ///
  /// In en, this message translates to:
  /// **'Apple does not let DeenFocus read other apps\' Screen Time on this iPhone, so Digital Balance cannot show usage totals yet. Your prayers, streaks, Focus blocking, and DeenFocus insights still work as usual.'**
  String get digitalBalanceUnavailableBody;

  /// No description provided for @digitalBalanceInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'About Digital Balance'**
  String get digitalBalanceInfoTitle;

  /// No description provided for @digitalBalanceInfoBody.
  ///
  /// In en, this message translates to:
  /// **'Digital Balance helps you see where your time is going and how much of it you\'re giving to your Deen. Usage stays on your device.'**
  String get digitalBalanceInfoBody;

  /// No description provided for @digitalBalanceDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m'**
  String digitalBalanceDurationMinutes(int minutes);

  /// No description provided for @digitalBalanceDurationHours.
  ///
  /// In en, this message translates to:
  /// **'{hours}h'**
  String digitalBalanceDurationHours(int hours);

  /// No description provided for @digitalBalanceDurationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String digitalBalanceDurationHoursMinutes(int hours, int minutes);

  /// No description provided for @digitalBalancePercentShort.
  ///
  /// In en, this message translates to:
  /// **'DeenFocus · {percent}% of phone time'**
  String digitalBalancePercentShort(int percent);

  /// No description provided for @digitalBalancePercentOfPhoneTime.
  ///
  /// In en, this message translates to:
  /// **'DeenFocus = {percent}% of your phone time'**
  String digitalBalancePercentOfPhoneTime(int percent);

  /// No description provided for @digitalBalancePercentToday.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of today\'s phone time'**
  String digitalBalancePercentToday(int percent);

  /// No description provided for @digitalBalanceRingLabel.
  ///
  /// In en, this message translates to:
  /// **'{percent}%\nDeenFocus'**
  String digitalBalanceRingLabel(int percent);

  /// No description provided for @digitalBalanceWeekMoreDeen.
  ///
  /// In en, this message translates to:
  /// **'↑ {percent}% more DeenFocus time than last week'**
  String digitalBalanceWeekMoreDeen(int percent);

  /// No description provided for @digitalBalanceInsightTimeToday.
  ///
  /// In en, this message translates to:
  /// **'You spent {duration} in DeenFocus today. Keep building the habit.'**
  String digitalBalanceInsightTimeToday(String duration);

  /// No description provided for @digitalBalanceInsightIncreasedYesterday.
  ///
  /// In en, this message translates to:
  /// **'Your DeenFocus time increased by {percent}% compared with yesterday.'**
  String digitalBalanceInsightIncreasedYesterday(int percent);

  /// No description provided for @digitalBalanceGoalPerDay.
  ///
  /// In en, this message translates to:
  /// **'{goal} / day'**
  String digitalBalanceGoalPerDay(String goal);

  /// No description provided for @digitalBalanceGoalProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} / {goal}'**
  String digitalBalanceGoalProgress(String current, String goal);

  /// No description provided for @digitalBalanceMinutesToGoal.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes to reach today\'s goal'**
  String digitalBalanceMinutesToGoal(int minutes);

  /// No description provided for @tajweedPracticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Tajweed Practice'**
  String get tajweedPracticeTitle;

  /// No description provided for @tajweedPracticeAyahTitle.
  ///
  /// In en, this message translates to:
  /// **'{surah} · {ref}'**
  String tajweedPracticeAyahTitle(String surah, String ref);

  /// No description provided for @tajweedDownloadTitle.
  ///
  /// In en, this message translates to:
  /// **'Preparing AI model'**
  String get tajweedDownloadTitle;

  /// No description provided for @tajweedDownloadFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not prepare AI model'**
  String get tajweedDownloadFailedTitle;

  /// No description provided for @tajweedDownloadBody.
  ///
  /// In en, this message translates to:
  /// **'One-time download so Tajweed practice works fully offline afterwards. This only happens once.'**
  String get tajweedDownloadBody;

  /// No description provided for @tajweedDownloadFinishing.
  ///
  /// In en, this message translates to:
  /// **'Finishing setup…'**
  String get tajweedDownloadFinishing;

  /// No description provided for @tajweedDownloadCanLeave.
  ///
  /// In en, this message translates to:
  /// **'You can leave this screen — the download continues in the background.'**
  String get tajweedDownloadCanLeave;

  /// No description provided for @tajweedDownloadTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tajweedDownloadTryAgain;

  /// No description provided for @tajweedDownloadPleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again.'**
  String get tajweedDownloadPleaseTryAgain;

  /// No description provided for @tajweedErrorFeatureDisabled.
  ///
  /// In en, this message translates to:
  /// **'AI Tajweed practice is turned off. Enable it in Settings first.'**
  String get tajweedErrorFeatureDisabled;

  /// No description provided for @tajweedErrorModelMissing.
  ///
  /// In en, this message translates to:
  /// **'The AI model is not installed yet.'**
  String get tajweedErrorModelMissing;

  /// No description provided for @tajweedErrorModelDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Downloading the AI model failed. Check your connection and try again.'**
  String get tajweedErrorModelDownloadFailed;

  /// No description provided for @tajweedErrorModelLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'The AI model could not be loaded on this device.'**
  String get tajweedErrorModelLoadFailed;

  /// No description provided for @tajweedErrorCouldNotPrepare.
  ///
  /// In en, this message translates to:
  /// **'Could not prepare the AI model.'**
  String get tajweedErrorCouldNotPrepare;

  /// No description provided for @tajweedErrorUnsupported.
  ///
  /// In en, this message translates to:
  /// **'AI Tajweed practice is not available on this device.'**
  String get tajweedErrorUnsupported;

  /// No description provided for @sharePromoTitle.
  ///
  /// In en, this message translates to:
  /// **'Check out this on DeenFocus 🌙'**
  String get sharePromoTitle;

  /// No description provided for @sharePromoBody.
  ///
  /// In en, this message translates to:
  /// **'A simple app to help you stay focused on your Deen, pray on time and build better habits.'**
  String get sharePromoBody;

  /// No description provided for @sharePromoDownloadHeading.
  ///
  /// In en, this message translates to:
  /// **'Download DeenFocus:'**
  String get sharePromoDownloadHeading;

  /// No description provided for @sharePromoAppStoreLine.
  ///
  /// In en, this message translates to:
  /// **'🍎 App Store: {url}'**
  String sharePromoAppStoreLine(String url);

  /// No description provided for @sharePromoPlayStoreLine.
  ///
  /// In en, this message translates to:
  /// **'🤖 Google Play: {url}'**
  String sharePromoPlayStoreLine(String url);

  /// No description provided for @shareBrandName.
  ///
  /// In en, this message translates to:
  /// **'DeenFocus'**
  String get shareBrandName;

  /// No description provided for @shareBrandTagline.
  ///
  /// In en, this message translates to:
  /// **'Your companion for a better Deen, every day.'**
  String get shareBrandTagline;

  /// No description provided for @shareDownloadCta.
  ///
  /// In en, this message translates to:
  /// **'Download DeenFocus'**
  String get shareDownloadCta;

  /// No description provided for @shareAppStoreBadge.
  ///
  /// In en, this message translates to:
  /// **'App Store'**
  String get shareAppStoreBadge;

  /// No description provided for @sharePlayStoreBadge.
  ///
  /// In en, this message translates to:
  /// **'Google Play'**
  String get sharePlayStoreBadge;

  /// No description provided for @shareFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to share. Please try again.'**
  String get shareFailed;

  /// No description provided for @insightsRatio.
  ///
  /// In en, this message translates to:
  /// **'{done} / {possible}'**
  String insightsRatio(int done, int possible);

  /// No description provided for @insightsCompactRatio.
  ///
  /// In en, this message translates to:
  /// **'{done}/{possible}'**
  String insightsCompactRatio(int done, int possible);

  /// No description provided for @insightsPercent.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String insightsPercent(int value);

  /// No description provided for @insightsFocusScoreValue.
  ///
  /// In en, this message translates to:
  /// **'{score} / 100'**
  String insightsFocusScoreValue(int score);

  /// No description provided for @insightsWeekNumber.
  ///
  /// In en, this message translates to:
  /// **'W{week}'**
  String insightsWeekNumber(int week);

  /// No description provided for @insightsLevelName1.
  ///
  /// In en, this message translates to:
  /// **'New Beginning'**
  String get insightsLevelName1;

  /// No description provided for @insightsLevelName2.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get insightsLevelName2;

  /// No description provided for @insightsLevelName3.
  ///
  /// In en, this message translates to:
  /// **'Building the Habit'**
  String get insightsLevelName3;

  /// No description provided for @insightsLevelName4.
  ///
  /// In en, this message translates to:
  /// **'Steady Worshipper'**
  String get insightsLevelName4;

  /// No description provided for @insightsLevelName5.
  ///
  /// In en, this message translates to:
  /// **'Consistent Heart'**
  String get insightsLevelName5;

  /// No description provided for @insightsLevelName6.
  ///
  /// In en, this message translates to:
  /// **'Prayer Keeper'**
  String get insightsLevelName6;

  /// No description provided for @insightsLevelName7.
  ///
  /// In en, this message translates to:
  /// **'Dedicated Servant'**
  String get insightsLevelName7;

  /// No description provided for @insightsLevelName8.
  ///
  /// In en, this message translates to:
  /// **'Strong Routine'**
  String get insightsLevelName8;

  /// No description provided for @insightsLevelName9.
  ///
  /// In en, this message translates to:
  /// **'Devoted Worshipper'**
  String get insightsLevelName9;

  /// No description provided for @insightsLevelName10.
  ///
  /// In en, this message translates to:
  /// **'Steadfast'**
  String get insightsLevelName10;

  /// No description provided for @insightsLevelName11.
  ///
  /// In en, this message translates to:
  /// **'Deepening Faith'**
  String get insightsLevelName11;

  /// No description provided for @insightsLevelName12.
  ///
  /// In en, this message translates to:
  /// **'Strong Consistency'**
  String get insightsLevelName12;

  /// No description provided for @insightsLevelName13.
  ///
  /// In en, this message translates to:
  /// **'Devotion Leader'**
  String get insightsLevelName13;

  /// No description provided for @insightsLevelName14.
  ///
  /// In en, this message translates to:
  /// **'Exceptional Consistency'**
  String get insightsLevelName14;

  /// No description provided for @insightsLevelName15.
  ///
  /// In en, this message translates to:
  /// **'DeenFocus Master'**
  String get insightsLevelName15;

  /// No description provided for @lockScreenOptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Lock Screen Style'**
  String get lockScreenOptionsTitle;

  /// No description provided for @lockScreenOptionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how prayer reminders appear'**
  String get lockScreenOptionsSubtitle;

  /// No description provided for @lockScreenOptionsHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a style to open the full-screen layout.'**
  String get lockScreenOptionsHint;

  /// No description provided for @lockScreenDefaultBadge.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get lockScreenDefaultBadge;

  /// No description provided for @lockScreenSelectedBadge.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get lockScreenSelectedBadge;

  /// No description provided for @lockScreenPreviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get lockScreenPreviewLabel;

  /// No description provided for @lockScreenStyleClassic.
  ///
  /// In en, this message translates to:
  /// **'Prayer reminder'**
  String get lockScreenStyleClassic;

  /// No description provided for @lockScreenStyleTasbih.
  ///
  /// In en, this message translates to:
  /// **'Tasbih counter'**
  String get lockScreenStyleTasbih;

  /// No description provided for @lockScreenStyleVerse.
  ///
  /// In en, this message translates to:
  /// **'Daily verse'**
  String get lockScreenStyleVerse;

  /// No description provided for @lockScreenStyleDua.
  ///
  /// In en, this message translates to:
  /// **'Daily du\'a'**
  String get lockScreenStyleDua;

  /// No description provided for @lockScreenStyleQuiz.
  ///
  /// In en, this message translates to:
  /// **'Knowledge check'**
  String get lockScreenStyleQuiz;

  /// No description provided for @lockScreenStyleTimes.
  ///
  /// In en, this message translates to:
  /// **'Prayer times'**
  String get lockScreenStyleTimes;

  /// No description provided for @lockScreenStyleCountdown.
  ///
  /// In en, this message translates to:
  /// **'Countdown'**
  String get lockScreenStyleCountdown;

  /// No description provided for @lockScreenStyleHold.
  ///
  /// In en, this message translates to:
  /// **'Hold to confirm'**
  String get lockScreenStyleHold;

  /// No description provided for @lockScreenStyleType.
  ///
  /// In en, this message translates to:
  /// **'Type to confirm'**
  String get lockScreenStyleType;

  /// No description provided for @lockScreenStyleMinimal.
  ///
  /// In en, this message translates to:
  /// **'Minimal Focus'**
  String get lockScreenStyleMinimal;

  /// No description provided for @lockScreenItsTimeToPray.
  ///
  /// In en, this message translates to:
  /// **'It\'s time to pray:'**
  String get lockScreenItsTimeToPray;

  /// No description provided for @lockScreenRemainingTime.
  ///
  /// In en, this message translates to:
  /// **'Remaining time: {time}'**
  String lockScreenRemainingTime(String time);

  /// No description provided for @lockScreenRemindLater.
  ///
  /// In en, this message translates to:
  /// **'Remind Me Later'**
  String get lockScreenRemindLater;

  /// No description provided for @lockScreenNextVerse.
  ///
  /// In en, this message translates to:
  /// **'Next verse'**
  String get lockScreenNextVerse;

  /// No description provided for @lockScreenVerseForToday.
  ///
  /// In en, this message translates to:
  /// **'Verse for today'**
  String get lockScreenVerseForToday;

  /// No description provided for @lockScreenDuaForToday.
  ///
  /// In en, this message translates to:
  /// **'Du\'a for today'**
  String get lockScreenDuaForToday;

  /// No description provided for @lockScreenTapToCount.
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere to count'**
  String get lockScreenTapToCount;

  /// No description provided for @lockScreenHoldHint.
  ///
  /// In en, this message translates to:
  /// **'Press and hold to confirm'**
  String get lockScreenHoldHint;

  /// No description provided for @lockScreenTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Type {word} to confirm'**
  String lockScreenTypeHint(String word);

  /// No description provided for @lockScreenTypeWord.
  ///
  /// In en, this message translates to:
  /// **'ALHAMDULILLAH'**
  String get lockScreenTypeWord;

  /// No description provided for @lockScreenConfirmBeforeAllah.
  ///
  /// In en, this message translates to:
  /// **'Confirm before Allah that you have prayed.'**
  String get lockScreenConfirmBeforeAllah;

  /// No description provided for @lockScreenQuizCategory.
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get lockScreenQuizCategory;

  /// No description provided for @lockScreenQuizQuestion.
  ///
  /// In en, this message translates to:
  /// **'How many daily prayers are obligatory?'**
  String get lockScreenQuizQuestion;

  /// No description provided for @lockScreenQuizA.
  ///
  /// In en, this message translates to:
  /// **'Three'**
  String get lockScreenQuizA;

  /// No description provided for @lockScreenQuizB.
  ///
  /// In en, this message translates to:
  /// **'Four'**
  String get lockScreenQuizB;

  /// No description provided for @lockScreenQuizC.
  ///
  /// In en, this message translates to:
  /// **'Five'**
  String get lockScreenQuizC;

  /// No description provided for @lockScreenQuizCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get lockScreenQuizCorrect;

  /// No description provided for @lockScreenQuizIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get lockScreenQuizIncorrect;

  /// No description provided for @lockScreenQuizComplete.
  ///
  /// In en, this message translates to:
  /// **'Knowledge check complete'**
  String get lockScreenQuizComplete;

  /// No description provided for @lockScreenQuizCategoryFasting.
  ///
  /// In en, this message translates to:
  /// **'Fasting'**
  String get lockScreenQuizCategoryFasting;

  /// No description provided for @lockScreenQuizCategoryPillars.
  ///
  /// In en, this message translates to:
  /// **'Pillars'**
  String get lockScreenQuizCategoryPillars;

  /// No description provided for @lockScreenQuizQ2.
  ///
  /// In en, this message translates to:
  /// **'In which month do Muslims fast?'**
  String get lockScreenQuizQ2;

  /// No description provided for @lockScreenQuizQ2A.
  ///
  /// In en, this message translates to:
  /// **'Shawwal'**
  String get lockScreenQuizQ2A;

  /// No description provided for @lockScreenQuizQ2B.
  ///
  /// In en, this message translates to:
  /// **'Ramadan'**
  String get lockScreenQuizQ2B;

  /// No description provided for @lockScreenQuizQ2C.
  ///
  /// In en, this message translates to:
  /// **'Muharram'**
  String get lockScreenQuizQ2C;

  /// No description provided for @lockScreenQuizQ3.
  ///
  /// In en, this message translates to:
  /// **'Which is the first pillar of Islam?'**
  String get lockScreenQuizQ3;

  /// No description provided for @lockScreenQuizQ3A.
  ///
  /// In en, this message translates to:
  /// **'Salah'**
  String get lockScreenQuizQ3A;

  /// No description provided for @lockScreenQuizQ3B.
  ///
  /// In en, this message translates to:
  /// **'Shahada'**
  String get lockScreenQuizQ3B;

  /// No description provided for @lockScreenQuizQ3C.
  ///
  /// In en, this message translates to:
  /// **'Hajj'**
  String get lockScreenQuizQ3C;

  /// No description provided for @lockScreenTimeUp.
  ///
  /// In en, this message translates to:
  /// **'Time\'s up'**
  String get lockScreenTimeUp;

  /// No description provided for @lockScreenHoldRelease.
  ///
  /// In en, this message translates to:
  /// **'Keep holding to confirm'**
  String get lockScreenHoldRelease;

  /// No description provided for @lockScreenCountProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String lockScreenCountProgress(int current, int total);

  /// No description provided for @lockScreenVerseTranslation.
  ///
  /// In en, this message translates to:
  /// **'So remember Me; I will remember you.'**
  String get lockScreenVerseTranslation;

  /// No description provided for @lockScreenVerseRef.
  ///
  /// In en, this message translates to:
  /// **'Quran 2:152'**
  String get lockScreenVerseRef;

  /// No description provided for @lockScreenDuaTransliteration.
  ///
  /// In en, this message translates to:
  /// **'Rabbana atina fid-dunya hasanah'**
  String get lockScreenDuaTransliteration;

  /// No description provided for @lockScreenDuaTranslation.
  ///
  /// In en, this message translates to:
  /// **'Our Lord, give us good in this world and good in the Hereafter.'**
  String get lockScreenDuaTranslation;

  /// No description provided for @lockScreenDuaSource.
  ///
  /// In en, this message translates to:
  /// **'Al-Baqarah 2:201'**
  String get lockScreenDuaSource;

  /// No description provided for @lockScreenSampleRemaining.
  ///
  /// In en, this message translates to:
  /// **'2h 34m'**
  String get lockScreenSampleRemaining;

  /// No description provided for @lockScreenDhikrAstaghfirullah.
  ///
  /// In en, this message translates to:
  /// **'Astaghfirullah'**
  String get lockScreenDhikrAstaghfirullah;

  /// No description provided for @lockScreenDhikrSubhanAllah.
  ///
  /// In en, this message translates to:
  /// **'SubhanAllah'**
  String get lockScreenDhikrSubhanAllah;

  /// No description provided for @lockScreenDhikrAlhamdulillah.
  ///
  /// In en, this message translates to:
  /// **'Alhamdulillah'**
  String get lockScreenDhikrAlhamdulillah;

  /// No description provided for @lockScreenDhikrAllahuAkbar.
  ///
  /// In en, this message translates to:
  /// **'Allahu Akbar'**
  String get lockScreenDhikrAllahuAkbar;

  /// No description provided for @homeTajweedPromoTitle.
  ///
  /// In en, this message translates to:
  /// **'Quran AI Tajweed'**
  String get homeTajweedPromoTitle;

  /// No description provided for @homeTajweedPromoBody.
  ///
  /// In en, this message translates to:
  /// **'Recite any verse and get instant AI feedback on your Tajweed.'**
  String get homeTajweedPromoBody;

  /// No description provided for @homeTajweedPromoCta.
  ///
  /// In en, this message translates to:
  /// **'Practice Tajweed'**
  String get homeTajweedPromoCta;

  /// No description provided for @homeTajweedPromoAiFeedback.
  ///
  /// In en, this message translates to:
  /// **'AI Feedback'**
  String get homeTajweedPromoAiFeedback;

  /// No description provided for @homeTajweedPromoWordAccuracy.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Word Accuracy'**
  String homeTajweedPromoWordAccuracy(int percent);

  /// No description provided for @homeLockScreenPromoTitle.
  ///
  /// In en, this message translates to:
  /// **'Lock Screen Styles'**
  String get homeLockScreenPromoTitle;

  /// No description provided for @homeLockScreenPromoBody.
  ///
  /// In en, this message translates to:
  /// **'Personalize your lock screen with beautiful Islamic designs and helpful reminders.'**
  String get homeLockScreenPromoBody;

  /// No description provided for @homeLockScreenPromoCta.
  ///
  /// In en, this message translates to:
  /// **'Explore Styles'**
  String get homeLockScreenPromoCta;

  /// No description provided for @homeFullScreenAlarmPromoTitle.
  ///
  /// In en, this message translates to:
  /// **'Full Screen AlarmKit at Prayer Time'**
  String get homeFullScreenAlarmPromoTitle;

  /// No description provided for @homeFullScreenAlarmPromoBody.
  ///
  /// In en, this message translates to:
  /// **'Stay on track with a calm, distraction-free full screen alert when it\'s time to pray.'**
  String get homeFullScreenAlarmPromoBody;

  /// No description provided for @homeFullScreenAlarmPromoCta.
  ///
  /// In en, this message translates to:
  /// **'Enable Prayer Alarms'**
  String get homeFullScreenAlarmPromoCta;

  /// No description provided for @homeFullScreenAlarmPromoSlideToStop.
  ///
  /// In en, this message translates to:
  /// **'Slide to stop'**
  String get homeFullScreenAlarmPromoSlideToStop;

  /// No description provided for @homePromoNewBadge.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get homePromoNewBadge;

  /// No description provided for @homeReadQuranPromoTitle.
  ///
  /// In en, this message translates to:
  /// **'Read Quran'**
  String get homeReadQuranPromoTitle;

  /// No description provided for @homeReadQuranPromoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read, listen & practice tajweed'**
  String get homeReadQuranPromoSubtitle;

  /// No description provided for @homeReadQuranPromoCta.
  ///
  /// In en, this message translates to:
  /// **'Open Quran'**
  String get homeReadQuranPromoCta;

  /// No description provided for @homeReadQuranPromoNewBadge.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get homeReadQuranPromoNewBadge;

  /// No description provided for @cycleModeActiveStatus.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Streak protected • Ends today} =1{Streak protected • Ends tomorrow} other{Streak protected • Ends in {days} days}}'**
  String cycleModeActiveStatus(int days);

  /// No description provided for @cycleModeProtectPrayerStreakSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep your streak intact during cycle days'**
  String get cycleModeProtectPrayerStreakSubtitle;

  /// No description provided for @cycleModeExcludeFromStatisticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Don\'t count cycle days in your prayer stats'**
  String get cycleModeExcludeFromStatisticsSubtitle;

  /// No description provided for @homePromoPreviewCity.
  ///
  /// In en, this message translates to:
  /// **'Lahore'**
  String get homePromoPreviewCity;

  /// No description provided for @focusScreenTimeAuthPasscodeRequired.
  ///
  /// In en, this message translates to:
  /// **'This iPhone needs a device passcode before Apple will allow Screen Time access. Set a passcode in iPhone Settings, then try again.'**
  String get focusScreenTimeAuthPasscodeRequired;

  /// No description provided for @focusScreenTimeAuthCanceled.
  ///
  /// In en, this message translates to:
  /// **'Screen Time access was canceled before Apple finished granting it. Please try again and complete the Apple prompt.'**
  String get focusScreenTimeAuthCanceled;

  /// No description provided for @focusScreenTimeAuthConflict.
  ///
  /// In en, this message translates to:
  /// **'Another app is already managing Family Controls on this iPhone. Turn that off first, then try again.'**
  String get focusScreenTimeAuthConflict;

  /// No description provided for @focusScreenTimeAuthInvalidAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in with a valid iCloud account on this iPhone, then try Screen Time access again.'**
  String get focusScreenTimeAuthInvalidAccount;

  /// No description provided for @focusScreenTimeAuthNetwork.
  ///
  /// In en, this message translates to:
  /// **'This iPhone needs an internet connection before Apple can grant Screen Time access.'**
  String get focusScreenTimeAuthNetwork;

  /// No description provided for @focusScreenTimeAuthRestricted.
  ///
  /// In en, this message translates to:
  /// **'Family Controls is restricted on this iPhone, so DeenFocus cannot request Screen Time access here.'**
  String get focusScreenTimeAuthRestricted;

  /// No description provided for @focusScreenTimeAuthUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Family Controls is currently unavailable on this iPhone.'**
  String get focusScreenTimeAuthUnavailable;

  /// No description provided for @focusScreenTimeAuthIosVersion.
  ///
  /// In en, this message translates to:
  /// **'Screen Time app blocking requires iOS 16 or later.'**
  String get focusScreenTimeAuthIosVersion;

  /// No description provided for @focusScreenTimeAuthInvalidArgument.
  ///
  /// In en, this message translates to:
  /// **'The Screen Time authorization request was invalid. Please try again.'**
  String get focusScreenTimeAuthInvalidArgument;

  /// No description provided for @focusScreenTimeAuthFailedGeneric.
  ///
  /// In en, this message translates to:
  /// **'Screen Time access could not be granted on this iPhone.'**
  String get focusScreenTimeAuthFailedGeneric;

  /// No description provided for @widgetLockCountdownHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'In {hours}h {minutes}m'**
  String widgetLockCountdownHoursMinutes(String hours, String minutes);

  /// No description provided for @widgetLockCountdownMinutes.
  ///
  /// In en, this message translates to:
  /// **'In {minutes}m'**
  String widgetLockCountdownMinutes(String minutes);

  /// No description provided for @lockScreenRecommendedBadge.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get lockScreenRecommendedBadge;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'az',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'it',
    'nl',
    'pt',
    'ro',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'az':
      return AppLocalizationsAz();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'nl':
      return AppLocalizationsNl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
