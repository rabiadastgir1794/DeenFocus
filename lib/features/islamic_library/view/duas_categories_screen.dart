import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_centered_nav_header.dart';
import '../../../l10n/app_localizations.dart';
import '../data/islamic_library_repository.dart';
import '../model/library_dua.dart';
import 'duas_reader_screen.dart';
import 'library_category_tile.dart';

class DuasCategoriesScreen extends StatefulWidget {
  const DuasCategoriesScreen({super.key});

  @override
  State<DuasCategoriesScreen> createState() => _DuasCategoriesScreenState();
}

class _DuasCategoriesScreenState extends State<DuasCategoriesScreen> {
  bool _loading = true;
  List<DuaCategory> _categories = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final categories = await IslamicLibraryRepository.instance
        .loadDuaCategories();
    if (!mounted) return;
    setState(() {
      _categories = categories;
      _loading = false;
    });
  }

  void _openCategory(DuaCategory category) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DuasReaderScreen(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final softCardColor = isDark
        ? colorScheme.surfaceContainerHighest
        : AppColors.surfaceLight;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppCenteredNavHeader(
              title: l10n.libraryModuleDuas,
              subtitle: l10n.libraryModuleDuasSub,
              backLabel: l10n.calendarBack,
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                      itemCount: _categories.length,
                      separatorBuilder: (_, _) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        return LibraryCategoryTile(
                          title: duaCategoryTitle(l10n, category.id),
                          subtitle: l10n.libraryDuaCount(category.itemCount),
                          backgroundColor: softCardColor,
                          onTap: () => _openCategory(category),
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

String duaCategoryTitle(AppLocalizations l10n, String categoryId) {
  switch (categoryId) {
    case 'morning':
      return l10n.libraryDuaCategoryMorning;
    case 'evening':
      return l10n.libraryDuaCategoryEvening;
    case 'daily_life':
      return l10n.libraryDuaCategoryDailyLife;
    case 'sleep':
      return l10n.libraryDuaCategorySleep;
    case 'food':
      return l10n.libraryDuaCategoryFood;
    case 'travel':
      return l10n.libraryDuaCategoryTravel;
    case 'illness':
      return l10n.libraryDuaCategoryIllness;
    case 'protection':
      return l10n.libraryDuaCategoryProtection;
    case 'forgiveness':
      return l10n.libraryDuaCategoryForgiveness;
    case 'parents':
      return l10n.libraryDuaCategoryParents;
    default:
      return categoryId;
  }
}
