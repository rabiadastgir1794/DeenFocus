import 'package:deenly/core/services/storage_service.dart';
import 'package:deenly/core/services/widget_sync_service.dart';
import 'package:deenly/features/focus/model/focus_models.dart';
import 'package:deenly/features/focus/viewmodel/focus_controller.dart';
import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/viewmodel/home_tab_view_model.dart';
import 'package:deenly/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Home no longer shows a dedicated Unlock/Relock banner; lock actions live on
/// the Focus Mode card.
class _HomeUnlockCardProbe extends StatelessWidget {
  const _HomeUnlockCardProbe();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(key: Key('unlock_card_hidden'));
  }
}

TrackablePrayer? _tipPrayer(DateTime now) {
  const hours = [5, 12, 15, 18, 20];
  final prayers = TrackablePrayer.values;
  TrackablePrayer? tip;
  for (var i = 0; i < prayers.length; i++) {
    if (now.hour >= hours[i]) tip = prayers[i];
  }
  return tip;
}

FocusSettings _nightLockedSettings(DateTime now) {
  return FocusSettings.defaults().copyWith(
    selectedApps: const <String, String>{'com.example.app': 'Example'},
    nightDisciplineEnabled: true,
    nightRange: FocusTimeRange(
      startHour: now.hour,
      startMinute: 0,
      endHour: (now.hour + 2) % 24,
      endMinute: 0,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    WidgetSyncService.debugDisableTimelineSync = true;
    FocusController.debugUnlockAppsAfterPrayerMarked = null;
    FocusController.debugSkipEnforcementSideEffects = true;
  });

  tearDown(() {
    FocusController.debugUnlockAppsAfterPrayerMarked = null;
    FocusController.debugSkipEnforcementSideEffects = false;
    WidgetSyncService.debugDisableTimelineSync = false;
  });

  testWidgets(
    'unlockAppsAfterPrayerMarked updates Focus without Home Relock banner',
    (tester) async {
      final now = DateTime.now();
      SharedPreferences.setMockInitialValues({
        'focus_settings_json': _nightLockedSettings(now).toJson(),
      });

      final focus = FocusController();
      await focus.initialize();
      expect(focus.isAppsLocked, isTrue);

      await tester.pumpWidget(
        ChangeNotifierProvider<FocusController>.value(
          value: focus,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(body: _HomeUnlockCardProbe()),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Unlock'), findsNothing);
      expect(find.text('Relock'), findsNothing);

      await FocusController.unlockAppsAfterPrayerMarked();
      await tester.pump();

      expect(focus.isAppsLocked, isFalse);
      expect(focus.isTemporarilyUnlocked, isTrue);
      expect(find.text('Unlock'), findsNothing);
      expect(find.text('Relock'), findsNothing);

      focus.dispose();
    },
  );

  testWidgets(
    'on-time mark (all Yes-I-prayed entry points) unlocks without Home banner',
    (tester) async {
      final now = DateTime.now();
      final tip = _tipPrayer(now);
      if (tip == null) return;

      SharedPreferences.setMockInitialValues({
        'focus_settings_json': _nightLockedSettings(now).toJson(),
      });

      final focus = FocusController();
      await focus.initialize();
      expect(focus.isAppsLocked, isTrue);

      final homeVm = HomeTabViewModel();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<FocusController>.value(value: focus),
            ChangeNotifierProvider<HomeTabViewModel>.value(value: homeVm),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(body: _HomeUnlockCardProbe()),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Unlock'), findsNothing);
      expect(find.text('Relock'), findsNothing);

      await homeVm.markPrayerStatus(now, tip, PrayerMarkStatus.onTime);
      await tester.pump();

      expect(homeVm.statusForToday(tip), PrayerMarkStatus.onTime);
      expect(focus.isAppsLocked, isFalse);
      expect(find.text('Unlock'), findsNothing);
      expect(find.text('Relock'), findsNothing);

      focus.dispose();
    },
  );

  test(
    'unlocked state persists so a fresh FocusController stays unlocked',
    () async {
      final now = DateTime.now();
      SharedPreferences.setMockInitialValues({
        'focus_settings_json': _nightLockedSettings(now).toJson(),
      });

      final first = FocusController();
      await first.initialize();
      expect(first.isAppsLocked, isTrue);

      await FocusController.unlockAppsAfterPrayerMarked();
      expect(first.isAppsLocked, isFalse);
      expect(first.isTemporarilyUnlocked, isTrue);

      final persisted = await StorageService.focusSettingsJson;
      expect(persisted, isNotNull);
      final saved = FocusSettings.fromJson(persisted!);
      expect(saved.temporarilyUnlockedUntil, isNotNull);
      expect(saved.temporarilyUnlockedUntil!.isAfter(now), isTrue);

      first.dispose();
      final second = FocusController();
      await second.initialize();
      expect(second.isAppsLocked, isFalse);
      expect(second.isTemporarilyUnlocked, isTrue);

      second.dispose();
    },
  );

  test('qada does not clear Unlock / locked state', () async {
    final now = DateTime.now();
    final tip = _tipPrayer(now);
    if (tip == null) return;

    SharedPreferences.setMockInitialValues({
      'focus_settings_json': _nightLockedSettings(now).toJson(),
    });

    final focus = FocusController();
    await focus.initialize();
    expect(focus.isAppsLocked, isTrue);

    final homeVm = HomeTabViewModel();
    await homeVm.markPrayerStatus(now, tip, PrayerMarkStatus.qada);
    expect(focus.isAppsLocked, isTrue);

    focus.dispose();
  });
}
