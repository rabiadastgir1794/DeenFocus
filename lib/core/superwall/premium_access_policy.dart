/// Pure entitlement rules for Superwall-gated features.
///
/// Keeps unlock decisions out of UI / session flags so they can be unit-tested
/// without the Superwall SDK. [PremiumGate] and [AppSuperwall] must call this
/// before invoking any `onAccess` callback after a paywall interaction.
library;

/// Paid feature entry points that share [PremiumGate.presentIfNeeded].
const List<String> kPremiumGateDebugContexts = [
  'focus:enable_mode:salah',
  'focus:enable_mode:nightDiscipline',
  'focus:enable_mode:child',
  'focus:load_apps',
  'tajweed:practice',
  'tajweed:free_preview_done',
  'reading_settings:tajweed',
  'quran_translation',
  'home:insights',
  'home:islamic_chat',
  'settings:premium_card',
  'post_onboarding_home',
];

enum PremiumGateEvent {
  /// Superwall `feature()` callback (subscribed, purchase, holdout, or skip).
  featureCallback,

  /// Paywall closed — inspect [PaywallDismissKind] + entitlement.
  paywallDismissed,
}

enum PaywallDismissKind {
  purchased,
  restored,
  declined,
  unknown,
}

class PremiumAccessDecision {
  const PremiumAccessDecision._({
    required this.grantAccess,
    required this.reason,
  });

  factory PremiumAccessDecision.grant(String reason) =>
      PremiumAccessDecision._(grantAccess: true, reason: reason);

  factory PremiumAccessDecision.deny(String reason) =>
      PremiumAccessDecision._(grantAccess: false, reason: reason);

  final bool grantAccess;
  final String reason;

  @override
  String toString() =>
      'PremiumAccessDecision(grant=$grantAccess, reason=$reason)';
}

/// Decides whether a gated feature may unlock.
///
/// Rules:
/// - Never unlock from paywall present / dismiss / `feature()` alone.
/// - Unlock only with an active Superwall entitlement, or a confirmed
///   purchase/restore (`PurchasedPaywallResult` / `RestoredPaywallResult`).
/// - Declined / cancelled / failed payment keep the feature locked unless
///   entitlement is already active.
abstract final class PremiumAccessPolicy {
  /// Maps Superwall dismiss result runtime types without importing the SDK
  /// into every call site that only needs the kind enum.
  static PaywallDismissKind dismissKindFromResultType(Type type) {
    final name = type.toString();
    if (name.contains('PurchasedPaywallResult')) {
      return PaywallDismissKind.purchased;
    }
    if (name.contains('RestoredPaywallResult')) {
      return PaywallDismissKind.restored;
    }
    if (name.contains('DeclinedPaywallResult')) {
      return PaywallDismissKind.declined;
    }
    return PaywallDismissKind.unknown;
  }

  static PremiumAccessDecision decide({
    required PremiumGateEvent event,
    required bool subscriptionActive,
    PaywallDismissKind? dismissKind,
    bool trustConfirmedPurchaseAfterSyncLag = false,
    String debugContext = '',
  }) {
    switch (event) {
      case PremiumGateEvent.featureCallback:
        // feature() is not entitlement — holdouts / skipped paywalls must not
        // unlock without an active subscription.
        if (subscriptionActive) {
          return PremiumAccessDecision.grant(
            'feature_callback_active_entitlement',
          );
        }
        return PremiumAccessDecision.deny(
          'feature_callback_inactive_entitlement',
        );

      case PremiumGateEvent.paywallDismissed:
        switch (dismissKind) {
          case PaywallDismissKind.purchased:
          case PaywallDismissKind.restored:
            if (subscriptionActive) {
              return PremiumAccessDecision.grant(
                'dismiss_purchase_restore_sync_confirmed',
              );
            }
            if (trustConfirmedPurchaseAfterSyncLag) {
              return PremiumAccessDecision.grant(
                'dismiss_purchase_restore_trusted_after_sync_lag',
              );
            }
            return PremiumAccessDecision.deny(
              'dismiss_purchase_restore_waiting_for_sync',
            );

          case PaywallDismissKind.declined:
          case PaywallDismissKind.unknown:
          case null:
            if (subscriptionActive) {
              return PremiumAccessDecision.grant(
                'dismiss_without_purchase_but_already_active',
              );
            }
            return PremiumAccessDecision.deny(
              'dismiss_without_purchase_keep_locked',
            );
        }
    }
  }

  /// Structured log line for device debugging of unlock-after-dismiss bugs.
  static String decisionLogLine({
    required PremiumAccessDecision decision,
    required PremiumGateEvent event,
    required bool subscriptionActive,
    PaywallDismissKind? dismissKind,
    required String debugContext,
  }) {
    return 'GATE_DECISION grant=${decision.grantAccess} '
        'reason=${decision.reason} event=${event.name} '
        'subscriptionActive=$subscriptionActive '
        'dismissKind=${dismissKind?.name ?? 'n/a'} '
        'context=$debugContext';
  }
}
