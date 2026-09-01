import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/services/cycle_mode_policy.dart';
import 'package:flutter_test/flutter_test.dart';

CycleModeData coldStart(CycleModeData data) =>
    CycleModeData.fromJson(data.toJsonMap());

void main() {
  group('Calendar highlighting — CycleModePolicy', () {
    final aug1 = DateTime(2026, 8, 1);

    CycleModePolicy twoDayPolicy() => CycleModePolicy(
          CycleModeData(
            isEnabled: true,
            startDate: DateTime(2026, 8, 1),
            cycleLength: 2,
          ),
        );

    test('2-day window highlights Aug 1 and Aug 2 when today is Aug 1', () {
      final policy = twoDayPolicy();
      expect(policy.isHighlightable(DateTime(2026, 8, 1), now: aug1), isTrue);
      expect(policy.isHighlightable(DateTime(2026, 8, 2), now: aug1), isTrue);
      expect(policy.isHighlightable(DateTime(2026, 8, 3), now: aug1), isFalse);
    });

    test('today inside the window is highlightable (not only future days)', () {
      final policy = twoDayPolicy();
      expect(policy.isHighlightable(aug1, now: aug1), isTrue);
    });

    test('future start date does not highlight before the cycle begins', () {
      final policy = CycleModePolicy(
        CycleModeData(
          isEnabled: true,
          startDate: DateTime(2026, 8, 5),
          cycleLength: 2,
        ),
      );
      expect(
        policy.isHighlightable(DateTime(2026, 8, 5), now: aug1),
        isFalse,
      );
      expect(
        policy.isHighlightable(DateTime(2026, 8, 6), now: aug1),
        isFalse,
      );
    });

    test('updateActiveCycle length change keeps full active window', () {
      var data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 6,
      ).updateActiveCycle(
        startDate: DateTime(2026, 8, 1),
        cycleLength: 2,
        now: aug1,
      );
      final policy = CycleModePolicy(data);
      expect(data.plannedEndDate, DateTime(2026, 8, 2));
      expect(policy.isHighlightable(DateTime(2026, 8, 1), now: aug1), isTrue);
      expect(policy.isHighlightable(DateTime(2026, 8, 2), now: aug1), isTrue);
      expect(policy.isHighlightable(DateTime(2026, 8, 3), now: aug1), isFalse);
    });

    test('cold restart preserves calendar highlight rules', () {
      final data = coldStart(
        CycleModeData(
          isEnabled: true,
          startDate: DateTime(2026, 8, 1),
          cycleLength: 2,
        ),
      );
      final policy = CycleModePolicy(data);
      for (final day in [1, 2]) {
        expect(
          policy.isHighlightable(DateTime(2026, 8, day), now: aug1),
          isTrue,
          reason: 'Aug $day should stay pink after restart',
        );
      }
      expect(policy.isHighlightable(DateTime(2026, 8, 3), now: aug1), isFalse);
    });

    test('toggle OFF keeps sealed days pink; disable day stays normal', () {
      final disableDay = DateTime(2026, 8, 3);
      final policy = CycleModePolicy(
        twoDayPolicy().data.disableOn(disableDay),
      );
      expect(
        policy.isHighlightable(DateTime(2026, 8, 1), now: disableDay),
        isTrue,
      );
      expect(
        policy.isHighlightable(DateTime(2026, 8, 2), now: disableDay),
        isTrue,
      );
      expect(
        policy.isHighlightable(DateTime(2026, 8, 3), now: disableDay),
        isFalse,
      );
      expect(policy.isCycleMember(DateTime(2026, 8, 1)), isTrue);
    });

    test('future start: inactive before start, active during window, inactive after', () {
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 29),
        cycleLength: 2,
      );
      final policy = CycleModePolicy(data);
      final aug28 = DateTime(2026, 8, 28);
      final aug29 = DateTime(2026, 8, 29);
      final aug30 = DateTime(2026, 8, 30);
      final aug31 = DateTime(2026, 8, 31);

      expect(data.isRunningOn(aug28), isFalse);
      expect(data.isRunningOn(aug29), isTrue);
      expect(data.isRunningOn(aug30), isTrue);
      expect(data.isRunningOn(aug31), isFalse);

      expect(data.daysRemainingOn(aug28), 0);
      expect(data.daysRemainingOn(aug29), 2);
      expect(data.daysRemainingOn(aug30), 1);
      expect(data.daysRemainingOn(aug31), 0);

      expect(policy.isHighlightable(aug28, now: aug28), isFalse);
      expect(policy.isHighlightable(aug29, now: aug28), isFalse);
      expect(policy.isHighlightable(aug30, now: aug28), isFalse);

      expect(policy.isHighlightable(aug29, now: aug29), isTrue);
      expect(policy.isHighlightable(aug30, now: aug29), isTrue);
      expect(policy.isHighlightable(aug28, now: aug29), isFalse);

      expect(policy.isHighlightable(aug29, now: aug30), isTrue);
      expect(policy.isHighlightable(aug30, now: aug30), isTrue);

      // Period ended (toggle still ON, not yet sealed) — past window days stay pink.
      expect(policy.isHighlightable(aug29, now: aug31), isTrue);
      expect(policy.isHighlightable(aug30, now: aug31), isTrue);
      expect(policy.isHighlightable(aug31, now: aug31), isFalse);

      expect(policy.isTodayProtected(now: aug28), isFalse);
      expect(policy.isTodayProtected(now: aug29), isTrue);
      expect(policy.isTodayProtected(now: aug30), isTrue);
      expect(policy.isTodayProtected(now: aug31), isFalse);

      expect(policy.shouldPauseStreaks(aug28, now: aug28), isFalse);
      expect(policy.shouldPauseStreaks(aug29, now: aug28), isFalse);
      expect(policy.shouldPauseStreaks(aug29, now: aug29), isTrue);
      expect(policy.shouldPauseStreaks(aug30, now: aug30), isTrue);
      expect(policy.shouldPauseStreaks(aug29, now: aug31), isTrue);
      expect(policy.shouldPauseStreaks(aug31, now: aug31), isFalse);
    });

    test('ON Monday → OFF later → Monday stays pink everywhere', () {
      final monday = DateTime(2026, 8, 31); // Monday
      final tuesday = DateTime(2026, 9, 1);
      final data = CycleModeData(
        isEnabled: true,
        startDate: monday,
        cycleLength: 6,
      ).disableOn(tuesday);
      final policy = CycleModePolicy(data);

      expect(data.history, hasLength(1));
      expect(data.history.single.startDate, monday);
      expect(data.history.single.endDate, monday);
      expect(policy.isHighlightable(monday, now: tuesday), isTrue);
      expect(policy.isHighlightable(tuesday, now: tuesday), isFalse);
      expect(policy.isCycleMember(monday), isTrue);
    });
  });
}
