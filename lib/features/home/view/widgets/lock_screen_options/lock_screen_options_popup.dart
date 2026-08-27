import 'package:flutter/material.dart';

import 'lock_screen_options_screen.dart';

/// Opens the full-screen Lock Screen Style picker.
class LockScreenOptionsPopup {
  static Future<void> show(BuildContext context) {
    return LockScreenOptionsScreen.open(context);
  }
}
