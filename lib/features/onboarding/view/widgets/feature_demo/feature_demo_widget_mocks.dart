import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../l10n/app_localizations.dart';
import 'feature_demo_phase.dart';

const _kWidgetGreen = Color(0xFF3E8268);

/// Shared painted mocks of the three DeenFocus home-screen widgets.
class FeatureDemoWidgetMock extends StatelessWidget {
  const FeatureDemoWidgetMock({
    super.key,
    required this.size,
    this.compact = false,
  });

  final FeatureDemoWidgetSize size;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (size) {
      FeatureDemoWidgetSize.small => _SmallMock(l10n: l10n, compact: compact),
      FeatureDemoWidgetSize.medium => _MediumMock(l10n: l10n, compact: compact),
      FeatureDemoWidgetSize.large => _LargeMock(l10n: l10n, compact: compact),
    };
  }
}

class _SmallMock extends StatelessWidget {
  const _SmallMock({required this.l10n, required this.compact});

  final AppLocalizations l10n;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final side = compact ? 110.w : 150.w;
    return Container(
      width: side,
      height: side,
      padding: EdgeInsets.all(compact ? 8.w : 10.w),
      decoration: BoxDecoration(
        color: _kWidgetGreen,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        children: [
          Text(
            l10n.appTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 9.sp : 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6.h),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: [
                for (final label in [
                  l10n.homePrayerFajr,
                  l10n.homePrayerDhuhr,
                  l10n.homePrayerAsr,
                  l10n.homePrayerMaghrib,
                ])
                  _PrayerChip(label: label, compact: compact),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MediumMock extends StatelessWidget {
  const _MediumMock({required this.l10n, required this.compact});

  final AppLocalizations l10n;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 10.w : 14.w),
      decoration: BoxDecoration(
        color: _kWidgetGreen,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                l10n.widgetDailyVerseTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 10.sp : 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                l10n.appTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 10.sp : 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.2)),
          SizedBox(height: 6.h),
          Text(
            l10n.featureDemoWidgetSampleVerse,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 11.sp : 13.sp,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            l10n.featureDemoWidgetSampleSource,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 9.sp,
            ),
          ),
          SizedBox(height: compact ? 6.h : 10.h),
          Row(
            children: [
              for (final prayer in [
                l10n.homePrayerFajr,
                l10n.homePrayerDhuhr,
                l10n.homePrayerAsr,
                l10n.homePrayerMaghrib,
                l10n.homePrayerIsha,
              ])
                Expanded(
                  child: Text(
                    prayer,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: compact ? 7.sp : 8.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LargeMock extends StatelessWidget {
  const _LargeMock({required this.l10n, required this.compact});

  final AppLocalizations l10n;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 10.w : 14.w),
      decoration: BoxDecoration(
        color: _kWidgetGreen,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.widgetPrayerProgressTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 11.sp : 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (i) {
              final done = i < 2;
              return Container(
                width: compact ? 18.w : 22.w,
                height: compact ? 18.w : 22.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? Colors.white : Colors.transparent,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.55),
                    width: 2,
                  ),
                ),
                child: done
                    ? Icon(
                        Icons.check_rounded,
                        size: compact ? 12.sp : 14.sp,
                        color: _kWidgetGreen,
                      )
                    : null,
              );
            }),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              l10n.widgetPrayersLeftToday(3),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 9.sp : 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              for (final prayer in [
                l10n.homePrayerFajr,
                l10n.homePrayerDhuhr,
                l10n.homePrayerAsr,
                l10n.homePrayerMaghrib,
                l10n.homePrayerIsha,
              ])
                Expanded(
                  child: Text(
                    prayer,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: compact ? 7.sp : 8.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrayerChip extends StatelessWidget {
  const _PrayerChip({required this.label, required this.compact});

  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: compact ? 8.sp : 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
