import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../features/quran/view/quran_reader_screen.dart';
import '../../../l10n/app_localizations.dart';
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

/// Scrollable module grid for the Islamic Library hub (all modules, Quran first).
class IslamicLibraryHubBody extends StatelessWidget {
  const IslamicLibraryHubBody({super.key});

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final softCardColor =
        isDark ? colorScheme.surfaceContainerHighest : AppColors.surfaceLight;

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: LibraryModule.all.length,
      separatorBuilder: (_, _) => SizedBox(height: 10.h),
      itemBuilder: (context, index) {
        final module = LibraryModule.all[index];
        return LibraryModuleCard(
          module: module,
          title: libraryModuleTitle(l10n, module.id),
          subtitle: libraryModuleSubtitle(l10n, module.id),
          backgroundColor: softCardColor,
          onTap: () => _openModule(context, module),
        );
      },
    );
  }
}
