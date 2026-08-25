import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../data/islamic_library_repository.dart';
import '../model/allah_name.dart';
import '../model/library_dua.dart';
import '../model/library_fiqh.dart';
import '../model/library_guide.dart';
import '../model/library_hadith.dart';
import '../model/library_module.dart';
import '../model/library_pillar.dart';
import '../model/prophet_story_card.dart';
import '../view/duas_categories_screen.dart';
import '../view/duas_reader_screen.dart';
import '../view/fiqh_differences_screen.dart';
import '../view/hadith_collections_screen.dart';
import '../view/hadith_reader_screen.dart';
import '../view/islamic_occasions_screen.dart';
import '../view/names_of_allah_screen.dart';
import '../view/pillars_reader_screen.dart';
import '../view/prayer_guide_reader_screen.dart';
import '../view/prayer_guides_screen.dart';
import '../view/prophet_muhammad_screen.dart';
import '../widgets/library_module_card.dart';

/// One searchable Learning-hub hit (module section or deep content item).
class LibraryHubSearchHit {
  const LibraryHubSearchHit({
    required this.moduleId,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.open,
    required this.searchText,
    this.isModule = false,
  });

  final LibraryModuleId moduleId;
  final String title;
  final String subtitle;
  final IconData icon;
  final void Function(BuildContext context) open;
  final String searchText;
  final bool isModule;
}

