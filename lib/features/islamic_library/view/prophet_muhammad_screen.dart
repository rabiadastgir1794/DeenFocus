import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../l10n/app_localizations.dart';
import '../data/islamic_library_repository.dart';
import '../helpers/learning_list_controller.dart';
import '../model/library_module.dart';
import '../model/prophet_story_card.dart';
import '../widgets/learning_item_tile.dart';
import '../widgets/learning_searchable_list.dart';
import '../widgets/prophet_story_card_view.dart';
import 'learning_item_detail_screen.dart';

class ProphetMuhammadScreen extends StatefulWidget {
  const ProphetMuhammadScreen({super.key, this.initialCardIndex});

  final int? initialCardIndex;

  @override
  State<ProphetMuhammadScreen> createState() => _ProphetMuhammadScreenState();
}

class _ProphetMuhammadScreenState extends State<ProphetMuhammadScreen>
    with LearningListController {
  static const _sectionId = LibraryModuleId.prophets;

  List<ProphetStoryCard> _cards = const [];

  @override
  String get sectionId => _sectionId.name;

  @override
  int? get initialCardIndex => widget.initialCardIndex;

  @override
  int get itemCount => _cards.length;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cards = await IslamicLibraryRepository.instance.loadProphetMuhammad();
    if (!mounted) return;
    setState(() => _cards = cards);
    await loadProgressAndFinish();
    maybeOpenInitial(_openDetail);
  }

  Future<void> _openDetail(int index) {
    final card = _cards[index];
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? colorScheme.surfaceContainerHighest
        : AppColors.surfaceLight;

    return openDetailRoute(
      index: index,
      builder: (_) => LearningItemDetailScreen(
        title: card.title,
        subtitle: l10n.libraryCardProgress(card.index, _cards.length),
        sectionId: sectionId,
        index: index,
        shareText: card.shareText(l10n),
        initiallyBookmarked: bookmarks.contains(index),
        body: ProphetStoryCardView(card: card, backgroundColor: cardColor),
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
    final q = query.trim().toLowerCase();
    final indexes = filterIndexes((i) {
      final c = _cards[i];
      return c.title.toLowerCase().contains(q) ||
          c.subtitle.toLowerCase().contains(q) ||
          c.body.toLowerCase().contains(q);
    });

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.libraryModuleProphets,
        subtitle: l10n.libraryModuleProphetsSub,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : LearningSearchableList(
              query: query,
              onQueryChanged: (value) => setState(() => query = value),
              itemCount: indexes.length,
              totalCount: _cards.length,
              itemBuilder: (context, i) {
                final index = indexes[i];
                final card = _cards[index];
                return LearningItemTile(
                  title: card.title,
                  subtitle: card.subtitle,
                  leadingLabel: '${card.index}',
                  bookmarked: bookmarks.contains(index),
                  backgroundColor: cardColor,
                  icon: Icons.mosque_outlined,
                  onTap: () => _openDetail(index),
                );
              },
            ),
    );
  }
}
