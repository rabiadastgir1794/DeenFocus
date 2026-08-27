import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../l10n/app_localizations.dart';
import '../data/islamic_library_repository.dart';
import '../helpers/learning_list_controller.dart';
import '../model/library_fiqh.dart';
import '../model/library_module.dart';
import '../widgets/fiqh_topic_card.dart';
import '../widgets/learning_item_tile.dart';
import '../widgets/learning_searchable_list.dart';
import 'learning_item_detail_screen.dart';

class FiqhDifferencesScreen extends StatefulWidget {
  const FiqhDifferencesScreen({super.key, this.initialCardIndex});

  final int? initialCardIndex;

  @override
  State<FiqhDifferencesScreen> createState() => _FiqhDifferencesScreenState();
}

class _FiqhDifferencesScreenState extends State<FiqhDifferencesScreen>
    with LearningListController {
  static const _sectionId = LibraryModuleId.fiqhDifferences;

  List<FiqhTopic> _topics = const [];

  @override
  String get sectionId => _sectionId.name;

  @override
  int? get initialCardIndex => widget.initialCardIndex;

  @override
  int get itemCount => _topics.length;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final topics = await IslamicLibraryRepository.instance.loadFiqhTopics();
    if (!mounted) return;
    setState(() => _topics = topics);
    await loadProgressAndFinish();
    maybeOpenInitial(_openDetail);
  }

  Future<void> _openDetail(int index) {
    final topic = _topics[index];
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? colorScheme.surfaceContainerHighest
        : AppColors.surfaceLight;

    return openDetailRoute(
      index: index,
      builder: (_) => LearningItemDetailScreen(
        title: topic.title,
        subtitle: l10n.libraryCardProgress(topic.index, _topics.length),
        sectionId: sectionId,
        index: index,
        shareText: topic.shareText(l10n),
        sharePayload: topic.sharePayload(),
        initiallyBookmarked: bookmarks.contains(index),
        body: FiqhTopicCard(topic: topic, backgroundColor: cardColor),
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
      final t = _topics[i];
      return t.title.toLowerCase().contains(q) ||
          t.overview.toLowerCase().contains(q);
    });

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.libraryModuleFiqh,
        subtitle: l10n.libraryModuleFiqhSub,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : LearningSearchableList(
              query: query,
              onQueryChanged: (value) => setState(() => query = value),
              itemCount: indexes.length,
              totalCount: _topics.length,
              itemBuilder: (context, i) {
                final index = indexes[i];
                final topic = _topics[index];
                return LearningItemTile(
                  title: topic.title,
                  subtitle: topic.overview,
                  leadingLabel: '${topic.index}',
                  bookmarked: bookmarks.contains(index),
                  backgroundColor: cardColor,
                  icon: Icons.balance_outlined,
                  onTap: () => _openDetail(index),
                );
              },
            ),
    );
  }
}
