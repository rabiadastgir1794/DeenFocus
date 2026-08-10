import '../../../l10n/app_localizations.dart';
import '../model/allah_name.dart';
import '../model/library_bookmark_entry.dart';
import '../model/library_dua.dart';
import '../model/library_fiqh.dart';
import '../model/library_guide.dart';
import '../model/library_hadith.dart';
import '../model/library_module.dart';
import '../model/library_pillar.dart';
import '../model/prophet_story_card.dart';
import '../view/duas_categories_screen.dart';
import '../view/hadith_collections_screen.dart';
import '../view/prayer_guides_screen.dart';
import '../widgets/library_module_card.dart';
import 'islamic_library_repository.dart';
import 'library_progress_service.dart';

abstract final class LibraryBookmarkService {
  static Future<List<LibraryBookmarkEntry>> list(AppLocalizations l10n) async {
    final all = await LibraryProgressService.instance.loadAllProgress();
    final hasBookmarks =
        all.values.any((progress) => progress.bookmarks.isNotEmpty);
    if (!hasBookmarks) return const [];

    final repo = IslamicLibraryRepository.instance;
    final results = await Future.wait<Object>([
      repo.loadNamesOfAllah(),
      repo.loadHadithCollections(),
      repo.loadDuaCategories(),
      repo.loadPillarsOfIslam(),
      repo.loadPillarsOfIman(),
      repo.loadProphetMuhammad(),
      repo.loadPrayerGuides(),
      repo.loadIslamicOccasions(),
      repo.loadFiqhTopics(),
    ]);

    final names = results[0] as List<AllahName>;
    final hadith = results[1] as List<HadithCollection>;
    final duas = results[2] as List<DuaCategory>;
    final pillarsIslam = results[3] as List<LibraryPillar>;
    final pillarsIman = results[4] as List<LibraryPillar>;
    final prophet = results[5] as List<ProphetStoryCard>;
    final guides = results[6] as List<PrayerGuide>;
    final occasions = results[7] as List<IslamicOccasion>;
    final fiqh = results[8] as List<FiqhTopic>;

    final entries = <LibraryBookmarkEntry>[];
    for (final MapEntry(:key, :value) in all.entries) {
      if (value.bookmarks.isEmpty) continue;
      for (final cardIndex in value.bookmarks) {
        final entry = _resolve(
          l10n: l10n,
          sectionId: key,
          cardIndex: cardIndex,
          names: names,
          hadith: hadith,
          duas: duas,
          pillarsIslam: pillarsIslam,
          pillarsIman: pillarsIman,
          prophet: prophet,
          guides: guides,
          occasions: occasions,
          fiqh: fiqh,
        );
        if (entry != null) entries.add(entry);
      }
    }

    entries.sort((a, b) {
      final module = a.moduleLabel.compareTo(b.moduleLabel);
      if (module != 0) return module;
      final section = a.sectionLabel.compareTo(b.sectionLabel);
      if (section != 0) return section;
      return a.cardIndex.compareTo(b.cardIndex);
    });
    return entries;
  }

  static Future<void> remove(LibraryBookmarkEntry entry) {
    return LibraryProgressService.instance.removeBookmark(
      entry.sectionId,
      entry.cardIndex,
    );
  }

