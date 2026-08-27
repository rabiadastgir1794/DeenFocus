import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_centered_nav_header.dart';
import '../../../l10n/app_localizations.dart';
import '../data/islamic_library_repository.dart';
import '../model/library_guide.dart';
import 'library_category_tile.dart';
import 'prayer_guide_reader_screen.dart';

class PrayerGuidesScreen extends StatefulWidget {
  const PrayerGuidesScreen({super.key});

  @override
  State<PrayerGuidesScreen> createState() => _PrayerGuidesScreenState();
}

class _PrayerGuidesScreenState extends State<PrayerGuidesScreen> {
  bool _loading = true;
  List<PrayerGuide> _guides = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final guides = await IslamicLibraryRepository.instance.loadPrayerGuides();
    if (!mounted) return;
    setState(() {
      _guides = guides;
      _loading = false;
    });
  }

  void _openGuide(PrayerGuide guide) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PrayerGuideReaderScreen(guide: guide),
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
              title: l10n.libraryModulePrayerMethods,
              subtitle: l10n.libraryModulePrayerMethodsSub,
              backLabel: l10n.calendarBack,
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                      itemCount: _guides.length,
                      separatorBuilder: (_, _) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final guide = _guides[index];
                        return LibraryCategoryTile(
                          title: prayerGuideTitle(l10n, guide.id),
                          subtitle: l10n.libraryGuideStepCount(guide.itemCount),
                          icon: Icons.accessibility_new_outlined,
                          backgroundColor: softCardColor,
                          onTap: () => _openGuide(guide),
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

String prayerGuideTitle(AppLocalizations l10n, String guideId) {
  switch (guideId) {
    case 'wudu':
      return l10n.libraryGuideWudu;
    case 'salah':
      return l10n.libraryGuideSalah;
    case 'ghusl':
      return l10n.libraryGuideGhusl;
    case 'tayammum':
      return l10n.libraryGuideTayammum;
    case 'janazah':
      return l10n.libraryGuideJanazah;
    case 'umrah':
      return l10n.libraryGuideUmrah;
    case 'hajj':
      return l10n.libraryGuideHajj;
    case 'fasting':
      return l10n.libraryGuideFasting;
    case 'zakat':
      return l10n.libraryGuideZakat;
    case 'tawbah':
      return l10n.libraryGuideTawbah;
    default:
      return guideId;
  }
}
