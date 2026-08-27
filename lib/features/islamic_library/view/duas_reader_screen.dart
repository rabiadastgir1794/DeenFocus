import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_centered_nav_header.dart';
import '../../../l10n/app_localizations.dart';
import '../helpers/learning_list_controller.dart';
import '../model/library_dua.dart';
import '../model/library_module.dart';
import '../widgets/dua_card.dart';
import '../widgets/learning_item_tile.dart';
import '../widgets/learning_searchable_list.dart';
import 'duas_categories_screen.dart';
import 'learning_item_detail_screen.dart';

class DuasReaderScreen extends StatefulWidget {
  const DuasReaderScreen({
    super.key,
    required this.category,
    this.initialCardIndex,
  });

  final DuaCategory category;
  final int? initialCardIndex;

  @override
  State<DuasReaderScreen> createState() => _DuasReaderScreenState();
}

class _DuasReaderScreenState extends State<DuasReaderScreen>
    with LearningListController {
  @override
  String get sectionId =>
      widget.category.progressSectionId(LibraryModuleId.duasAdhkar.name);

  @override
  int? get initialCardIndex => widget.initialCardIndex;

  @override
  int get itemCount => widget.category.items.length;

  List<LibraryDua> get _duas => widget.category.items;

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
    final dua = _duas[index];
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? colorScheme.surfaceContainerHighest
        : AppColors.surfaceLight;

    return openDetailRoute(
      index: index,
      builder: (_) => LearningItemDetailScreen(
        title: dua.title,
        subtitle: l10n.libraryCardProgress(dua.index, _duas.length),
        sectionId: sectionId,
        index: index,
        shareText: dua.shareText(l10n),
        sharePayload: dua.sharePayload(l10n),
        initiallyBookmarked: bookmarks.contains(index),
        body: DuaCard(dua: dua, backgroundColor: cardColor),
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
    final categoryTitle = duaCategoryTitle(l10n, widget.category.id);
    final q = query.trim().toLowerCase();
    final indexes = filterIndexes((i) {
      final d = _duas[i];
      return d.title.toLowerCase().contains(q) ||
          d.transliteration.toLowerCase().contains(q) ||
          d.translation.toLowerCase().contains(q) ||
          d.arabic.contains(query.trim());
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppCenteredNavHeader(
              title: categoryTitle,
              subtitle: l10n.libraryDuaCount(_duas.length),
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
                      totalCount: _duas.length,
                      itemBuilder: (context, i) {
                        final index = indexes[i];
                        final dua = _duas[index];
                        return LearningItemTile(
                          title: dua.title,
                          subtitle: dua.transliteration,
                          leadingLabel: '${dua.index}',
                          leadingArabic: dua.arabic,
                          bookmarked: bookmarks.contains(index),
                          backgroundColor: cardColor,
                          icon: Icons.favorite_outline,
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
