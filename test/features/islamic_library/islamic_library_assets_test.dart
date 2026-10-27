import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:deenly/core/constants/app_languages.dart';
import 'package:deenly/features/islamic_library/data/islamic_library_repository.dart';
import 'package:deenly/features/islamic_library/data/library_content_language.dart';
import 'package:deenly/features/islamic_library/data/library_locale_merge.dart';
import 'package:deenly/l10n/app_localizations.dart';

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

  group('library content language', () {
    test('maps regional locales onto one content pack', () {
      expect(libraryContentLanguageCode('en'), 'en');
      expect(libraryContentLanguageCode('ar_SA'), 'ar');
      expect(libraryContentLanguageCode('ar-EG'), 'ar');
      expect(libraryContentLanguageCode('pt_BR'), 'pt');
      expect(libraryContentLanguageCode('zh_Hans'), 'zh');
      expect(libraryContentLanguageCode('ja'), 'en');
    });

    test('merge keeps Arabic and transliteration from the English source', () {
      final merged = mergeLibraryLocale(
        {
          'items': [
            {
              'arabic': 'الله',
              'transliteration': 'Allah',
              'meaning': 'God',
              'index': 1,
            },
          ],
        },
        {
          'items': [
            {
              'arabic': 'changed',
              'transliteration': 'changed',
              'meaning': 'Dieu',
              'index': 9,
            },
          ],
        },
      );
      final item = (merged['items'] as List).first as Map<String, dynamic>;
      expect(item['arabic'], 'الله');
      expect(item['transliteration'], 'Allah');
      expect(item['meaning'], 'Dieu');
      expect(item['index'], 1);
    });
  });

  group('localized Learn sections', () {
    const languages = [
      'ar',
      'az',
      'de',
      'es',
      'fr',
      'hi',
      'it',
      'nl',
      'pt',
      'ro',
      'ru',
      'zh',
    ];

    test('every supported language translates non-Quran sections', () async {
      final repo = IslamicLibraryRepository.instance;
      final english = await _SectionSnapshot.load(repo, 'en');
      for (final language in languages) {
        final localized = await _SectionSnapshot.load(repo, language);
        localized.expectMatchesEnglishShape(english);
        localized.expectProseTranslated(english, language);
      }
    });

    testWidgets('section text follows ar_SA, ar_EG, and pt_BR', (tester) async {
      for (final locale in const [
        Locale('ar', 'SA'),
        Locale('ar', 'EG'),
        Locale('pt', 'BR'),
        Locale('zh'),
        Locale('fr'),
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            supportedLocales: kSupportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const _LocalizedSectionProbe(),
          ),
        );
        await tester.pumpAndSettle();
        final probe = tester.widget<Text>(find.byKey(const Key('library-probe')));
        final text = probe.data!;
        expect(text, isNotEmpty);
        expect(text.contains('Declaration of faith'), isFalse);
        expect(text.contains('Actions are by intentions'), isFalse);
        expect(text.contains('The Most Gracious'), isFalse);
        if (locale.languageCode == 'ar') {
          expect(text, matches(RegExp(r'[\u0600-\u06FF]')));
        } else if (locale.languageCode == 'zh') {
          expect(text, matches(RegExp(r'[\u4E00-\u9FFF]')));
        }
      }
    });
  });
}

class _LocalizedSectionProbe extends StatelessWidget {
  const _LocalizedSectionProbe();

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return FutureBuilder<String>(
      future: _probeText(languageCode),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        return Text(snapshot.data!, key: const Key('library-probe'));
      },
    );
  }
}

