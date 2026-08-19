import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../reading_engine/reading_mode.dart';
import 'quran_reader_theme.dart';

/// "Continue Reading" card on the Quran home screen with progress.
class ContinueReadingCard extends StatelessWidget {
  const ContinueReadingCard({
    super.key,
    required this.mode,
    required this.surahName,
    required this.ayahNumber,
    required this.pageNumber,
    required this.juzNumber,
    required this.juzProgressPercent,
    required this.onTap,
  });

  final ReadingMode mode;
  final String surahName;
  final int ayahNumber;
  final int pageNumber;
  final int juzNumber;
  final int juzProgressPercent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = context.quranReader;
    final progress = (juzProgressPercent / 100).clamp(0.0, 1.0);

    final headline = switch (mode) {
      ReadingMode.surah => '$surahName · ${l10n.quranSurahLabel} $ayahNumber',
      ReadingMode.juz => '$surahName · ${l10n.quranSurahLabel} $ayahNumber',
      ReadingMode.page => '$surahName · ${l10n.quranSurahLabel} $ayahNumber',
    };

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22.r),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: palette.paper,
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(color: palette.accent.withValues(alpha: 0.28)),
            boxShadow: palette.softShadow,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 52.r,
                height: 52.r,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress > 0 ? progress : null,
                      strokeWidth: 3.5,
                      backgroundColor: palette.accent.withValues(alpha: 0.22),
                      color: palette.primary,
                    ),
                    Icon(
                      Icons.auto_stories_rounded,
                      color: palette.primary,
                      size: 22.sp,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.quranContinueReading.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: palette.primary,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      headline,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: palette.textPrimary,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      l10n.quranJuzProgressLabel(juzProgressPercent, juzNumber),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.play_circle_fill_rounded,
                color: palette.primary,
                size: 34.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
