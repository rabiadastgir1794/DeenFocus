import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../features/quran/view/quran_reader_screen.dart';
import '../../../l10n/app_localizations.dart';
import '../helpers/library_hub_search.dart';
import '../model/library_module.dart';
import '../view/duas_categories_screen.dart';
import '../view/hadith_collections_screen.dart';
import '../view/fiqh_differences_screen.dart';
import '../view/islamic_occasions_screen.dart';
import '../view/prayer_guides_screen.dart';
import '../view/prophet_muhammad_screen.dart';
import '../view/names_of_allah_screen.dart';
import '../view/pillars_reader_screen.dart';
import 'library_module_card.dart';
import 'learning_item_tile.dart';

/// Scrollable module grid for the Islamic Library hub (all modules, Quran first),
/// with hub-wide search across sections and content.
class IslamicLibraryHubBody extends StatefulWidget {
  const IslamicLibraryHubBody({super.key});

  @override
  State<IslamicLibraryHubBody> createState() => _IslamicLibraryHubBodyState();
}

class _IslamicLibraryHubBodyState extends State<IslamicLibraryHubBody> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  List<LibraryHubSearchHit>? _contentIndex;
  bool _indexLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openModule(BuildContext context, LibraryModule module) {
    switch (module.id) {
      case LibraryModuleId.quran:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const QuranReaderScreen(),
          ),
        );
        return;
      case LibraryModuleId.namesOfAllah:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const NamesOfAllahScreen(),
          ),
        );
        return;
      case LibraryModuleId.duasAdhkar:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const DuasCategoriesScreen(),
          ),
        );
        return;
      case LibraryModuleId.hadith:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const HadithCollectionsScreen(),
          ),
        );
        return;
      case LibraryModuleId.prophets:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const ProphetMuhammadScreen(),
          ),
        );
        return;
      case LibraryModuleId.pillarsOfIslam:
      case LibraryModuleId.pillarsOfIman:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => PillarsReaderScreen(moduleId: module.id),
          ),
        );
        return;
      case LibraryModuleId.prayerMethods:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const PrayerGuidesScreen(),
          ),
        );
        return;
      case LibraryModuleId.fiqhDifferences:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const FiqhDifferencesScreen(),
          ),
        );
        return;
      case LibraryModuleId.islamicOccasions:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const IslamicOccasionsScreen(),
          ),
        );
        return;
    }
  }

  Future<void> _ensureContentIndex(AppLocalizations l10n) async {
    if (_contentIndex != null || _indexLoading) return;
    setState(() => _indexLoading = true);
    try {
      final index = await LibraryHubSearch.buildContentIndex(l10n);
      if (!mounted) return;
      setState(() {
        _contentIndex = index;
        _indexLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _contentIndex = const [];
        _indexLoading = false;
      });
    }
  }

  void _onQueryChanged(String value, AppLocalizations l10n) {
    setState(() => _query = value);
    if (value.trim().isNotEmpty) {
      unawaited(_ensureContentIndex(l10n));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final softCardColor =
        isDark ? colorScheme.surfaceContainerHighest : AppColors.surfaceLight;
    final q = _query.trim();
    final searching = q.isNotEmpty;

    final moduleResults = searching
        ? LibraryHubSearch.moduleHits(l10n, q, _openModule)
        : LibraryModule.all
            .map(
              (module) => LibraryHubSearchHit(
                moduleId: module.id,
                title: libraryModuleTitle(l10n, module.id),
                subtitle: libraryModuleSubtitle(l10n, module.id),
                icon: module.icon,
                searchText: '',
                isModule: true,
                open: (ctx) => _openModule(ctx, module),
              ),
            )
            .toList(growable: false);

    final contentResults = searching && _contentIndex != null
        ? LibraryHubSearch.filterContent(_contentIndex!, q)
        : const <LibraryHubSearchHit>[];

    final showEmpty = searching &&
        !_indexLoading &&
        moduleResults.isEmpty &&
        contentResults.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _searchController,
          onChanged: (value) => _onQueryChanged(value, l10n),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: l10n.libraryHubSearchHint,
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: q.isEmpty
                ? null
                : IconButton(
                    tooltip: l10n.cancel,
                    onPressed: () {
                      _searchController.clear();
                      _onQueryChanged('', l10n);
                    },
                    icon: const Icon(Icons.close_rounded),
                  ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.45,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 12.h,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        if (_indexLoading && searching)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: const LinearProgressIndicator(minHeight: 2),
          ),
        Expanded(
          child: showEmpty
              ? Center(
                  child: Text(
                    l10n.librarySearchEmpty,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                )
              : ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    if (searching && moduleResults.isNotEmpty) ...[
                      _SectionLabel(label: l10n.libraryHubSearchSections),
                      SizedBox(height: 8.h),
                    ],
                    ..._mapHits(
                      moduleResults,
                      softCardColor,
                      asModuleCards: !searching || moduleResults.every(
                        (h) => h.isModule,
                      ),
                    ),
                    if (contentResults.isNotEmpty) ...[
                      SizedBox(height: 16.h),
                      _SectionLabel(label: l10n.libraryHubSearchTopics),
                      SizedBox(height: 8.h),
                      ..._mapHits(
                        contentResults,
                        softCardColor,
                        asModuleCards: false,
                      ),
                    ],
                    SizedBox(height: 8.h),
                  ],
                ),
        ),
      ],
    );
  }

  List<Widget> _mapHits(
    List<LibraryHubSearchHit> hits,
    Color softCardColor, {
    required bool asModuleCards,
  }) {
    final widgets = <Widget>[];
    for (var i = 0; i < hits.length; i++) {
      final hit = hits[i];
      if (i > 0) widgets.add(SizedBox(height: 10.h));
      if (asModuleCards && hit.isModule) {
        final module = LibraryModule.all.firstWhere(
          (m) => m.id == hit.moduleId,
        );
        widgets.add(
          LibraryModuleCard(
            module: module,
            title: hit.title,
            subtitle: hit.subtitle,
            backgroundColor: softCardColor,
            onTap: () => hit.open(context),
          ),
        );
      } else {
        widgets.add(
          LearningItemTile(
            title: hit.title,
            subtitle: hit.subtitle,
            backgroundColor: softCardColor,
            icon: hit.icon,
            onTap: () => hit.open(context),
          ),
        );
      }
    }
    return widgets;
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
    );
  }
}
