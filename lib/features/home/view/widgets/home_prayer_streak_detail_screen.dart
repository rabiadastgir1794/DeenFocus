export 'home_insights_screen.dart';

import 'package:flutter/material.dart';

import 'home_insights_screen.dart';

/// Compatibility alias — Prayer Streak detail is now My Insights.
@Deprecated('Use HomeInsightsScreen')
class HomePrayerStreakDetailScreen extends StatelessWidget {
  const HomePrayerStreakDetailScreen({super.key});

  @override
  Widget build(BuildContext context) => const HomeInsightsScreen();
}
