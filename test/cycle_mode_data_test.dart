import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/services/cycle_mode_policy.dart';
import 'package:deenly/features/home/services/prayer_analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';

CycleModePolicy policy(CycleModeData data) => CycleModePolicy(data);

void main() {
  Map<TrackablePrayer, PrayerMarkStatus> allFive() => {
        for (final p in TrackablePrayer.values) p: PrayerMarkStatus.onTime,
      };

  group('CycleModeData', () {
    test('defaults: length 6, pause and exclude enabled', () {
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 7, 31),
      );
      expect(data.cycleLength, 6);
      expect(data.pauseStreaks, isTrue);
      expect(data.excludeFromStatistics, isTrue);
    });

    test('containsDate uses calendar days and configurable length', () {
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 7, 28, 22, 15), // Tuesday evening
        cycleLength: 3,
      );
      // Tue / Wed / Thu
      expect(data.containsDate(DateTime(2026, 7, 28)), isTrue);
      expect(data.containsDate(DateTime(2026, 7, 29)), isTrue);
      expect(data.containsDate(DateTime(2026, 7, 30)), isTrue);
      expect(data.containsDate(DateTime(2026, 7, 27)), isFalse); // Mon
      expect(data.containsDate(DateTime(2026, 7, 31)), isFalse); // Fri
    });

    test('never-enabled disabled data has no cycle days', () {
      final data = CycleModeData(
        isEnabled: false,
        startDate: DateTime(2026, 7, 28),
        cycleLength: 6,
      );
      expect(data.containsDate(DateTime(2026, 7, 28)), isFalse);
    });

    test('manual early disable seals through day before disable', () {
      final active = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 5,
      );
      expect(active.containsDate(DateTime(2026, 8, 1)), isTrue);
      expect(active.containsDate(DateTime(2026, 8, 5)), isTrue);

      // Disable on 4 Aug → 1–3 historical, 4 Aug normal.
      final stopped = active.disableOn(DateTime(2026, 8, 4, 15, 0));
      expect(stopped.isEnabled, isFalse);
      expect(stopped.containsDate(DateTime(2026, 8, 1)), isTrue);
      expect(stopped.containsDate(DateTime(2026, 8, 2)), isTrue);
      expect(stopped.containsDate(DateTime(2026, 8, 3)), isTrue);
      expect(stopped.containsDate(DateTime(2026, 8, 4)), isFalse);
      expect(stopped.containsDate(DateTime(2026, 8, 5)), isFalse);
      expect(stopped.history, hasLength(1));
      expect(stopped.history.single.endDate, DateTime(2026, 8, 3));
    });

    test('expireFully seals the entire planned window', () {
      final active = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 5,
      );
      final expired = active.expireFully();
      expect(expired.isEnabled, isFalse);
      expect(expired.containsDate(DateTime(2026, 8, 1)), isTrue);
      expect(expired.containsDate(DateTime(2026, 8, 5)), isTrue);
      expect(expired.containsDate(DateTime(2026, 8, 6)), isFalse);
    });

    test('re-enable preserves prior sealed history', () {
      final prior = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 5,
      ).disableOn(DateTime(2026, 8, 4));

      final next = prior.copyWith(
        isEnabled: true,
        startDate: DateTime(2026, 9, 1),
        cycleLength: 6,
      );
      expect(next.containsDate(DateTime(2026, 8, 2)), isTrue);
      expect(next.containsDate(DateTime(2026, 8, 4)), isFalse);
      expect(next.containsDate(DateTime(2026, 9, 1)), isTrue);
    });

    test('shouldPauseStreaks / shouldExclude respect flags via policy', () {
      final day = DateTime(2026, 7, 28);
      final pausedOnly = CycleModeData(
        isEnabled: true,
        startDate: day,
        cycleLength: 3,
        pauseStreaks: true,
        excludeFromStatistics: false,
      );
      final pausedPolicy = policy(pausedOnly);
      expect(pausedPolicy.shouldPauseStreaks(day), isTrue);
      expect(pausedPolicy.shouldExcludeFromStatistics(day), isFalse);

      final statsOnly = pausedOnly.copyWith(
        pauseStreaks: false,
        excludeFromStatistics: true,
      );
      final statsPolicy = policy(statsOnly);
      expect(statsPolicy.shouldPauseStreaks(day), isFalse);
      expect(statsPolicy.shouldExcludeFromStatistics(day), isTrue);
    });

    test('daysRemainingOn and hasExpiredOn use cycle length', () {
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 7, 28),
        cycleLength: 3,
      );
      expect(data.daysRemainingOn(DateTime(2026, 7, 28)), 3);
      expect(data.daysRemainingOn(DateTime(2026, 7, 30)), 1);
      expect(data.hasExpiredOn(DateTime(2026, 7, 30)), isFalse);
      expect(data.hasExpiredOn(DateTime(2026, 7, 31)), isTrue);
    });

    test('json round-trip preserves settings and history', () {
      final original = CycleModeData(
        isEnabled: false,
        startDate: DateTime(2026, 7, 31),
        cycleLength: 8,
        pauseStreaks: false,
        excludeFromStatistics: true,
        history: [
          CycleModeInterval(
            startDate: DateTime(2026, 8, 1),
            endDate: DateTime(2026, 8, 3),
            pauseStreaks: true,
            excludeFromStatistics: true,
          ),
        ],
      );
      final restored = CycleModeData.fromJson(original.toJsonMap());
      expect(restored.isEnabled, isFalse);
      expect(restored.startDate, DateTime(2026, 7, 31));
      expect(restored.cycleLength, 8);
      expect(restored.pauseStreaks, isFalse);
      expect(restored.excludeFromStatistics, isTrue);
      expect(restored.history, hasLength(1));
      expect(restored.containsDate(DateTime(2026, 8, 3)), isTrue);
      expect(restored.containsDate(DateTime(2026, 8, 4)), isFalse);
    });

    test('cycle length is clamped', () {
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 7, 31),
        cycleLength: 99,
      ).copyWith(cycleLength: 0);
      expect(data.cycleLength, CycleModeData.minCycleLength);
    });
  });

  group('Separate cycles — disable then enable with gap', () {
    test('1–3 Aug historical, 4–9 normal, 10 Aug new cycle', () {
      final now = DateTime(2026, 8, 10, 12, 0);

      // Active 1–3 Aug (length 6), disable on 4 Aug.
      final stopped = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 6,
      ).disableOn(DateTime(2026, 8, 4));

      expect(stopped.isEnabled, isFalse);
      expect(stopped.history, hasLength(1));
      expect(
        stopped.history.single,
        CycleModeInterval(
          startDate: DateTime(2026, 8, 1),
          endDate: DateTime(2026, 8, 3),
        ),
      );
      expect(stopped.containsDate(DateTime(2026, 8, 4)), isFalse);

      // Enable again on 10 Aug — previous cycle stays a separate history row.
      final next = stopped.enableWith(
        startDate: DateTime(2026, 8, 10),
        cycleLength: 6,
      );
      expect(next.isEnabled, isTrue);
      expect(next.history, hasLength(1));
      expect(next.history.single.endDate, DateTime(2026, 8, 3));
      expect(next.activeInterval?.startDate, DateTime(2026, 8, 10));

      // Membership
      expect(next.containsDate(DateTime(2026, 8, 1)), isTrue);
      expect(next.containsDate(DateTime(2026, 8, 3)), isTrue);
      expect(next.activeInterval!.containsDate(DateTime(2026, 8, 10)), isTrue);
      expect(next.containsDate(DateTime(2026, 8, 4)), isFalse);
      expect(next.containsDate(DateTime(2026, 8, 9)), isFalse);

      // Highlight while new cycle is ON: historical + new (not the gap).
      expect(
        policy(next).isHighlightable(DateTime(2026, 8, 1), now: now),
        isTrue,
      );
      expect(
        policy(next).isHighlightable(DateTime(2026, 8, 3), now: now),
        isTrue,
      );
      expect(
        policy(next).isHighlightable(DateTime(2026, 8, 4), now: now),
        isFalse,
      );
      expect(
        policy(next).isHighlightable(DateTime(2026, 8, 9), now: now),
        isFalse,
      );
      expect(
        policy(next).isHighlightable(DateTime(2026, 8, 10), now: now),
        isTrue,
      );

      // Disabling the new cycle must not merge into the first.
      final stoppedAgain = next.disableOn(DateTime(2026, 8, 12));
      expect(stoppedAgain.history, hasLength(2));
      expect(stoppedAgain.history[0].endDate, DateTime(2026, 8, 3));
      expect(stoppedAgain.history[1].startDate, DateTime(2026, 8, 10));
      expect(stoppedAgain.history[1].endDate, DateTime(2026, 8, 11));
      expect(stoppedAgain.containsDate(DateTime(2026, 8, 4)), isFalse);
      expect(stoppedAgain.containsDate(DateTime(2026, 8, 9)), isFalse);
    });

    test('adjacent cycles from separate sessions stay separate', () {
      // End first cycle on 3 Aug, start next on 4 Aug — do not glue them.
      final first = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 5,
      ).disableOn(DateTime(2026, 8, 4)); // seals 1–3
      final second = first
          .enableWith(startDate: DateTime(2026, 8, 4), cycleLength: 3)
          .disableOn(DateTime(2026, 8, 6)); // seals 4–5
      expect(second.history, hasLength(2));
      expect(second.history[0].endDate, DateTime(2026, 8, 3));
      expect(second.history[1].startDate, DateTime(2026, 8, 4));
      expect(second.history[1].endDate, DateTime(2026, 8, 5));
    });
  });

  group('Case 1 — disable then enable (no duplicate history)', () {
    test('repeated disable is idempotent', () {
      final active = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 5,
      );
      final once = active.disableOn(DateTime(2026, 8, 4));
      final twice = once.disableOn(DateTime(2026, 8, 4));
      expect(twice.history, hasLength(1));
      expect(twice.history, once.history);
      expect(
        twice.history.single,
        CycleModeInterval(
          startDate: DateTime(2026, 8, 1),
          endDate: DateTime(2026, 8, 3),
        ),
      );
    });

    test('re-enable overlapping then disable merges overlap only', () {
      final first = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 5,
      ).disableOn(DateTime(2026, 8, 4)); // seals 1–3
      expect(first.history, hasLength(1));

      // Re-enable on 3 Aug (overlaps last sealed day).
      final reenabled = first.enableWith(
        startDate: DateTime(2026, 8, 3),
        cycleLength: 5,
      );
      expect(reenabled.isEnabled, isTrue);
      expect(reenabled.history, hasLength(1));

      // Disable on 6 Aug → seals 3–5; overlaps history on 3 Aug → one interval.
      final second = reenabled.disableOn(DateTime(2026, 8, 6));
      expect(second.history, hasLength(1));
      expect(
        second.history.single,
        CycleModeInterval(
          startDate: DateTime(2026, 8, 1),
          endDate: DateTime(2026, 8, 5),
        ),
      );
    });

    test('mergeHistories drops exact duplicates', () {
      final interval = CycleModeInterval(
        startDate: DateTime(2026, 8, 1),
        endDate: DateTime(2026, 8, 3),
      );
      final merged = CycleModeData.mergeHistories(
        [interval],
        [interval, interval],
      );
      expect(merged, [interval]);
    });

    test('gap between cycles is preserved (not merged across normal days)', () {
      final first = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 5,
      ).disableOn(DateTime(2026, 8, 4)); // seals 1–3
      // Re-enable on 5 Aug — 4 Aug was a normal day.
      final second = first
          .enableWith(startDate: DateTime(2026, 8, 5), cycleLength: 3)
          .disableOn(DateTime(2026, 8, 7)); // seals 5–6
      expect(second.history, hasLength(2));
      expect(second.containsDate(DateTime(2026, 8, 4)), isFalse);
      expect(second.containsDate(DateTime(2026, 8, 5)), isTrue);
    });
  });

  group('Three states — draft / active / historical', () {
    final now = DateTime(2026, 8, 1, 12, 0);
    final statusHistory = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
      for (var d = 1; d <= 20; d++)
        PrayerAnalyticsService.dayKey(DateTime(2026, 8, d)): allFive(),
      PrayerAnalyticsService.dayKey(DateTime(2026, 7, 31)): allFive(),
    };

    test('Draft: configured but OFF — no pink, no analytics impact', () {
      final draft = CycleModeData.disabled().saveDraft(
        startDate: DateTime(2026, 8, 12),
        cycleLength: 6,
      );
      expect(draft.phase, CycleModePhase.draft);
      expect(draft.isEnabled, isFalse);
      expect(draft.activeInterval, isNull);
      expect(draft.containsDate(DateTime(2026, 8, 12)), isFalse);
      expect(draft.containsDate(DateTime(2026, 8, 1)), isFalse);
      expect(
        policy(draft).isHighlightable(DateTime(2026, 8, 12), now: now),
        isFalse,
      );
      final draftPolicy = policy(draft);
      expect(draftPolicy.shouldPauseStreaks(DateTime(2026, 8, 12)), isFalse);
      expect(
        draftPolicy.shouldExcludeFromStatistics(DateTime(2026, 8, 12)),
        isFalse,
      );

      final snap = PrayerAnalyticsService.calculate(
        now: now,
        statusHistory: statusHistory,
        isPausedStreakDay: draftPolicy.shouldPauseStreaks,
        isExcludedStatsDay: draftPolicy.shouldExcludeFromStatistics,
      );
      final baseline = PrayerAnalyticsService.calculate(
        now: now,
        statusHistory: statusHistory,
        isPausedStreakDay: (_) => false,
        isExcludedStatsDay: (_) => false,
      );
      expect(snap.prayerStreak, baseline.prayerStreak);
      expect(snap.dayStreak, baseline.dayStreak);
      expect(snap.weeklyCompleted, baseline.weeklyCompleted);
      expect(snap.weeklyPossible, baseline.weeklyPossible);
      expect(snap.prayerRatePercent, baseline.prayerRatePercent);
      expect(snap.homeWeekDayCounts, baseline.homeWeekDayCounts);
    });

    test('Active: toggle ON — full window highlighted once cycle starts', () {
      final active = CycleModeData.disabled()
          .saveDraft(startDate: DateTime(2026, 8, 1), cycleLength: 6)
          .enableWith(
            startDate: DateTime(2026, 8, 1),
            cycleLength: 6,
          );
      expect(active.phase, CycleModePhase.active);
      expect(active.isEnabled, isTrue);
      expect(active.activeInterval, isNotNull);
      expect(active.containsDate(DateTime(2026, 8, 1)), isTrue);
      expect(active.containsDate(DateTime(2026, 8, 6)), isTrue);
      for (var d = 1; d <= 6; d++) {
        expect(
          policy(active).isHighlightable(
            DateTime(2026, 8, d),
            now: now,
          ),
          isTrue,
          reason: 'Aug $d should be pink in the active window',
        );
      }
      expect(
        policy(active).isHighlightable(DateTime(2026, 8, 7), now: now),
        isFalse,
      );
      final activePolicy = policy(active);
      expect(activePolicy.shouldPauseStreaks(DateTime(2026, 8, 1)), isTrue);
      expect(activePolicy.shouldExcludeFromStatistics(DateTime(2026, 8, 1)), isTrue);
    });

    test('Historical: sealed for analytics; toggle OFF → pink UI stays', () {
      final historical = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 12),
        cycleLength: 6,
      ).expireFully();
      expect(historical.phase, CycleModePhase.historical);
      expect(historical.isEnabled, isFalse);
      expect(historical.activeInterval, isNull);
      expect(historical.history, hasLength(1));
      expect(historical.history.single.startDate, DateTime(2026, 8, 12));
      expect(historical.history.single.endDate, DateTime(2026, 8, 17));
      // Analytics still see sealed days.
      expect(historical.containsDate(DateTime(2026, 8, 15)), isTrue);
      expect(historical.containsDate(DateTime(2026, 8, 18)), isFalse);
      // UI pink uses sealed history even while toggle is OFF.
      expect(
        policy(historical).isHighlightable(
          DateTime(2026, 8, 15),
          now: DateTime(2026, 8, 20),
        ),
        isTrue,
      );
    });

    test('Draft after history: Saturday sealed historically is not pink', () {
      // Accidental enable on 1 Aug, then disable + draft for 12 Aug.
      // Same-day disable seals nothing; leftover single-day seals are purged.
      final after = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 6,
      ).disableOn(DateTime(2026, 8, 1)).saveDraft(
            startDate: DateTime(2026, 8, 12),
            cycleLength: 6,
          );
      expect(after.isEnabled, isFalse);
      expect(after.containsDate(DateTime(2026, 8, 1)), isFalse);
      expect(after.containsDate(DateTime(2026, 8, 12)), isFalse); // draft
      expect(
        policy(after).isHighlightable(DateTime(2026, 8, 1), now: now),
        isFalse,
      );

      // Legacy same-day seal residue (if any) is still purged on load.
      final polluted = after.copyWith(
        history: [
          CycleModeInterval(
            startDate: DateTime(2026, 8, 1),
            endDate: DateTime(2026, 8, 1),
            pauseStreaks: true,
            excludeFromStatistics: true,
          ),
        ],
      );
      final purged = polluted.purgeLegacyEditBugHistory(now: now);
      expect(purged.history, isEmpty);
      expect(purged.containsDate(DateTime(2026, 8, 1)), isFalse);
    });

    test('same-day disableOn seals no history', () {
      final stopped = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 11),
        cycleLength: 6,
        pauseStreaks: true,
        excludeFromStatistics: true,
      ).disableOn(DateTime(2026, 8, 11, 15));
      expect(stopped.isEnabled, isFalse);
      expect(stopped.history, isEmpty);
      expect(
        CycleModePolicy(stopped).shouldExcludeFromStatistics(
          DateTime(2026, 8, 11),
        ),
        isFalse,
      );
    });

    test('purge drops same-day toggle artifact equal to today', () {
      final today = DateTime(2026, 8, 11);
      final polluted = CycleModeData(
        isEnabled: false,
        startDate: today,
        cycleLength: 6,
        history: [
          CycleModeInterval(
            startDate: today,
            endDate: today,
            pauseStreaks: true,
            excludeFromStatistics: true,
          ),
        ],
      );
      final purged = polluted.purgeLegacyEditBugHistory(now: today);
      expect(purged.history, isEmpty);
      expect(
        CycleModePolicy(purged).shouldExcludeFromStatistics(today),
        isFalse,
      );
    });

    test('enableWith after draft activates the saved window', () {
      final draft = CycleModeData.disabled().saveDraft(
        startDate: DateTime(2026, 8, 1),
        cycleLength: 5,
      );
      final enabled = draft.enableWith(
        startDate: draft.startDate,
        cycleLength: draft.cycleLength,
      );
      expect(enabled.phase, CycleModePhase.active);
      expect(enabled.containsDate(DateTime(2026, 8, 1)), isTrue);
      expect(enabled.containsDate(DateTime(2026, 8, 5)), isTrue);
      expect(enabled.containsDate(DateTime(2026, 8, 6)), isFalse);
    });
  });

  group('Legacy Edit-bug history purge', () {
    final now = DateTime(2026, 8, 1, 12, 0);

    test('drops spurious single-day and future-only seals', () {
      final polluted = CycleModeData(
        isEnabled: false,
        startDate: DateTime(2026, 8, 12),
        cycleLength: 6,
        history: [
          CycleModeInterval(
            startDate: DateTime(2026, 8, 1),
            endDate: DateTime(2026, 8, 1),
          ),
          CycleModeInterval(
            startDate: DateTime(2026, 8, 12),
            endDate: DateTime(2026, 8, 17),
          ),
        ],
      );
      final purged = polluted.purgeLegacyEditBugHistory(now: now);
      expect(purged.history, isEmpty);
    });

    test('keeps legitimate multi-day sealed history', () {
      final data = CycleModeData(
        isEnabled: false,
        startDate: DateTime(2026, 9, 1),
        cycleLength: 6,
        history: [
          CycleModeInterval(
            startDate: DateTime(2026, 7, 20),
            endDate: DateTime(2026, 7, 25),
          ),
        ],
      );
      final purged = data.purgeLegacyEditBugHistory(now: now);
      expect(purged.history, hasLength(1));
      expect(purged.history.single.endDate, DateTime(2026, 7, 25));
    });
  });

  group('Cycle day UI highlighting', () {
    test('highlights every day in the active window once started', () {
      final active = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1), // Saturday
        cycleLength: 6,
      );
      expect(
        policy(active).isHighlightable(
          DateTime(2026, 7, 31),
          now: DateTime(2026, 8, 1),
        ),
        isFalse,
      );
      for (var d = 1; d <= 6; d++) {
        expect(
          policy(active).isHighlightable(
            DateTime(2026, 8, d),
            now: DateTime(2026, 8, 1),
          ),
          isTrue,
        );
      }
      expect(
        policy(active).isHighlightable(
          DateTime(2026, 8, 7),
          now: DateTime(2026, 8, 1),
        ),
        isFalse,
      );
    });

    test('future start date does not highlight current week days', () {
      final active = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 12),
        cycleLength: 6,
      );
      expect(
        policy(active).isHighlightable(
          DateTime(2026, 8, 1),
          now: DateTime(2026, 8, 1),
        ),
        isFalse,
      );
      expect(
        active.containsDate(DateTime(2026, 8, 12)),
        isTrue,
      );
    });

    test('historical sealed days stay pink while toggle is OFF', () {
      final stopped = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 5,
      ).disableOn(DateTime(2026, 8, 4));
      expect(stopped.containsDate(DateTime(2026, 8, 2)), isTrue);
      expect(
        policy(stopped).isHighlightable(
          DateTime(2026, 8, 2),
          now: DateTime(2026, 8, 10),
        ),
        isTrue,
      );
    });

    test('historical days are pink again while a new cycle is ON', () {
      final next = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 5,
      )
          .disableOn(DateTime(2026, 8, 4))
          .enableWith(startDate: DateTime(2026, 8, 10), cycleLength: 6);
      expect(
        policy(next).isHighlightable(
          DateTime(2026, 8, 2),
          now: DateTime(2026, 8, 10),
        ),
        isTrue,
      );
      expect(policy(next).isCycleMember(DateTime(2026, 8, 2)), isTrue);
      expect(next.activeInterval!.containsDate(DateTime(2026, 8, 2)), isFalse);
    });
  });

  group('Active cycle length changes extend the same window', () {
    test('6 → 8 days keeps start date and extends end', () {
      final active = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 6,
      );
      expect(active.plannedEndDate, DateTime(2026, 8, 6));
      expect(active.containsDate(DateTime(2026, 8, 3)), isTrue);
      expect(active.containsDate(DateTime(2026, 8, 8)), isFalse);

      final extended = active.updateActiveCycle(
        cycleLength: 8,
        now: DateTime(2026, 8, 3),
      );
      expect(extended.isEnabled, isTrue);
      expect(extended.startDate, DateTime(2026, 8, 1));
      expect(extended.cycleLength, 8);
      expect(extended.plannedEndDate, DateTime(2026, 8, 8));
      expect(extended.history, isEmpty); // did not seal / start a new cycle
      expect(extended.containsDate(DateTime(2026, 8, 3)), isTrue);
      expect(extended.containsDate(DateTime(2026, 8, 8)), isTrue);
      expect(extended.daysRemainingOn(DateTime(2026, 8, 3)), 6); // 8 - 2
    });

    test('shortening cannot exclude today from the active window', () {
      final active = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 6,
      );
      // On 3 Aug, shrinking to 2 would end on 2 Aug — clamp through today.
      final shortened = active.updateActiveCycle(
        cycleLength: 2,
        now: DateTime(2026, 8, 3),
      );
      expect(shortened.startDate, DateTime(2026, 8, 1));
      expect(shortened.cycleLength, 3); // elapsed(2) + 1
      expect(shortened.containsDate(DateTime(2026, 8, 3)), isTrue);
      expect(shortened.plannedEndDate, DateTime(2026, 8, 3));
    });
  });

  group('Case 2 — automatic expiry after selected length', () {
    test('expires after N days and seals full window once', () {
      final active = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 5,
      );
      expect(active.hasExpiredOn(DateTime(2026, 8, 5)), isFalse);
      expect(active.hasExpiredOn(DateTime(2026, 8, 6)), isTrue);

      final expired = active.expireFully();
      expect(expired.isEnabled, isFalse);
      expect(expired.history, hasLength(1));
      expect(
        expired.history.single,
        CycleModeInterval(
          startDate: DateTime(2026, 8, 1),
          endDate: DateTime(2026, 8, 5),
        ),
      );

      // Running expiry again must not duplicate.
      expect(expired.expireFully().history, expired.history);
      expect(expired.disableOn(DateTime(2026, 8, 10)).history, expired.history);
    });
  });

  group('Case 3 — restart restores sealed + active state', () {
    test('json round-trip keeps active cycle membership', () {
      final active = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 5,
        history: [
          CycleModeInterval(
            startDate: DateTime(2026, 7, 1),
            endDate: DateTime(2026, 7, 3),
          ),
        ],
      );
      final restored = CycleModeData.fromJson(active.toJsonMap());
      expect(restored.isEnabled, isTrue);
      expect(restored.containsDate(DateTime(2026, 8, 3)), isTrue);
      expect(restored.containsDate(DateTime(2026, 7, 2)), isTrue);
      expect(restored.history, hasLength(1));
    });

    test('json round-trip after early disable restores sealed days only', () {
      final stopped = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 5,
      ).disableOn(DateTime(2026, 8, 4));
      final restored = CycleModeData.fromJson(stopped.toJsonMap());
      expect(restored.isEnabled, isFalse);
      expect(restored.containsDate(DateTime(2026, 8, 1)), isTrue);
      expect(restored.containsDate(DateTime(2026, 8, 3)), isTrue);
      expect(restored.containsDate(DateTime(2026, 8, 4)), isFalse);
    });

    test('fromJson merges overlapping history but keeps adjacent separate', () {
      final restored = CycleModeData.fromJson({
        'isEnabled': false,
        'startDateMs': DateTime(2026, 8, 1).millisecondsSinceEpoch,
        'cycleLength': 5,
        'pauseStreaks': true,
        'excludeFromStatistics': true,
        'history': [
          CycleModeInterval(
            startDate: DateTime(2026, 8, 1),
            endDate: DateTime(2026, 8, 3),
          ).toJsonMap(),
          CycleModeInterval(
            startDate: DateTime(2026, 8, 3),
            endDate: DateTime(2026, 8, 4),
          ).toJsonMap(),
          CycleModeInterval(
            startDate: DateTime(2026, 8, 6),
            endDate: DateTime(2026, 8, 7),
          ).toJsonMap(),
        ],
      });
      // Aug 1–3 and Aug 3–4 overlap → one; Aug 6–7 stays separate.
      expect(restored.history, hasLength(2));
      expect(
        restored.history[0],
        CycleModeInterval(
          startDate: DateTime(2026, 8, 1),
          endDate: DateTime(2026, 8, 4),
        ),
      );
      expect(
        restored.history[1],
        CycleModeInterval(
          startDate: DateTime(2026, 8, 6),
          endDate: DateTime(2026, 8, 7),
        ),
      );
    });
  });

  group('Early disable — analytics sync', () {
    test('streak bridges sealed days; post-disable days are normal', () {
      // Aug 1–2 during cycle, disable Aug 4 (seals 1–3), Aug 4 miss breaks.
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        PrayerAnalyticsService.dayKey(DateTime(2026, 7, 31)): allFive(),
        PrayerAnalyticsService.dayKey(DateTime(2026, 8, 1)): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
        PrayerAnalyticsService.dayKey(DateTime(2026, 8, 2)): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
        PrayerAnalyticsService.dayKey(DateTime(2026, 8, 3)): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
        PrayerAnalyticsService.dayKey(DateTime(2026, 8, 4)): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
      };

      final cycle = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 5,
      ).disableOn(DateTime(2026, 8, 4));

      final cyclePolicy = policy(cycle);

      // On Aug 3 (still sealed): cycle days skipped → Jul 31 streak holds.
      expect(
        PrayerStreakCalculator.calculate(
          now: DateTime(2026, 8, 3, 23, 0),
          statusHistory: history,
          isCycleDay: cyclePolicy.shouldPauseStreaks,
        ),
        5,
      );

      // On Aug 4: not a cycle day → miss breaks streak to 0.
      expect(
        PrayerStreakCalculator.calculate(
          now: DateTime(2026, 8, 4, 23, 0),
          statusHistory: history,
          isCycleDay: cyclePolicy.shouldPauseStreaks,
        ),
        0,
      );

      // Weekly possible excludes only sealed Aug 1–3, not Aug 4–5.
      final weekStart = DateTime(2026, 7, 31); // Friday week
      final weekDates = WeeklyCalculator.insightsWeekDates(
        DateTime(2026, 8, 4, 12, 0),
      );
      expect(weekDates.first, weekStart);
      final weekly = WeeklyCalculator.calculate(
        now: DateTime(2026, 8, 4, 12, 0),
        statusHistory: {
          for (final d in weekDates)
            PrayerAnalyticsService.dayKey(d): allFive(),
        },
        isCycleDay: cyclePolicy.shouldExcludeFromStatistics,
      );
      // Fri Jul 31 + Sat–Thu Aug 1–6, but Aug 1–3 excluded → 4 days × 5 = 20.
      expect(weekly.possible, 20);
    });

    test('snapshot after early disable uses sealed policy callbacks', () {
      final cycle = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 5,
      ).disableOn(DateTime(2026, 8, 4));

      final now = DateTime(2026, 8, 4, 20, 0);
      final statusHistory = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        PrayerAnalyticsService.dayKey(DateTime(2026, 8, 4)): allFive(),
        PrayerAnalyticsService.dayKey(DateTime(2026, 8, 3)): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
        PrayerAnalyticsService.dayKey(DateTime(2026, 8, 2)): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
        PrayerAnalyticsService.dayKey(DateTime(2026, 8, 1)): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
        PrayerAnalyticsService.dayKey(DateTime(2026, 7, 31)): allFive(),
      };

      final cyclePolicy = policy(cycle);
      final snap = PrayerAnalyticsService.calculate(
        now: now,
        statusHistory: statusHistory,
        isPausedStreakDay: cyclePolicy.shouldPauseStreaks,
        isExcludedStatsDay: cyclePolicy.shouldExcludeFromStatistics,
      );
      // Aug 4 full (5) + sealed Aug 1–3 skipped + Jul 31 full (5) = 10.
      expect(snap.prayerStreak, 10);
      expect(snap.dayStreak, 2);
      expect(cycle.containsDate(DateTime(2026, 8, 4)), isFalse);
      expect(cycle.isEnabled, isFalse);
    });

    test('disable→enable→expire keeps cycles separate across a gap', () {
      var cycle = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 5,
      ).disableOn(DateTime(2026, 8, 4)); // seals 1–3
      cycle = cycle.enableWith(
        startDate: DateTime(2026, 8, 10),
        cycleLength: 5,
      );
      cycle = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 10),
        cycleLength: 5,
        history: cycle.history,
      ).expireFully();

      expect(cycle.history, hasLength(2));
      expect(cycle.isEnabled, isFalse);
      expect(cycle.containsDate(DateTime(2026, 8, 1)), isTrue);
      expect(cycle.containsDate(DateTime(2026, 8, 3)), isTrue);
      expect(cycle.containsDate(DateTime(2026, 8, 4)), isFalse);
      expect(cycle.containsDate(DateTime(2026, 8, 9)), isFalse);
      expect(cycle.containsDate(DateTime(2026, 8, 10)), isTrue);
      expect(cycle.containsDate(DateTime(2026, 8, 14)), isTrue);
      expect(cycle.containsDate(DateTime(2026, 8, 15)), isFalse);

      // Gap days 4–9 are normal misses so they don't inflate the streak;
      // sealed windows are skipped; only Aug 15 contributes.
      final statusHistory = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        for (var d = 1; d <= 14; d++)
          PrayerAnalyticsService.dayKey(DateTime(2026, 8, d)): {
            TrackablePrayer.fajr: PrayerMarkStatus.missed,
          },
        PrayerAnalyticsService.dayKey(DateTime(2026, 8, 15)): allFive(),
      };

      final cyclePolicy = policy(cycle);

      final now = DateTime(2026, 8, 15, 23, 0);
      final snap = PrayerAnalyticsService.calculate(
        now: now,
        statusHistory: statusHistory,
        isPausedStreakDay: cyclePolicy.shouldPauseStreaks,
        isExcludedStatsDay: cyclePolicy.shouldExcludeFromStatistics,
      );
      final achievements = AchievementCalculator.calculate(
        now: now,
        statusHistory: statusHistory,
        isPausedStreakDay: cyclePolicy.shouldPauseStreaks,
      );

      // Only Aug 15 counts after the second sealed window (gap misses break).
      expect(snap.prayerStreak, 5);
      expect(snap.dayStreak, 1);
      expect(snap.prayerStreak, achievements.prayerStreak);
      expect(snap.dayStreak, achievements.dayStreak);
      expect(snap.canRestoreStreak, isFalse);
    });
  });
}
