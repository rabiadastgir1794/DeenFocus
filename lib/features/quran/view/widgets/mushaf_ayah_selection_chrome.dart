import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/quran_local_repository.dart';
import 'quran_reader_theme.dart';

/// Translation sheet for a selected ayah in Mushaf page view.
class MushafAyahTranslationStrip extends StatelessWidget {
  const MushafAyahTranslationStrip({
    super.key,
    required this.ayah,
    required this.fontSp,
    required this.surahLabel,
    required this.onPlay,
    required this.onClose,
  });

  final AyahRecord ayah;
  final double fontSp;
  final String surahLabel;
  final VoidCallback onPlay;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.quranReader;
    final translation = ayah.englishText.trim();
    final hasTranslation = translation.isNotEmpty;

    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(18.r),
      color: palette.paper.withValues(alpha: 0.95),
      shadowColor: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: palette.accent.withValues(alpha: 0.22)),
          boxShadow: palette.softShadow,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(14.w, 10.h, 10.w, 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '$surahLabel ${ayah.surahNumber}:${ayah.ayahNumber}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: palette.primary,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Play',
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.play_circle_fill_rounded,
                      color: palette.primary,
                      size: 28.sp,
                    ),
                    onPressed: onPlay,
                  ),
                  IconButton(
                    tooltip: 'Close',
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.close_rounded,
                      size: 18.sp,
                      color: palette.textSecondary,
                    ),
                    onPressed: onClose,
                  ),
                ],
              ),
              Text(
                hasTranslation
                    ? translation
                    : (l10n?.quranTranslationUnavailable ??
                        'Translation not available for this ayah'),
                style: TextStyle(
                  fontSize: fontSp.sp,
                  height: 1.45,
                  fontStyle:
                      hasTranslation ? FontStyle.normal : FontStyle.italic,
                  color: hasTranslation
                      ? palette.textPrimary
                      : palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown when English translation is off but an ayah is selected.
class MushafAyahPlayChip extends StatelessWidget {
  const MushafAyahPlayChip({
    super.key,
    required this.label,
    required this.onPlay,
    required this.onClose,
  });

  final String label;
  final VoidCallback onPlay;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final palette = context.quranReader;
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(18.r),
      color: palette.paper.withValues(alpha: 0.95),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: palette.accent.withValues(alpha: 0.22)),
          boxShadow: palette.softShadow,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: palette.textPrimary,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Play',
                icon: Icon(
                  Icons.play_circle_fill_rounded,
                  color: palette.primary,
                  size: 32.sp,
                ),
                onPressed: onPlay,
              ),
              IconButton(
                tooltip: 'Close',
                icon: Icon(
                  Icons.close_rounded,
                  size: 18.sp,
                  color: palette.textSecondary,
                ),
                onPressed: onClose,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
