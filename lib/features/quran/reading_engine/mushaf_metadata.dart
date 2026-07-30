import 'dart:convert';

import 'package:flutter/services.dart';

/// Printed Mushaf layouts DeenFocus knows how to paginate by.
///
/// Only [uthmani] (the 604-page Madani Mushaf) ships data today. [indopak]
/// is reserved for a future phase — adding it is a data-only change (drop
/// `assets/quran/indopak.json`, see assets/quran/README.md), not an
/// architecture change.
enum MushafStandard { uthmani, indopak }

extension on MushafStandard {
  String get _assetPath => 'assets/quran/$name.json';
}

/// Where a single ayah sits in a given [MushafStandard]'s layout.
class AyahLocation {
  const AyahLocation({
    required this.surah,
    required this.ayah,
    required this.page,
    required this.juz,
  });

  final int surah;
  final int ayah;
  final int page;
  final int juz;

  factory AyahLocation.fromMap(Map<String, dynamic> map) {
    return AyahLocation(
      surah: (map['surah'] as num).toInt(),
      ayah: (map['ayah'] as num).toInt(),
      page: (map['page'] as num).toInt(),
      juz: (map['juz'] as num).toInt(),
    );
  }
}

/// Summary of one of the 30 Juz, derived from [MushafMetadata.ayahsInJuz].
class JuzInfo {
  const JuzInfo({
    required this.number,
    required this.startSurah,
    required this.startAyah,
    required this.endSurah,
    required this.endAyah,
    required this.ayahCount,
  });

  final int number;
  final int startSurah;
  final int startAyah;
  final int endSurah;
  final int endAyah;
  final int ayahCount;
}

/// Loads and indexes the static ayah -> (page, juz) mapping for a
/// [MushafStandard] (see `assets/quran/README.md`). Pure structural data —
/// no ayah text, no Hive — so it is safe to load once and cache forever.
class MushafMetadata {
  MushafMetadata._({
    required this.standard,
    required this.totalPages,
    required this.totalJuz,
    required List<AyahLocation> ayahs,
  }) : _ayahs = ayahs {
    for (var i = 0; i < _ayahs.length; i++) {
      final loc = _ayahs[i];
      _byKey['${loc.surah}:${loc.ayah}'] = loc;
      _pageStart.putIfAbsent(loc.page, () => i);
      _pageEnd[loc.page] = i;
      _juzStart.putIfAbsent(loc.juz, () => i);
      _juzEnd[loc.juz] = i;
    }
  }

  final MushafStandard standard;
  final int totalPages;
  final int totalJuz;
  final List<AyahLocation> _ayahs;
  final Map<String, AyahLocation> _byKey = <String, AyahLocation>{};
  final Map<int, int> _pageStart = <int, int>{};
  final Map<int, int> _pageEnd = <int, int>{};
  final Map<int, int> _juzStart = <int, int>{};
  final Map<int, int> _juzEnd = <int, int>{};

  static final Map<MushafStandard, MushafMetadata> _cache =
      <MushafStandard, MushafMetadata>{};
  static final Map<MushafStandard, Future<MushafMetadata>> _loading =
      <MushafStandard, Future<MushafMetadata>>{};

  static Future<MushafMetadata> load([
    MushafStandard standard = MushafStandard.uthmani,
  ]) async {
    final cached = _cache[standard];
    if (cached != null) return cached;

    final pending = _loading[standard];
    if (pending != null) return pending;

    final future = _loadInternal(standard);
    _loading[standard] = future;
    try {
      return await future;
    } finally {
      _loading.remove(standard);
    }
  }

  static Future<MushafMetadata> _loadInternal(MushafStandard standard) async {
    final raw = await rootBundle.loadString(standard._assetPath);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final ayahs = (decoded['ayahs'] as List<dynamic>)
        .map((e) => AyahLocation.fromMap(e as Map<String, dynamic>))
        .toList(growable: false);

    final metadata = MushafMetadata._(
      standard: standard,
      totalPages: (decoded['totalPages'] as num).toInt(),
      totalJuz: (decoded['totalJuz'] as num).toInt(),
      ayahs: ayahs,
    );
    _cache[standard] = metadata;
    return metadata;
  }

  AyahLocation? locate(int surah, int ayah) => _byKey['$surah:$ayah'];

  int pageForAyah(int surah, int ayah) => locate(surah, ayah)?.page ?? 1;

  int juzForAyah(int surah, int ayah) => locate(surah, ayah)?.juz ?? 1;

  List<AyahLocation> ayahsOnPage(int page) {
    return _slice(_pageStart[page], _pageEnd[page]);
  }

  List<AyahLocation> ayahsInJuz(int juz) {
    return _slice(_juzStart[juz], _juzEnd[juz]);
  }

  /// Madani Mushaf page numbers that contain at least one ayah of [surah],
  /// ascending. Used by surah-scoped Page Mode so the reader swipes only
  /// within one surah instead of all 604 Quran pages.
  List<int> pagesForSurah(int surah) {
    final pages = <int>{};
    for (final loc in _ayahs) {
      if (loc.surah == surah) pages.add(loc.page);
    }
    return pages.toList(growable: false)..sort();
  }

  /// Ayahs of [surah] that fall on [page] (empty if the surah does not
  /// appear on that page). Shared pages with neighbouring surahs only
  /// return this surah's portion.
  List<AyahLocation> ayahsOfSurahOnPage(int surah, int page) {
    return ayahsOnPage(page).where((loc) => loc.surah == surah).toList(
      growable: false,
    );
  }

  AyahLocation? firstAyahOfPage(int page) {
    final start = _pageStart[page];
    return start == null ? null : _ayahs[start];
  }

  AyahLocation? firstAyahOfJuz(int juz) {
    final start = _juzStart[juz];
    return start == null ? null : _ayahs[start];
  }

  List<AyahLocation> _slice(int? start, int? end) {
    if (start == null || end == null) return const <AyahLocation>[];
    return _ayahs.sublist(start, end + 1);
  }

  /// Summaries for all 30 Juz, computed once from the loaded mapping.
  late final List<JuzInfo> juzList = List<JuzInfo>.generate(totalJuz, (i) {
    final juz = i + 1;
    final ayahsInThisJuz = ayahsInJuz(juz);
    final first = ayahsInThisJuz.first;
    final last = ayahsInThisJuz.last;
    return JuzInfo(
      number: juz,
      startSurah: first.surah,
      startAyah: first.ayah,
      endSurah: last.surah,
      endAyah: last.ayah,
      ayahCount: ayahsInThisJuz.length,
    );
  });
}
