import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class SupportImpactItem {
  const SupportImpactItem({
    required this.assetPath,
    required this.icon,
    required this.titleBuilder,
  });

  final String assetPath;
  final IconData icon;
  final String Function(AppLocalizations l10n) titleBuilder;
}

/// Horizontal impact gallery items (assets under `assets/support/`).
List<SupportImpactItem> supportImpactItems() {
  return [
    SupportImpactItem(
      assetPath: 'assets/support/impact_palestine.jpg',
      icon: Icons.favorite_rounded,
      titleBuilder: (l10n) => l10n.supportUsImpactPalestine,
    ),
    SupportImpactItem(
      assetPath: 'assets/support/impact_needy.jpg',
      icon: Icons.volunteer_activism_rounded,
      titleBuilder: (l10n) => l10n.supportUsImpactNeedy,
    ),
    SupportImpactItem(
      assetPath: 'assets/support/impact_community.jpg',
      icon: Icons.groups_rounded,
      titleBuilder: (l10n) => l10n.supportUsImpactCommunity,
    ),
    SupportImpactItem(
      assetPath: 'assets/support/impact_experience.jpg',
      icon: Icons.bar_chart_rounded,
      titleBuilder: (l10n) => l10n.supportUsImpactExperience,
    ),
    SupportImpactItem(
      assetPath: 'assets/support/impact_features.jpg',
      icon: Icons.auto_awesome_rounded,
      titleBuilder: (l10n) => l10n.supportUsImpactFeatures,
    ),
    SupportImpactItem(
      assetPath: 'assets/support/impact_quran.jpg',
      icon: Icons.menu_book_rounded,
      titleBuilder: (l10n) => l10n.supportUsImpactQuran,
    ),
    SupportImpactItem(
      assetPath: 'assets/support/impact_servers.jpg',
      icon: Icons.shield_outlined,
      titleBuilder: (l10n) => l10n.supportUsImpactServers,
    ),
  ];
}
