import '../../../l10n/app_localizations.dart';
import '../../onboarding/view/widgets/app_lock_demo/app_lock_demo_mode.dart';
import 'focus_models.dart';

enum RestrictedModeKind { salah, child, night }

extension RestrictedModeKindX on RestrictedModeKind {
  static RestrictedModeKind fromDemo(AppLockDemoMode mode) => switch (mode) {
    AppLockDemoMode.prayer => RestrictedModeKind.salah,
    AppLockDemoMode.child => RestrictedModeKind.child,
    AppLockDemoMode.sleep => RestrictedModeKind.night,
  };

  static RestrictedModeKind fromFocus(FocusModeType mode) => switch (mode) {
    FocusModeType.salah => RestrictedModeKind.salah,
    FocusModeType.child => RestrictedModeKind.child,
    FocusModeType.nightDiscipline => RestrictedModeKind.night,
  };
}

class RestrictedModeContent {
  const RestrictedModeContent({
    required this.kind,
    required this.title,
    required this.message,
    required this.info,
    required this.quote,
    required this.quoteSource,
    required this.cta,
  });

  final RestrictedModeKind kind;
  final String title;
  final String message;
  final String info;
  final String quote;
  final String quoteSource;
  final String cta;

  factory RestrictedModeContent.resolve(
    AppLocalizations l10n,
    RestrictedModeKind kind,
  ) {
    final info = l10n.restrictedModeAppsUnavailable;
    switch (kind) {
      case RestrictedModeKind.salah:
        return RestrictedModeContent(
          kind: kind,
          title: l10n.restrictedModeSalahTitle,
          message: l10n.restrictedModeSalahMessage,
          info: info,
          quote: l10n.restrictedModeSalahQuote,
          quoteSource: l10n.restrictedModeSalahQuoteSource,
          cta: l10n.restrictedModeSalahCta,
        );
      case RestrictedModeKind.child:
        return RestrictedModeContent(
          kind: kind,
          title: l10n.restrictedModeChildTitle,
          message: l10n.restrictedModeChildMessage,
          info: info,
          quote: l10n.restrictedModeChildQuote,
          quoteSource: l10n.restrictedModeChildQuoteSource,
          cta: l10n.restrictedModeChildCta,
        );
      case RestrictedModeKind.night:
        return RestrictedModeContent(
          kind: kind,
          title: l10n.restrictedModeNightTitle,
          message: l10n.restrictedModeNightMessage,
          info: info,
          quote: l10n.restrictedModeNightQuote,
          quoteSource: l10n.restrictedModeNightQuoteSource,
          cta: l10n.restrictedModeNightCta,
        );
    }
  }
}
