import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';
import 'startup_probe.dart';

/// Times the generated [AppLocalizations] load (sync `lookupAppLocalizations`).
class TimedAppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const TimedAppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.delegate.isSupported(locale);

  @override
  Future<AppLocalizations> load(Locale locale) {
    StartupProbe.detail('AppLocalizations.load SYNC begin locale=$locale');
    final sw = Stopwatch()..start();
    final future = AppLocalizations.delegate.load(locale);
    StartupProbe.detail(
      'AppLocalizations.load returned Future +${sw.elapsedMilliseconds}ms '
      '(lookupAppLocalizations is synchronous)',
    );
    return future.then((value) {
      StartupProbe.detail(
        'AppLocalizations.load Future complete +${sw.elapsedMilliseconds}ms '
        'type=${value.runtimeType}',
      );
      return value;
    });
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
