import 'package:flutter/foundation.dart';

import '../../quran/data/quran_local_repository.dart';
import '../helpers/home_daily_verse_helper.dart';
import '../model/home_models.dart';

/// Curated authentic ayahs loaded from [QuranLocalRepository].
class LockScreenVerseViewModel extends ChangeNotifier {
  static const catalog = <DailyVerseRef>[
    DailyVerseRef(surahNumber: 1, ayahNumber: 5),
    DailyVerseRef(surahNumber: 2, ayahNumber: 45),
    DailyVerseRef(surahNumber: 2, ayahNumber: 152),
    DailyVerseRef(surahNumber: 2, ayahNumber: 186),
    DailyVerseRef(surahNumber: 3, ayahNumber: 139),
    DailyVerseRef(surahNumber: 13, ayahNumber: 28),
    DailyVerseRef(surahNumber: 16, ayahNumber: 90),
    DailyVerseRef(surahNumber: 17, ayahNumber: 23),
    DailyVerseRef(surahNumber: 33, ayahNumber: 41),
    DailyVerseRef(surahNumber: 39, ayahNumber: 53),
    DailyVerseRef(surahNumber: 94, ayahNumber: 5),
    DailyVerseRef(surahNumber: 112, ayahNumber: 1),
  ];

  final List<HomeDailyVerse> _verses = [];
  int _index = 0;
  bool _loading = true;

  bool get loading => _loading;
  int get index => _index;
  HomeDailyVerse? get current =>
      _verses.isEmpty ? null : _verses[_index % _verses.length];

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    await QuranLocalRepository.instance.ensureInitialized();
    final loaded = <HomeDailyVerse>[];
    for (final ref in catalog) {
      final verse = await HomeDailyVerseHelper.loadDailyVerse(ref);
      if (verse != null &&
          verse.arabicText.trim().isNotEmpty &&
          verse.englishText.trim().isNotEmpty) {
        loaded.add(verse);
      }
    }
    _verses
      ..clear()
      ..addAll(loaded);
    _index = 0;
    _loading = false;
    notifyListeners();
  }

  void next() {
    if (_verses.isEmpty) return;
    _index = (_index + 1) % _verses.length;
    notifyListeners();
  }
}
