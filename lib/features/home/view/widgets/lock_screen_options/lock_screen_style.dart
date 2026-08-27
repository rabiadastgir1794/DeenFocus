import '../../../../../l10n/app_localizations.dart';

/// Visual lock-screen layouts for the Custom Lock Screen Options picker.
///
/// [classic] is the free Prayer Reminder default and must stay first.
enum LockScreenStyle {
  classic,
  tasbih,
  verse,
  dua,
  quiz,
  times,
  countdown,
  hold,
  typeConfirm,
  minimal;

  static LockScreenStyle? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final value in values) {
      if (value.name == raw) return value;
    }
    return null;
  }
}

extension LockScreenStyleCopy on LockScreenStyle {
  String title(AppLocalizations l10n) {
    switch (this) {
      case LockScreenStyle.classic:
        return l10n.lockScreenStyleClassic;
      case LockScreenStyle.tasbih:
        return l10n.lockScreenStyleTasbih;
      case LockScreenStyle.verse:
        return l10n.lockScreenStyleVerse;
      case LockScreenStyle.dua:
        return l10n.lockScreenStyleDua;
      case LockScreenStyle.quiz:
        return l10n.lockScreenStyleQuiz;
      case LockScreenStyle.times:
        return l10n.lockScreenStyleTimes;
      case LockScreenStyle.countdown:
        return l10n.lockScreenStyleCountdown;
      case LockScreenStyle.hold:
        return l10n.lockScreenStyleHold;
      case LockScreenStyle.typeConfirm:
        return l10n.lockScreenStyleType;
      case LockScreenStyle.minimal:
        return l10n.lockScreenStyleMinimal;
    }
  }

  bool get isDefault => this == LockScreenStyle.classic;

  /// Classic prayer reminder stays free; every other style is premium.
  bool get requiresPremium => this != LockScreenStyle.classic;
}
