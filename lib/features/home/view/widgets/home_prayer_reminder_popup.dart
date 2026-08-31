import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/lock_screen_prayer_actions.dart';
import '../../helpers/lock_screen_style_preference.dart';
import '../../model/home_models.dart';
import '../../viewmodel/home_tab_view_model.dart';
import 'lock_screen_options/lock_screen_style.dart';
import 'lock_screen_options/lock_screen_style_interactive.dart';

/// Prayer reminder shown when the app opens if the most recent prayer
/// hasn't been marked.
///
/// Returns `true` when the user confirms on-time (mark + unlock happen inside
/// [LockScreenPrayerActions.confirmOnTime]), `false` for Later, and `null` if
/// dismissed.
///
/// Presentation is always the original centered [AlertDialog] (barrier,
/// 24px card, default fade/scale). Inner content follows the selected
/// Lock Screen Style (Classic Prayer Reminder when none is selected or a
/// paid style is no longer entitled).
class PrayerReminderPopup {
  static Future<bool?> show({
    required BuildContext context,
    required TrackablePrayer prayer,
  }) async {
    final style = await LockScreenStylePreference.resolveForReminder();
    if (!context.mounted) return null;

    HomeTabViewModel? homeVm;
    try {
      homeVm = context.read<HomeTabViewModel>();
    } on ProviderNotFoundException {
      homeVm = null;
    }

    if (homeVm != null &&
        homeVm.statusForToday(prayer) != PrayerMarkStatus.none) {
      return null;
    }

    // Prefer shared confirm path so mark + unlock stay centralized.
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        Widget dialog = PrayerReminderStyleDialog(style: style, prayer: prayer);
        if (homeVm == null) return dialog;
        return ChangeNotifierProvider<HomeTabViewModel>.value(
          value: homeVm,
          child: dialog,
        );
      },
    );
  }
}

/// Centered reminder dialog chrome shared by every Lock Screen Style.
class PrayerReminderStyleDialog extends StatelessWidget {
  const PrayerReminderStyleDialog({
    super.key,
    required this.style,
    required this.prayer,
  });

  final LockScreenStyle style;
  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final maxHeight = media.size.height * 0.78;
    final contentWidth = (media.size.width - 80).clamp(260.0, 360.0);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      content: SizedBox(
        width: contentWidth,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            child: LockScreenInteractiveStyle(
              style: style,
              prayer: prayer,
              compact: true,
              onConfirm: () => LockScreenPrayerActions.confirmOnTime(
                context,
                prayer: prayer,
              ),
              onLater: () => LockScreenPrayerActions.deferReminder(context),
            ),
          ),
        ),
      ),
    );
  }
}
