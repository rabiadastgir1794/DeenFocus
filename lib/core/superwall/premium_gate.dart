// premium_gate.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

import '../logger/trace_helpers.dart';
import 'app_superwall.dart';

/// Centralised entry point for premium-gated features.
///
/// Already-subscribed users skip the loader and unlock immediately when
/// entitlement is cached or confirmed. Non-subscribers get the paywall as
/// soon as Superwall is ready — the verifying overlay is only shown briefly
/// while configure / status resolve, never held until the paywall appears.
class PremiumGate {
  PremiumGate._();

  static const Duration _verificationTimeout = Duration(seconds: 30);
  static const Duration _statusCheckTimeout = Duration(seconds: 2);

  // Set to true after a purchase/restore completes so subsequent gated-feature
  // taps don't re-verify against a lagging Superwall/StoreKit status.
  // Reset to false if Superwall later confirms the subscription is not active.
  static bool _accessGrantedThisSession = false;

  static void _log(String message) {
    debugPrint('[PremiumGate] $message');
  }

  /// Verifies the user's subscription, then either invokes [onAccess]
  /// directly or presents the appropriate Superwall paywall placement.
  ///
  /// Pass [placementOverride] for entry points that should always request a
  /// specific Superwall placement instead of the intro/premium decision.
  ///
  /// Already-subscribed users (cached session or in-memory grant) call
  /// [onAccess] immediately with **no** verifying loader.
  static Future<void> presentIfNeeded({
    required BuildContext context,
    required VoidCallback onAccess,
    required String debugContext,
    String? placementOverride,
  }) async {
    // Fast path: never flash the loader when entitlement is already known.
    if (AppSuperwall.subscriptionActiveNotifier.value) {
      _log(
        'cached subscription active, opening immediately context=$debugContext',
      );
      onAccess();
      unawaited(
        Future<void>.delayed(const Duration(seconds: 5)).then(
          (_) => AppSuperwall.syncSubscriptionState(),
        ),
      );
      return;
    }
    if (_accessGrantedThisSession) {
      _log(
        'access already granted this session, skipping gate context=$debugContext',
      );
      onAccess();
      return;
    }

    // Hydrate disk cache in case cold-start loadCachedState() has not finished.
    await AppSuperwall.loadCachedState();
    if (AppSuperwall.subscriptionActiveNotifier.value) {
      _log(
        'disk-cached subscription active, opening immediately '
        'context=$debugContext',
      );
      _accessGrantedThisSession = true;
      onAccess();
      unawaited(AppSuperwall.syncSubscriptionState());
      return;
    }

    if (!context.mounted) return;

    final overlayState = Overlay.maybeOf(context, rootOverlay: true);
    if (overlayState == null) {
      // No overlay available — fall back to the direct flow so the user is
      // never silently stuck.
      await AppSuperwall.requireActiveSubscriptionOrPresentPaywall(
        onAccess,
        debugContext: debugContext,
        placementOverride: placementOverride,
      );
      return;
    }

    // Only show the verifying UI while Superwall still needs to configure.
    // On warm taps the SDK is ready — go straight to status / paywall.
    final needsConfigureLoader = !AppSuperwall.isEnabled;
    OverlayEntry? entry;
    var overlayRemoved = true;
    void removeOverlay() {
      if (overlayRemoved) return;
      overlayRemoved = true;
      try {
        entry?.remove();
      } catch (_) {
        // Overlay may already be torn down (route popped, etc.) — ignore.
      }
    }

    if (needsConfigureLoader) {
      entry = OverlayEntry(
        builder: (_) => const _VerifyingSubscriptionOverlay(),
      );
      overlayState.insert(entry);
      overlayRemoved = false;
    }

    final start = DateTime.now();

    Duration remainingBudget() {
      final elapsed = DateTime.now().difference(start);
      final left = _verificationTimeout - elapsed;
      return left.isNegative ? Duration.zero : left;
    }

    try {
      await AppSuperwall.configure().timeout(_verificationTimeout);

      if (!AppSuperwall.isEnabled) {
        // Superwall is not configured (missing key etc.) — let the caller
        // proceed so the feature is not permanently bricked.
        removeOverlay();
        onAccess();
        return;
      }

      // Quick status check. Prefer unlocking subscribers without a long wait;
      // on timeout fall through to registerPlacement (Superwall rechecks).
      SubscriptionStatus? status;
      try {
        status = await TraceHelpers.traceAsync(
          'PAYWALL',
          'Superwall.getSubscriptionStatus context=$debugContext',
          () => Superwall.shared.getSubscriptionStatus().timeout(
            _statusCheckTimeout,
          ),
        );
      } on TimeoutException {
        _log(
          'getSubscriptionStatus timed out, proceeding to paywall '
          'context=$debugContext',
        );
      }

      if (status != null && status.isActive) {
        _accessGrantedThisSession = true;
        removeOverlay();
        onAccess();
        unawaited(AppSuperwall.syncSubscriptionState());
        return;
      }

      final placement =
          placementOverride ??
          await AppSuperwall.paywallPlacementForCurrentUser(
            debugContext: debugContext,
          );

      _log('registering paywall placement=$placement context=$debugContext');

      // Drop the verifying loader before asking Superwall to present so the
      // paywall appears as soon as the SDK is ready (no forced hold).
      removeOverlay();

      final presented = Completer<void>();

      // One-shot guard: Superwall fires both onDismiss(PurchasedPaywallResult)
      // AND feature() after a purchase, which would call onAccess twice and
      // open the downstream screen (e.g. iOS FamilyActivityPicker) twice.
      var accessGranted = false;
      void grantAccess() {
        if (accessGranted) return;
        accessGranted = true;
        _accessGrantedThisSession = true;
        onAccess();
      }

      unawaited(
        Superwall.shared.registerPlacement(
          placement,
          handler: PaywallPresentationHandler()
            ..onPresent((info) {
              _log('paywall presented context=$debugContext');
              if (!presented.isCompleted) presented.complete();
            })
            ..onDismiss((info, result) async {
              _log('paywall dismissed context=$debugContext result=$result');
              if (result is PurchasedPaywallResult ||
                  result is RestoredPaywallResult) {
                // Brief verifying overlay while StoreKit / Play Billing catch up.
                OverlayEntry? syncEntry;
                var syncEntryRemoved = false;
                void removeSyncEntry() {
                  if (syncEntryRemoved) return;
                  syncEntryRemoved = true;
                  try {
                    syncEntry?.remove();
                  } catch (_) {}
                }

                syncEntry = OverlayEntry(
                  builder: (_) => const _VerifyingSubscriptionOverlay(),
                );
                try {
                  overlayState.insert(syncEntry);
                } catch (_) {}

                const maxAttempts = 5;
                for (var attempt = 1; attempt <= maxAttempts; attempt++) {
                  await AppSuperwall.syncSubscriptionState();
                  if (AppSuperwall.subscriptionActiveNotifier.value) {
                    _log(
                      'subscription confirmed active (attempt $attempt) '
                      'context=$debugContext',
                    );
                    removeSyncEntry();
                    grantAccess();
                    return;
                  }
                  _log(
                    'subscription not yet active '
                    '($attempt/$maxAttempts) context=$debugContext',
                  );
                  if (attempt < maxAttempts) {
                    await Future<void>.delayed(const Duration(seconds: 2));
                  }
                }
                _log(
                  'status still lagging after $maxAttempts attempts — '
                  'trusting PurchasedPaywallResult context=$debugContext',
                );
                removeSyncEntry();
                grantAccess();
                return;
              }
              try {
                final updated = await Superwall.shared
                    .getSubscriptionStatus()
                    .timeout(const Duration(seconds: 10));
                if (updated.isActive) {
                  grantAccess();
                }
              } catch (e) {
                _log('post-dismiss status check failed: $e');
              }
            })
            ..onError((error) {
              _log('paywall error context=$debugContext error=$error');
              if (!presented.isCompleted) {
                presented.completeError(StateError('paywall error: $error'));
              }
            })
            ..onCustomCallback((callback) {
              return AppSuperwall.handleCustomPaywallCallback(
                callback,
                debugContext: debugContext,
              );
            }),
          feature: () async {
            // Superwall invokes feature() when the gated code should run:
            // already subscribed, purchase/restore completed, holdout, or
            // paywall skipped (e.g. no matching campaign / status timeout).
            // Re-checking isActive here caused a silent no-op on Android when
            // the SDK skipped the paywall without an active entitlement —
            // Settings download / other gates looked like a dead button.
            _log('feature() invoked — granting access context=$debugContext');
            if (!presented.isCompleted) presented.complete();
            grantAccess();
            unawaited(AppSuperwall.syncSubscriptionState());
          },
        ),
      );

      final budgetForPresent = remainingBudget();
      if (budgetForPresent == Duration.zero) {
        throw TimeoutException('paywall did not present in time');
      }
      await presented.future.timeout(budgetForPresent);
    } on TimeoutException catch (e) {
      _log('verification timed out context=$debugContext error=$e');
      removeOverlay();
      if (!context.mounted) return;
      await _showVerifyError(context);
    } catch (e, st) {
      _log('verification failed context=$debugContext error=$e');
      debugPrintStack(stackTrace: st);
      removeOverlay();
    } finally {
      removeOverlay();
    }
  }

  static Future<void> _showVerifyError(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Subscription'),
        content: const Text(
          'Failed to verify subscription. Please try again later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _VerifyingSubscriptionOverlay extends StatelessWidget {
  const _VerifyingSubscriptionOverlay();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return PopScope(
      canPop: false,
      child: Material(
        color: Colors.black.withValues(alpha: 0.55),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(minWidth: 220, maxWidth: 320),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Verifying subscription',
                  textAlign: TextAlign.center,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
