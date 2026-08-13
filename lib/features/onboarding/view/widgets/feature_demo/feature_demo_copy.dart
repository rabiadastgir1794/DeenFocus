import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import 'feature_demo_kind.dart';
import 'feature_demo_phase.dart';

/// Copy for Widgets / Live Activity demos (platform-aware callouts).
class FeatureDemoCopy {
  const FeatureDemoCopy({
    required this.kind,
    required this.navTitle,
    required this.introTitle,
    required this.introSubtitle,
    required this.completionTitle,
    required this.completionSubtitle,
    required this.completionBody,
    required this.completionCta,
    required this.icon,
    required this.isCupertinoPlatform,
  });

  final FeatureDemoKind kind;
  final String navTitle;
  final String introTitle;
  final String introSubtitle;
  final String completionTitle;
  final String completionSubtitle;
  final String completionBody;
  final String completionCta;
  final IconData icon;
  final bool isCupertinoPlatform;

  factory FeatureDemoCopy.resolve({
    required AppLocalizations l10n,
    required FeatureDemoKind kind,
    required bool isCupertinoPlatform,
  }) {
    switch (kind) {
      case FeatureDemoKind.widgets:
        return FeatureDemoCopy(
          kind: kind,
          navTitle: l10n.featureDemoWidgetsTitle,
          introTitle: l10n.featureDemoWidgetsIntroTitle,
          introSubtitle: isCupertinoPlatform
              ? l10n.featureDemoWidgetsIntroSubtitleIos
              : l10n.featureDemoWidgetsIntroSubtitleAndroid,
          completionTitle: l10n.featureDemoWidgetsCompletionTitle,
          completionSubtitle: l10n.featureDemoWidgetsCompletionSubtitle,
          completionBody: l10n.featureDemoWidgetsCompletionBody,
          completionCta: l10n.appLockDemoDone,
          icon: Icons.widgets_rounded,
          isCupertinoPlatform: isCupertinoPlatform,
        );
      case FeatureDemoKind.liveActivity:
        return FeatureDemoCopy(
          kind: kind,
          navTitle: l10n.featureDemoLiveActivityTitle,
          introTitle: l10n.featureDemoLiveActivityIntroTitle,
          introSubtitle: isCupertinoPlatform
              ? l10n.featureDemoLiveActivityIntroSubtitleIos
              : l10n.featureDemoLiveActivityIntroSubtitleAndroid,
          completionTitle: l10n.featureDemoLiveActivityCompletionTitle,
          completionSubtitle: isCupertinoPlatform
              ? l10n.featureDemoLiveActivityCompletionSubtitleIos
              : l10n.featureDemoLiveActivityCompletionSubtitleAndroid,
          completionBody: isCupertinoPlatform
              ? l10n.featureDemoLiveActivityCompletionBodyIos
              : l10n.featureDemoLiveActivityCompletionBodyAndroid,
          completionCta: l10n.appLockDemoDone,
          icon: Icons.notifications_active_rounded,
          isCupertinoPlatform: isCupertinoPlatform,
        );
    }
  }

  String calloutFor(FeatureDemoPhase phase, AppLocalizations l10n) {
    return switch (phase) {
      FeatureDemoPhase.widgetsHome => isCupertinoPlatform
          ? l10n.featureDemoWidgetsLongPressCalloutIos
          : l10n.featureDemoWidgetsLongPressCalloutAndroid,
      FeatureDemoPhase.widgetsEditMode => l10n.featureDemoWidgetsAddCallout,
      FeatureDemoPhase.liveSettings =>
        l10n.featureDemoLiveEnableToggleCallout,
      FeatureDemoPhase.liveLockScreen => l10n.featureDemoLiveLockScreenCallout,
      FeatureDemoPhase.liveCompactIsland =>
        l10n.featureDemoLiveCompactCallout,
      FeatureDemoPhase.liveExpandedIsland =>
        l10n.featureDemoLiveExpandedCallout,
      FeatureDemoPhase.liveOngoingNotification =>
        l10n.featureDemoAndroidOngoingCallout,
      FeatureDemoPhase.liveNotificationShade =>
        l10n.featureDemoAndroidShadeCallout,
      _ => '',
    };
  }
}
