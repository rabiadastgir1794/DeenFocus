import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../quran/view/quran_reader_screen.dart';
import 'home_card_open_arrow.dart';

/// Compact home promo after Today's Prayers — opens the Quran reader on tap.
class HomeReadQuranPromoCard extends StatelessWidget {
  const HomeReadQuranPromoCard({super.key, required this.backgroundColor});

  final Color backgroundColor;

  void _openQuran(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const QuranReaderScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onPrimary = colorScheme.onPrimary;
    final showCtaButton = MediaQuery.sizeOf(context).width >= 340;

    return InkWell(
      onTap: () => _openQuran(context),
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? colorScheme.primary.withValues(alpha: 0.35)
                : colorScheme.primary.withValues(alpha: 0.28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDark
                    ? colorScheme.primary.withValues(alpha: 0.18)
                    : const Color(0xFFF0E8DA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.menu_book_outlined,
                color: colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.homeReadQuranPromoTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.homeReadQuranPromoSubtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (showCtaButton) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.homeReadQuranPromoCta,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    HomeDirectionalForwardIcon(
                      size: 14,
                      color: onPrimary,
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(width: 4),
              HomeDirectionalChevronIcon(
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
