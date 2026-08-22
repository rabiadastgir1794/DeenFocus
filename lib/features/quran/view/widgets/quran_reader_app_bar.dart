import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'quran_reader_icon_button.dart';
import 'quran_reader_theme.dart';

/// Frosted glass app bar for premium Mushaf reader screens.
class QuranReaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const QuranReaderAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.actions = const [],
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final List<Widget> actions;

  static const double toolbarHeight = 56;

  static double heightFor(BuildContext context) =>
      toolbarHeight.h + MediaQuery.paddingOf(context).top;

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight.h);

  @override
  Widget build(BuildContext context) {
    final palette = context.quranReader;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          color: palette.paper.withValues(alpha: 0.72),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: toolbarHeight.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  children: [
                    QuranReaderIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      tooltip: 'Back',
                      onPressed:
                          onBack ?? () => Navigator.of(context).maybePop(),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                              color: palette.textPrimary,
                            ),
                          ),
                          if (subtitle != null) ...[
                            SizedBox(height: 1.h),
                            Text(
                              subtitle!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: palette.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    ...actions.map(
                      (action) => Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: action,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
