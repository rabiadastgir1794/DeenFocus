import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../features/home/helpers/home_daily_verse_helper.dart';
import '../../features/home/helpers/home_prayer_times_helper.dart';
import '../../features/home/model/home_models.dart';
import 'storage_service.dart';

class WidgetSyncService {
  WidgetSyncService._();

  static final WidgetSyncService instance = WidgetSyncService._();

  static const MethodChannel _channel = MethodChannel(
    'com.app.deenly.deenly/widgets',
  );
  static const int _timelineDays = 7;
  static final DateFormat _dayKeyFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _dateLabelFormat = DateFormat('EEE, MMM d');
  static final DateFormat _timeLabelFormat = DateFormat('h:mm a');

  Future<void> syncTimeline({DateTime? fromDate}) async {
    final seedDate = fromDate ?? DateTime.now();
    final startDate = DateTime(seedDate.year, seedDate.month, seedDate.day);
    final latitude = await StorageService.locationLatitude;
    final longitude = await StorageService.locationLongitude;
    final locationName = await StorageService.locationName;
    final sect = await StorageService.sect;
    final isDarkMode = await StorageService.darkModeEnabled ?? false;
    final prayerCache = <String, HomePrayerTimesData>{};
    final verseCache = <String, HomeDailyVerse?>{};

    final entries = <Map<String, dynamic>>[];
    for (var index = 0; index < _timelineDays; index++) {
      final date = startDate.add(Duration(days: index));
      final dayKey = _dayKeyFormat.format(date);
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
        'dateLabel': _dateLabelFormat.format(date),
        'timeLabel': _timeLabelFormat.format(date),
        'locationName': locationName,
        'isDarkMode': isDarkMode,
        'verse': verse == null
            ? null
            : <String, dynamic>{
                'text': verse.englishText,
                'source':
                    '${verse.surahName} ${verse.surahNumber}:${verse.ayahNumber}',
              },
        'prayers':
            prayerTimes?.slots
                .map(
                  (slot) => <String, dynamic>{
                    'id': slot.id.name,
                    'label': _labelForPrayer(slot.id),
                    'timeLabel': _timeLabelFormat.format(slot.time),
                    'isoTime': slot.time.toIso8601String(),
                  },
                )
                .toList(growable: false) ??
            const <Map<String, dynamic>>[],
      });
    }

    final payload = jsonEncode(<String, dynamic>{
      'generatedAt': DateTime.now().toIso8601String(),
      'entries': entries,
    });

    await _channel.invokeMethod<void>('saveWidgetTimeline', <String, dynamic>{
      'timelineJson': payload,
    });
  }

  String _labelForPrayer(HomePrayerId id) {
    switch (id) {
      case HomePrayerId.fajr:
        return 'Fajr';
      case HomePrayerId.sunrise:
        return 'Sunrise';
      case HomePrayerId.dhuhr:
        return 'Dhuhr';
      case HomePrayerId.asr:
        return 'Asr';
      case HomePrayerId.maghrib:
        return 'Maghrib';
      case HomePrayerId.isha:
        return 'Isha';
    }
  }
}
