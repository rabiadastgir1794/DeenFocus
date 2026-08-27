import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../model/home_models.dart';
import 'lock_screen_style.dart';
import 'lock_screen_style_chrome.dart';
import 'lock_screen_style_interactive.dart';

class LockScreenStyleExperienceScreen extends StatelessWidget {
  const LockScreenStyleExperienceScreen({
    super.key,
    required this.style,
    required this.prayer,
  });

  final LockScreenStyle style;
  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: LockScreenPreviewChrome(
        label: style.title(l10n),
        onClose: () => Navigator.of(context).pop(),
        child: LockScreenInteractiveStyle(style: style, prayer: prayer),
      ),
    );
  }
}
