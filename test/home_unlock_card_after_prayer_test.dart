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

/// Mirrors Home's Unlock Apps card visibility / label driven by Focus select.
class _HomeUnlockCardProbe extends StatelessWidget {
  const _HomeUnlockCardProbe();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locked = context.select<FocusController, bool>((c) => c.isAppsLocked);
    final temp = context.select<FocusController, bool>(
      (c) => c.isTemporarilyUnlocked,
    );
    final showCard = locked || temp;
    if (!showCard) {
      return const SizedBox.shrink(key: Key('unlock_card_hidden'));
    }
    return Text(
      temp ? l10n.homeRelock : l10n.homeUnlock,
      key: const Key('unlock_card_label'),
    );
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
    'unlockAppsAfterPrayerMarked clears Unlock label immediately via Focus notify',
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

      expect(find.text('Unlock'), findsOneWidget);

      await FocusController.unlockAppsAfterPrayerMarked();
      await tester.pump();

      expect(focus.isAppsLocked, isFalse);
      expect(find.text('Unlock'), findsNothing);
      // Existing unlockFromHome UX: Relock card while temp-unlocked.
      expect(find.text('Relock'), findsOneWidget);
      expect(focus.isTemporarilyUnlocked, isTrue);

      // Cancel refresh timer before test binding checks pending timers.
      focus.dispose();
    },
  );

  testWidgets(
    'on-time mark (all Yes-I-prayed entry points) unlocks and drops Unlock label',
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
      expect(find.text('Unlock'), findsOneWidget);

      // Same central path used by reminder, lock-screen, AlarmKit/FSI, mark sheet.
      await homeVm.markPrayerStatus(now, tip, PrayerMarkStatus.onTime);
      await tester.pump();

      expect(homeVm.statusForToday(tip), PrayerMarkStatus.onTime);
      expect(focus.isAppsLocked, isFalse);
      expect(find.text('Unlock'), findsNothing);

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

      // Simulate leaving Home / process and opening again.
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
