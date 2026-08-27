import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../l10n/app_localizations.dart';

class LockScreenQuizQuestion {
  const LockScreenQuizQuestion({
    required this.category,
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  final String category;
  final String question;
  final List<String> options;
  final int correctIndex;
}

class LockScreenQuizViewModel extends ChangeNotifier {
  LockScreenQuizViewModel(this.questions);

  factory LockScreenQuizViewModel.fromL10n(AppLocalizations l10n) {
    return LockScreenQuizViewModel([
      LockScreenQuizQuestion(
        category: l10n.lockScreenQuizCategory,
        question: l10n.lockScreenQuizQuestion,
        options: [
          l10n.lockScreenQuizA,
          l10n.lockScreenQuizB,
          l10n.lockScreenQuizC,
        ],
        correctIndex: 2,
      ),
      LockScreenQuizQuestion(
        category: l10n.lockScreenQuizCategoryFasting,
        question: l10n.lockScreenQuizQ2,
        options: [
          l10n.lockScreenQuizQ2A,
          l10n.lockScreenQuizQ2B,
          l10n.lockScreenQuizQ2C,
        ],
        correctIndex: 1,
      ),
      LockScreenQuizQuestion(
        category: l10n.lockScreenQuizCategoryPillars,
        question: l10n.lockScreenQuizQ3,
        options: [
          l10n.lockScreenQuizQ3A,
          l10n.lockScreenQuizQ3B,
          l10n.lockScreenQuizQ3C,
        ],
        correctIndex: 1,
      ),
    ]);
  }

  final List<LockScreenQuizQuestion> questions;

  int _index = 0;
  int? _selectedIndex;
  bool _complete = false;
  Timer? _advanceTimer;

  int get index => _index;
  int get total => questions.length;
  int? get selectedIndex => _selectedIndex;
  bool get complete => _complete;
  LockScreenQuizQuestion get current => questions[_index];
  bool get answered => _selectedIndex != null;
  bool get lastWasCorrect =>
      _selectedIndex != null && _selectedIndex == current.correctIndex;

  void select(int optionIndex) {
    if (answered || _complete) return;
    _selectedIndex = optionIndex;
    notifyListeners();
    _advanceTimer?.cancel();
    _advanceTimer = Timer(const Duration(milliseconds: 850), _advance);
  }

  void _advance() {
    if (_index >= questions.length - 1) {
      _complete = true;
      notifyListeners();
      return;
    }
    _index += 1;
    _selectedIndex = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _advanceTimer?.cancel();
    super.dispose();
  }
}
