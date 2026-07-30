import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/services/storage_service.dart';
import '../reading_engine/quran_script.dart';
import '../reading_engine/quran_script_texts.dart';

class SurahSummary {
  const SurahSummary({
    required this.number,
    required this.name,
    required this.arabicName,
    required this.verses,
    required this.revelationType,
  });

  final int number;
  final String name;
  final String arabicName;
  final int verses;
  final String revelationType;

  factory SurahSummary.fromMap(Map<dynamic, dynamic> map) {
    return SurahSummary(
      number: (map['number'] as num).toInt(),
      name: map['name'] as String,
      arabicName: map['arabicName'] as String,
      verses: (map['verses'] as num).toInt(),
      revelationType: map['revelationType'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'number': number,
      'name': name,
      'arabicName': arabicName,
      'verses': verses,
      'revelationType': revelationType,
    };
  }
}

class AyahRecord {
  const AyahRecord({
    required this.surahNumber,
    required this.ayahNumber,
    required this.arabicText,
    required this.englishText,
  });

  final int surahNumber;
  final int ayahNumber;
  final String arabicText;
  final String englishText;

  factory AyahRecord.fromMap(Map<dynamic, dynamic> map) {
    return AyahRecord(
      surahNumber: (map['surahNumber'] as num).toInt(),
      ayahNumber: (map['ayahNumber'] as num).toInt(),
      arabicText: map['arabicText'] as String,
      englishText: map['englishText'] as String,
    );
  }

  AyahRecord copyWith({String? arabicText, String? englishText}) {
    return AyahRecord(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      arabicText: arabicText ?? this.arabicText,
      englishText: englishText ?? this.englishText,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'arabicText': arabicText,
      'englishText': englishText,
    };
  }
}

class QuranLocalRepository {
  QuranLocalRepository._();

  static final QuranLocalRepository instance = QuranLocalRepository._();

  static const String _surahBoxName = 'quran_surahs';
  static const String _ayahBoxName = 'quran_ayahs';
  static const int _seedVersion = 1;

  bool _initialized = false;
  Future<void>? _initializing;
  late final Box<Map> _surahBox;
  late final Box<Map> _ayahBox;

  Future<void> ensureInitialized() async {
    if (_initialized) return;
    if (_initializing != null) {
      await _initializing;
      return;
    }

    _initializing = _initializeInternal();
    try {
      await _initializing;
    } finally {
      _initializing = null;
    }
  }

  Future<void> _initializeInternal() async {
    if (_initialized) return;

    _surahBox = await Hive.openBox<Map>(_surahBoxName);
    _ayahBox = await Hive.openBox<Map>(_ayahBoxName);

    final seedVersion = await StorageService.quranSeedVersion;
    final needsSeed =
        seedVersion < _seedVersion || _surahBox.isEmpty || _ayahBox.isEmpty;
    if (needsSeed) {
      await _seedFromAssets();
      await StorageService.setQuranSeedVersion(_seedVersion);
    }

    _initialized = true;
  }

  Future<List<SurahSummary>> getSurahs() async {
    await ensureInitialized();
    final surahs =
        _surahBox.values.map(SurahSummary.fromMap).toList(growable: false)
          ..sort((a, b) => a.number.compareTo(b.number));
    return surahs;
  }

  Future<List<AyahRecord>> getAyahsBySurah(int surahNumber) async {
    await ensureInitialized();
    final records =
        _ayahBox.values
            .where((value) => value['surahNumber'] == surahNumber)
            .map(AyahRecord.fromMap)
            .toList(growable: false)
          ..sort((a, b) => a.ayahNumber.compareTo(b.ayahNumber));
    return _applySelectedScript(records);
  }

  /// All 6236 ayahs, ordered by surah then ayah number — same order as the
  /// bundled Mushaf page/juz mapping (`reading_engine/mushaf_metadata.dart`).
  /// Used by Page Mode to preload the whole book once for smooth swiping.
  Future<List<AyahRecord>> getAllAyahs() async {
    await ensureInitialized();
    final records =
        _ayahBox.values.map(AyahRecord.fromMap).toList(growable: false)
          ..sort((a, b) {
            final surahCompare = a.surahNumber.compareTo(b.surahNumber);
            return surahCompare != 0
                ? surahCompare
                : a.ayahNumber.compareTo(b.ayahNumber);
          });
    return _applySelectedScript(records);
  }

