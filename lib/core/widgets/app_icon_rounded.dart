import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Rounded background with centered icon. Used on onboarding screens.
class AppIconRounded extends StatelessWidget {
  const AppIconRounded({
    super.key,
    required this.icon,
    this.size,
    this.iconSize,
    this.backgroundColor,
  });

  final Widget icon;
  final double? size;
  final double? iconSize;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final defaultBg = colorScheme.primaryContainer;

    final bg = backgroundColor ?? defaultBg;

    final s = size ?? 72.r;
    final iSize = iconSize ?? 32.sp;

    return Container(
      width: s,
      height: s,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: IconTheme(
          data: IconThemeData(size: iSize, color: colorScheme.primary),
          child: icon,
        ),
      ),
    );
  }
}
