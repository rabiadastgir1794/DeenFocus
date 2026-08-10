import 'package:flutter/material.dart';

enum LibraryModuleId {
  quran,
  hadith,
  duasAdhkar,
  prayerMethods,
  namesOfAllah,
  fiqhDifferences,
  pillarsOfIslam,
  pillarsOfIman,
  prophets,
  islamicOccasions,
}

class LibraryModule {
  const LibraryModule({
    required this.id,
    required this.icon,
    required this.iconTint,
  });

  final LibraryModuleId id;
  final IconData icon;
  final Color iconTint;

  static const List<LibraryModule> all = <LibraryModule>[
    LibraryModule(
      id: LibraryModuleId.quran,
      icon: Icons.menu_book_outlined,
      iconTint: Color(0xFF2E7D5B),
    ),
    LibraryModule(
      id: LibraryModuleId.hadith,
      icon: Icons.auto_stories_outlined,
      iconTint: Color(0xFF8B6914),
    ),
    LibraryModule(
      id: LibraryModuleId.duasAdhkar,
      icon: Icons.volunteer_activism_outlined,
      iconTint: Color(0xFF5C6BC0),
    ),
    LibraryModule(
      id: LibraryModuleId.prayerMethods,
      icon: Icons.accessibility_new_outlined,
      iconTint: Color(0xFF00838F),
    ),
    LibraryModule(
      id: LibraryModuleId.namesOfAllah,
      icon: Icons.star_outline_rounded,
      iconTint: Color(0xFF6A1B9A),
    ),
    LibraryModule(
      id: LibraryModuleId.fiqhDifferences,
      icon: Icons.balance_outlined,
      iconTint: Color(0xFF5D4037),
    ),
    LibraryModule(
      id: LibraryModuleId.pillarsOfIslam,
      icon: Icons.account_balance_outlined,
      iconTint: Color(0xFF1565C0),
    ),
    LibraryModule(
      id: LibraryModuleId.pillarsOfIman,
      icon: Icons.favorite_outline_rounded,
      iconTint: Color(0xFFC62828),
    ),
    LibraryModule(
      id: LibraryModuleId.prophets,
      icon: Icons.landscape_outlined,
      iconTint: Color(0xFF4E342E),
    ),
    LibraryModule(
      id: LibraryModuleId.islamicOccasions,
      icon: Icons.event_outlined,
      iconTint: Color(0xFFEF6C00),
    ),
  ];

  String storageKey(String suffix) => 'library_${id.name}_$suffix';
}
