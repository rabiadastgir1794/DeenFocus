import 'package:flutter/material.dart';

import '../../../features/home/view/widgets/home_action_container.dart';
import '../../../l10n/app_localizations.dart';
import '../model/library_module.dart';

class LibraryModuleCard extends StatelessWidget {
  const LibraryModuleCard({
    super.key,
    required this.module,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.onTap,
  });

  final LibraryModule module;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HomeActionContainer(
      backgroundColor: backgroundColor,
      title: title,
      subtitle: subtitle,
      icon: module.icon,
      iconBackground: module.iconTint.withValues(alpha: 0.14),
      onTap: onTap,
    );
  }
}

String libraryModuleTitle(AppLocalizations l10n, LibraryModuleId id) {
  switch (id) {
    case LibraryModuleId.quran:
      return l10n.libraryModuleQuran;
    case LibraryModuleId.hadith:
      return l10n.libraryModuleHadith;
    case LibraryModuleId.duasAdhkar:
      return l10n.libraryModuleDuas;
    case LibraryModuleId.prayerMethods:
      return l10n.libraryModulePrayerMethods;
    case LibraryModuleId.fiqhDifferences:
      return l10n.libraryModuleFiqh;
    case LibraryModuleId.namesOfAllah:
      return l10n.libraryModuleNames;
    case LibraryModuleId.pillarsOfIslam:
      return l10n.libraryModulePillarsIslam;
    case LibraryModuleId.pillarsOfIman:
      return l10n.libraryModulePillarsIman;
    case LibraryModuleId.prophets:
      return l10n.libraryModuleProphets;
    case LibraryModuleId.islamicOccasions:
      return l10n.libraryModuleOccasions;
  }
}

String libraryModuleSubtitle(AppLocalizations l10n, LibraryModuleId id) {
  switch (id) {
    case LibraryModuleId.quran:
      return l10n.libraryModuleQuranSub;
    case LibraryModuleId.hadith:
      return l10n.libraryModuleHadithSub;
    case LibraryModuleId.duasAdhkar:
      return l10n.libraryModuleDuasSub;
    case LibraryModuleId.prayerMethods:
      return l10n.libraryModulePrayerMethodsSub;
    case LibraryModuleId.fiqhDifferences:
      return l10n.libraryModuleFiqhSub;
    case LibraryModuleId.namesOfAllah:
      return l10n.libraryModuleNamesSub;
    case LibraryModuleId.pillarsOfIslam:
      return l10n.libraryModulePillarsIslamSub;
    case LibraryModuleId.pillarsOfIman:
      return l10n.libraryModulePillarsImanSub;
    case LibraryModuleId.prophets:
      return l10n.libraryModuleProphetsSub;
    case LibraryModuleId.islamicOccasions:
      return l10n.libraryModuleOccasionsSub;
  }
}