/// Builds a searchable index across Islamic Library modules and content.
abstract final class LibraryHubSearch {
  static bool matches(String query, String haystack) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    if (haystack.toLowerCase().contains(q)) return true;
    return haystack.contains(query.trim());
  }

  static List<LibraryHubSearchHit> moduleHits(
    AppLocalizations l10n,
    String query,
    void Function(BuildContext context, LibraryModule module) openModule,
  ) {
    final out = <LibraryHubSearchHit>[];
    for (final module in LibraryModule.all) {
      final title = libraryModuleTitle(l10n, module.id);
      final subtitle = libraryModuleSubtitle(l10n, module.id);
      final searchText = '$title $subtitle ${module.id.name}';
      if (!matches(query, searchText)) continue;
      out.add(
        LibraryHubSearchHit(
          moduleId: module.id,
          title: title,
          subtitle: subtitle,
          icon: module.icon,
          searchText: searchText,
          isModule: true,
          open: (context) => openModule(context, module),
        ),
      );
    }
    return out;
  }

  /// Loads all library JSON once (cached in the repository) and returns content hits.
  static Future<List<LibraryHubSearchHit>> buildContentIndex(
    AppLocalizations l10n,
  ) async {
    final repo = IslamicLibraryRepository.instance;
    final names = await repo.loadNamesOfAllah();
    final duaCategories = await repo.loadDuaCategories();
    final hadithCollections = await repo.loadHadithCollections();
    final pillarsIslam = await repo.loadPillarsOfIslam();
    final pillarsIman = await repo.loadPillarsOfIman();
    final prophet = await repo.loadProphetMuhammad();
    final prayerGuides = await repo.loadPrayerGuides();
    final fiqh = await repo.loadFiqhTopics();
    final occasions = await repo.loadIslamicOccasions();

    final hits = <LibraryHubSearchHit>[];
    final namesModule = libraryModuleTitle(l10n, LibraryModuleId.namesOfAllah);
    for (var i = 0; i < names.length; i++) {
      final AllahName n = names[i];
      hits.add(
        LibraryHubSearchHit(
          moduleId: LibraryModuleId.namesOfAllah,
          title: '${n.transliteration} — ${n.meaning}',
          subtitle: namesModule,
          icon: Icons.star_outline_rounded,
          searchText:
              '${n.transliteration} ${n.meaning} ${n.arabic} ${n.explanation} '
              '${n.reflection ?? ''} $namesModule',
          open: (context) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => NamesOfAllahScreen(initialCardIndex: i),
              ),
            );
          },
        ),
      );
    }

    final duasModule = libraryModuleTitle(l10n, LibraryModuleId.duasAdhkar);
    for (final DuaCategory category in duaCategories) {
      final catTitle = duaCategoryTitle(l10n, category.id);
      hits.add(
        LibraryHubSearchHit(
          moduleId: LibraryModuleId.duasAdhkar,
          title: catTitle,
          subtitle: duasModule,
          icon: Icons.volunteer_activism_outlined,
          searchText: '$catTitle $duasModule ${category.id}',
          open: (context) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => DuasReaderScreen(category: category),
              ),
            );
          },
        ),
      );
      for (var i = 0; i < category.items.length; i++) {
        final LibraryDua dua = category.items[i];
        hits.add(
          LibraryHubSearchHit(
            moduleId: LibraryModuleId.duasAdhkar,
            title: dua.title,
            subtitle: '$duasModule · $catTitle',
            icon: Icons.volunteer_activism_outlined,
            searchText:
                '${dua.title} ${dua.arabic} ${dua.transliteration} '
                '${dua.translation} ${dua.reference ?? ''} $catTitle',
            open: (context) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => DuasReaderScreen(
                    category: category,
                    initialCardIndex: i,
                  ),
                ),
              );
            },
          ),
        );
      }
    }

    final hadithModule = libraryModuleTitle(l10n, LibraryModuleId.hadith);
    for (final HadithCollection collection in hadithCollections) {
      final colTitle = hadithCollectionTitle(l10n, collection.id);
      hits.add(
        LibraryHubSearchHit(
          moduleId: LibraryModuleId.hadith,
          title: colTitle,
          subtitle: hadithModule,
          icon: Icons.auto_stories_outlined,
          searchText: '$colTitle $hadithModule ${collection.id}',
          open: (context) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => HadithReaderScreen(collection: collection),
              ),
            );
          },
        ),
      );
      for (var i = 0; i < collection.items.length; i++) {
        final LibraryHadith h = collection.items[i];
        hits.add(
          LibraryHubSearchHit(
            moduleId: LibraryModuleId.hadith,
            title: h.title,
            subtitle: '$hadithModule · $colTitle',
            icon: Icons.auto_stories_outlined,
            searchText:
                '${h.title} ${h.translation} ${h.narrator} ${h.source} '
                '${h.arabic ?? ''} $colTitle',
            open: (context) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => HadithReaderScreen(
                    collection: collection,
                    initialCardIndex: i,
                  ),
                ),
              );
            },
          ),
        );
      }
    }

    void addPillars(LibraryModuleId moduleId, List<LibraryPillar> pillars) {
      final moduleTitle = libraryModuleTitle(l10n, moduleId);
      for (var i = 0; i < pillars.length; i++) {
        final p = pillars[i];
        hits.add(
          LibraryHubSearchHit(
            moduleId: moduleId,
            title: p.title,
            subtitle: '$moduleTitle · ${p.subtitle}',
            icon: Icons.account_balance_outlined,
            searchText:
                '${p.title} ${p.subtitle} ${p.body} ${p.arabic ?? ''} '
                '${p.reference ?? ''} $moduleTitle',
            open: (context) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => PillarsReaderScreen(
                    moduleId: moduleId,
                    initialCardIndex: i,
                  ),
                ),
              );
            },
          ),
        );
      }
    }

    addPillars(LibraryModuleId.pillarsOfIslam, pillarsIslam);
    addPillars(LibraryModuleId.pillarsOfIman, pillarsIman);

    final prophetsModule = libraryModuleTitle(l10n, LibraryModuleId.prophets);
    for (var i = 0; i < prophet.length; i++) {
      final ProphetStoryCard s = prophet[i];
      hits.add(
        LibraryHubSearchHit(
          moduleId: LibraryModuleId.prophets,
          title: s.title,
          subtitle: '$prophetsModule · ${s.subtitle}',
          icon: Icons.landscape_outlined,
          searchText:
              '${s.title} ${s.subtitle} ${s.body} ${s.lesson ?? ''} '
              '${s.quranReference ?? ''} $prophetsModule',
          open: (context) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    ProphetMuhammadScreen(initialCardIndex: i),
              ),
            );
          },
        ),
      );
    }

    final prayerModule =
        libraryModuleTitle(l10n, LibraryModuleId.prayerMethods);
    for (final PrayerGuide guide in prayerGuides) {
      final guideTitle = prayerGuideTitle(l10n, guide.id);
      hits.add(
        LibraryHubSearchHit(
          moduleId: LibraryModuleId.prayerMethods,
          title: guideTitle,
          subtitle: prayerModule,
          icon: Icons.accessibility_new_outlined,
          searchText: '$guideTitle $prayerModule ${guide.id}',
          open: (context) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => PrayerGuideReaderScreen(guide: guide),
              ),
            );
          },
        ),
      );
      for (var i = 0; i < guide.steps.length; i++) {
        final GuideStep step = guide.steps[i];
        hits.add(
          LibraryHubSearchHit(
            moduleId: LibraryModuleId.prayerMethods,
            title: step.title,
            subtitle: '$prayerModule · $guideTitle',
            icon: Icons.accessibility_new_outlined,
            searchText: '${step.title} ${step.description} $guideTitle',
            open: (context) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => PrayerGuideReaderScreen(
                    guide: guide,
                    initialCardIndex: i,
                  ),
                ),
              );
            },
          ),
        );
      }
    }

    final fiqhModule =
        libraryModuleTitle(l10n, LibraryModuleId.fiqhDifferences);
    for (var i = 0; i < fiqh.length; i++) {
      final FiqhTopic t = fiqh[i];
      hits.add(
        LibraryHubSearchHit(
          moduleId: LibraryModuleId.fiqhDifferences,
          title: t.title,
          subtitle: fiqhModule,
          icon: Icons.balance_outlined,
          searchText:
              '${t.title} ${t.overview} ${t.keyPoints} ${t.differences} '
              '${t.commonGround} $fiqhModule',
          open: (context) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    FiqhDifferencesScreen(initialCardIndex: i),
              ),
            );
          },
        ),
      );
    }

    final occasionsModule =
        libraryModuleTitle(l10n, LibraryModuleId.islamicOccasions);
    for (var i = 0; i < occasions.length; i++) {
      final IslamicOccasion o = occasions[i];
      hits.add(
        LibraryHubSearchHit(
          moduleId: LibraryModuleId.islamicOccasions,
          title: o.title,
          subtitle: occasionsModule,
          icon: Icons.event_outlined,
          searchText:
              '${o.title} ${o.importance} ${o.virtues} '
              '${o.recommendedActs} $occasionsModule',
          open: (context) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    IslamicOccasionsScreen(initialCardIndex: i),
              ),
            );
          },
        ),
      );
    }

    return hits;
  }

  static List<LibraryHubSearchHit> filterContent(
    List<LibraryHubSearchHit> index,
    String query, {
    int limit = 60,
  }) {
    final q = query.trim();
    if (q.isEmpty) return const [];
    final out = <LibraryHubSearchHit>[];
    for (final hit in index) {
      if (matches(q, hit.searchText)) {
        out.add(hit);
        if (out.length >= limit) break;
      }
    }
    return out;
  }
}
