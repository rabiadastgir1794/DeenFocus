import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../l10n/app_localizations.dart';
import '../helpers/learning_list_controller.dart';
import '../model/library_guide.dart';
import '../model/library_module.dart';
import '../widgets/guide_step_card.dart';
import '../widgets/learning_item_tile.dart';
import '../widgets/learning_searchable_list.dart';
import 'learning_item_detail_screen.dart';
import 'prayer_guides_screen.dart';

class PrayerGuideReaderScreen extends StatefulWidget {
  const PrayerGuideReaderScreen({
    super.key,
    required this.guide,
    this.initialCardIndex,
  });

  final PrayerGuide guide;
  final int? initialCardIndex;

  @override
  State<PrayerGuideReaderScreen> createState() =>
      _PrayerGuideReaderScreenState();
}

class _PrayerGuideReaderScreenState extends State<PrayerGuideReaderScreen>
    with LearningListController {
  @override
  String get sectionId => widget.guide.progressSectionId(
        LibraryModuleId.prayerMethods.name,
      );

  @override
  int? get initialCardIndex => widget.initialCardIndex;

  @override
  int get itemCount => widget.guide.steps.length;

  List<GuideStep> get _steps => widget.guide.steps;

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
    final step = _steps[index];
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? colorScheme.surfaceContainerHighest
        : AppColors.surfaceLight;
    final guideTitle = prayerGuideTitle(l10n, widget.guide.id);

    return openDetailRoute(
      index: index,
      builder: (_) => LearningItemDetailScreen(
        title: step.title,
        subtitle: l10n.libraryCardProgress(step.index, _steps.length),
        sectionId: sectionId,
        index: index,
        shareText: step.shareText(
          l10n,
          guideTitle,
          totalSteps: _steps.length,
        ),
        sharePayload: step.sharePayload(),
        initiallyBookmarked: bookmarks.contains(index),
        body: GuideStepCard(
          step: step,
          backgroundColor: cardColor,
          guideTitle: guideTitle,
          totalSteps: _steps.length,
        ),
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
    final guideTitle = prayerGuideTitle(l10n, widget.guide.id);
    final q = query.trim().toLowerCase();
    final indexes = filterIndexes((i) {
      final s = _steps[i];
      return s.title.toLowerCase().contains(q) ||
          s.description.toLowerCase().contains(q);
    });

    return Scaffold(
      appBar: CustomAppBar(
        title: guideTitle,
        subtitle: l10n.libraryItemCount(_steps.length),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : LearningSearchableList(
              query: query,
              onQueryChanged: (value) => setState(() => query = value),
              itemCount: indexes.length,
              totalCount: _steps.length,
              itemBuilder: (context, i) {
                final index = indexes[i];
                final step = _steps[index];
                return LearningItemTile(
                  title: step.title,
                  subtitle: step.description,
                  leadingLabel: '${step.index}',
                  bookmarked: bookmarks.contains(index),
                  backgroundColor: cardColor,
                  icon: Icons.accessibility_new_outlined,
                  onTap: () => _openDetail(index),
                );
              },
            ),
    );
  }
}