Future<String> _probeText(String languageCode) async {
  final repo = IslamicLibraryRepository.instance;
  final results = await Future.wait([
    repo.loadPillarsOfIslam(languageCode: languageCode),
    repo.loadPillarsOfIman(languageCode: languageCode),
    repo.loadNamesOfAllah(languageCode: languageCode),
    repo.loadHadithCollections(languageCode: languageCode),
    repo.loadDuaCategories(languageCode: languageCode),
    repo.loadPrayerGuides(languageCode: languageCode),
    repo.loadProphetMuhammad(languageCode: languageCode),
    repo.loadIslamicOccasions(languageCode: languageCode),
    repo.loadFiqhTopics(languageCode: languageCode),
  ]);
  final islam = results[0] as dynamic;
  final iman = results[1] as dynamic;
  final names = results[2] as dynamic;
  final hadith = results[3] as dynamic;
  final duas = results[4] as dynamic;
  final guides = results[5] as dynamic;
  final prophet = results[6] as dynamic;
  final occasions = results[7] as dynamic;
  final fiqh = results[8] as dynamic;
  return [
    islam.first.title,
    islam.first.body,
    iman.first.title,
    names.first.meaning,
    names.first.explanation,
    hadith.first.items.first.title,
    hadith.first.items.first.translation,
    duas.first.items.first.title,
    duas.first.items.first.translation,
    guides.first.steps.first.title,
    guides.first.steps.first.description,
    prophet.first.title,
    prophet.first.body,
    occasions.first.title,
    occasions.first.importance,
    fiqh.first.title,
    fiqh.first.overview,
  ].join('\n');
}

class _SectionSnapshot {
  _SectionSnapshot({
    required this.islam,
    required this.iman,
    required this.names,
    required this.hadith,
    required this.duas,
    required this.guides,
    required this.prophet,
    required this.occasions,
    required this.fiqh,
  });

  final List<dynamic> islam;
  final List<dynamic> iman;
  final List<dynamic> names;
  final List<dynamic> hadith;
  final List<dynamic> duas;
  final List<dynamic> guides;
  final List<dynamic> prophet;
  final List<dynamic> occasions;
  final List<dynamic> fiqh;

  static Future<_SectionSnapshot> load(
    IslamicLibraryRepository repo,
    String languageCode,
  ) async {
    final results = await Future.wait([
      repo.loadPillarsOfIslam(languageCode: languageCode),
      repo.loadPillarsOfIman(languageCode: languageCode),
      repo.loadNamesOfAllah(languageCode: languageCode),
      repo.loadHadithCollections(languageCode: languageCode),
      repo.loadDuaCategories(languageCode: languageCode),
      repo.loadPrayerGuides(languageCode: languageCode),
      repo.loadProphetMuhammad(languageCode: languageCode),
      repo.loadIslamicOccasions(languageCode: languageCode),
      repo.loadFiqhTopics(languageCode: languageCode),
    ]);
    return _SectionSnapshot(
      islam: results[0],
      iman: results[1],
      names: results[2],
      hadith: results[3],
      duas: results[4],
      guides: results[5],
      prophet: results[6],
      occasions: results[7],
      fiqh: results[8],
    );
  }

  void expectMatchesEnglishShape(_SectionSnapshot english) {
    expect(islam.length, english.islam.length);
    expect(iman.length, english.iman.length);
    expect(names.length, english.names.length);
    expect(hadith.length, english.hadith.length);
    expect(duas.length, english.duas.length);
    expect(guides.length, english.guides.length);
    expect(prophet.length, english.prophet.length);
    expect(occasions.length, english.occasions.length);
    expect(fiqh.length, english.fiqh.length);
    for (var i = 0; i < names.length; i++) {
      expect(names[i].arabic, english.names[i].arabic);
      expect(names[i].transliteration, english.names[i].transliteration);
    }
    for (var i = 0; i < islam.length; i++) {
      expect(islam[i].arabic, english.islam[i].arabic);
    }
    for (final collection in duas) {
      final match = english.duas.cast<dynamic>().firstWhere(
        (category) => category.id == collection.id,
      );
      expect(collection.items.length, match.items.length);
      for (var i = 0; i < collection.items.length; i++) {
        expect(collection.items[i].arabic, match.items[i].arabic);
        expect(
          collection.items[i].transliteration,
          match.items[i].transliteration,
        );
      }
    }
  }

