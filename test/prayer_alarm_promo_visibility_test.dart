import 'package:deenly/core/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('turning prayer alarms off clears the Home promo dismiss flag', () async {
    await StorageService.setHomeFullScreenAlarmPromoDismissed(true);
    await StorageService.setPrayerAlarmsEnabled(true);
    expect(await StorageService.homeFullScreenAlarmPromoDismissed, isTrue);
    expect(StorageService.prayerAlarmsEnabledListenable.value, isTrue);

    await StorageService.setPrayerAlarmsEnabled(false);
    expect(await StorageService.prayerAlarmsEnabled, isFalse);
    expect(await StorageService.homeFullScreenAlarmPromoDismissed, isFalse);
    expect(StorageService.prayerAlarmsEnabledListenable.value, isFalse);
  });

  test('prayer alarms listenable notifies on master toggle', () async {
    var notifications = 0;
    void listener() => notifications++;
    StorageService.prayerAlarmsEnabledListenable.addListener(listener);
    addTearDown(() {
      StorageService.prayerAlarmsEnabledListenable.removeListener(listener);
    });

    await StorageService.setPrayerAlarmsEnabled(true);
    await StorageService.setPrayerAlarmsEnabled(false);
    expect(notifications, greaterThanOrEqualTo(2));
  });
}
