import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../reading_engine/reading_mode.dart';

/// "Continue Reading" card shown on the Quran home screen (Phase 1, item 2)
/// when a previous reading position exists.
class ContinueReadingCard extends StatelessWidget {
  const ContinueReadingCard({
    super.key,
    required this.mode,
    required this.surahName,
    required this.ayahNumber,
    required this.pageNumber,
    required this.juzNumber,
    required this.onTap,
  });

  final ReadingMode mode;
  final String surahName;
  final int ayahNumber;
  final int pageNumber;
  final int juzNumber;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final subtitle = switch (mode) {
      ReadingMode.surah => '$surahName • ${l10n.quranSurahLabel.toLowerCase()} $ayahNumber',
      ReadingMode.juz => '${l10n.quranJuzLabel} $juzNumber • $surahName $ayahNumber',
      ReadingMode.page => '${l10n.quranPageLabel} $pageNumber • $surahName $ayahNumber',
    };

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withValues(alpha: 0.16),
                colorScheme.primary.withValues(alpha: 0.06),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: colorScheme.primary.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.auto_stories_rounded,
                  color: colorScheme.primary,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.quranContinueReading,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.play_circle_fill_rounded,
                color: colorScheme.primary,
                size: 28.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
