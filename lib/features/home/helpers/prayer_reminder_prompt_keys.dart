import 'package:intl/intl.dart';

import '../model/home_models.dart';

/// Stable storage keys for the soft "Did you pray?" reminder prompt.
abstract final class PrayerReminderPromptKeys {
  static String forPrayer(TrackablePrayer prayer, {String? dayKey}) {
    final key = dayKey ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
    return 'v2:$key:${prayer.name}';
  }
}
