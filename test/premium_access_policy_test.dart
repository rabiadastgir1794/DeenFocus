import 'package:deenly/core/superwall/premium_access_policy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

/// Simulates the Superwall callbacks that previously unlocked on dismiss.
class _PaywallSession {
  _PaywallSession({required this.subscriptionActive});

  bool subscriptionActive;
  var unlocked = false;
  final decisions = <PremiumAccessDecision>[];

  void _apply(PremiumAccessDecision decision) {
    decisions.add(decision);
    if (decision.grantAccess) unlocked = true;
  }

  /// What Superwall does when feature() fires (holdout / skip / after purchase).
  void onFeatureCallback() {
    _apply(
      PremiumAccessPolicy.decide(
        event: PremiumGateEvent.featureCallback,
        subscriptionActive: subscriptionActive,
      ),
    );
  }

  void onDismiss(PaywallResult result, {bool trustPurchaseAfterLag = false}) {
    final kind = PremiumAccessPolicy.dismissKindFromResultType(result.runtimeType);
    if (kind == PaywallDismissKind.purchased ||
        kind == PaywallDismissKind.restored) {
      // Mimic sync retries: first without trust, then with trust if still inactive.
      var decision = PremiumAccessPolicy.decide(
        event: PremiumGateEvent.paywallDismissed,
        subscriptionActive: subscriptionActive,
        dismissKind: kind,
        trustConfirmedPurchaseAfterSyncLag: false,
      );
      if (!decision.grantAccess && trustPurchaseAfterLag) {
        decision = PremiumAccessPolicy.decide(
          event: PremiumGateEvent.paywallDismissed,
          subscriptionActive: subscriptionActive,
          dismissKind: kind,
          trustConfirmedPurchaseAfterSyncLag: true,
        );
        if (decision.grantAccess) {
          subscriptionActive = true;
        }
      }
      _apply(decision);
      return;
    }
    _apply(
      PremiumAccessPolicy.decide(
        event: PremiumGateEvent.paywallDismissed,
        subscriptionActive: subscriptionActive,
        dismissKind: kind,
      ),
    );
  }
}

