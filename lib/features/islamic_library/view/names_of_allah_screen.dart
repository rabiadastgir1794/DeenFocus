import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../l10n/app_localizations.dart';
import '../data/islamic_library_repository.dart';
import '../data/library_progress_service.dart';
import '../model/allah_name.dart';
import '../model/library_module.dart';
import '../model/library_section_progress.dart';
import '../widgets/learning_card_actions.dart';
import '../widgets/learning_detail_scaffold.dart';
import '../widgets/learning_item_tile.dart';
import '../widgets/learning_searchable_list.dart';

class NamesOfAllahScreen extends StatefulWidget {
  const NamesOfAllahScreen({super.key, this.initialCardIndex});

  /// When set (e.g. from a bookmark), open that item's detail after load.
  final int? initialCardIndex;

  @override
  State<NamesOfAllahScreen> createState() => _NamesOfAllahScreenState();
}

class _NamesOfAllahScreenState extends State<NamesOfAllahScreen> {
  static const _sectionId = LibraryModuleId.namesOfAllah;

  bool _loading = true;
  List<AllahName> _names = const [];
  Set<int> _bookmarks = const {};
  String _query = '';
  bool _openedInitial = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final results = await Future.wait([
      IslamicLibraryRepository.instance.loadNamesOfAllah(),
      LibraryProgressService.instance.getProgress(_sectionId.name),
    ]);
    if (!mounted) return;
    final names = results[0] as List<AllahName>;
    final progress = results[1] as LibrarySectionProgress;
    setState(() {
      _names = names;
      _bookmarks = Set<int>.from(progress.bookmarks);
      _loading = false;
    });
    _maybeOpenInitial();
  }

  void _maybeOpenInitial() {
    if (_openedInitial || widget.initialCardIndex == null || _names.isEmpty) {
      return;
    }
    _openedInitial = true;
    final index = widget.initialCardIndex!.clamp(0, _names.length - 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _openDetail(index);
    });
  }

  List<int> get _filteredIndexes {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) {
      return List<int>.generate(_names.length, (i) => i);
    }
    final out = <int>[];
    for (var i = 0; i < _names.length; i++) {
      final n = _names[i];
      if (n.transliteration.toLowerCase().contains(q) ||
          n.meaning.toLowerCase().contains(q) ||
          n.arabic.contains(_query.trim()) ||
          '${n.index}'.contains(q)) {
        out.add(i);
      }
    }
    return out;
  }

  Future<void> _openDetail(int index) async {
    await LibraryProgressService.instance.setLastIndex(_sectionId.name, index);
    if (!mounted) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => _NameDetailScreen(
          names: _names,
          index: index,
          sectionId: _sectionId.name,
          initiallyBookmarked: _bookmarks.contains(index),
          onBookmarkChanged: (bookmarked) {
            setState(() {
              _bookmarks = Set<int>.from(_bookmarks);
              if (bookmarked) {
                _bookmarks.add(index);
              } else {
                _bookmarks.remove(index);
              }
            });
          },
        ),
      ),
    );
    if (!mounted) return;
    final progress =
        await LibraryProgressService.instance.getProgress(_sectionId.name);
    if (!mounted) return;
    setState(() {
      _bookmarks = Set<int>.from(progress.bookmarks);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? colorScheme.surfaceContainerHighest
        : AppColors.surfaceLight;
    final indexes = _filteredIndexes;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.libraryModuleNames,
        subtitle: l10n.libraryModuleNamesSub,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : LearningSearchableList(
              query: _query,
              onQueryChanged: (value) => setState(() => _query = value),
              itemCount: indexes.length,
              totalCount: _names.length,
              itemBuilder: (context, i) {
                final index = indexes[i];
                final name = _names[index];
                return LearningItemTile(
                  title: name.transliteration,
                  subtitle: name.meaning,
                  leadingLabel: '${name.index}',
                  leadingArabic: name.arabic,
                  bookmarked: _bookmarks.contains(index),
                  backgroundColor: cardColor,
                  icon: Icons.auto_awesome_outlined,
                  onTap: () => _openDetail(index),
                );
              },
            ),
    );
  }
}

class _NameDetailScreen extends StatefulWidget {
  const _NameDetailScreen({
    required this.names,
    required this.index,
    required this.sectionId,
    required this.initiallyBookmarked,
    required this.onBookmarkChanged,
  });

  final List<AllahName> names;
  final int index;
  final String sectionId;
  final bool initiallyBookmarked;
  final ValueChanged<bool> onBookmarkChanged;

  @override
  State<_NameDetailScreen> createState() => _NameDetailScreenState();
}

class _NameDetailScreenState extends State<_NameDetailScreen> {
  late bool _bookmarked = widget.initiallyBookmarked;

  AllahName get _name => widget.names[widget.index];

  Future<void> _toggleBookmark() async {
    final saved = await LibraryProgressService.instance.toggleBookmark(
      widget.sectionId,
      widget.index,
    );
    if (!mounted) return;
    setState(() => _bookmarked = saved);
    widget.onBookmarkChanged(saved);
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          saved ? l10n.libraryBookmarkSaved : l10n.libraryBookmarkRemoved,
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
    final name = _name;

    return LearningDetailScaffold(
      title: name.transliteration,
      subtitle: l10n.libraryCardProgress(name.index, widget.names.length),
      isBookmarked: _bookmarked,
      onBookmark: _toggleBookmark,
      onCopy: () => copyLearningText(context, name.shareText(l10n)),
      sharePayload: name.sharePayload(),
      child: _NameDetailBody(name: name, backgroundColor: cardColor),
    );
  }
}

class _NameDetailBody extends StatelessWidget {
  const _NameDetailBody({
    required this.name,
    required this.backgroundColor,
  });

  final AllahName name;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${name.index}',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            name.arabic,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontFamily: 'UthmanicHafs',
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            name.transliteration,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.libraryMeaning,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            name.meaning,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              name.explanation,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.55,
                    color: colorScheme.onSurface,
                  ),
            ),
          ),
          if (name.reflection != null && name.reflection!.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.libraryReflection,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    name.reflection!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
