import 'dart:convert';

import 'package:flutter/services.dart';

import '../model/allah_name.dart';
import '../model/library_dua.dart';
import '../model/library_hadith.dart';
import '../model/prophet_story_card.dart';
import '../model/library_fiqh.dart';
import '../model/library_guide.dart';
import '../model/library_pillar.dart';

class IslamicLibraryRepository {
  IslamicLibraryRepository._();

  static final IslamicLibraryRepository instance =
      IslamicLibraryRepository._();

  List<AllahName>? _cachedNames;
  List<LibraryPillar>? _cachedPillarsIslam;
  List<LibraryPillar>? _cachedPillarsIman;
  List<DuaCategory>? _cachedDuas;
  List<HadithCollection>? _cachedHadith;
  List<ProphetStoryCard>? _cachedProphetMuhammad;
  List<PrayerGuide>? _cachedPrayerGuides;
  List<IslamicOccasion>? _cachedOccasions;
  List<FiqhTopic>? _cachedFiqhTopics;

  Future<List<AllahName>> loadNamesOfAllah() async {
    if (_cachedNames != null) return _cachedNames!;
    final raw = await rootBundle.loadString(
      'assets/islamic_library/names_of_allah.json',
    );
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final items = decoded['items'] as List<dynamic>;
    _cachedNames = items
        .map((e) => AllahName.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    return _cachedNames!;
  }

  Future<List<LibraryPillar>> loadPillarsOfIslam() async {
    return _loadPillars(
      assetPath: 'assets/islamic_library/pillars_of_islam.json',
      cache: () => _cachedPillarsIslam,
      store: (v) => _cachedPillarsIslam = v,
    );
  }

  Future<List<LibraryPillar>> loadPillarsOfIman() async {
    return _loadPillars(
      assetPath: 'assets/islamic_library/pillars_of_iman.json',
      cache: () => _cachedPillarsIman,
      store: (v) => _cachedPillarsIman = v,
    );
  }

  Future<List<LibraryPillar>> _loadPillars({
    required String assetPath,
    required List<LibraryPillar>? Function() cache,
    required void Function(List<LibraryPillar>?) store,
  }) async {
    final cached = cache();
    if (cached != null) return cached;
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final items = decoded['items'] as List<dynamic>;
    final pillars = items
        .map((e) => LibraryPillar.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    store(pillars);
    return pillars;
  }

  Future<List<DuaCategory>> loadDuaCategories() async {
    if (_cachedDuas != null) return _cachedDuas!;
    final raw = await rootBundle.loadString(
      'assets/islamic_library/duas_adhkar.json',
    );
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final categories = decoded['categories'] as List<dynamic>;
    _cachedDuas = categories
        .map((e) => DuaCategory.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    return _cachedDuas!;
  }

  Future<DuaCategory?> loadDuaCategory(String categoryId) async {
    final categories = await loadDuaCategories();
    for (final category in categories) {
      if (category.id == categoryId) return category;
    }
    return null;
  }

  Future<List<HadithCollection>> loadHadithCollections() async {
    if (_cachedHadith != null) return _cachedHadith!;
    final raw = await rootBundle.loadString(
      'assets/islamic_library/hadith.json',
    );
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final collections = decoded['collections'] as List<dynamic>;
    _cachedHadith = collections
        .map((e) => HadithCollection.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    return _cachedHadith!;
  }

  Future<List<ProphetStoryCard>> loadProphetMuhammad() async {
    if (_cachedProphetMuhammad != null) return _cachedProphetMuhammad!;
    final raw = await rootBundle.loadString(
      'assets/islamic_library/prophet_muhammad.json',
    );
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final items = decoded['items'] as List<dynamic>;
    _cachedProphetMuhammad = items
        .map((e) => ProphetStoryCard.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    return _cachedProphetMuhammad!;
  }

  Future<List<PrayerGuide>> loadPrayerGuides() async {
    if (_cachedPrayerGuides != null) return _cachedPrayerGuides!;
    final raw = await rootBundle.loadString(
      'assets/islamic_library/prayer_methods.json',
    );
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final guides = decoded['guides'] as List<dynamic>;
    _cachedPrayerGuides = guides
        .map((e) => PrayerGuide.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    return _cachedPrayerGuides!;
  }

  Future<List<IslamicOccasion>> loadIslamicOccasions() async {
    if (_cachedOccasions != null) return _cachedOccasions!;
    final raw = await rootBundle.loadString(
      'assets/islamic_library/islamic_occasions.json',
    );
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final items = decoded['items'] as List<dynamic>;
    _cachedOccasions = items
        .map((e) => IslamicOccasion.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    return _cachedOccasions!;
  }

  Future<List<FiqhTopic>> loadFiqhTopics() async {
    if (_cachedFiqhTopics != null) return _cachedFiqhTopics!;
    final raw = await rootBundle.loadString(
      'assets/islamic_library/fiqh_differences.json',
    );
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final items = decoded['items'] as List<dynamic>;
    _cachedFiqhTopics = items
        .map((e) => FiqhTopic.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    return _cachedFiqhTopics!;
  }
}
