import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../l10n/app_localizations.dart';

/// Simulated social feed used behind prayer lock / streak reward overlays.
class AppLockDemoSocialBackground extends StatelessWidget {
  const AppLockDemoSocialBackground({
    super.key,
    this.blurred = true,
  });

  final bool blurred;

  @override
  Widget build(BuildContext context) {
    final feed = ColoredBox(
      color: const Color(0xFF0E0E0E),
      child: Column(
        children: [
          SizedBox(height: 48.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.appLockDemoAppInstagram,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Spacer(),
                Icon(Icons.favorite_border, color: Colors.white70, size: 22.sp),
                SizedBox(width: 14.w),
                Icon(Icons.send_outlined, color: Colors.white70, size: 22.sp),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            height: 72.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              itemCount: 8,
              separatorBuilder: (_, _) => SizedBox(width: 10.w),
              itemBuilder: (_, i) => Container(
                width: 64.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(
                        const Color(0xFFF58529),
                        const Color(0xFFDD2A7B),
                        i / 8,
                      )!,
                      const Color(0xFF8134AF),
                    ],
                  ),
                ),
                padding: EdgeInsets.all(3.w),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1C1C1E),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (_, i) => Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16.r,
                            backgroundColor: Colors.white24,
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            width: 90.w,
                            height: 10.h,
                            color: Colors.white24,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      height: 180.h,
                      color: Color.lerp(
                        const Color(0xFF2A2A2A),
                        const Color(0xFF3A3A3A),
                        i / 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (!blurred) return feed;

    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: feed,
    );
  }
}