  void expectProseTranslated(_SectionSnapshot english, String language) {
    for (var i = 0; i < islam.length; i++) {
      _expectTranslated(islam[i].body, english.islam[i].body, language);
      _expectTranslated(islam[i].subtitle, english.islam[i].subtitle, language);
    }
    for (var i = 0; i < iman.length; i++) {
      _expectTranslated(iman[i].body, english.iman[i].body, language);
    }
    for (var i = 0; i < names.length; i++) {
      _expectTranslated(names[i].meaning, english.names[i].meaning, language);
      _expectTranslated(
        names[i].explanation,
        english.names[i].explanation,
        language,
      );
      _expectTranslated(
        names[i].reflection,
        english.names[i].reflection,
        language,
      );
    }
    for (var c = 0; c < hadith.length; c++) {
      final items = hadith[c].items as List;
      final englishItems = english.hadith[c].items as List;
      for (var i = 0; i < items.length; i++) {
        _expectTranslated(items[i].translation, englishItems[i].translation, language);
        if (_titleNeedsTranslation(englishItems[i].title as String)) {
          _expectTranslated(items[i].title, englishItems[i].title, language);
        }
      }
    }
    for (final collection in duas) {
      final match = english.duas.cast<dynamic>().firstWhere(
        (category) => category.id == collection.id,
      );
      for (var i = 0; i < collection.items.length; i++) {
        _expectTranslated(
          collection.items[i].translation,
          match.items[i].translation,
          language,
        );
        if (_titleNeedsTranslation(match.items[i].title as String)) {
          _expectTranslated(
            collection.items[i].title,
            match.items[i].title,
            language,
          );
        }
      }
    }
    for (var g = 0; g < guides.length; g++) {
      final steps = guides[g].steps as List;
      final englishSteps = english.guides[g].steps as List;
      for (var i = 0; i < steps.length; i++) {
        _expectTranslated(
          steps[i].description,
          englishSteps[i].description,
          language,
        );
      }
    }
    for (var i = 0; i < prophet.length; i++) {
      _expectTranslated(prophet[i].body, english.prophet[i].body, language);
      _expectTranslated(prophet[i].lesson, english.prophet[i].lesson, language);
      if (_titleNeedsTranslation(english.prophet[i].title as String)) {
        _expectTranslated(prophet[i].title, english.prophet[i].title, language);
      }
    }
    for (var i = 0; i < occasions.length; i++) {
      _expectTranslated(
        occasions[i].importance,
        english.occasions[i].importance,
        language,
      );
      _expectTranslated(
        occasions[i].virtues,
        english.occasions[i].virtues,
        language,
      );
      _expectTranslated(
        occasions[i].recommendedActs,
        english.occasions[i].recommendedActs,
        language,
      );
    }
    for (var i = 0; i < fiqh.length; i++) {
      _expectTranslated(fiqh[i].overview, english.fiqh[i].overview, language);
      _expectTranslated(fiqh[i].keyPoints, english.fiqh[i].keyPoints, language);
      _expectTranslated(
        fiqh[i].differences,
        english.fiqh[i].differences,
        language,
      );
      _expectTranslated(
        fiqh[i].commonGround,
        english.fiqh[i].commonGround,
        language,
      );
      if (_titleNeedsTranslation(english.fiqh[i].title as String)) {
        _expectTranslated(fiqh[i].title, english.fiqh[i].title, language);
      }
    }
    if (language == 'ar' || language == 'hi' || language == 'ru' || language == 'zh') {
      final script = switch (language) {
        'ar' => RegExp(r'[\u0600-\u06FF]'),
        'hi' => RegExp(r'[\u0900-\u097F]'),
        'ru' => RegExp(r'[\u0400-\u04FF]'),
        _ => RegExp(r'[\u4E00-\u9FFF]'),
      };
      expect(islam.first.body, matches(script));
      expect(names.first.meaning, matches(script));
      expect(fiqh.first.overview, matches(script));
    }
  }
}

bool _titleNeedsTranslation(String english) {
  const words = {
    'a',
    'an',
    'and',
    'are',
    'before',
    'by',
    'declaration',
    'faith',
    'for',
    'from',
    'how',
    'in',
    'is',
    'of',
    'on',
    'or',
    'the',
    'to',
    'what',
    'when',
    'why',
    'with',
    'your',
  };
  final parts = english.toLowerCase().split(RegExp(r"[^a-z']+"));
  return parts.any(words.contains);
}

void _expectTranslated(String? actual, String? english, String language) {
  expect(actual, isNotNull, reason: language);
  expect(actual, isNotEmpty, reason: language);
  expect(actual, isNot(english), reason: '$language still has: $english');
}
