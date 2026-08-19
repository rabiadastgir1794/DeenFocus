import 'package:flutter/material.dart';

import '../../../../core/constants/spacing.dart';
import '../../../../l10n/app_localizations.dart';

/// Cycle Mode banner — shown only when toggle is ON.
/// Day-level pink uses [HomeTabViewModel.isCycleHighlight].
class HomeCycleModeActiveBanner extends StatelessWidget {
  const HomeCycleModeActiveBanner({
    super.key,
    required this.daysRemaining,
    this.onTap,
  });

  final int daysRemaining;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Pink color for Cycle Mode
    final cycleModeColor = isDark
        ? const Color(0xFFE59DB7) // Lighter pink for dark mode
        : const Color(0xFFFF9EC5); // Pink for light mode

    final cycleModeContainerColor = isDark
        ? cycleModeColor.withValues(alpha: 0.10)
        : cycleModeColor.withValues(alpha: 0.08);

    final cycleModeBorderColor = cycleModeColor.withValues(alpha: 0.22);

    return Material(
      color: cycleModeContainerColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cycleModeBorderColor, width: 1),
          ),
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: cycleModeColor.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(
                      Icons.shield_moon_rounded,
                      color: cycleModeColor,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: Spacing.sm + 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.cycleModeActiveTitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.cycleModeActiveSubtitle,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.35,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.cycleModeAutoEndInfo(daysRemaining),
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                            color: cycleModeColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