  static LibraryBookmarkEntry? _resolve({
    required AppLocalizations l10n,
    required String sectionId,
    required int cardIndex,
    required List<AllahName> names,
    required List<HadithCollection> hadith,
    required List<DuaCategory> duas,
    required List<LibraryPillar> pillarsIslam,
    required List<LibraryPillar> pillarsIman,
    required List<ProphetStoryCard> prophet,
    required List<PrayerGuide> guides,
    required List<IslamicOccasion> occasions,
    required List<FiqhTopic> fiqh,
  }) {
    if (sectionId == LibraryModuleId.namesOfAllah.name) {
      if (cardIndex < 0 || cardIndex >= names.length) return null;
      final name = names[cardIndex];
      return LibraryBookmarkEntry(
        sectionId: sectionId,
        cardIndex: cardIndex,
        moduleId: LibraryModuleId.namesOfAllah,
        moduleLabel: libraryModuleTitle(l10n, LibraryModuleId.namesOfAllah),
        sectionLabel: libraryModuleTitle(l10n, LibraryModuleId.namesOfAllah),
        title: name.transliteration,
        preview: _preview(name.meaning),
      );
    }

    if (sectionId.startsWith('hadith_')) {
      final id = sectionId.substring('hadith_'.length);
      final collection = _findById(hadith, id);
      if (collection == null) return null;
      if (cardIndex < 0 || cardIndex >= collection.items.length) return null;
      final item = collection.items[cardIndex];
      return LibraryBookmarkEntry(
        sectionId: sectionId,
        cardIndex: cardIndex,
        moduleId: LibraryModuleId.hadith,
        subSectionId: id,
        moduleLabel: libraryModuleTitle(l10n, LibraryModuleId.hadith),
        sectionLabel: hadithCollectionTitle(l10n, id),
        title: item.title,
        preview: _preview(item.translation),
      );
    }

    if (sectionId.startsWith('duasAdhkar_')) {
      final id = sectionId.substring('duasAdhkar_'.length);
      final category = _findDuaCategory(duas, id);
      if (category == null) return null;
      if (cardIndex < 0 || cardIndex >= category.items.length) return null;
      final item = category.items[cardIndex];
      return LibraryBookmarkEntry(
        sectionId: sectionId,
        cardIndex: cardIndex,
        moduleId: LibraryModuleId.duasAdhkar,
        subSectionId: id,
        moduleLabel: libraryModuleTitle(l10n, LibraryModuleId.duasAdhkar),
        sectionLabel: duaCategoryTitle(l10n, id),
        title: item.title,
        preview: _preview(item.translation),
      );
    }

    if (sectionId.startsWith('prayerMethods_')) {
      final id = sectionId.substring('prayerMethods_'.length);
      final guide = _findGuide(guides, id);
      if (guide == null) return null;
      if (cardIndex < 0 || cardIndex >= guide.steps.length) return null;
      final step = guide.steps[cardIndex];
      return LibraryBookmarkEntry(
        sectionId: sectionId,
        cardIndex: cardIndex,
        moduleId: LibraryModuleId.prayerMethods,
        subSectionId: id,
        moduleLabel: libraryModuleTitle(l10n, LibraryModuleId.prayerMethods),
        sectionLabel: prayerGuideTitle(l10n, id),
        title: step.title,
        preview: _preview(step.description),
      );
    }

    if (sectionId == LibraryModuleId.pillarsOfIslam.name) {
      if (cardIndex < 0 || cardIndex >= pillarsIslam.length) return null;
      final pillar = pillarsIslam[cardIndex];
      return _pillarEntry(
        l10n: l10n,
        sectionId: sectionId,
        cardIndex: cardIndex,
        moduleId: LibraryModuleId.pillarsOfIslam,
        pillar: pillar,
      );
    }

    if (sectionId == LibraryModuleId.pillarsOfIman.name) {
      if (cardIndex < 0 || cardIndex >= pillarsIman.length) return null;
      final pillar = pillarsIman[cardIndex];
      return _pillarEntry(
        l10n: l10n,
        sectionId: sectionId,
        cardIndex: cardIndex,
        moduleId: LibraryModuleId.pillarsOfIman,
        pillar: pillar,
      );
    }

    if (sectionId == LibraryModuleId.prophets.name) {
      if (cardIndex < 0 || cardIndex >= prophet.length) return null;
      final card = prophet[cardIndex];
      return LibraryBookmarkEntry(
        sectionId: sectionId,
        cardIndex: cardIndex,
        moduleId: LibraryModuleId.prophets,
        moduleLabel: libraryModuleTitle(l10n, LibraryModuleId.prophets),
        sectionLabel: libraryModuleTitle(l10n, LibraryModuleId.prophets),
        title: card.title,
        preview: _preview(card.subtitle),
      );
    }

    if (sectionId == LibraryModuleId.islamicOccasions.name) {
      if (cardIndex < 0 || cardIndex >= occasions.length) return null;
      final occasion = occasions[cardIndex];
      return LibraryBookmarkEntry(
        sectionId: sectionId,
        cardIndex: cardIndex,
        moduleId: LibraryModuleId.islamicOccasions,
        moduleLabel: libraryModuleTitle(l10n, LibraryModuleId.islamicOccasions),
        sectionLabel: libraryModuleTitle(l10n, LibraryModuleId.islamicOccasions),
        title: occasion.title,
        preview: _preview(occasion.importance),
      );
    }

    if (sectionId == LibraryModuleId.fiqhDifferences.name) {
      if (cardIndex < 0 || cardIndex >= fiqh.length) return null;
      final topic = fiqh[cardIndex];
      return LibraryBookmarkEntry(
        sectionId: sectionId,
        cardIndex: cardIndex,
        moduleId: LibraryModuleId.fiqhDifferences,
        moduleLabel: libraryModuleTitle(l10n, LibraryModuleId.fiqhDifferences),
        sectionLabel: libraryModuleTitle(l10n, LibraryModuleId.fiqhDifferences),
        title: topic.title,
        preview: _preview(topic.overview),
      );
    }

    return null;
  }

  static LibraryBookmarkEntry _pillarEntry({
    required AppLocalizations l10n,
    required String sectionId,
    required int cardIndex,
    required LibraryModuleId moduleId,
    required LibraryPillar pillar,
  }) {
    return LibraryBookmarkEntry(
      sectionId: sectionId,
      cardIndex: cardIndex,
      moduleId: moduleId,
      moduleLabel: libraryModuleTitle(l10n, moduleId),
      sectionLabel: libraryModuleTitle(l10n, moduleId),
      title: pillar.title,
      preview: _preview(pillar.subtitle),
    );
  }

  static HadithCollection? _findById(List<HadithCollection> items, String id) {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  static DuaCategory? _findDuaCategory(List<DuaCategory> items, String id) {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  static PrayerGuide? _findGuide(List<PrayerGuide> items, String id) {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  static String _preview(String text) {
    final trimmed = text.trim();
    if (trimmed.length <= 96) return trimmed;
    return '${trimmed.substring(0, 93)}…';
  }
}
