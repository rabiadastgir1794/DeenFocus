import 'dart:math';

import 'package:intl/intl.dart';

import '../../../core/services/storage_service.dart';
import '../../quran/data/quran_local_repository.dart';
import '../model/home_models.dart';
import 'surah_ayah_count_helper.dart';

abstract class HomeDailyVerseHelper {
  static final DateFormat _dayKeyFormat = DateFormat('yyyy-MM-dd');
  static const int _widgetVerseBucketMinutes = 5;

  static DailyVerseRef getDailyVerseRefForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final random = Random(
      normalizedDate.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay,
    );
    final surahNumber = random.nextInt(kSurahAyahCount.length) + 1;
    final ayahCount = kSurahAyahCount[surahNumber] ?? 1;
    final ayahNumber = random.nextInt(ayahCount) + 1;
    return DailyVerseRef(surahNumber: surahNumber, ayahNumber: ayahNumber);
  }

  static DailyVerseRef getWidgetVerseRefForMoment(DateTime moment) {
    final normalizedMoment = DateTime(
      moment.year,
      moment.month,
      moment.day,
      moment.hour,
      (moment.minute ~/ _widgetVerseBucketMinutes) * _widgetVerseBucketMinutes,
    );
    final random = Random(
      normalizedMoment.millisecondsSinceEpoch ~/
          Duration(minutes: _widgetVerseBucketMinutes).inMilliseconds,
    );
    final surahNumber = random.nextInt(kSurahAyahCount.length) + 1;
    final ayahCount = kSurahAyahCount[surahNumber] ?? 1;
    final ayahNumber = random.nextInt(ayahCount) + 1;
    return DailyVerseRef(surahNumber: surahNumber, ayahNumber: ayahNumber);
  }

  static Future<DailyVerseRef> getOrGenerateDailyVerseRef({
    DateTime? now,
  }) async {
    final today = now ?? DateTime.now();
    final dayKey = _dayKeyFormat.format(today);

    final cachedDate = await StorageService.homeDailyVerseDate;
    final cachedSurah = await StorageService.homeDailyVerseSurah;
    final cachedAyah = await StorageService.homeDailyVerseAyah;

    if (cachedDate == dayKey && cachedSurah != null && cachedAyah != null) {
      return DailyVerseRef(surahNumber: cachedSurah, ayahNumber: cachedAyah);
    }

    final ref = getDailyVerseRefForDate(today);

    await StorageService.setHomeDailyVerse(
      dateKey: dayKey,
      surah: ref.surahNumber,
      ayah: ref.ayahNumber,
    );

    return ref;
  }

  static Future<HomeDailyVerse?> loadDailyVerse(DailyVerseRef ref) async {
    await QuranLocalRepository.instance.ensureInitialized();
    final surahs = await QuranLocalRepository.instance.getSurahs();
    final ayahs = await QuranLocalRepository.instance.getAyahsBySurah(
      ref.surahNumber,
    );

    final ayah = ayahs
        .where((item) => item.ayahNumber == ref.ayahNumber)
        .firstOrNull;
    if (ayah == null) return null;

    final surah = surahs
        .where((item) => item.number == ref.surahNumber)
        .firstOrNull;

    return HomeDailyVerse(
      surahNumber: ref.surahNumber,
      ayahNumber: ref.ayahNumber,
      surahName: surah?.name ?? 'Surah ${ref.surahNumber}',
      arabicText: ayah.arabicText,
      englishText: ayah.englishText,
    );
  }
}
