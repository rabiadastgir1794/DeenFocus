import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../l10n/app_localizations.dart';
import '../data/islamic_library_repository.dart';
import '../helpers/learning_list_controller.dart';
import '../model/library_module.dart';
import '../model/library_pillar.dart';
import '../widgets/learning_item_tile.dart';
import '../widgets/learning_searchable_list.dart';
import '../widgets/library_module_card.dart';
import '../widgets/pillar_card.dart';
import 'learning_item_detail_screen.dart';

class PillarsReaderScreen extends StatefulWidget {
  const PillarsReaderScreen({
    super.key,
    required this.moduleId,
    this.initialCardIndex,
  });

  final LibraryModuleId moduleId;
  final int? initialCardIndex;

  @override
  State<PillarsReaderScreen> createState() => _PillarsReaderScreenState();
}

class _PillarsReaderScreenState extends State<PillarsReaderScreen>
    with LearningListController {
  List<LibraryPillar> _pillars = const [];

  @override
  String get sectionId => widget.moduleId.name;

  @override
  int? get initialCardIndex => widget.initialCardIndex;

  @override
  int get itemCount => _pillars.length;

  Future<List<LibraryPillar>> _loadPillars() {
    return switch (widget.moduleId) {
      LibraryModuleId.pillarsOfIslam =>
        IslamicLibraryRepository.instance.loadPillarsOfIslam(),
      LibraryModuleId.pillarsOfIman =>
        IslamicLibraryRepository.instance.loadPillarsOfIman(),
      _ => Future.value(const <LibraryPillar>[]),
    };
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final pillars = await _loadPillars();
    if (!mounted) return;
    setState(() => _pillars = pillars);
    await loadProgressAndFinish();
    maybeOpenInitial(_openDetail);
  }

  Future<void> _openDetail(int index) {
    final pillar = _pillars[index];
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? colorScheme.surfaceContainerHighest
        : AppColors.surfaceLight;

    return openDetailRoute(
      index: index,
      builder: (_) => LearningItemDetailScreen(
        title: pillar.title,
        subtitle: l10n.libraryCardProgress(pillar.index, _pillars.length),
        sectionId: sectionId,
        index: index,
        shareText: pillar.shareText(l10n),
        sharePayload: pillar.sharePayload(l10n),
        initiallyBookmarked: bookmarks.contains(index),
        body: PillarCard(pillar: pillar, backgroundColor: cardColor),
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
      final p = _pillars[i];
      return p.title.toLowerCase().contains(q) ||
          p.subtitle.toLowerCase().contains(q) ||
          p.body.toLowerCase().contains(q);
    });

    return Scaffold(
      appBar: CustomAppBar(
        title: libraryModuleTitle(l10n, widget.moduleId),
        subtitle: libraryModuleSubtitle(l10n, widget.moduleId),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : LearningSearchableList(
              query: query,
              onQueryChanged: (value) => setState(() => query = value),
              itemCount: indexes.length,
              totalCount: _pillars.length,
              itemBuilder: (context, i) {
                final index = indexes[i];
                final pillar = _pillars[index];
                return LearningItemTile(
                  title: pillar.title,
                  subtitle: pillar.subtitle,
                  leadingLabel: '${pillar.index}',
                  leadingArabic: pillar.arabic,
                  bookmarked: bookmarks.contains(index),
                  backgroundColor: cardColor,
                  icon: Icons.account_balance_outlined,
                  onTap: () => _openDetail(index),
                );
              },
            ),
    );
  }
}
