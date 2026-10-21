import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Centralized Firebase Analytics tracking service.
///
/// All app analytics events should route through this service. Events are
/// stable-named and deduplicated to avoid conflicts with Meta/TikTok/Superwall
/// tracking (which handle subscription lifecycle independently).
///
/// Never log sensitive data: no PII, Quran content, credentials, or FCM tokens.
class FirebaseAnalyticsService {
  FirebaseAnalyticsService._();

  static final FirebaseAnalyticsService instance = FirebaseAnalyticsService._();

  FirebaseAnalytics? _analytics;
  bool _initialized = false;

  FirebaseAnalytics? get analytics => _analytics;
  bool get isInitialized => _initialized;

  /// Initializes Firebase Analytics. Safe to call multiple times.
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _analytics = FirebaseAnalytics.instance;
      await _analytics!.setAnalyticsCollectionEnabled(true);
      _initialized = true;
      debugPrint('[FirebaseAnalytics] Initialized successfully');
    } catch (e, st) {
      debugPrint('[FirebaseAnalytics] Initialization failed: $e');
      debugPrintStack(stackTrace: st);
      _analytics = null;
      _initialized = false;
    }
  }

  /// Logs a custom event with parameters. Safe to call before initialization.
  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  }) async {
    if (!_initialized || _analytics == null) {
      if (kDebugMode) {
        debugPrint(
          '[FirebaseAnalytics] Event skipped (not initialized): $name',
        );
      }
      return;
    }

    try {
      // Filter out null values as Firebase Analytics expects Map<String, Object>
      final cleanParams = parameters?.entries
          .where((e) => e.value != null)
          .fold<Map<String, Object>>({}, (map, e) => map..[e.key] = e.value!);

      await _analytics!.logEvent(name: name, parameters: cleanParams);
      if (kDebugMode) {
        debugPrint('[FirebaseAnalytics] Event: $name ${parameters ?? {}}');
      }
    } catch (e) {
      debugPrint('[FirebaseAnalytics] logEvent failed: $e');
      // Never throw — analytics failures must not interrupt app flow
    }
  }

  /// Sets user properties (non-sensitive identifiers only).
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    if (!_initialized || _analytics == null) return;

    try {
      await _analytics!.setUserProperty(name: name, value: value);
    } catch (e) {
      debugPrint('[FirebaseAnalytics] setUserProperty failed: $e');
    }
  }

  /// Tracks screen views.
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    if (!_initialized || _analytics == null) return;

    try {
      await _analytics!.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } catch (e) {
      debugPrint('[FirebaseAnalytics] logScreenView failed: $e');
    }
  }

  // ========================================================================
  // App Lifecycle Events
  // ========================================================================

  Future<void> logAppOpen() => logEvent(name: 'app_open');

  // ========================================================================
  // Prayer Feature Events
  // ========================================================================

  Future<void> logPrayerMarked({
    required String prayer,
    required String status,
  }) => logEvent(
    name: 'prayer_marked',
    parameters: {'prayer': prayer, 'status': status},
  );

  Future<void> logPrayerSettingsOpened() =>
      logEvent(name: 'prayer_settings_opened');

  Future<void> logPrayerNotificationToggled({required bool enabled}) =>
      logEvent(
        name: 'prayer_notification_toggled',
        parameters: {'enabled': enabled},
      );

  Future<void> logPrayerSoundChanged({required String sound}) =>
      logEvent(name: 'prayer_sound_changed', parameters: {'sound': sound});

  Future<void> logPrayerAlarmToggled({
    required String prayer,
    required bool enabled,
  }) => logEvent(
    name: 'prayer_alarm_toggled',
    parameters: {'prayer': prayer, 'enabled': enabled},
  );

  Future<void> logCalculationMethodChanged({required String method}) =>
      logEvent(
        name: 'calculation_method_changed',
        parameters: {'method': method},
      );

  Future<void> logInsightsOpened() => logEvent(name: 'insights_opened');

  Future<void> logCalendarOpened() => logEvent(name: 'calendar_opened');

  // ========================================================================
  // Quran Feature Events
  // ========================================================================

  Future<void> logQuranSurahOpened({required int surahNumber}) => logEvent(
    name: 'quran_surah_opened',
    parameters: {'surah_number': surahNumber},
  );

  Future<void> logQuranAyahBookmarked({
    required int surahNumber,
    required int ayahNumber,
  }) => logEvent(
    name: 'quran_ayah_bookmarked',
    parameters: {'surah_number': surahNumber, 'ayah_number': ayahNumber},
  );

  Future<void> logQuranSurahBookmarked({required int surahNumber}) => logEvent(
    name: 'quran_surah_bookmarked',
    parameters: {'surah_number': surahNumber},
  );

  Future<void> logQuranJuzBookmarked({required int juzNumber}) => logEvent(
    name: 'quran_juz_bookmarked',
    parameters: {'juz_number': juzNumber},
  );

  Future<void> logQuranRecitationPlayed({
    required int surahNumber,
    required String reciter,
  }) => logEvent(
    name: 'quran_recitation_played',
    parameters: {'surah_number': surahNumber, 'reciter': reciter},
  );

  Future<void> logQuranTranslationChanged({required String language}) =>
      logEvent(
        name: 'quran_translation_changed',
        parameters: {'language': language},
      );

  Future<void> logQuranSearchOpened() => logEvent(name: 'quran_search_opened');

  Future<void> logQuranJuzOpened({required int juzNumber}) =>
      logEvent(name: 'quran_juz_opened', parameters: {'juz_number': juzNumber});

  // ========================================================================
  // Tasbih Feature Events
  // ========================================================================

  Future<void> logTasbihCounterUsed({required int finalCount}) => logEvent(
    name: 'tasbih_counter_used',
    parameters: {'final_count': finalCount},
  );

  Future<void> logTasbihOpened({required String tasbihId}) =>
      logEvent(name: 'tasbih_opened', parameters: {'tasbih_id': tasbihId});

  Future<void> logTasbihPresetSelected({required String preset}) =>
      logEvent(name: 'tasbih_preset_selected', parameters: {'preset': preset});

  Future<void> logTasbihReset() => logEvent(name: 'tasbih_reset');

  // ========================================================================
  // Focus Mode Events
  // ========================================================================

  Future<void> logFocusModeEnabled({required String mode}) =>
      logEvent(name: 'focus_mode_enabled', parameters: {'mode': mode});

  Future<void> logFocusModeDisabled({required String mode}) =>
      logEvent(name: 'focus_mode_disabled', parameters: {'mode': mode});

  Future<void> logNightModeScheduleSet({
    required int startHour,
    required int endHour,
  }) => logEvent(
    name: 'night_mode_schedule_set',
    parameters: {'start_hour': startHour, 'end_hour': endHour},
  );

  Future<void> logCycleModeStarted({required int days}) =>
      logEvent(name: 'cycle_mode_started', parameters: {'days': days});

  Future<void> logCycleModeDisabled() => logEvent(name: 'cycle_mode_disabled');

  Future<void> logFocusAppsUpdated({required int count}) =>
      logEvent(name: 'focus_apps_updated', parameters: {'count': count});

  Future<void> logAppsUnlocked({required String source}) =>
      logEvent(name: 'apps_unlocked', parameters: {'source': source});

  // ========================================================================
  // Qibla & Masjid Finder Events
  // ========================================================================

  Future<void> logQiblaCompassOpened() =>
      logEvent(name: 'qibla_compass_opened');

  Future<void> logMasjidFinderOpened() =>
      logEvent(name: 'masjid_finder_opened');

  Future<void> logMasjidDirectionsRequested() =>
      logEvent(name: 'masjid_directions_requested');

  // ========================================================================
  // Islamic Library Events
  // ========================================================================

  Future<void> logIslamicLibraryTopicOpened({required String topic}) =>
      logEvent(
        name: 'islamic_library_topic_opened',
        parameters: {'topic': topic},
      );

  Future<void> logTajweedPracticeOpened({
    required int surahNumber,
    required int ayahNumber,
    required bool preview,
  }) => logEvent(
    name: 'tajweed_practice_opened',
    parameters: {
      'surah_number': surahNumber,
      'ayah_number': ayahNumber,
      'preview': preview,
    },
  );

  Future<void> logTajweedPracticeCompleted({
    required int surahNumber,
    required int ayahNumber,
    required int accuracyPercent,
    required bool exactMatch,
  }) => logEvent(
    name: 'tajweed_practice_completed',
    parameters: {
      'surah_number': surahNumber,
      'ayah_number': ayahNumber,
      'accuracy_percent': accuracyPercent,
      'exact_match': exactMatch,
    },
  );

  // ========================================================================
  // Settings & Preferences Events
  // ========================================================================

  Future<void> logLanguageChanged({required String language}) =>
      logEvent(name: 'language_changed', parameters: {'language': language});

  Future<void> logThemeChanged({required String theme}) =>
      logEvent(name: 'theme_changed', parameters: {'theme': theme});

  // ========================================================================
  // Onboarding Events
  // ========================================================================

  Future<void> logOnboardingStarted() => logEvent(name: 'onboarding_started');

  Future<void> logOnboardingCompleted() =>
      logEvent(name: 'onboarding_completed');

  Future<void> logOnboardingSkipped({required String step}) =>
      logEvent(name: 'onboarding_skipped', parameters: {'step': step});

  // ========================================================================
  // Premium/Paywall Events (metadata only, Superwall owns conversion)
  // ========================================================================

  Future<void> logPaywallViewed({required String source}) =>
      logEvent(name: 'paywall_viewed', parameters: {'source': source});

  Future<void> logPaywallDismissed({
    required String source,
    String? dismissKind,
  }) => logEvent(
    name: 'paywall_dismissed',
    parameters: {'source': source, 'dismiss_kind': dismissKind},
  );

  /// Entitlement outcome only — Superwall/Meta/TikTok own revenue amounts.
  Future<void> logPremiumUnlocked({required String method}) =>
      logEvent(name: 'premium_unlocked', parameters: {'method': method});

  Future<void> logDonationCompleted({required String status}) =>
      logEvent(name: 'donation_completed', parameters: {'status': status});

  Future<void> logSupportOpened() => logEvent(name: 'support_opened');

  Future<void> logLockScreenStyleChanged({required String style}) =>
      logEvent(name: 'lock_screen_style_changed', parameters: {'style': style});

  // ========================================================================
  // Share & Social Events
  // ========================================================================

  Future<void> logContentShared({required String contentType}) => logEvent(
    name: 'content_shared',
    parameters: {'content_type': contentType},
  );

  Future<void> logAppReviewPrompted() => logEvent(name: 'app_review_prompted');

  // ========================================================================
  // Navigation Events
  // ========================================================================

  Future<void> logTabSwitched({required String tab}) =>
      logEvent(name: 'tab_switched', parameters: {'tab': tab});

  Future<void> logAboutOpened() => logEvent(name: 'about_opened');
}
