import '../../../l10n/app_localizations.dart';

enum SectOption {
  sunni,
  shia,
  preferNotToSay;

  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case SectOption.sunni:
        return l10n.sectSunni;
      case SectOption.shia:
        return l10n.sectShia;
      case SectOption.preferNotToSay:
        return l10n.sectPreferNotToSay;
    }
  }
}
