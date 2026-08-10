import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'quran_reader_theme.dart';

/// Rounded, soft icon button for premium reader chrome.
class QuranReaderIconButton extends StatelessWidget {
  const QuranReaderIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.highlighted = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final palette = context.quranReader;
    final enabled = onPressed != null;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: highlighted
            ? palette.primary.withValues(alpha: 0.12)
            : palette.paper.withValues(alpha: 0.9),
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
          side: BorderSide(
            color: enabled
                ? palette.glassBorder
                : palette.glassBorder.withValues(alpha: 0.5),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.all(10.r),
            child: Icon(
              icon,
              size: 22.sp,
              color: enabled
                  ? (highlighted
                      ? palette.primary
                      : palette.textPrimary.withValues(alpha: 0.75))
                  : palette.textSecondary.withValues(alpha: 0.4),
            ),
          ),
        ),
      ),
    );
  }
}