  /// Looks up ayahs by exact (surah, ayah) pairs, preserving the order of
  /// [keys]. Used by Juz Mode and Page Mode, whose ayah ranges come from the
  /// Mushaf page/juz mapping (see `reading_engine/mushaf_metadata.dart`)
  /// rather than a single contiguous surah.
  Future<List<AyahRecord>> getAyahsByKeys(
    List<(int surah, int ayah)> keys,
  ) async {
    await ensureInitialized();
    final records = <AyahRecord>[];
    for (final (surah, ayah) in keys) {
      final map = _ayahBox.get('$surah:$ayah');
      if (map != null) records.add(AyahRecord.fromMap(map));
    }
    return _applySelectedScript(records);
  }

  /// Overlays the user's selected script orthography onto Hive-backed ayahs
  /// (English + structure stay in Hive; Arabic glyphs come from
  /// `assets/quran/text/<script>.json`).
  Future<List<AyahRecord>> _applySelectedScript(
    List<AyahRecord> records,
  ) async {
    if (records.isEmpty) return records;
    final script = QuranScriptX.fromName(await StorageService.quranScript);
    final texts = await QuranScriptTexts.load(script);
    return records
        .map((a) {
          final text = texts.textFor(a.surahNumber, a.ayahNumber);
          return text == null ? a : a.copyWith(arabicText: text);
        })
        .toList(growable: false);
  }

