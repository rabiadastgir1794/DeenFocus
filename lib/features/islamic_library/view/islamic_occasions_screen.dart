import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_centered_nav_header.dart';
import '../../../l10n/app_localizations.dart';
import '../data/islamic_library_repository.dart';
import '../helpers/learning_list_controller.dart';
import '../model/library_guide.dart';
import '../model/library_module.dart';
import '../widgets/learning_item_tile.dart';
import '../widgets/learning_searchable_list.dart';
import '../widgets/occasion_card.dart';
import 'learning_item_detail_screen.dart';

class IslamicOccasionsScreen extends StatefulWidget {
  const IslamicOccasionsScreen({super.key, this.initialCardIndex});

  final int? initialCardIndex;

  @override
  State<IslamicOccasionsScreen> createState() => _IslamicOccasionsScreenState();
}

class _IslamicOccasionsScreenState extends State<IslamicOccasionsScreen>
    with LearningListController {
  static const _sectionId = LibraryModuleId.islamicOccasions;

  List<IslamicOccasion> _occasions = const [];

  @override
  String get sectionId => _sectionId.name;

  @override
  int? get initialCardIndex => widget.initialCardIndex;

  @override
  int get itemCount => _occasions.length;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final occasions = await IslamicLibraryRepository.instance
        .loadIslamicOccasions();
    if (!mounted) return;
    setState(() => _occasions = occasions);
    await loadProgressAndFinish();
    maybeOpenInitial(_openDetail);
  }

  Future<void> _openDetail(int index) {
    final occasion = _occasions[index];
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? colorScheme.surfaceContainerHighest
        : AppColors.surfaceLight;

    return openDetailRoute(
      index: index,
      builder: (_) => LearningItemDetailScreen(
        title: occasion.title,
        subtitle: l10n.libraryCardProgress(occasion.index, _occasions.length),
        sectionId: sectionId,
        index: index,
        shareText: occasion.shareText(l10n),
        initiallyBookmarked: bookmarks.contains(index),
        body: OccasionCard(occasion: occasion, backgroundColor: cardColor),
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
      final o = _occasions[i];
      return o.title.toLowerCase().contains(q) ||
          o.importance.toLowerCase().contains(q);
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppCenteredNavHeader(
              title: l10n.libraryModuleOccasions,
              subtitle: l10n.libraryModuleOccasionsSub,
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
                      totalCount: _occasions.length,
                      itemBuilder: (context, i) {
                        final index = indexes[i];
                        final occasion = _occasions[index];
                        return LearningItemTile(
                          title: occasion.title,
                          subtitle: occasion.importance,
                          leadingLabel: '${occasion.index}',
                          bookmarked: bookmarks.contains(index),
                          backgroundColor: cardColor,
                          icon: Icons.event_outlined,
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
