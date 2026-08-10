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
  /// **'Or enter your city'**
  String get locationManualEntry;

  /// No description provided for @locationPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Stays on your device'**
  String get locationPrivacyNote;

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
  /// **'2m'**
  String get notificationsPreviewMinutesAgo;

  /// No description provided for @notificationsPreviewHourAgo.
  ///
  /// In en, this message translates to:
  /// **'1h'**
  String get notificationsPreviewHourAgo;

  /// No description provided for @notificationsPreviewAdhanTitle.
  ///
  /// In en, this message translates to:
  /// **'Maghrib Adhan'**
  String get notificationsPreviewAdhanTitle;

  /// No description provided for @notificationsPreviewAdhanBody.
  ///
  /// In en, this message translates to:
  /// **'It\'s time to pray. Apps are paused.'**
  String get notificationsPreviewAdhanBody;

  /// No description provided for @notificationsPreviewDhikrTitle.
  ///
  /// In en, this message translates to:
  /// **'DAILY DHIKR'**
  String get notificationsPreviewDhikrTitle;

  /// No description provided for @notificationsPreviewDhikrBody.
  ///
  /// In en, this message translates to:
  /// **'SubhanAllah — take a minute to remember.'**
  String get notificationsPreviewDhikrBody;

  /// No description provided for @notificationsPreviewStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'STREAK'**
  String get notificationsPreviewStreakTitle;

  /// No description provided for @notificationsPreviewStreakBody.
  ///
  /// In en, this message translates to:
  /// **'7 days of complete prayers. Keep going!'**
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
  /// **'Prayer Streak'**
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
  /// **'\"Allah intends ease for you and does not intend hardship for you.\" — Quran 2:185'**
  String get cycleModeActiveTitle;

  /// No description provided for @cycleModeActiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'During this period, your prayer streak is protected. Your cycle days are highlighted in pink, and Cycle Mode turns off automatically when the cycle ends.'**
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
  /// **'Pause streaks'**
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
  /// **'Distraction control'**
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
  /// **'Support Us'**
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
  /// **'Quran'**
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

  /// No description provided for @quranSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search surah...'**
  String get quranSearchHint;

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
  /// **'Stay consistent. Stay mindful.\nStay connected to your Deen.'**
  String get settingsAboutFooter;

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
  /// **'Nearby Mosques'**
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
  /// **'Search radius: 5 km'**
  String get nearbyMosquesSearchRadius;

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
  /// **'No mosques found within 5 km'**
  String get nearbyMosquesNoneWithinRadius;

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
  /// **'Nothing listed within 5 km on OpenStreetMap for this spot. Try again later or move the map.'**
  String get nearbyMosquesEmptyHint;

  /// No description provided for @nearbyMosquesFoundWithin.
  ///
  /// In en, this message translates to:
  /// **'{count} mosques found within 5 km'**
  String nearbyMosquesFoundWithin(int count);

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
  /// **'Prayer streak'**
  String get insightsPrayerStreak;

  /// No description provided for @insightsPrayerStreakCount.
  ///
  /// In en, this message translates to:
  /// **'{count} prayers'**
  String insightsPrayerStreakCount(int count);

  /// No description provided for @insightsPrayersInARow.
  ///
  /// In en, this message translates to:
  /// **'Prayers in a row'**
  String get insightsPrayersInARow;

  /// No description provided for @insightsDaysInARow.
  ///
  /// In en, this message translates to:
  /// **'Days in a row'**
  String get insightsDaysInARow;

  /// No description provided for @insightsChipUpToday.
  ///
  /// In en, this message translates to:
  /// **'↑ +1'**
  String get insightsChipUpToday;

  /// No description provided for @insightsChipDayUp.
  ///
  /// In en, this message translates to:
  /// **'↑ +1 today'**
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
  /// **'You completed {done} out of {possible} prayers. Alhamdulillah — keep going!'**
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
  /// **'Current prayer streak'**
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
  /// **'First Prayer Streak'**
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
  /// **'Your prayer streak has increased'**
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
