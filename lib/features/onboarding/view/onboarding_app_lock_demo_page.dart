import 'package:flutter/material.dart';

import 'widgets/app_lock_demo/app_lock_demo_flow.dart';
import 'widgets/app_lock_demo/app_lock_demo_mode.dart';

/// Onboarding host for the shared interactive App Lock Demo (Prayer Mode).
class OnboardingAppLockDemoPage extends StatelessWidget {
  const OnboardingAppLockDemoPage({
    super.key,
    required this.onComplete,
    required this.onExitToPrevious,
    this.isActive = true,
    this.onImmersiveChanged,
  });

  final VoidCallback onComplete;
  final VoidCallback onExitToPrevious;
  final ValueChanged<bool>? onImmersiveChanged;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AppLockDemoFlow(
      mode: AppLockDemoMode.prayer,
      isActive: isActive,
      fromSettings: false,
      onComplete: onComplete,
      onExit: onExitToPrevious,
      onImmersiveChanged: onImmersiveChanged,
    );
  }
}
