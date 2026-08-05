import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import 'reading_settings_screen.dart';

/// Opens [ReadingSettingsScreen] from any Quran reader surface.
abstract final class QuranReadingSettingsLauncher {
  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const ReadingSettingsScreen(),
      ),
    );
  }

  static Widget appBarAction(
    BuildContext context, {
    VoidCallback? onReturn,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return IconButton(
      tooltip: l10n.readingSettingsTitle,
      icon: const Icon(Icons.tune_rounded),
      onPressed: () async {
        await open(context);
        onReturn?.call();
      },
    );
  }
}
