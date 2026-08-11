import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import 'app_lock_demo_mode.dart';

/// Mode-specific copy for the shared App Lock Demo walkthrough.
class AppLockDemoCopy {
  const AppLockDemoCopy({
    required this.mode,
    required this.showStreakReward,
    required this.navTitle,
    required this.introTitle,
    required this.introSubtitle,
    required this.tryOpeningApp,
    required this.lockBadge,
    required this.lockTitle,
    required this.lockDetailTitle,
    required this.lockDetailSubtitle,
    required this.lockCta,
    required this.lockIcon,
    required this.rewardCompletedLabel,
    required this.rewardIncreasedLabel,
    required this.rewardLeftStatLabel,
    required this.rewardRightStatLabel,
    required this.rewardLeftIcon,
    required this.rewardRightIcon,
    required this.rewardFooterLine,
    required this.rewardMotivation,
    required this.completionTitle,
    required this.showCompletionHeart,
    required this.completionSubtitle,
    required this.completionBody,
    required this.completionCta,
  });

  final AppLockDemoMode mode;

  /// Prayer Mode only — Sleep/Child skip the streak popup.
  final bool showStreakReward;

  /// Centered nav header title (mode name).
  final String navTitle;
  final String introTitle;
  final String introSubtitle;
  final String tryOpeningApp;
  final String lockBadge;
  final String lockTitle;
  final String lockDetailTitle;
  final String lockDetailSubtitle;
  final String lockCta;
  final IconData lockIcon;
  final String rewardCompletedLabel;
  final String rewardIncreasedLabel;
  final String rewardLeftStatLabel;
  final String rewardRightStatLabel;
  final IconData rewardLeftIcon;
  final IconData rewardRightIcon;
  final String rewardFooterLine;
  final String rewardMotivation;
  final String completionTitle;
  final bool showCompletionHeart;
  final String completionSubtitle;
  final String completionBody;
  final String completionCta;

  factory AppLockDemoCopy.resolve({
    required AppLocalizations l10n,
    required AppLockDemoMode mode,
    required String remainingFormatted,
    required bool fromSettings,
  }) {
    final completionCta = fromSettings
        ? l10n.appLockDemoDone
        : l10n.appLockDemoContinueSetup;

    switch (mode) {
      case AppLockDemoMode.prayer:
        final prayer = l10n.homePrayerMaghrib;
        return AppLockDemoCopy(
          mode: mode,
          showStreakReward: true,
          navTitle: l10n.focusPrayerModeTitle,
          introTitle: l10n.appLockDemoIntroTitle,
          introSubtitle: l10n.appLockDemoIntroSubtitle,
          tryOpeningApp: l10n.appLockDemoTryOpeningApp,
          lockBadge: l10n.appLockDemoSalahModeBadge,
          lockTitle: l10n.appLockDemoTimeToPray,
          lockDetailTitle: prayer,
          lockDetailSubtitle: l10n.appLockDemoRemainingTime(remainingFormatted),
          lockCta: l10n.appLockDemoIvePrayed(prayer),
          lockIcon: Icons.nightlight_round,
          rewardCompletedLabel: l10n.appLockDemoPrayerCompleted(prayer),
          rewardIncreasedLabel: l10n.appLockDemoStreakIncreased,
          rewardLeftStatLabel: l10n.appLockDemoPrayerStreakLabel,
          rewardRightStatLabel: l10n.appLockDemoDayStreakLabel,
          rewardLeftIcon: Icons.local_fire_department_rounded,
          rewardRightIcon: Icons.calendar_today_rounded,
          rewardFooterLine: l10n.appLockDemoNextPrayerIn('58'),
          rewardMotivation: l10n.appLockDemoStreakMotivation,
          completionTitle: l10n.appLockDemoAlhamdulillah,
          showCompletionHeart: true,
          completionSubtitle: l10n.appLockDemoCompletionSubtitle,
          completionBody: l10n.appLockDemoCompletionBody,
          completionCta: completionCta,
        );
      case AppLockDemoMode.sleep:
        return AppLockDemoCopy(
          mode: mode,
          showStreakReward: false,
          navTitle: l10n.focusSleepModeTitle,
          introTitle: l10n.appLockDemoSleepIntroTitle,
          introSubtitle: l10n.appLockDemoSleepIntroSubtitle,
          tryOpeningApp: l10n.appLockDemoTryOpeningApp,
          lockBadge: l10n.appLockDemoSleepModeBadge,
          lockTitle: l10n.appLockDemoSleepLockTitle,
          lockDetailTitle: l10n.focusSleepModeTitle,
          lockDetailSubtitle:
              l10n.appLockDemoRemainingTime(remainingFormatted),
          lockCta: l10n.appLockDemoSleepLockCta,
          lockIcon: Icons.bedtime_rounded,
          // Unused when showStreakReward is false.
          rewardCompletedLabel: '',
          rewardIncreasedLabel: '',
          rewardLeftStatLabel: '',
          rewardRightStatLabel: '',
          rewardLeftIcon: Icons.bedtime_rounded,
          rewardRightIcon: Icons.calendar_today_rounded,
          rewardFooterLine: '',
          rewardMotivation: '',
          completionTitle: l10n.appLockDemoSleepCompletionTitle,
          showCompletionHeart: false,
          completionSubtitle: l10n.appLockDemoSleepCompletionSubtitle,
          completionBody: l10n.appLockDemoSleepCompletionBody,
          completionCta: completionCta,
        );
      case AppLockDemoMode.child:
        return AppLockDemoCopy(
          mode: mode,
          showStreakReward: false,
          navTitle: l10n.focusChildModeTitle,
          introTitle: l10n.appLockDemoChildIntroTitle,
          introSubtitle: l10n.appLockDemoChildIntroSubtitle,
          tryOpeningApp: l10n.appLockDemoTryOpeningApp,
          lockBadge: l10n.appLockDemoChildModeBadge,
          lockTitle: l10n.appLockDemoChildLockTitle,
          lockDetailTitle: l10n.focusChildModeTitle,
          lockDetailSubtitle: l10n.appLockDemoChildLockDetail,
          lockCta: l10n.appLockDemoChildLockCta,
          lockIcon: Icons.child_care_rounded,
          rewardCompletedLabel: '',
          rewardIncreasedLabel: '',
          rewardLeftStatLabel: '',
          rewardRightStatLabel: '',
          rewardLeftIcon: Icons.shield_rounded,
          rewardRightIcon: Icons.calendar_today_rounded,
          rewardFooterLine: '',
          rewardMotivation: '',
          completionTitle: l10n.appLockDemoChildCompletionTitle,
          showCompletionHeart: false,
          completionSubtitle: l10n.appLockDemoChildCompletionSubtitle,
          completionBody: l10n.appLockDemoChildCompletionBody,
          completionCta: completionCta,
        );
    }
  }
}