  Future<void> _seedFromAssets() async {
    final arabicRaw = await rootBundle.loadString('assets/raw/quran_paak.json');
    final englishRaw = await rootBundle.loadString(
      'assets/raw/english_translation.json',
    );
    final arabicData = (jsonDecode(arabicRaw) as List<dynamic>).cast<Map>();
    final englishData = (jsonDecode(englishRaw) as List<dynamic>).cast<Map>();

    final Map<int, Map<String, dynamic>> englishBySurah =
        <int, Map<String, dynamic>>{};
    for (final surah in englishData) {
      final index = int.tryParse('${surah['@index']}');
      if (index != null) {
        englishBySurah[index] = Map<String, dynamic>.from(surah);
      }
    }

    final Map<dynamic, Map> surahRows = <dynamic, Map>{};
    final Map<dynamic, Map> ayahRows = <dynamic, Map>{};

    for (final rawSurah in arabicData) {
      final surah = Map<String, dynamic>.from(rawSurah);
      final surahNumber = int.tryParse('${surah['@index']}');
      if (surahNumber == null) continue;

      final ayat = (surah['aya'] as List<dynamic>)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(growable: false);
      final englishSurahAyat =
          (englishBySurah[surahNumber]?['aya'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList(growable: false) ??
          const <Map<String, dynamic>>[];

      surahRows[surahNumber] = SurahSummary(
        number: surahNumber,
        name: _surahEnglishNames[surahNumber] ?? 'Surah $surahNumber',
        arabicName: '${surah['@name'] ?? ''}',
        verses: ayat.length,
        revelationType: _medinanSurahs.contains(surahNumber)
            ? 'Medinan'
            : 'Meccan',
      ).toMap();

      for (final ayah in ayat) {
        final ayahNumber = int.tryParse('${ayah['@index']}');
        if (ayahNumber == null) continue;
        final englishAyah = englishSurahAyat.firstWhere(
          (a) => int.tryParse('${a['@index']}') == ayahNumber,
          orElse: () => const <String, dynamic>{},
        );

        final record = AyahRecord(
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
          arabicText: '${ayah['@text'] ?? ''}',
          englishText: '${englishAyah['@text'] ?? ''}',
        );
        ayahRows['$surahNumber:$ayahNumber'] = record.toMap();
      }
    }

    await _surahBox.clear();
    await _ayahBox.clear();
    await _surahBox.putAll(surahRows);
    await _ayahBox.putAll(ayahRows);
  }
}

const Set<int> _medinanSurahs = <int>{
  2,
  3,
  4,
  5,
  8,
  9,
  13,
  22,
  24,
  33,
  47,
  48,
  49,
  55,
  57,
  58,
  59,
  60,
  61,
  62,
  63,
  64,
  65,
  66,
  76,
  98,
  99,
  110,
};

const Map<int, String> _surahEnglishNames = <int, String>{
  1: 'Al-Fatihah',
  2: 'Al-Baqarah',
  3: "Ali 'Imran",
  4: 'An-Nisa',
  5: "Al-Ma'idah",
  6: "Al-An'am",
  7: "Al-A'raf",
  8: 'Al-Anfal',
  9: 'At-Tawbah',
  10: 'Yunus',
  11: 'Hud',
  12: 'Yusuf',
  13: "Ar-Ra'd",
  14: 'Ibrahim',
  15: 'Al-Hijr',
  16: 'An-Nahl',
  17: 'Al-Isra',
  18: 'Al-Kahf',
  19: 'Maryam',
  20: 'Ta-Ha',
  21: 'Al-Anbiya',
  22: 'Al-Hajj',
  23: "Al-Mu'minun",
  24: 'An-Nur',
  25: 'Al-Furqan',
  26: "Ash-Shu'ara",
  27: 'An-Naml',
  28: 'Al-Qasas',
  29: "Al-'Ankabut",
  30: 'Ar-Rum',
  31: 'Luqman',
  32: 'As-Sajdah',
  33: 'Al-Ahzab',
  34: "Saba'",
  35: 'Fatir',
  36: 'Ya-Sin',
  37: 'As-Saffat',
  38: 'Sad',
  39: 'Az-Zumar',
  40: 'Ghafir',
  41: 'Fussilat',
  42: 'Ash-Shura',
  43: 'Az-Zukhruf',
  44: 'Ad-Dukhan',
  45: 'Al-Jathiyah',
  46: 'Al-Ahqaf',
  47: 'Muhammad',
  48: 'Al-Fath',
  49: 'Al-Hujurat',
  50: 'Qaf',
  51: 'Adh-Dhariyat',
  52: 'At-Tur',
  53: 'An-Najm',
  54: 'Al-Qamar',
  55: 'Ar-Rahman',
  56: "Al-Waqi'ah",
  57: 'Al-Hadid',
  58: 'Al-Mujadilah',
  59: 'Al-Hashr',
  60: 'Al-Mumtahanah',
  61: 'As-Saff',
  62: "Al-Jumu'ah",
  63: 'Al-Munafiqun',
  64: 'At-Taghabun',
  65: 'At-Talaq',
  66: 'At-Tahrim',
  67: 'Al-Mulk',
  68: 'Al-Qalam',
  69: 'Al-Haqqah',
  70: "Al-Ma'arij",
  71: 'Nuh',
  72: 'Al-Jinn',
  73: 'Al-Muzzammil',
  74: 'Al-Muddaththir',
  75: 'Al-Qiyamah',
  76: 'Al-Insan',
  77: 'Al-Mursalat',
  78: "An-Naba'",
  79: "An-Nazi'at",
  80: "'Abasa",
  81: 'At-Takwir',
  82: 'Al-Infitar',
  83: 'Al-Mutaffifin',
  84: 'Al-Inshiqaq',
  85: 'Al-Buruj',
  86: 'At-Tariq',
  87: "Al-A'la",
  88: 'Al-Ghashiyah',
  89: 'Al-Fajr',
  90: 'Al-Balad',
  91: 'Ash-Shams',
  92: 'Al-Layl',
  93: 'Ad-Duhaa',
  94: 'Ash-Sharh',
  95: 'At-Tin',
  96: "Al-'Alaq",
  97: 'Al-Qadr',
  98: 'Al-Bayyinah',
  99: 'Az-Zalzalah',
  100: "Al-'Adiyat",
  101: "Al-Qari'ah",
  102: 'At-Takathur',
  103: "Al-'Asr",
  104: 'Al-Humazah',
  105: 'Al-Fil',
  106: 'Quraysh',
  107: "Al-Ma'un",
  108: 'Al-Kawthar',
  109: 'Al-Kafirun',
  110: 'An-Nasr',
  111: 'Al-Masad',
  112: 'Al-Ikhlas',
  113: 'Al-Falaq',
  114: 'An-Nas',
};
