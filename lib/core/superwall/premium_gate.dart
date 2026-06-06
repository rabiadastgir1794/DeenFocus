// premium_gate.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

import '../logger/trace_helpers.dart';
import 'app_superwall.dart';

/// Centralised entry point for premium-gated features.
///
/// Shows a fullscreen "Verifying subscription" loader for at least 1 second
/// while [AppSuperwall.configure] resolves and the subscription status is
/// fetched. If a paywall must be shown the loader is dismissed once Superwall
/// reports the paywall as presented. If the entire flow takes longer than
/// 30 seconds the loader is dismissed and a friendly error is surfaced.
class PremiumGate {
  PremiumGate._();

  static const Duration _minLoaderDuration = Duration(seconds: 1);
  static const Duration _verificationTimeout = Duration(seconds: 30);

  static void _log(String message) {
    debugPrint('[PremiumGate] $message');
  }

  /// Verifies the user's subscription, then either invokes [onAccess]
  /// directly or presents the appropriate Superwall paywall placement.
  ///
  /// Pass [placementOverride] for entry points that should always request a
  /// specific Superwall placement instead of the intro/premium decision.
  static Future<void> presentIfNeeded({
    required BuildContext context,
    required VoidCallback onAccess,
    required String debugContext,
    String? placementOverride,
  }) async {
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

    final entry = OverlayEntry(
      builder: (_) => const _VerifyingSubscriptionOverlay(),
    );
    overlayState.insert(entry);

    final start = DateTime.now();
    var overlayRemoved = false;
    void removeOverlay() {
      if (overlayRemoved) return;
      overlayRemoved = true;
      try {
        entry.remove();
      } catch (_) {
        // Overlay may already be torn down (route popped, etc.) — ignore.
      }
    }

    Future<void> waitForMinimum() async {
      final elapsed = DateTime.now().difference(start);
      if (elapsed < _minLoaderDuration) {
        await Future<void>.delayed(_minLoaderDuration - elapsed);
      }
    }

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
        await waitForMinimum();
        removeOverlay();
        onAccess();
        return;
      }

      // On Play Store, Superwall.getSubscriptionStatus() can take 1-2 minutes
      // while Google Play Billing initialises. Use a short timeout and fall
      // through to registerPlacement on timeout — Superwall rechecks internally,
      // and the feature: / onPresent handlers below handle both outcomes.
      SubscriptionStatus? status;
      try {
        status = await TraceHelpers.traceAsync(
          'PAYWALL',
          'Superwall.getSubscriptionStatus context=$debugContext',
          () => Superwall.shared.getSubscriptionStatus().timeout(
            const Duration(seconds: 5),
          ),
        );
      } on TimeoutException {
        _log(
          'getSubscriptionStatus timed out, proceeding to paywall '
          'context=$debugContext',
        );
      }

      if (status != null && status.isActive) {
        await waitForMinimum();
        removeOverlay();
        onAccess();
        return;
      }

      final placement =
          placementOverride ??
          await AppSuperwall.paywallPlacementForCurrentUser(
            debugContext: debugContext,
          );

      _log('registering paywall placement=$placement context=$debugContext');

      // Hold the loader until Superwall reports the paywall as presented so
      // the transition feels uninterrupted.
      final presented = Completer<void>();

      await waitForMinimum();

      unawaited(
        Superwall.shared.registerPlacement(
          placement,
          handler: PaywallPresentationHandler()
            ..onPresent((info) {
              _log('paywall presented context=$debugContext');
              if (!presented.isCompleted) presented.complete();
              removeOverlay();
            })
            ..onDismiss((info, result) async {
              _log('paywall dismissed context=$debugContext result=$result');
              unawaited(AppSuperwall.syncSubscriptionState());
              // Grant access immediately when Superwall confirms a purchase or
              // restore — billing verification already happened inside Superwall.
              // Waiting for getSubscriptionStatus() here can take 1-2 minutes
              // on Play Store, leaving the user blocked after a real purchase.
              if (result is PurchasedPaywallResult ||
                  result is RestoredPaywallResult) {
                onAccess();
                return;
              }
              try {
                final updated = await Superwall.shared
                    .getSubscriptionStatus()
                    .timeout(const Duration(seconds: 10));
                if (updated.isActive) onAccess();
              } catch (e) {
                _log('post-dismiss status check failed: $e');
              }
            })
            ..onError((error) {
              _log('paywall error context=$debugContext error=$error');
              if (!presented.isCompleted) {
                presented.completeError(StateError('paywall error: $error'));
              }
              removeOverlay();
            })
            ..onCustomCallback((callback) {
              return AppSuperwall.handleCustomPaywallCallback(
                callback,
                debugContext: debugContext,
              );
            }),
          feature: () async {
            // Superwall calls feature() when it decides not to show a paywall
            // (subscription_status_timeout, no matching campaign, etc.).
            // Always complete `presented` here — otherwise the overlay hangs
            // for the full ~30 s timeout before surfacing an error.
            try {
              final latest = await Superwall.shared.getSubscriptionStatus();
              if (!presented.isCompleted) presented.complete();
              removeOverlay();
              if (latest.isActive) onAccess();
            } catch (e) {
              _log('feature status check failed: $e');
              if (!presented.isCompleted) presented.complete();
              removeOverlay();
            }
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
      await waitForMinimum();
      removeOverlay();
      if (!context.mounted) return;
      await _showVerifyError(context);
    } catch (e, st) {
      _log('verification failed context=$debugContext error=$e');
      debugPrintStack(stackTrace: st);
      await waitForMinimum();
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
