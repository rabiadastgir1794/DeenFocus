import 'package:flutter/material.dart';

import '../data/islamic_library_repository.dart';
import '../model/library_bookmark_entry.dart';
import '../model/library_hadith.dart';
import '../model/library_guide.dart';
import '../model/library_module.dart';
import '../view/duas_reader_screen.dart';
import '../view/fiqh_differences_screen.dart';
import '../view/hadith_reader_screen.dart';
import '../view/islamic_occasions_screen.dart';
import '../view/names_of_allah_screen.dart';
import '../view/pillars_reader_screen.dart';
import '../view/prayer_guide_reader_screen.dart';
import '../view/prophet_muhammad_screen.dart';

Future<void> openLibraryBookmark(
  BuildContext context,
  LibraryBookmarkEntry entry,
) async {
  final cardIndex = entry.cardIndex;
  switch (entry.moduleId) {
    case LibraryModuleId.namesOfAllah:
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => NamesOfAllahScreen(initialCardIndex: cardIndex),
        ),
      );
      return;
    case LibraryModuleId.hadith:
      final collections =
          await IslamicLibraryRepository.instance.loadHadithCollections();
      HadithCollection? collection;
      for (final item in collections) {
        if (item.id == entry.subSectionId) {
          collection = item;
          break;
        }
      }
      if (!context.mounted || collection == null) return;
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => HadithReaderScreen(
            collection: collection!,
            initialCardIndex: cardIndex,
          ),
        ),
      );
      return;
    case LibraryModuleId.duasAdhkar:
      final category = await IslamicLibraryRepository.instance
          .loadDuaCategory(entry.subSectionId!);
      if (!context.mounted || category == null) return;
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => DuasReaderScreen(
            category: category,
            initialCardIndex: cardIndex,
          ),
        ),
      );
      return;
    case LibraryModuleId.prayerMethods:
      final guides =
          await IslamicLibraryRepository.instance.loadPrayerGuides();
      PrayerGuide? guide;
      for (final item in guides) {
        if (item.id == entry.subSectionId) {
          guide = item;
          break;
        }
      }
      if (!context.mounted || guide == null) return;
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => PrayerGuideReaderScreen(
            guide: guide!,
            initialCardIndex: cardIndex,
          ),
        ),
      );
      return;
    case LibraryModuleId.pillarsOfIslam:
    case LibraryModuleId.pillarsOfIman:
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => PillarsReaderScreen(
            moduleId: entry.moduleId,
            initialCardIndex: cardIndex,
          ),
        ),
      );
      return;
    case LibraryModuleId.prophets:
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) =>
              ProphetMuhammadScreen(initialCardIndex: cardIndex),
        ),
      );
      return;
    case LibraryModuleId.islamicOccasions:
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) =>
              IslamicOccasionsScreen(initialCardIndex: cardIndex),
        ),
      );
      return;
    case LibraryModuleId.fiqhDifferences:
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) =>
              FiqhDifferencesScreen(initialCardIndex: cardIndex),
        ),
      );
      return;
    case LibraryModuleId.quran:
      return;
  }
}
