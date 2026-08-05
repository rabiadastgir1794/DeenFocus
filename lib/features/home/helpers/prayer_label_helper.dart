import '../../../l10n/app_localizations.dart';
import '../model/home_models.dart';

/// Localized display name for a trackable prayer. Kept separate from
/// home_models.dart so the model layer stays free of Flutter/l10n imports.
extension TrackablePrayerLabel on TrackablePrayer {
  String label(AppLocalizations l10n) {
    switch (this) {
      case TrackablePrayer.fajr:
        return l10n.homePrayerFajr;
      case TrackablePrayer.dhuhr:
        return l10n.homePrayerDhuhr;
      case TrackablePrayer.asr:
        return l10n.homePrayerAsr;
      case TrackablePrayer.maghrib:
        return l10n.homePrayerMaghrib;
      case TrackablePrayer.isha:
        return l10n.homePrayerIsha;
    }
  }
}
