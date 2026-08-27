import 'dart:convert';

import 'package:flutter/material.dart' show Locale;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../features/home/helpers/home_daily_verse_helper.dart';
import '../../features/home/helpers/home_prayer_times_helper.dart';
import '../../features/home/model/home_models.dart';
import '../../l10n/app_localizations.dart';
import 'storage_service.dart';

class WidgetSyncService {
  WidgetSyncService._();

  static final WidgetSyncService instance = WidgetSyncService._();

  static const MethodChannel _channel = MethodChannel(
    'com.app.deenly.deenly/widgets',
  );
  static const int _timelineDays = 2;

  static Locale _localeFromPrefsCode(String? code) {
    if (code == null || code.isEmpty) return const Locale('en');
    final primary = code.replaceAll('_', '-').split('-').first.toLowerCase();
    return Locale(primary);
  }

  static AppLocalizations _widgetLocalizations(Locale locale) {
    try {
      return lookupAppLocalizations(locale);
    } catch (_) {
      return lookupAppLocalizations(const Locale('en'));
    }
  }

  /// Avoids [LocaleDataException] when intl locale data is not loaded yet
  /// (e.g. unit tests, cold start before date formatting init).
  static DateFormat _safeDateFormat(String pattern, String localeName) {
    try {
      return DateFormat(pattern, localeName);
    } catch (_) {
      return DateFormat(pattern);
    }
  }

  Future<void> syncTimeline({DateTime? fromDate}) async {
    try {
      await _syncTimelineBody(fromDate: fromDate);
    } catch (_) {
      // Best-effort: Hive/Quran/platform channel may be unavailable in tests
      // or before native init. Never fail callers like prayer marking.
    }
  }

  Future<void> _syncTimelineBody({DateTime? fromDate}) async {
    final seedDate = fromDate ?? DateTime.now();
    final startDate = DateTime(seedDate.year, seedDate.month, seedDate.day);
    final latitude = await StorageService.locationLatitude;
    final longitude = await StorageService.locationLongitude;
    final locationName = await StorageService.locationName;
    final sect = await StorageService.sect;
    final isDarkMode = await StorageService.darkModeEnabled ?? false;
    final l10n = _widgetLocalizations(
      _localeFromPrefsCode(await StorageService.localeCode),
    );
    final useArabicVerse = l10n.localeName.toLowerCase().startsWith('ar');
    final dayKeyFormat = DateFormat('yyyy-MM-dd');
    final dateLabelFormat = _safeDateFormat('EEE, MMM d', l10n.localeName);
    final timeLabelFormat = _safeDateFormat('h:mm a', l10n.localeName);
    final prayerCache = <String, HomePrayerTimesData>{};
    final verseCache = <String, HomeDailyVerse?>{};
    final streakState = await _loadStreakState();
    final prayerSettingsRaw = await StorageService.prayerSettingsJson;
    final prayerSettings = prayerSettingsRaw == null
        ? PrayerSettingsState.defaults()
        : PrayerSettingsState.fromJson(prayerSettingsRaw);
    final customTimeOverrides = prayerSettings.customTimeOverrides;

    final ui = <String, dynamic>{
      'brandName': l10n.appTitle,
      'dailyVerseTitle': l10n.widgetDailyVerseTitle,
      'timelinePlaceholder': l10n.widgetOpenAppTimelineHint,
      'setLocationMessage': l10n.widgetSetLocationForPrayers,
      'prayerProgressTitle': l10n.widgetPrayerProgressTitle,
      'prayersCompletedSubtitle': l10n.widgetPrayersCompletedSubtitle,
      'defaultProgressCountLabel': l10n.widgetPrayerProgressCount(0, 5),
    };

    final entries = <Map<String, dynamic>>[];
    for (var index = 0; index < _timelineDays; index++) {
      final date = startDate.add(Duration(days: index));
      final dayKey = dayKeyFormat.format(date);
      final verseKey = '$dayKey:${useArabicVerse ? 'ar' : 'en'}';
      HomeDailyVerse? verse;
      if (verseCache.containsKey(verseKey)) {
        verse = verseCache[verseKey];
      } else {
        try {
          verse = await HomeDailyVerseHelper.loadDailyVerseForDate(
            date: date,
            useArabic: useArabicVerse,
            // Medium widget: complete ayah only, natural 2-line fit (no truncation).
            maxChars: useArabicVerse ? 64 : 90,
          );
        } catch (_) {
          verse = null;
        }
        verseCache[verseKey] = verse;
      }
      final prayerTimes = latitude != null && longitude != null
          ? prayerCache[dayKey] ??
                await HomePrayerTimesHelper.generatePrayerTimesForDateWithOverrides(
                  latitude: latitude,
                  longitude: longitude,
                  date: date,
                  sectRaw: sect,
                  overridesMinutesSinceMidnight: customTimeOverrides,
                )
          : null;
      if (prayerTimes != null) {
        prayerCache[dayKey] = prayerTimes;
      }

      entries.add(<String, dynamic>{
        'timestamp': date.toIso8601String(),
        'dayKey': dayKey,
        'dateLabel': dateLabelFormat.format(date),
        'timeLabel': timeLabelFormat.format(date),
        'locationName': locationName,
        'isDarkMode': isDarkMode,
        'verse': verse == null
            ? null
            : <String, dynamic>{
                'text': HomeDailyVerseHelper.localizedText(
                  verse,
                  useArabic: useArabicVerse,
                ),
                'source': HomeDailyVerseHelper.localizedSource(
                  verse,
                  l10n: l10n,
                  useArabic: useArabicVerse,
                ),
              },
        'progress': _progressForDay(
          dayKey: dayKey,
          streakState: streakState,
          l10n: l10n,
        ),
        'prayers':
            prayerTimes?.slots
                .map(
                  (slot) => <String, dynamic>{
                    'id': slot.id.name,
                    'label': _labelForPrayer(slot.id, l10n),
                    'timeLabel': timeLabelFormat.format(slot.time),
                    'isoTime': slot.time.toIso8601String(),
                  },
                )
                .toList(growable: false) ??
            const <Map<String, dynamic>>[],
      });
    }

    final payload = jsonEncode(<String, dynamic>{
      'generatedAt': DateTime.now().toIso8601String(),
      'ui': ui,
      'entries': entries,
    });

    try {
      await _channel.invokeMethod<void>('saveWidgetTimeline', <String, dynamic>{
        'timelineJson': payload,
      });
    } on MissingPluginException {
      // Expected in unit tests / before plugin registration.
    }
  }

