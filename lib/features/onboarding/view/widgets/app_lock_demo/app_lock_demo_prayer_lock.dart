import 'package:flutter/material.dart';

import '../../../../focus/model/restricted_mode_content.dart';
import '../../../../focus/view/widgets/restricted_mode_screen.dart';
import 'app_lock_demo_copy.dart';

/// Lock overlay shown after the user “opens” Instagram in the demo.
class AppLockDemoPrayerLock extends StatelessWidget {
  const AppLockDemoPrayerLock({
    super.key,
    required this.copy,
    required this.remaining,
    required this.onConfirm,
  });

  final AppLockDemoCopy copy;
  final Duration remaining;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return RestrictedModeScreen(
      key: ValueKey<int>(remaining.inSeconds),
      kind: RestrictedModeKindX.fromDemo(copy.mode),
      onPrimary: onConfirm,
    );
  }
}
