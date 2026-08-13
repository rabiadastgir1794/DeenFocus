import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/spacing.dart';
import '../../../../../core/services/prayer_live_activity_toggle.dart';
import '../../../../../l10n/app_localizations.dart';

/// Final Yes/No prompt after the Live Activity walkthrough.
class FeatureDemoEnableOffer extends StatefulWidget {
  const FeatureDemoEnableOffer({
    super.key,
    required this.onFinished,
  });

  final VoidCallback onFinished;

  @override
  State<FeatureDemoEnableOffer> createState() => _FeatureDemoEnableOfferState();
}

class _FeatureDemoEnableOfferState extends State<FeatureDemoEnableOffer> {
  bool _busy = false;

  Future<void> _onYes() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await PrayerLiveActivityToggle.applyWithDialogs(context, enabled: true);
    } finally {
      if (mounted) {
        setState(() => _busy = false);
        widget.onFinished();
      }
    }
  }

  void _onNo() {
    if (_busy) return;
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bottomPad = Spacing.lg.h + MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(flex: 2),
          Icon(
            Icons.notifications_active_outlined,
            size: 56.sp,
            color: colorScheme.primary,
          ),
          SizedBox(height: Spacing.lg.h),
          Text(
            l10n.featureDemoOfferLiveActivityTitle,
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          const Spacer(flex: 3),
          SizedBox(
            height: 56.h,
            child: ElevatedButton(
              onPressed: _busy ? null : () => unawaited(_onYes()),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                disabledBackgroundColor:
                    colorScheme.primary.withValues(alpha: 0.45),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.r),
                ),
              ),
              child: _busy
                  ? SizedBox(
                      width: 22.w,
                      height: 22.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : Text(
                      l10n.featureDemoOfferYes,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
          SizedBox(height: Spacing.md.h),
          SizedBox(
            height: 56.h,
            child: OutlinedButton(
              onPressed: _busy ? null : _onNo,
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.onSurface,
                side: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.55),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.r),
                ),
              ),
              child: Text(
                l10n.featureDemoOfferNo,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(height: bottomPad),
        ],
      ),
    );
  }
}
