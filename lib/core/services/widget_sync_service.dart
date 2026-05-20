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

  Future<void> syncTimeline({DateTime? fromDate}) async {
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
    final dayKeyFormat = DateFormat('yyyy-MM-dd', l10n.localeName);
    final dateLabelFormat = DateFormat('EEE, MMM d', l10n.localeName);
    final timeLabelFormat = DateFormat('h:mm a', l10n.localeName);
    final prayerCache = <String, HomePrayerTimesData>{};
    final verseCache = <String, HomeDailyVerse?>{};

    final ui = <String, dynamic>{
      'brandName': l10n.appTitle,
      'dailyVerseTitle': l10n.widgetDailyVerseTitle,
      'timelinePlaceholder': l10n.widgetOpenAppTimelineHint,
      'setLocationMessage': l10n.widgetSetLocationForPrayers,
    };

    final entries = <Map<String, dynamic>>[];
    for (var index = 0; index < _timelineDays; index++) {
      final date = startDate.add(Duration(days: index));
      final dayKey = dayKeyFormat.format(date);
      final ref = HomeDailyVerseHelper.getDailyVerseRefForDate(date);
      final verseKey = '${ref.surahNumber}:${ref.ayahNumber}';
      final verse = verseCache.containsKey(verseKey)
          ? verseCache[verseKey]
          : await HomeDailyVerseHelper.loadDailyVerse(ref);
      verseCache[verseKey] = verse;
      final prayerTimes = latitude != null && longitude != null
          ? prayerCache[dayKey] ??
                await HomePrayerTimesHelper.generatePrayerTimesForDate(
                  latitude: latitude,
                  longitude: longitude,
                  date: date,
                  sectRaw: sect,
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
                'text': useArabicVerse ? verse.arabicText : verse.englishText,
                'source':
                    '${verse.surahName} ${verse.surahNumber}:${verse.ayahNumber}',
              },
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

    await _channel.invokeMethod<void>('saveWidgetTimeline', <String, dynamic>{
      'timelineJson': payload,
    });
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
