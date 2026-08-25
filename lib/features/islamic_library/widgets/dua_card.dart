import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../model/library_dua.dart';

class DuaCard extends StatelessWidget {
  const DuaCard({
    super.key,
    required this.dua,
    required this.backgroundColor,
  });

  final LibraryDua dua;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              dua.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              dua.arabic,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              softWrap: true,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontFamily: 'UthmanicHafs',
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.libraryTransliteration,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              dua.transliteration,
              textAlign: TextAlign.center,
              softWrap: true,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.libraryTranslation,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dua.translation,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.55,
                        ),
                  ),
                ],
              ),
            ),
            if (dua.reference != null && dua.reference!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.libraryReference(dua.reference!),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ],
        ),
    );
  }
}
