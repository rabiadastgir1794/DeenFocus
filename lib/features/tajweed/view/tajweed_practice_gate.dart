import 'package:flutter/material.dart';

import '../model/tajweed_practice_args.dart';
import 'tajweed_practice_screen.dart' deferred as tajweed_practice;

/// Thin route entry that deferred-loads the practice screen (and its VM /
/// native channel wiring) only when the user navigates to Tajweed practice.
///
/// Keeps `app_router` / splash startup from compiling or initializing the
/// heavy Tajweed Dart graph before the first Flutter frame.
class TajweedPracticeGate extends StatefulWidget {
  const TajweedPracticeGate({super.key, required this.args});

  final TajweedPracticeArgs args;

  @override
  State<TajweedPracticeGate> createState() => _TajweedPracticeGateState();
}

class _TajweedPracticeGateState extends State<TajweedPracticeGate> {
  Object? _error;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      await tajweed_practice.loadLibrary();
      if (!mounted) return;
      setState(() => _ready = true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Could not open Tajweed practice:\n$_error'),
          ),
        ),
      );
    }
    if (!_ready) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return tajweed_practice.TajweedPracticeScreen(args: widget.args);
  }
}
