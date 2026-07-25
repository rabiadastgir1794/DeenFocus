import 'package:adhan_dart/adhan_dart.dart';

enum AsrCalculationOption {
  standard,
  hanafi;

  String get label {
    switch (this) {
      case standard:
        return 'Standard';
      case hanafi:
        return 'Hanafi';
    }
  }

  String get subtitle {
    switch (this) {
      case standard:
        return 'Shafi, Maliki, Hanbali';
      case hanafi:
        return '';
    }
  }

  Madhab get madhab {
    switch (this) {
      case standard:
        return Madhab.shafi;
      case hanafi:
        return Madhab.hanafi;
    }
  }

  static AsrCalculationOption fromRaw(String? raw) {
    if (raw == 'hanafi') return hanafi;
    return standard;
  }
}
