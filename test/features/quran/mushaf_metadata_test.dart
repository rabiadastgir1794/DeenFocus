import 'package:flutter_test/flutter_test.dart';

import 'package:deenly/features/quran/reading_engine/mushaf_metadata.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MushafMetadata (assets/quran/uthmani.json)', () {
    late MushafMetadata metadata;

    setUpAll(() async {
      metadata = await MushafMetadata.load();
    });

    test('reports the standard 604-page, 30-juz Madani Mushaf', () {
      expect(metadata.totalPages, 604);
      expect(metadata.totalJuz, 30);
    });

    test('page 1 starts at 1:1 and page 2 starts at 2:1', () {
      expect(metadata.firstAyahOfPage(1)?.surah, 1);
      expect(metadata.firstAyahOfPage(1)?.ayah, 1);
      expect(metadata.firstAyahOfPage(2)?.surah, 2);
      expect(metadata.firstAyahOfPage(2)?.ayah, 1);
    });

    test('juz boundaries match the known Madani Mushaf layout', () {
      // Juz 2 famously starts at Al-Baqarah 142.
      expect(metadata.firstAyahOfJuz(2)?.surah, 2);
      expect(metadata.firstAyahOfJuz(2)?.ayah, 142);
      // Juz 30 starts at An-Naba (78:1).
      expect(metadata.firstAyahOfJuz(30)?.surah, 78);
      expect(metadata.firstAyahOfJuz(30)?.ayah, 1);
    });

    test('locate()/pageForAyah()/juzForAyah() agree with each other', () {
      final location = metadata.locate(2, 142);
      expect(location, isNotNull);
      expect(metadata.pageForAyah(2, 142), location!.page);
      expect(metadata.juzForAyah(2, 142), 2);
    });

    test('ayahsOnPage and ayahsInJuz return non-empty, ordered ranges', () {
      final pageOne = metadata.ayahsOnPage(1);
      expect(pageOne, isNotEmpty);
      expect(pageOne.first.surah, 1);
      expect(pageOne.first.ayah, 1);

      final juzOne = metadata.ayahsInJuz(1);
      expect(juzOne, isNotEmpty);
      expect(juzOne.first.surah, 1);
      expect(juzOne.first.ayah, 1);
    });

    test('pagesForSurah returns only Madani pages that contain the surah', () {
      // Al-Fatihah is entirely on page 1.
      expect(metadata.pagesForSurah(1), [1]);
      // Al-Baqarah spans many pages starting at page 2.
      final baqarahPages = metadata.pagesForSurah(2);
      expect(baqarahPages.first, 2);
      expect(baqarahPages.length, greaterThan(40));
      // Shared page content is filtered to the requested surah only.
      final page2Baqarah = metadata.ayahsOfSurahOnPage(2, 2);
      expect(page2Baqarah, isNotEmpty);
      expect(page2Baqarah.every((a) => a.surah == 2), isTrue);
    });
  });
}
