import 'package:flutter/foundation.dart';

import '../../../l10n/app_localizations.dart';

class LockScreenTasbihStep {
  const LockScreenTasbihStep({
    required this.arabic,
    required this.transliteration,
    required this.target,
  });

  final String arabic;
  final String transliteration;
  final int target;
}

/// Session-only tasbih sequence for the lock-screen style.
class LockScreenTasbihViewModel extends ChangeNotifier {
  static const steps = <LockScreenTasbihStep>[
    LockScreenTasbihStep(
      arabic: 'أَسْتَغْفِرُ اللّٰهَ',
      transliteration: 'Astaghfirullah',
      target: 3,
    ),
    LockScreenTasbihStep(
      arabic: 'سُبْحَانَ اللّٰهِ',
      transliteration: 'SubhanAllah',
      target: 33,
    ),
    LockScreenTasbihStep(
      arabic: 'الْحَمْدُ لِلّٰهِ',
      transliteration: 'Alhamdulillah',
      target: 33,
    ),
    LockScreenTasbihStep(
      arabic: 'اللّٰهُ أَكْبَرُ',
      transliteration: 'Allahu Akbar',
      target: 33,
    ),
  ];

  static List<String> localizedLabels(AppLocalizations l10n) => [
    l10n.lockScreenDhikrAstaghfirullah,
    l10n.lockScreenDhikrSubhanAllah,
    l10n.lockScreenDhikrAlhamdulillah,
    l10n.lockScreenDhikrAllahuAkbar,
  ];

  String localizedTransliteration(AppLocalizations l10n) =>
      localizedLabels(l10n)[_stepIndex];

  int _stepIndex = 0;
  int _count = 0;

  int get stepIndex => _stepIndex;
  int get count => _count;
  LockScreenTasbihStep get current => steps[_stepIndex];
  bool get hasStarted => _count > 0 || _stepIndex > 0;
  bool _completionConsumed = false;

  bool get sequenceComplete =>
      _stepIndex == steps.length - 1 && _count >= current.target;

  /// True once, the first time the last step reaches its target.
  bool consumeSequenceCompletion() {
    if (!sequenceComplete || _completionConsumed) return false;
    _completionConsumed = true;
    return true;
  }

  void tap() {
    if (sequenceComplete) return;
    _count += 1;
    if (_count >= current.target && _stepIndex < steps.length - 1) {
      _stepIndex += 1;
      _count = 0;
    }
    notifyListeners();
  }

  void reset() {
    _stepIndex = 0;
    _count = 0;
    _completionConsumed = false;
    notifyListeners();
  }
}
