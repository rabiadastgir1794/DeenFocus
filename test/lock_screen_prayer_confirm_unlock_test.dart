import 'package:deenly/core/services/widget_sync_service.dart';
import 'package:deenly/features/focus/viewmodel/focus_controller.dart';
import 'package:deenly/features/home/helpers/lock_screen_prayer_actions.dart';
import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/viewmodel/home_tab_view_model.dart';
import 'package:deenly/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tip prayer for analytics fallback hours when no schedule is loaded.
TrackablePrayer? _tipPrayer(DateTime now) {
  const hours = [5, 12, 15, 18, 20];
  final prayers = TrackablePrayer.values;
  TrackablePrayer? tip;
  for (var i = 0; i < prayers.length; i++) {
    if (now.hour >= hours[i]) tip = prayers[i];
  }
  return tip;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    WidgetSyncService.debugDisableTimelineSync = true;
    FocusController.debugUnlockAppsAfterPrayerMarked = () async {};
  });

  tearDown(() {
    FocusController.debugUnlockAppsAfterPrayerMarked = null;
    WidgetSyncService.debugDisableTimelineSync = false;
  });

  testWidgets(
    'LockScreenPrayerActions.confirmOnTime marks on-time and unlocks apps',
    (tester) async {
      final now = DateTime.now();
      final tip = _tipPrayer(now);
      if (tip == null) return;

      var unlockCalls = 0;
      FocusController.debugUnlockAppsAfterPrayerMarked = () async {
        unlockCalls++;
      };

      final vm = HomeTabViewModel();
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChangeNotifierProvider<HomeTabViewModel>.value(
            value: vm,
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: TextButton(
                    onPressed: () => LockScreenPrayerActions.confirmOnTime(
                      context,
                      prayer: tip,
                    ),
                    child: const Text('confirm'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('confirm'));
      await tester.pumpAndSettle();

      expect(vm.statusForToday(tip), PrayerMarkStatus.onTime);
      expect(unlockCalls, 1);
    },
  );

  testWidgets(
    'confirmOnTime is a no-op when prayer already marked (still pops)',
    (tester) async {
      final now = DateTime.now();
      final tip = _tipPrayer(now);
      if (tip == null) return;

      var unlockCalls = 0;
      FocusController.debugUnlockAppsAfterPrayerMarked = () async {
        unlockCalls++;
      };

      final vm = HomeTabViewModel();
      await vm.markPrayerStatus(now, tip, PrayerMarkStatus.onTime);
      unlockCalls = 0;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChangeNotifierProvider<HomeTabViewModel>.value(
            value: vm,
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: TextButton(
                    onPressed: () => showDialog<bool>(
                      context: context,
                      builder: (dialogContext) {
                        return ChangeNotifierProvider<HomeTabViewModel>.value(
                          value: vm,
                          child: AlertDialog(
                            content: TextButton(
                              onPressed: () =>
                                  LockScreenPrayerActions.confirmOnTime(
                                dialogContext,
                                prayer: tip,
                              ),
                              child: const Text('confirm'),
                            ),
                          ),
                        );
                      },
                    ),
                    child: const Text('open'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('confirm'));
      await tester.pumpAndSettle();

      expect(find.text('confirm'), findsNothing);
      expect(unlockCalls, 0);
    },
  );
}
