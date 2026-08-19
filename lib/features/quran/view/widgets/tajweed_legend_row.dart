import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';

/// Static Tajweed colour-key chips (presentation only).
class TajweedLegendRow extends StatelessWidget {
  const TajweedLegendRow({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _LegendChip(
            color: const Color(0xFFFB8C00),
            title: l10n.quranTajweedLegendMadd,
            subtitle: l10n.quranTajweedLegendMaddDesc,
          ),
          SizedBox(width: 8.w),
          _LegendChip(
            color: const Color(0xFF1976D2),
            title: l10n.quranTajweedLegendIdgham,
            subtitle: l10n.quranTajweedLegendIdghamDesc,
          ),
          SizedBox(width: 8.w),
          _LegendChip(
            color: const Color(0xFF00897B),
            title: l10n.quranTajweedLegendIkhfa,
            subtitle: l10n.quranTajweedLegendIkhfaDesc,
          ),
          SizedBox(width: 8.w),
          _LegendChip(
            color: const Color(0xFF6A1B9A),
            title: l10n.quranTajweedLegendGhunnah,
            subtitle: l10n.quranTajweedLegendGhunnahDesc,
          ),
          SizedBox(width: 8.w),
          _LegendChip(
            color: const Color(0xFFC62828),
            title: l10n.quranTajweedLegendQalqalah,
            subtitle: l10n.quranTajweedLegendQalqalahDesc,
          ),
        ],
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.r,
            height: 8.r,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 8.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11.sp,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
