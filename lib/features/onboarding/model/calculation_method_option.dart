import 'package:adhan_dart/adhan_dart.dart';

import '../../../l10n/app_localizations.dart';

enum CalculationMethodOption {
  muslimWorldLeague,
  northAmerica,
  egyptian,
  ummAlQura,
  karachi,
  tehran,
  kuwait,
  qatar,
  dubai,
  turkey,
  singapore,
  moonsightingCommittee;

  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case muslimWorldLeague:
        return l10n.calcMethodMuslimWorldLeague;
      case northAmerica:
        return l10n.calcMethodNorthAmerica;
      case egyptian:
        return l10n.calcMethodEgyptian;
      case ummAlQura:
        return l10n.calcMethodUmmAlQura;
      case karachi:
        return l10n.calcMethodKarachi;
      case tehran:
        return l10n.calcMethodTehran;
      case kuwait:
        return l10n.calcMethodKuwait;
      case qatar:
        return l10n.calcMethodQatar;
      case dubai:
        return l10n.calcMethodDubai;
      case turkey:
        return l10n.calcMethodTurkey;
      case singapore:
        return l10n.calcMethodSingapore;
      case moonsightingCommittee:
        return l10n.calcMethodMoonsighting;
    }
  }

  bool get isShia => this == tehran;

  CalculationParameters toParams() {
    switch (this) {
      case muslimWorldLeague:
        return CalculationMethodParameters.muslimWorldLeague();
      case northAmerica:
        return CalculationMethodParameters.northAmerica();
      case egyptian:
        return CalculationMethodParameters.egyptian();
      case ummAlQura:
        return CalculationMethodParameters.ummAlQura();
      case karachi:
        return CalculationMethodParameters.karachi();
      case tehran:
        return CalculationMethodParameters.tehran();
      case kuwait:
        return CalculationMethodParameters.kuwait();
      case qatar:
        return CalculationMethodParameters.qatar();
      case dubai:
        return CalculationMethodParameters.dubai();
      case turkey:
        return CalculationMethodParameters.turkiye();
      case singapore:
        return CalculationMethodParameters.singapore();
      case moonsightingCommittee:
        return CalculationMethodParameters.moonsightingCommittee();
    }
  }

  static CalculationMethodOption fromRaw(String? raw, {String? sectRaw}) {
    if (raw != null) {
      for (final m in values) {
        if (m.name == raw) return m;
      }
    }
    if (sectRaw == 'shia') return tehran;
    return muslimWorldLeague;
  }
}