  Future<HomePrayerStreakState?> _loadStreakState() async {
    final raw = await StorageService.homePrayerStreakJson;
    if (raw == null || raw.isEmpty) return null;
    return HomePrayerStreakState.fromJson(raw);
  }

  /// Today's prayer completion for the large widget — same onTime/qada rules
  /// as Home streaks, read from existing [HomePrayerStreakState] storage.
  Map<String, dynamic> _progressForDay({
    required String dayKey,
    required HomePrayerStreakState? streakState,
    required AppLocalizations l10n,
  }) {
    const total = 5;
    final dayStatuses = <TrackablePrayer, PrayerMarkStatus>{
      ...?streakState?.statusHistory[dayKey],
    };
    final weekDay = streakState?.weekDays
        .where((day) => day.dateKey == dayKey)
        .firstOrNull;
    if (weekDay != null) {
      for (final prayer in TrackablePrayer.values) {
        final status = weekDay.statusFor(prayer);
        if (status != PrayerMarkStatus.none) {
          dayStatuses[prayer] = status;
        }
      }
    }
    final flags = <bool>[
      for (final prayer in TrackablePrayer.values)
        _countsAsCompleted(dayStatuses[prayer]),
    ];
    final completed = flags.where((done) => done).length;
    final remaining = total - completed;
    return <String, dynamic>{
      'completedCount': completed,
      'totalCount': total,
      'flags': flags,
      'countLabel': l10n.widgetPrayerProgressCount(completed, total),
      'statusMessage': remaining == 0
          ? l10n.widgetAllPrayersDoneToday
          : l10n.widgetPrayersLeftToday(remaining),
    };
  }

  bool _countsAsCompleted(PrayerMarkStatus? status) {
    return status == PrayerMarkStatus.onTime ||
        status == PrayerMarkStatus.qada;
  }

  String _labelForPrayer(HomePrayerId id, AppLocalizations l10n) {
    switch (id) {
      case HomePrayerId.fajr:
        return l10n.homePrayerFajr;
      case HomePrayerId.sunrise:
        return l10n.homePrayerSunrise;
      case HomePrayerId.dhuhr:
        return l10n.homePrayerDhuhr;
      case HomePrayerId.asr:
        return l10n.homePrayerAsr;
      case HomePrayerId.maghrib:
        return l10n.homePrayerMaghrib;
      case HomePrayerId.isha:
        return l10n.homePrayerIsha;
    }
  }
}
