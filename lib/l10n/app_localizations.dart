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

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'Prayer Mode. Child Mode. Sleep Mode.'**
  String get welcomeTagline;

  /// No description provided for @welcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Track your prayers, read the Quran, count Tasbih, and build meaningful streaks — all in one place.'**
  String get welcomeDescription;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
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

  /// No description provided for @salahTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasbih & Prayer Streaks'**
  String get salahTitle;

  /// No description provided for @salahSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A beautiful digital tasbih counter with dhikhr presets, custom entries and streak tracking.'**
  String get salahSubtitle;

  /// No description provided for @tasbihTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasbih & Prayer Streaks'**
  String get tasbihTitle;

  /// No description provided for @tasbihSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A beautiful digital tasbih counter with dhikr presets, custom entries, and streak tracking.'**
  String get tasbihSubtitle;

  /// No description provided for @quranTitle.
  ///
  /// In en, this message translates to:
  /// **'Quran, Qibla & Masjid'**
  String get quranTitle;

  /// No description provided for @quranSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read the Holy Quran, find the Qibla direction, and discover mosques near you—all in one place.'**
  String get quranSubtitle;

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
  /// **'Enable Location'**
  String get locationTitle;

  /// No description provided for @locationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We need your location for accurate prayer times, Qibla direction, and finding nearby mosques.'**
  String get locationSubtitle;

  /// No description provided for @locationButton.
  ///
  /// In en, this message translates to:
  /// **'Allow Location Access'**
  String get locationButton;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay Reminded'**
  String get notificationsTitle;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get notified for prayer times, focus mode reminders, and daily spiritual prompts.'**
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

  /// No description provided for @screenTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Screen Time Access'**
  String get screenTimeTitle;

  /// No description provided for @screenTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'To block distracting apps during Salah and Night Discipline, we need screen time permission.'**
  String get screenTimeSubtitle;

  /// No description provided for @screenTimeButton.
  ///
  /// In en, this message translates to:
  /// **'Allow Access'**
  String get screenTimeButton;

  /// No description provided for @focusModesTitle.
  ///
  /// In en, this message translates to:
  /// **'Powerful Focus Modes'**
  String get focusModesTitle;

  /// No description provided for @focusModesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Three modes designed to protect your time and attention'**
  String get focusModesSubtitle;

  /// No description provided for @focusPrayerModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Mode'**
  String get focusPrayerModeTitle;

  /// No description provided for @focusPrayerModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Block distracting apps during Salah for complete khushu'**
  String get focusPrayerModeDescription;

  /// No description provided for @focusSleepModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Sleep Mode'**
  String get focusSleepModeTitle;

  /// No description provided for @focusSleepModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Protect your sleep schedule and wake up for Fajr'**
  String get focusSleepModeDescription;

  /// No description provided for @focusChildModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Child Mode'**
  String get focusChildModeTitle;

  /// No description provided for @focusChildModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Instantly block apps when handing device to children'**
  String get focusChildModeDescription;

  /// No description provided for @investTitle.
  ///
  /// In en, this message translates to:
  /// **'Invest in Your Deen'**
  String get investTitle;

  /// No description provided for @investSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You don\'t think twice about spending on coffee or snacks...'**
  String get investSubtitle;

  /// No description provided for @investComparisonTitle.
  ///
  /// In en, this message translates to:
  /// **'Think about it...'**
  String get investComparisonTitle;

  /// No description provided for @investDailyCoffee.
  ///
  /// In en, this message translates to:
  /// **'Daily coffee'**
  String get investDailyCoffee;

  /// No description provided for @investDailyCoffeePrice.
  ///
  /// In en, this message translates to:
  /// **'\$5/day'**
  String get investDailyCoffeePrice;

  /// No description provided for @investFastFood.
  ///
  /// In en, this message translates to:
  /// **'Fast food'**
  String get investFastFood;

  /// No description provided for @investFastFoodPrice.
  ///
  /// In en, this message translates to:
  /// **'\$10/meal'**
  String get investFastFoodPrice;

  /// No description provided for @investYourDeen.
  ///
  /// In en, this message translates to:
  /// **'Your Deen'**
  String get investYourDeen;

  /// No description provided for @investYourDeenPrice.
  ///
  /// In en, this message translates to:
  /// **'\$4.99/mo'**
  String get investYourDeenPrice;

  /// No description provided for @investComparisonQuote.
  ///
  /// In en, this message translates to:
  /// **'You spend \$10 on small things without thinking - why not invest in your Deen?'**
  String get investComparisonQuote;

  /// No description provided for @bestValueTag.
  ///
  /// In en, this message translates to:
  /// **'BEST VALUE'**
  String get bestValueTag;

  /// No description provided for @mostPopularChoice.
  ///
  /// In en, this message translates to:
  /// **'Most popular choice'**
  String get mostPopularChoice;

  /// No description provided for @monthlyPriceValue.
  ///
  /// In en, this message translates to:
  /// **'\$4.99'**
  String get monthlyPriceValue;

  /// No description provided for @monthlyPriceSuffix.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get monthlyPriceSuffix;

  /// No description provided for @monthlyPlanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Billed monthly • Cancel anytime'**
  String get monthlyPlanSubtitle;

  /// No description provided for @yearlyPriceValue.
  ///
  /// In en, this message translates to:
  /// **'\$29.99'**
  String get yearlyPriceValue;

  /// No description provided for @yearlyPriceSuffix.
  ///
  /// In en, this message translates to:
  /// **'/year'**
  String get yearlyPriceSuffix;

  /// No description provided for @yearlyPlanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save 50% • Billed annually'**
  String get yearlyPlanSubtitle;

  /// No description provided for @lifetimePriceValue.
  ///
  /// In en, this message translates to:
  /// **'\$79.99'**
  String get lifetimePriceValue;

  /// No description provided for @lifetimePriceSuffix.
  ///
  /// In en, this message translates to:
  /// **' lifetime'**
  String get lifetimePriceSuffix;

  /// No description provided for @lifetimePlanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One-time purchase • Forever access'**
  String get lifetimePlanSubtitle;

  /// No description provided for @everythingYouGet.
  ///
  /// In en, this message translates to:
  /// **'Everything you get'**
  String get everythingYouGet;

  /// No description provided for @featureFocusModeAllModes.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Focus Mode with all 3 modes'**
  String get featureFocusModeAllModes;

  /// No description provided for @featurePrayerAnalyticsStreaks.
  ///
  /// In en, this message translates to:
  /// **'Advanced prayer analytics & streaks'**
  String get featurePrayerAnalyticsStreaks;

  /// No description provided for @featureMasjidGeofencing.
  ///
  /// In en, this message translates to:
  /// **'Masjid auto-detection & geofencing'**
  String get featureMasjidGeofencing;

  /// No description provided for @featureQuranAudioTranslations.
  ///
  /// In en, this message translates to:
  /// **'Full Quran with audio & translations'**
  String get featureQuranAudioTranslations;

  /// No description provided for @featureAiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Islamic assistant'**
  String get featureAiAssistant;

  /// No description provided for @featureNoAdsForever.
  ///
  /// In en, this message translates to:
  /// **'Remove all ads forever'**
  String get featureNoAdsForever;

  /// No description provided for @featurePrioritySupportEarlyAccess.
  ///
  /// In en, this message translates to:
  /// **'Priority support & early access'**
  String get featurePrioritySupportEarlyAccess;

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
  /// **' Muslims already growing with Deen Focus'**
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

  /// No description provided for @monthlyPrice.
  ///
  /// In en, this message translates to:
  /// **'\$4.99/month · billed monthly · cancel anytime'**
  String get monthlyPrice;

  /// No description provided for @yearlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearlyLabel;

  /// No description provided for @yearlyPrice.
  ///
  /// In en, this message translates to:
  /// **'\$29.99/year · save 50% · billed annually'**
  String get yearlyPrice;

  /// No description provided for @lifetimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get lifetimeLabel;

  /// No description provided for @lifetimePrice.
  ///
  /// In en, this message translates to:
  /// **'\$79.99 lifetime · one-time purchase · forever access'**
  String get lifetimePrice;

  /// No description provided for @featurePrayerAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Advanced prayer analytics'**
  String get featurePrayerAnalytics;

  /// No description provided for @featureFocusMode.
  ///
  /// In en, this message translates to:
  /// **'Unlimited focus mode'**
  String get featureFocusMode;

  /// No description provided for @featureMasjidMode.
  ///
  /// In en, this message translates to:
  /// **'Masjid auto mode'**
  String get featureMasjidMode;

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

  /// No description provided for @homeTapToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Tap to unlock apps temporarily'**
  String get homeTapToUnlock;

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

  /// No description provided for @homeSearchNearbyMosques.
  ///
  /// In en, this message translates to:
  /// **'Search nearby mosques.'**
  String get homeSearchNearbyMosques;

  /// No description provided for @homePrayerStreak.
  ///
  /// In en, this message translates to:
  /// **'Prayer Streaks'**
  String get homePrayerStreak;

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

  /// No description provided for @focusTabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay focused when it matters most'**
  String get focusTabSubtitle;

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
