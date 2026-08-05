import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/constants/spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../helpers/prayer_label_helper.dart';
import '../../model/home_models.dart';

class _PrayerInfo {
  const _PrayerInfo({
    required this.timing,
    required this.rakat,
    required this.virtue,
    required this.reference,
  });

  final String timing;
  final String rakat;
  final String virtue;
  final String reference;
}

_PrayerInfo _prayerInfoFor(TrackablePrayer prayer, AppLocalizations l10n) {
  switch (prayer) {
    case TrackablePrayer.fajr:
      return _PrayerInfo(
        timing: l10n.homeAboutFajrTiming,
        rakat: l10n.homeAboutFajrRakat,
        virtue: l10n.homeAboutFajrVirtue,
        reference: l10n.homeAboutFajrReference,
      );
    case TrackablePrayer.dhuhr:
      return _PrayerInfo(
        timing: l10n.homeAboutDhuhrTiming,
        rakat: l10n.homeAboutDhuhrRakat,
        virtue: l10n.homeAboutDhuhrVirtue,
        reference: l10n.homeAboutDhuhrReference,
      );
    case TrackablePrayer.asr:
      return _PrayerInfo(
        timing: l10n.homeAboutAsrTiming,
        rakat: l10n.homeAboutAsrRakat,
        virtue: l10n.homeAboutAsrVirtue,
        reference: l10n.homeAboutAsrReference,
      );
    case TrackablePrayer.maghrib:
      return _PrayerInfo(
        timing: l10n.homeAboutMaghribTiming,
        rakat: l10n.homeAboutMaghribRakat,
        virtue: l10n.homeAboutMaghribVirtue,
        reference: l10n.homeAboutMaghribReference,
      );
    case TrackablePrayer.isha:
      return _PrayerInfo(
        timing: l10n.homeAboutIshaTiming,
        rakat: l10n.homeAboutIshaRakat,
        virtue: l10n.homeAboutIshaVirtue,
        reference: l10n.homeAboutIshaReference,
      );
  }
}

class HomeAboutPrayerScreen extends StatelessWidget {
  const HomeAboutPrayerScreen({super.key, required this.prayer});

  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prayerLabel = prayer.label(l10n);
    final info = _prayerInfoFor(prayer, l10n);
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : AppColors.outlineVariantLight.withValues(alpha: 0.35);

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.homeAboutPrayerTitle(prayerLabel),
        onBack: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 24.h),
          children: [
            Center(
              child: Container(
                width: 96.r,
                height: 96.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primaryContainer,
                ),
                child: Icon(
                  Iconsax.moon,
                  size: 40.sp,
                  color: colorScheme.primary,
                ),
              ),
            ),
            SizedBox(height: Spacing.lg.h),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: Spacing.md.h,
              crossAxisSpacing: Spacing.md.w,
              childAspectRatio: 0.92,
              children: [
                _InfoCard(
                  icon: Iconsax.clock,
                  label: l10n.homeAboutPrayerTimeLabel,
                  body: info.timing,
                  borderColor: borderColor,
                ),
                _InfoCard(
                  icon: Iconsax.people,
                  label: l10n.homeAboutPrayerRakatLabel,
                  body: info.rakat,
                  borderColor: borderColor,
                ),
                _InfoCard(
                  icon: Iconsax.star,
                  label: l10n.homeAboutPrayerVirtuesLabel,
                  body: info.virtue,
                  borderColor: borderColor,
                ),
                _InfoCard(
                  icon: Iconsax.book_1,
                  label: l10n.homeAboutPrayerReferenceLabel,
                  body: info.reference,
                  borderColor: borderColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.label,
    required this.body,
    required this.borderColor,
  });

  final IconData icon;
  final String label;
  final String body;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textDirection = Directionality.of(context);
    return Container(
      padding: EdgeInsets.all(Spacing.md.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.sp, color: colorScheme.primary),
          SizedBox(height: Spacing.sm.h),
          Text(
            label,
            textAlign: TextAlign.start,
            textDirection: textDirection,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4.h),
          Expanded(
            child: Text(
              body,
              textAlign: TextAlign.start,
              textDirection: textDirection,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.3,
              ),
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
    );
  }
}
