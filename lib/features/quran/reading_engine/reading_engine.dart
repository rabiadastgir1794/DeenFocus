import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/services/storage_service.dart';
import '../data/quran_local_repository.dart';
import 'mushaf_metadata.dart';
import 'reading_mode.dart';

/// Reading Engine
/// ├── Surah Mode
/// ├── Juz Mode
/// └── Page Mode
///
/// A single navigation + progress-tracking controller shared by all three
/// reading modes. It answers "what ayahs am I reading right now" and "where
/// was I", backed by [QuranLocalRepository] (ayah text) and [MushafMetadata]
/// (page/juz boundaries). It deliberately owns neither audio playback nor
/// widget rendering — those stay screen-specific — so it can sit underneath
/// the existing Surah reading screen as well as the new Juz/Page screens
/// without forcing a UI rewrite.
class ReadingEngine extends ChangeNotifier {
  ReadingEngine({
    required this.mode,
    QuranLocalRepository? repository,
  }) : _repository = repository ?? QuranLocalRepository.instance;

  final ReadingMode mode;
  final QuranLocalRepository _repository;
  MushafMetadata? _mushaf;

  List<AyahRecord> _ayahs = const <AyahRecord>[];
  int _unitNumber = 1;
  bool _isLoading = true;
  DateTime? _sessionStart;
  final Set<String> _visitedThisSession = <String>{};
  AyahRecord? _lastVisited;

  List<AyahRecord> get ayahs => _ayahs;

  /// Surah number (Surah Mode), Juz number (Juz Mode) or page number (Page
  /// Mode) currently open.
  int get unitNumber => _unitNumber;

  bool get isLoading => _isLoading;

  int get totalUnits => switch (mode) {
    ReadingMode.surah => 114,
    ReadingMode.juz => _mushaf?.totalJuz ?? 30,
    ReadingMode.page => _mushaf?.totalPages ?? 604,
  };

  MushafMetadata? get mushaf => _mushaf;

  Future<MushafMetadata> _ensureMushaf() async {
    return _mushaf ??= await MushafMetadata.load();
  }

  Future<void> openSurah(int surahNumber, {int? ayah}) async {
    _isLoading = true;
    notifyListeners();

    _unitNumber = surahNumber.clamp(1, 114);
    _ayahs = await _repository.getAyahsBySurah(_unitNumber);
    _isLoading = false;
    _sessionStart ??= DateTime.now();
    notifyListeners();

    if (ayah != null) reportAyahVisited(_unitNumber, ayah);
  }

  Future<void> openJuz(int juzNumber, {int? surah, int? ayah}) async {
    _isLoading = true;
    notifyListeners();

    final metadata = await _ensureMushaf();
    _unitNumber = juzNumber.clamp(1, metadata.totalJuz);
    final locations = metadata.ayahsInJuz(_unitNumber);
    _ayahs = await _repository.getAyahsByKeys(
      locations.map((l) => (l.surah, l.ayah)).toList(growable: false),
    );
    _isLoading = false;
    _sessionStart ??= DateTime.now();
    notifyListeners();

    if (surah != null && ayah != null) {
      reportAyahVisited(surah, ayah);
    } else if (ayah != null && locations.isNotEmpty) {
      // Fallback for callers that only know the ayah number (assumed to be
      // within the juz's first surah, e.g. opening straight from the list).
      reportAyahVisited(locations.first.surah, ayah);
    }
  }

  Future<void> openPage(int pageNumber) async {
    _isLoading = true;
    notifyListeners();

    final metadata = await _ensureMushaf();
    _unitNumber = pageNumber.clamp(1, metadata.totalPages);
    final locations = metadata.ayahsOnPage(_unitNumber);
    _ayahs = await _repository.getAyahsByKeys(
      locations.map((l) => (l.surah, l.ayah)).toList(growable: false),
    );
    _isLoading = false;
    _sessionStart ??= DateTime.now();
    notifyListeners();
  }

  Future<void> open(int unitNumber) {
    return switch (mode) {
      ReadingMode.surah => openSurah(unitNumber),
      ReadingMode.juz => openJuz(unitNumber),
      ReadingMode.page => openPage(unitNumber),
    };
  }

  /// Re-fetch ayah text for the current unit (e.g. after a translation pack
  /// finishes downloading) without changing the open unit/position.
  Future<void> reloadAyahTexts() async {
    if (_isLoading) return;
    switch (mode) {
      case ReadingMode.surah:
        _ayahs = await _repository.getAyahsBySurah(_unitNumber);
      case ReadingMode.juz:
        final metadata = await _ensureMushaf();
        final locations = metadata.ayahsInJuz(_unitNumber);
        _ayahs = await _repository.getAyahsByKeys(
          locations.map((l) => (l.surah, l.ayah)).toList(growable: false),
        );
      case ReadingMode.page:
        final metadata = await _ensureMushaf();
        final locations = metadata.ayahsOnPage(_unitNumber);
        _ayahs = await _repository.getAyahsByKeys(
          locations.map((l) => (l.surah, l.ayah)).toList(growable: false),
        );
    }
    notifyListeners();
  }

