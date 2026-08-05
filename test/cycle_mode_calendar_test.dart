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

    test('toggle OFF removes all pink including active window', () {
      final policy = CycleModePolicy(
        twoDayPolicy().data.disableOn(DateTime(2026, 8, 3)),
      );
      expect(policy.isHighlightable(DateTime(2026, 8, 1), now: aug1), isFalse);
      expect(policy.isHighlightable(DateTime(2026, 8, 2), now: aug1), isFalse);
      expect(policy.isCycleMember(DateTime(2026, 8, 1)), isTrue);
    });
  });
}