void main() {
  group('PremiumAccessPolicy — close without purchase', () {
    test('feature() alone never unlocks when inactive', () {
      final d = PremiumAccessPolicy.decide(
        event: PremiumGateEvent.featureCallback,
        subscriptionActive: false,
      );
      expect(d.grantAccess, isFalse);
      expect(d.reason, 'feature_callback_inactive_entitlement');
    });

    test('DeclinedPaywallResult keeps locked when inactive', () {
      final d = PremiumAccessPolicy.decide(
        event: PremiumGateEvent.paywallDismissed,
        subscriptionActive: false,
        dismissKind: PaywallDismissKind.declined,
      );
      expect(d.grantAccess, isFalse);
      expect(d.reason, 'dismiss_without_purchase_keep_locked');
    });

    test('unknown dismiss keeps locked when inactive', () {
      final d = PremiumAccessPolicy.decide(
        event: PremiumGateEvent.paywallDismissed,
        subscriptionActive: false,
        dismissKind: PaywallDismissKind.unknown,
      );
      expect(d.grantAccess, isFalse);
    });

    test(
      'regression: feature() then declined dismiss must not unlock '
      '(previous Superwall non-gated / skip bug)',
      () {
        final session = _PaywallSession(subscriptionActive: false);
        // Bug path: Superwall invokes feature() when paywall is closed/skipped.
        session.onFeatureCallback();
        expect(session.unlocked, isFalse);
        session.onDismiss(const DeclinedPaywallResult());
        expect(session.unlocked, isFalse);
        expect(
          session.decisions.every((d) => !d.grantAccess),
          isTrue,
        );
      },
    );
  });

  group('PremiumAccessPolicy — cancel / decline purchase', () {
    test('declined after seeing paywall stays locked', () {
      final session = _PaywallSession(subscriptionActive: false);
      session.onDismiss(const DeclinedPaywallResult());
      expect(session.unlocked, isFalse);
    });
  });

  group('PremiumAccessPolicy — successful purchase', () {
    test('purchased + sync confirmed unlocks', () {
      final session = _PaywallSession(subscriptionActive: false)
        ..subscriptionActive = true;
      session.onDismiss(const PurchasedPaywallResult(productId: 'pro_yearly'));
      expect(session.unlocked, isTrue);
      expect(
        session.decisions.last.reason,
        'dismiss_purchase_restore_sync_confirmed',
      );
    });

    test('purchased + lagging sync unlocks when trusted', () {
      final session = _PaywallSession(subscriptionActive: false);
      session.onDismiss(
        const PurchasedPaywallResult(productId: 'pro_yearly'),
        trustPurchaseAfterLag: true,
      );
      expect(session.unlocked, isTrue);
      expect(session.subscriptionActive, isTrue);
      expect(
        session.decisions.last.reason,
        'dismiss_purchase_restore_trusted_after_sync_lag',
      );
    });

    test('restored unlocks when active', () {
      final session = _PaywallSession(subscriptionActive: true);
      session.onDismiss(const RestoredPaywallResult());
      expect(session.unlocked, isTrue);
    });

    test('feature() after purchase unlocks once entitlement is active', () {
      final session = _PaywallSession(subscriptionActive: true);
      session.onFeatureCallback();
      expect(session.unlocked, isTrue);
      expect(
        session.decisions.single.reason,
        'feature_callback_active_entitlement',
      );
    });
  });

  group('PremiumAccessPolicy — existing subscriber', () {
    test('feature() unlocks when already active', () {
      final d = PremiumAccessPolicy.decide(
        event: PremiumGateEvent.featureCallback,
        subscriptionActive: true,
      );
      expect(d.grantAccess, isTrue);
    });

    test('closing paywall while already active still unlocks', () {
      final session = _PaywallSession(subscriptionActive: true);
      session.onDismiss(const DeclinedPaywallResult());
      expect(session.unlocked, isTrue);
      expect(
        session.decisions.single.reason,
        'dismiss_without_purchase_but_already_active',
      );
    });
  });

  group('PremiumAccessPolicy — all paid PremiumGate contexts', () {
    test(
      'close / decline / feature-skip keep locked for every paid entry point',
      () {
        for (final context in kPremiumGateDebugContexts) {
          for (final event in [
            (
              PremiumGateEvent.featureCallback,
              null,
            ),
            (
              PremiumGateEvent.paywallDismissed,
              PaywallDismissKind.declined,
            ),
            (
              PremiumGateEvent.paywallDismissed,
              PaywallDismissKind.unknown,
            ),
          ]) {
            final decision = PremiumAccessPolicy.decide(
              event: event.$1,
              subscriptionActive: false,
              dismissKind: event.$2,
              debugContext: context,
            );
            expect(
              decision.grantAccess,
              isFalse,
              reason: 'context=$context event=${event.$1} kind=${event.$2}',
            );
            final line = PremiumAccessPolicy.decisionLogLine(
              decision: decision,
              event: event.$1,
              subscriptionActive: false,
              dismissKind: event.$2,
              debugContext: context,
            );
            expect(line, contains('grant=false'));
            expect(line, contains('context=$context'));
          }
        }
      },
    );

    test('purchase unlocks for every paid entry point', () {
      for (final context in kPremiumGateDebugContexts) {
        final decision = PremiumAccessPolicy.decide(
          event: PremiumGateEvent.paywallDismissed,
          subscriptionActive: true,
          dismissKind: PaywallDismissKind.purchased,
          debugContext: context,
        );
        expect(
          decision.grantAccess,
          isTrue,
          reason: 'context=$context',
        );
      }
    });

    test('active subscriber unlocks for every paid entry point', () {
      for (final context in kPremiumGateDebugContexts) {
        final decision = PremiumAccessPolicy.decide(
          event: PremiumGateEvent.featureCallback,
          subscriptionActive: true,
          debugContext: context,
        );
        expect(decision.grantAccess, isTrue, reason: context);
      }
    });
  });

  group('PaywallResult type mapping', () {
    test('maps Superwall result types', () {
      expect(
        PremiumAccessPolicy.dismissKindFromResultType(
          const PurchasedPaywallResult(productId: 'x').runtimeType,
        ),
        PaywallDismissKind.purchased,
      );
      expect(
        PremiumAccessPolicy.dismissKindFromResultType(
          const RestoredPaywallResult().runtimeType,
        ),
        PaywallDismissKind.restored,
      );
      expect(
        PremiumAccessPolicy.dismissKindFromResultType(
          const DeclinedPaywallResult().runtimeType,
        ),
        PaywallDismissKind.declined,
      );
    });
  });

  group('UI / session flags must not grant access', () {
    test('policy has no paywallShown / isUnlocked / dismissed inputs', () {
      // Documented contract: only entitlement + dismiss kind decide unlock.
      // If someone later adds a paywallShown parameter, this suite should fail
      // by requiring an explicit entitlement check in the same decide() call.
      final closed = PremiumAccessPolicy.decide(
        event: PremiumGateEvent.paywallDismissed,
        subscriptionActive: false,
        dismissKind: PaywallDismissKind.declined,
      );
      final skipped = PremiumAccessPolicy.decide(
        event: PremiumGateEvent.featureCallback,
        subscriptionActive: false,
      );
      expect(closed.grantAccess, isFalse);
      expect(skipped.grantAccess, isFalse);
    });
  });
}
