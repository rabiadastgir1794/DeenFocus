import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:deenly/features/islamic_library/data/islamic_library_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('IslamicLibraryRepository prayer & occasions assets', () {
    test('loads 10 prayer guides with steps', () async {
      final guides =
          await IslamicLibraryRepository.instance.loadPrayerGuides();
      expect(guides.length, 10);
      expect(guides.first.steps, isNotEmpty);
      expect(guides.map((g) => g.id).toSet(), containsAll(<String>{
        'wudu',
        'salah',
        'ghusl',
        'tayammum',
        'janazah',
        'umrah',
        'hajj',
        'fasting',
        'zakat',
        'tawbah',
      }));
    });

    test('loads 7 islamic occasions', () async {
      final occasions =
          await IslamicLibraryRepository.instance.loadIslamicOccasions();
      expect(occasions.length, 7);
      expect(occasions.first.title, isNotEmpty);
      expect(occasions.first.importance, isNotEmpty);
    });

    test('loads 15 fiqh topics', () async {
      final topics =
          await IslamicLibraryRepository.instance.loadFiqhTopics();
      expect(topics.length, 15);
      expect(topics.first.overview, isNotEmpty);
      expect(
        topics.any((t) => t.title.contains('Ahl-e Hadith')),
        isTrue,
      );
    });

    test('cover WebP assets exist for hub modules and dua categories', () {
      const base = 'assets/islamic_library/covers';
      const modules = [
        'module_quran.webp',
        'module_hadith.webp',
        'module_duas_adhkar.webp',
        'module_prayer_methods.webp',
        'module_fiqh_differences.webp',
        'module_names_of_allah.webp',
        'module_pillars_of_islam.webp',
        'module_pillars_of_iman.webp',
        'module_prophets.webp',
        'module_islamic_occasions.webp',
      ];
      const duas = [
        'dua_morning.webp',
        'dua_evening.webp',
        'dua_daily_life.webp',
        'dua_sleep.webp',
        'dua_food.webp',
        'dua_travel.webp',
        'dua_illness.webp',
        'dua_protection.webp',
        'dua_forgiveness.webp',
        'dua_parents.webp',
      ];
      for (final file in [...modules, ...duas]) {
        expect(File('$base/$file').existsSync(), isTrue, reason: file);
      }
    });

    test('loads 94 hadith across collections', () async {
      final collections =
          await IslamicLibraryRepository.instance.loadHadithCollections();
      final total = collections.fold<int>(0, (sum, c) => sum + c.items.length);
      expect(total, 94);
      expect(collections.firstWhere((c) => c.id == 'nawawi_40').items.length, 40);
    });

    test('loads expanded duas/adhkar across categories', () async {
      final categories =
          await IslamicLibraryRepository.instance.loadDuaCategories();
      final byId = {for (final c in categories) c.id: c};
      expect(byId['morning']!.items.length, greaterThanOrEqualTo(12));
      expect(byId['evening']!.items.length, greaterThanOrEqualTo(12));
      expect(byId['daily_life']!.items.length, greaterThanOrEqualTo(15));
      expect(byId['sleep']!.items.length, greaterThanOrEqualTo(8));
      final total =
          categories.fold<int>(0, (sum, c) => sum + c.items.length);
      expect(total, greaterThanOrEqualTo(90));
    });
  });
}
