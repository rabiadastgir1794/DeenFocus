import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_centered_nav_header.dart';
import '../../../l10n/app_localizations.dart';
import '../helpers/learning_list_controller.dart';
import '../model/library_hadith.dart';
import '../model/library_module.dart';
import '../widgets/hadith_card.dart';
import '../widgets/learning_item_tile.dart';
import '../widgets/learning_searchable_list.dart';
import 'hadith_collections_screen.dart';
import 'learning_item_detail_screen.dart';

class HadithReaderScreen extends StatefulWidget {
  const HadithReaderScreen({
    super.key,
    required this.collection,
    this.initialCardIndex,
  });

  final HadithCollection collection;
  final int? initialCardIndex;

  @override
  State<HadithReaderScreen> createState() => _HadithReaderScreenState();
}

class _HadithReaderScreenState extends State<HadithReaderScreen>
    with LearningListController {
  @override
  String get sectionId =>
      widget.collection.progressSectionId(LibraryModuleId.hadith.name);

  @override
  int? get initialCardIndex => widget.initialCardIndex;

  @override
  int get itemCount => widget.collection.items.length;

  List<LibraryHadith> get _hadiths => widget.collection.items;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await loadProgressAndFinish();
    maybeOpenInitial(_openDetail);
  }

  Future<void> _openDetail(int index) {
    final hadith = _hadiths[index];
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? colorScheme.surfaceContainerHighest
        : AppColors.surfaceLight;

    return openDetailRoute(
      index: index,
      builder: (_) => LearningItemDetailScreen(
        title: hadith.title,
        subtitle: l10n.libraryCardProgress(hadith.index, _hadiths.length),
        sectionId: sectionId,
        index: index,
        shareText: hadith.shareText(l10n),
        sharePayload: hadith.sharePayload(l10n),
        initiallyBookmarked: bookmarks.contains(index),
        body: HadithCard(hadith: hadith, backgroundColor: cardColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? colorScheme.surfaceContainerHighest
        : AppColors.surfaceLight;
    final collectionTitle = hadithCollectionTitle(l10n, widget.collection.id);
    final q = query.trim().toLowerCase();
    final indexes = filterIndexes((i) {
      final h = _hadiths[i];
      return h.title.toLowerCase().contains(q) ||
          h.translation.toLowerCase().contains(q) ||
          h.narrator.toLowerCase().contains(q) ||
          h.source.toLowerCase().contains(q);
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppCenteredNavHeader(
              title: collectionTitle,
              subtitle: l10n.libraryHadithCount(_hadiths.length),
              backLabel: l10n.calendarBack,
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : LearningSearchableList(
                      query: query,
                      onQueryChanged: (value) => setState(() => query = value),
                      itemCount: indexes.length,
                      totalCount: _hadiths.length,
                      itemBuilder: (context, i) {
                        final index = indexes[i];
                        final hadith = _hadiths[index];
                        return LearningItemTile(
                          title: hadith.title,
                          subtitle: hadith.translation,
                          leadingLabel: '${hadith.index}',
                          leadingArabic: hadith.arabic,
                          bookmarked: bookmarks.contains(index),
                          backgroundColor: cardColor,
                          icon: Icons.format_quote_outlined,
                          onTap: () => _openDetail(index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
