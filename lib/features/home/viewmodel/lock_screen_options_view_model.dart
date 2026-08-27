import 'package:flutter/foundation.dart';

import '../helpers/lock_screen_style_preference.dart';
import '../view/widgets/lock_screen_options/lock_screen_style.dart';

/// Selection state for the Lock Screen Style picker.
class LockScreenOptionsViewModel extends ChangeNotifier {
  LockScreenStyle _selected = LockScreenStyle.classic;

  LockScreenStyle get selected => _selected;

  Future<void> load() async {
    _selected = await LockScreenStylePreference.ensureSelected();
    notifyListeners();
  }

  Future<void> select(LockScreenStyle style) async {
    _selected = style;
    notifyListeners();
    await LockScreenStylePreference.save(style);
  }
}
