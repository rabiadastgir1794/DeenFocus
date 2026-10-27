import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../model/allah_name.dart';
import '../model/library_dua.dart';
import '../model/library_hadith.dart';
import '../model/prophet_story_card.dart';
import '../model/library_fiqh.dart';
import '../model/library_guide.dart';
import '../model/library_pillar.dart';
import 'library_content_language.dart';
import 'library_locale_merge.dart';

class IslamicLibraryRepository {
  IslamicLibraryRepository._();

  static final IslamicLibraryRepository instance =
      IslamicLibraryRepository._();

  final Map<String, List<AllahName>> _namesByLanguage = {};
  final Map<String, List<LibraryPillar>> _pillarsIslamByLanguage = {};
  final Map<String, List<LibraryPillar>> _pillarsImanByLanguage = {};
  final Map<String, List<DuaCategory>> _duasByLanguage = {};
  final Map<String, List<HadithCollection>> _hadithByLanguage = {};
  final Map<String, List<ProphetStoryCard>> _prophetByLanguage = {};
  final Map<String, List<PrayerGuide>> _guidesByLanguage = {};
  final Map<String, List<IslamicOccasion>> _occasionsByLanguage = {};
  final Map<String, List<FiqhTopic>> _fiqhByLanguage = {};

  Future<List<AllahName>> loadNamesOfAllah({
    String languageCode = 'en',
  }) async {
    final lang = libraryContentLanguageCode(languageCode);
    final cached = _namesByLanguage[lang];
    if (cached != null) return cached;
    final decoded = await _loadLocalizedJson(
      'assets/islamic_library/names_of_allah.json',
      lang,
    );
    final items = decoded['items'] as List<dynamic>;
    final names = items
        .map((e) => AllahName.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    _namesByLanguage[lang] = names;
    return names;
  }

  Future<List<LibraryPillar>> loadPillarsOfIslam({
    String languageCode = 'en',
  }) {
    return _loadPillars(
      assetPath: 'assets/islamic_library/pillars_of_islam.json',
      languageCode: languageCode,
      cache: _pillarsIslamByLanguage,
    );
  }

  Future<List<LibraryPillar>> loadPillarsOfIman({
    String languageCode = 'en',
  }) {
    return _loadPillars(
      assetPath: 'assets/islamic_library/pillars_of_iman.json',
      languageCode: languageCode,
      cache: _pillarsImanByLanguage,
    );
  }

  Future<List<LibraryPillar>> _loadPillars({
    required String assetPath,
    required String languageCode,
    required Map<String, List<LibraryPillar>> cache,
  }) async {
    final lang = libraryContentLanguageCode(languageCode);
    final cached = cache[lang];
    if (cached != null) return cached;
    final decoded = await _loadLocalizedJson(assetPath, lang);
    final items = decoded['items'] as List<dynamic>;
    final pillars = items
        .map((e) => LibraryPillar.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    cache[lang] = pillars;
    return pillars;
  }

  Future<List<DuaCategory>> loadDuaCategories({
    String languageCode = 'en',
  }) async {
    final lang = libraryContentLanguageCode(languageCode);
    final cached = _duasByLanguage[lang];
    if (cached != null) return cached;
    final decoded = await _loadLocalizedJson(
      'assets/islamic_library/duas_adhkar.json',
      lang,
    );
    final categories = decoded['categories'] as List<dynamic>;
    final duas = categories
        .map((e) => DuaCategory.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    _duasByLanguage[lang] = duas;
    return duas;
  }

  Future<DuaCategory?> loadDuaCategory(
    String categoryId, {
    String languageCode = 'en',
  }) async {
    final categories = await loadDuaCategories(languageCode: languageCode);
    for (final category in categories) {
      if (category.id == categoryId) return category;
    }
    return null;
  }

  Future<List<HadithCollection>> loadHadithCollections({
    String languageCode = 'en',
  }) async {
    final lang = libraryContentLanguageCode(languageCode);
    final cached = _hadithByLanguage[lang];
    if (cached != null) return cached;
    final decoded = await _loadLocalizedJson(
      'assets/islamic_library/hadith.json',
      lang,
    );
    final collections = decoded['collections'] as List<dynamic>;
    final hadith = collections
        .map((e) => HadithCollection.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    _hadithByLanguage[lang] = hadith;
    return hadith;
  }

  Future<List<ProphetStoryCard>> loadProphetMuhammad({
    String languageCode = 'en',
  }) async {
    final lang = libraryContentLanguageCode(languageCode);
    final cached = _prophetByLanguage[lang];
    if (cached != null) return cached;
    final decoded = await _loadLocalizedJson(
      'assets/islamic_library/prophet_muhammad.json',
      lang,
    );
    final items = decoded['items'] as List<dynamic>;
    final cards = items
        .map((e) => ProphetStoryCard.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    _prophetByLanguage[lang] = cards;
    return cards;
  }

  Future<List<PrayerGuide>> loadPrayerGuides({
    String languageCode = 'en',
  }) async {
    final lang = libraryContentLanguageCode(languageCode);
    final cached = _guidesByLanguage[lang];
    if (cached != null) return cached;
    final decoded = await _loadLocalizedJson(
      'assets/islamic_library/prayer_methods.json',
      lang,
    );
    final guidesJson = decoded['guides'] as List<dynamic>;
    final guides = guidesJson
        .map((e) => PrayerGuide.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    _guidesByLanguage[lang] = guides;
    return guides;
  }

  Future<List<IslamicOccasion>> loadIslamicOccasions({
    String languageCode = 'en',
  }) async {
    final lang = libraryContentLanguageCode(languageCode);
    final cached = _occasionsByLanguage[lang];
    if (cached != null) return cached;
    final decoded = await _loadLocalizedJson(
      'assets/islamic_library/islamic_occasions.json',
      lang,
    );
    final items = decoded['items'] as List<dynamic>;
    final occasions = items
        .map((e) => IslamicOccasion.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    _occasionsByLanguage[lang] = occasions;
    return occasions;
  }

  Future<List<FiqhTopic>> loadFiqhTopics({
    String languageCode = 'en',
  }) async {
    final lang = libraryContentLanguageCode(languageCode);
    final cached = _fiqhByLanguage[lang];
    if (cached != null) return cached;
    final decoded = await _loadLocalizedJson(
      'assets/islamic_library/fiqh_differences.json',
      lang,
    );
    final items = decoded['items'] as List<dynamic>;
    final topics = items
        .map((e) => FiqhTopic.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    _fiqhByLanguage[lang] = topics;
    return topics;
  }

  Future<Map<String, dynamic>> _loadLocalizedJson(
    String assetPath,
    String languageCode,
  ) async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final lang = libraryContentLanguageCode(languageCode);
    if (lang == 'en') return decoded;
    final fileName = assetPath.split('/').last;
    final overlayPath = 'assets/islamic_library/l10n/$lang/$fileName';
    try {
      final overlayRaw = await rootBundle.loadString(overlayPath);
      final overlay = jsonDecode(overlayRaw) as Map<String, dynamic>;
      return mergeLibraryLocale(decoded, overlay);
    } on FlutterError {
      return decoded;
    }
  }
}
