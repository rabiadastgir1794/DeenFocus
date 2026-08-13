import 'dart:math';

import 'package:intl/intl.dart';

import '../../../core/services/storage_service.dart';
import '../../quran/data/quran_local_repository.dart';
import '../model/home_models.dart';
import 'surah_ayah_count_helper.dart';

abstract class HomeDailyVerseHelper {
  static final DateFormat _dayKeyFormat = DateFormat('yyyy-MM-dd');

  /// Day-seeded verse picker used by Home and widgets.
  /// [attempt] keeps attempt 0 identical to the historical seed.
  static DailyVerseRef getDailyVerseRefForDate(DateTime date, {int attempt = 0}) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final daySeed =
        normalizedDate.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
    final random = Random(daySeed ^ (attempt * 0x9E3779B9));
    final surahNumber = random.nextInt(kSurahAyahCount.length) + 1;
    final ayahCount = kSurahAyahCount[surahNumber] ?? 1;
    final ayahNumber = random.nextInt(ayahCount) + 1;
    return DailyVerseRef(surahNumber: surahNumber, ayahNumber: ayahNumber);
  }

  /// Loads a complete ayah from the trusted Quran DB for [date].
  ///
  /// When [maxChars] is set (Medium widget), only returns ayahs that fit
  /// naturally in ~2 lines — still using the same daily-verse refs/source.
  static Future<HomeDailyVerse?> loadDailyVerseForDate({
    required DateTime date,
    required bool useArabic,
    int? maxChars,
  }) async {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    final primaryRef = isToday
        ? await getOrGenerateDailyVerseRef(now: date)
        : getDailyVerseRefForDate(date);
    final primary = await loadDailyVerse(primaryRef);
    if (maxChars == null) return primary;
    if (primary != null &&
        _fitsTwoLines(
          useArabic ? primary.arabicText : primary.englishText,
          maxChars: maxChars,
        )) {
      return primary;
    }

    // Same daily-verse picker/source; walk attempts until a complete short ayah fits.
    // Do not persist widget-only alternates — Home keeps today's primary ref.
    for (var attempt = 1; attempt <= 24; attempt++) {
      final ref = getDailyVerseRefForDate(date, attempt: attempt);
      final verse = await loadDailyVerse(ref);
      if (verse == null) continue;
      final text = useArabic ? verse.arabicText : verse.englishText;
      if (!_fitsTwoLines(text, maxChars: maxChars)) continue;
      return verse;
    }

    // Trusted short fallback from the same Quran DB (never truncate on widget).
    return loadDailyVerse(
      const DailyVerseRef(surahNumber: 112, ayahNumber: 1),
    );
  }

  static bool _fitsTwoLines(String text, {required int maxChars}) {
    final normalized = text.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (normalized.isEmpty || normalized.contains('\n')) return false;
    return normalized.length <= maxChars;
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
