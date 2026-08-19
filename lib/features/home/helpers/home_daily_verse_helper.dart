import 'dart:math';

import 'package:intl/intl.dart';

import '../../../core/services/storage_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../quran/data/quran_local_repository.dart';
import '../model/home_models.dart';
import 'surah_ayah_count_helper.dart';

abstract class HomeDailyVerseHelper {
  static final DateFormat _dayKeyFormat = DateFormat('yyyy-MM-dd');

  /// Known complete, short ayahs from the same Quran DB (widget last resort).
  static const List<DailyVerseRef> _widgetCompleteFallbacks = [
    DailyVerseRef(surahNumber: 1, ayahNumber: 5),
    DailyVerseRef(surahNumber: 1, ayahNumber: 4),
    DailyVerseRef(surahNumber: 112, ayahNumber: 2),
    DailyVerseRef(surahNumber: 108, ayahNumber: 1),
  ];

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
  /// When [maxChars] is set (Medium widget), only returns a full ayah that
  /// naturally fits in ~2 lines. Continuation fragments and overlong ayahs
  /// are skipped — never truncated.
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

    HomeDailyVerse? takeIfSuitable(HomeDailyVerse? verse) {
      if (verse == null) return null;
      final text = useArabic ? verse.arabicText : verse.englishText;
      if (!_isCompleteTwoLineVerse(
        text,
        maxChars: maxChars,
        useArabic: useArabic,
      )) {
        return null;
      }
      return verse;
    }

    final suitablePrimary = takeIfSuitable(primary);
    if (suitablePrimary != null) return suitablePrimary;

    // Same daily-verse picker/source; walk attempts until a complete short ayah fits.
    // Do not persist widget-only alternates — Home keeps today's primary ref.
    for (var attempt = 1; attempt <= 40; attempt++) {
      final verse = takeIfSuitable(
        await loadDailyVerse(getDailyVerseRefForDate(date, attempt: attempt)),
      );
      if (verse != null) return verse;
    }

    for (final ref in _widgetCompleteFallbacks) {
      final verse = takeIfSuitable(await loadDailyVerse(ref));
      if (verse != null) return verse;
    }

    // Prefer empty over an incomplete / truncated verse on the widget.
    return null;
  }

  /// True when [text] is a full ayah that fits the Medium widget's 2-line area.
  static bool _isCompleteTwoLineVerse(
    String text, {
    required int maxChars,
    required bool useArabic,
  }) {
    final normalized = text.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (normalized.isEmpty || normalized.contains('\n')) return false;
    if (normalized.length > maxChars) return false;

    // Arabic ayahs are complete units from the DB; length alone is enough.
    if (useArabic) return true;

    // Saheeh International often continues mid-thought with "-" / "," / ";".
    // Those read as cut-off on the widget even when the full ayah string is shown.
    if (RegExp(r'[-–—…,;:]\s*$').hasMatch(normalized)) return false;

    // Require a finished English sentence / closed bracket so the line feels whole.
    return RegExp(r'''[.!?]"?'?$|\]"?'?$''').hasMatch(normalized);
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
    final ayahs = await QuranLocalRepository.instance.getAyahsByKeys([
      (ref.surahNumber, ref.ayahNumber),
    ]);
    if (ayahs.isEmpty) return null;

    final ayah = ayahs.first;
    final surah = await QuranLocalRepository.instance.getSurah(ref.surahNumber);

    return HomeDailyVerse(
      surahNumber: ref.surahNumber,
      ayahNumber: ref.ayahNumber,
      surahName: surah?.name ?? 'Surah ${ref.surahNumber}',
      arabicSurahName: surah?.arabicName ?? '',
      arabicText: ayah.arabicText,
      englishText: ayah.englishText,
    );
  }

  /// Localized citation for Home / widgets (matches Quran reader style).
  static String localizedSource(
    HomeDailyVerse verse, {
    required AppLocalizations l10n,
    required bool useArabic,
  }) {
    final locale = l10n.localeName.toLowerCase();
    if (useArabic && verse.arabicSurahName.trim().isNotEmpty) {
      return '${verse.arabicSurahName} ${verse.surahNumber}:${verse.ayahNumber}';
    }
    if (locale.startsWith('en') && verse.surahName.trim().isNotEmpty) {
      return '${verse.surahName} ${verse.surahNumber}:${verse.ayahNumber}';
    }
    return '${l10n.quranSurahLabel} ${verse.surahNumber}:${verse.ayahNumber}';
  }

  /// Quran DB only ships Arabic + English bodies; pick by app language.
  static String localizedText(
    HomeDailyVerse verse, {
    required bool useArabic,
  }) {
    return useArabic ? verse.arabicText : verse.englishText;
  }
}
