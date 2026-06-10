import 'package:adhan_dart/adhan_dart.dart';

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

  String get label {
    switch (this) {
      case muslimWorldLeague:
        return 'Muslim World League';
      case northAmerica:
        return 'Islamic Society of North America (ISNA)';
      case egyptian:
        return 'Egyptian General Authority of Survey';
      case ummAlQura:
        return 'Umm al-Qura University, Makkah';
      case karachi:
        return 'University of Islamic Sciences, Karachi';
      case tehran:
        return 'Tehran';
      case kuwait:
        return 'Kuwait';
      case qatar:
        return 'Qatar';
      case dubai:
        return 'Dubai';
      case turkey:
        return 'Turkey';
      case singapore:
        return 'Singapore';
      case moonsightingCommittee:
        return 'Moonsighting Committee Worldwide';
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
    return karachi;
  }
}
