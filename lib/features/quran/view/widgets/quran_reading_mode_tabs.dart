import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../reading_engine/reading_mode.dart';

/// Surah / Juz / Page switcher — white sliding pill on a soft track.
class QuranReadingModeTabs extends StatelessWidget {
  const QuranReadingModeTabs({
    super.key,
    required this.selected,
    required this.onSelected,
    required this.surahLabel,
    required this.juzLabel,
    required this.pageLabel,
  });

  final ReadingMode selected;
  final ValueChanged<ReadingMode> onSelected;
  final String surahLabel;
  final String juzLabel;
  final String pageLabel;

  static const _modes = <ReadingMode>[
    ReadingMode.surah,
    ReadingMode.juz,
    ReadingMode.page,
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackColor = isDark
        ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.65)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.55);
    final selectedIndex = _modes.indexOf(selected).clamp(0, _modes.length - 1);

    String label(ReadingMode mode) => switch (mode) {
          ReadingMode.surah => surahLabel,
          ReadingMode.juz => juzLabel,
          ReadingMode.page => pageLabel,
        };

    return LayoutBuilder(
      builder: (context, constraints) {
        final segmentWidth = constraints.maxWidth / _modes.length;
        return Container(
          height: 44.h,
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                left: segmentWidth * selectedIndex,
                top: 4.h,
                bottom: 4.h,
                width: segmentWidth,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  for (final mode in _modes)
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20.r),
                          onTap: () => onSelected(mode),
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 180),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: mode == selected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: mode == selected
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant,
                              ),
                              child: Text(label(mode)),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