  bool get hasNextUnit => _unitNumber < totalUnits;
  bool get hasPreviousUnit => _unitNumber > 1;

  Future<void> goToNextUnit() async {
    if (!hasNextUnit) return;
    await open(_unitNumber + 1);
  }

  Future<void> goToPreviousUnit() async {
    if (!hasPreviousUnit) return;
    await open(_unitNumber - 1);
  }

  /// Moves to the ayah right after (surah, ayah) within the current unit; if
  /// it's the last ayah of the unit, advances to the next unit's first ayah.
  /// Returns the resulting (surah, ayah), or null if already at the very end.
  Future<(int surah, int ayah)?> nextAyahAfter(int surah, int ayah) async {
    final index = _ayahs.indexWhere(
      (a) => a.surahNumber == surah && a.ayahNumber == ayah,
    );
    if (index >= 0 && index + 1 < _ayahs.length) {
      final next = _ayahs[index + 1];
      reportAyahVisited(next.surahNumber, next.ayahNumber);
      return (next.surahNumber, next.ayahNumber);
    }
    if (hasNextUnit) {
      await goToNextUnit();
      if (_ayahs.isNotEmpty) {
        final first = _ayahs.first;
        reportAyahVisited(first.surahNumber, first.ayahNumber);
        return (first.surahNumber, first.ayahNumber);
      }
    }
    return null;
  }

  /// Moves to the ayah right before (surah, ayah); if it's the first ayah of
  /// the unit, goes back to the previous unit's last ayah.
  Future<(int surah, int ayah)?> previousAyahBefore(int surah, int ayah) async {
    final index = _ayahs.indexWhere(
      (a) => a.surahNumber == surah && a.ayahNumber == ayah,
    );
    if (index > 0) {
      final prev = _ayahs[index - 1];
      reportAyahVisited(prev.surahNumber, prev.ayahNumber);
      return (prev.surahNumber, prev.ayahNumber);
    }
    if (hasPreviousUnit) {
      await goToPreviousUnit();
      if (_ayahs.isNotEmpty) {
        final last = _ayahs.last;
        reportAyahVisited(last.surahNumber, last.ayahNumber);
        return (last.surahNumber, last.ayahNumber);
      }
    }
    return null;
  }

  /// For Page Mode screens that preload every page up front for smooth
  /// swiping (and therefore never call [openPage] per swipe): records that
  /// [page] is now being read, starting at [surah]:[ayah]. Keeps
  /// Continue Reading / Reading Progress flowing through the engine even
  /// though rendering bypasses it for performance.
  void trackPageVisit(int page, {required int surah, required int ayah}) {
    _sessionStart ??= DateTime.now();
    _unitNumber = page;
    reportAyahVisited(surah, ayah);
  }

  /// Records that the reader has reached (surah, ayah) — via tap, audio
  /// playback, or page swipe. Persists Continue Reading state immediately and
  /// accumulates this session's distinct-ayah count for Reading Progress.
  void reportAyahVisited(int surahNumber, int ayahNumber) {
    _sessionStart ??= DateTime.now();
    _lastVisited = AyahRecord(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      arabicText: '',
      englishText: '',
    );
    _visitedThisSession.add('$surahNumber:$ayahNumber');
    unawaited(_persistPosition());
  }

  /// Persists continue reading immediately — safe to await before leaving a screen.
  Future<void> flush() async {
    await _persistPosition();
  }

  Future<void> _persistPosition() async {
    final last = _lastVisited;
    if (last == null) return;
    final metadata = await _ensureMushaf();
    final location = metadata.locate(last.surahNumber, last.ayahNumber);
    await StorageService.setQuranContinueReading(
      mode: mode.name,
      surah: last.surahNumber,
      ayah: last.ayahNumber,
      page: location?.page ?? (mode == ReadingMode.page ? _unitNumber : 1),
      juz: location?.juz ?? (mode == ReadingMode.juz ? _unitNumber : 1),
    );
  }

  /// Flushes the pending position write and folds this session's counters
  /// into the cumulative Reading Progress totals. Call from the owning
  /// screen's `dispose()` (best-effort; not awaited by [dispose]).
  Future<void> endSession() async {
    await _persistPosition();

    final start = _sessionStart;
    if (start != null) {
      await StorageService.addQuranReadingProgress(
        ayahsRead: _visitedThisSession.length,
        pagesRead: mode == ReadingMode.page && _visitedThisSession.isNotEmpty
            ? 1
            : 0,
        duration: DateTime.now().difference(start),
      );
    }
    _sessionStart = null;
    _visitedThisSession.clear();
  }

  @override
  void dispose() {
    unawaited(endSession());
    super.dispose();
  }
}
