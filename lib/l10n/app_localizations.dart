import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Deen Focus'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Where faith meets focus'**
  String get appTagline;

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'Prayer Mode. Child Mode. Sleep Mode.'**
  String get welcomeTagline;

  /// No description provided for @welcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Track prayers, read Quran, count Tasbih, build streaks - everything for your spiritual journey in one app.'**
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
  /// **'Choose a plan that supports your spiritual journey. You can start free and upgrade anytime.'**
  String get investSubtitle;

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
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
