import 'package:flutter/material.dart';

import '../../../../core/constants/spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../helpers/prayer_label_helper.dart';
import '../../model/home_models.dart';

/// Prayer Reminder Popup that shows when the app opens if the most recent
/// prayer hasn't been marked. Encourages users to keep their streak alive.
class PrayerReminderPopup {
  static Future<bool?> show({
    required BuildContext context,
    required TrackablePrayer prayer,
    required VoidCallback onMarkPrayer,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark
              ? colorScheme.surfaceContainerHigh
              : colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: EdgeInsets.all(Spacing.lg),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.mosque_rounded,
                  size: 40,
                  color: colorScheme.primary,
                ),
              ),
              SizedBox(height: Spacing.lg),
              
              // Title
              Text(
                l10n.prayerReminderTitle(prayer.label(l10n)),
                textAlign: TextAlign.center,
                style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: Spacing.sm),
              
              // Subtitle
              Text(
                l10n.prayerReminderSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              SizedBox(height: Spacing.lg),
              
              // Primary Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                    onMarkPrayer();
                  },
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(vertical: Spacing.md),
                  ),
                  child: Text(l10n.prayerReminderYesButton),
                ),
              ),
              SizedBox(height: Spacing.sm),
              
              // Secondary Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(vertical: Spacing.md),
                  ),
                  child: Text(l10n.prayerReminderLaterButton),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
