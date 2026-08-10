import 'package:flutter/material.dart';

import '../model/library_module.dart';

/// Lightweight WebP cover paths for hub modules and Dua categories.
abstract final class LibraryCoverAssets {
  static const _base = 'assets/islamic_library/covers';

  static String? moduleCover(LibraryModuleId id) {
    final file = switch (id) {
      LibraryModuleId.quran => 'module_quran.webp',
      LibraryModuleId.hadith => 'module_hadith.webp',
      LibraryModuleId.duasAdhkar => 'module_duas_adhkar.webp',
      LibraryModuleId.prayerMethods => 'module_prayer_methods.webp',
      LibraryModuleId.fiqhDifferences => 'module_fiqh_differences.webp',
      LibraryModuleId.namesOfAllah => 'module_names_of_allah.webp',
      LibraryModuleId.pillarsOfIslam => 'module_pillars_of_islam.webp',
      LibraryModuleId.pillarsOfIman => 'module_pillars_of_iman.webp',
      LibraryModuleId.prophets => 'module_prophets.webp',
      LibraryModuleId.islamicOccasions => 'module_islamic_occasions.webp',
    };
    return '$_base/$file';
  }

  static String? duaCategoryCover(String categoryId) {
    final file = switch (categoryId) {
      'morning' => 'dua_morning.webp',
      'evening' => 'dua_evening.webp',
      'daily_life' => 'dua_daily_life.webp',
      'sleep' => 'dua_sleep.webp',
      'food' => 'dua_food.webp',
      'travel' => 'dua_travel.webp',
      'illness' => 'dua_illness.webp',
      'protection' => 'dua_protection.webp',
      'forgiveness' => 'dua_forgiveness.webp',
      'parents' => 'dua_parents.webp',
      _ => null,
    };
    if (file == null) return null;
    return '$_base/$file';
  }
}

/// Small rounded cover thumbnail for list cards.
class LibraryCoverThumb extends StatelessWidget {
  const LibraryCoverThumb({
    super.key,
    required this.assetPath,
    this.size = 56,
    this.borderRadius = 14,
  });

  final String assetPath;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.cover,
        cacheWidth: (size * 2).round(),
        cacheHeight: (size * 2).round(),
        errorBuilder: (_, _, _) => _fallback(context),
      ),
    );
  }

  Widget _fallback(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      color: colorScheme.primary.withValues(alpha: 0.12),
      child: Icon(
        Icons.image_outlined,
        color: colorScheme.primary.withValues(alpha: 0.5),
        size: size * 0.4,
      ),
    );
  }
}

/// Wider cover strip for Dua category rows.
class LibraryCoverBanner extends StatelessWidget {
  const LibraryCoverBanner({
    super.key,
    required this.assetPath,
    this.width = 88,
    this.height = 56,
  });

  final String assetPath;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        cacheWidth: (width * 2).round(),
        cacheHeight: (height * 2).round(),
        errorBuilder: (_, _, _) => LibraryCoverThumb(
          assetPath: assetPath,
          size: height,
        ),
      ),
    );
  }
}
