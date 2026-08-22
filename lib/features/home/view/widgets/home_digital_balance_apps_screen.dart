import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_centered_nav_header.dart';
import '../../../../core/widgets/focus_app_icon.dart';
import '../../../../l10n/app_localizations.dart';
import '../../model/digital_balance_models.dart';
import 'digital_balance_chrome.dart';

class HomeDigitalBalanceAppsScreen extends StatelessWidget {
  const HomeDigitalBalanceAppsScreen({super.key, required this.apps});

  final List<AppUsageEntry> apps;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cream = isDark ? colorScheme.surface : AppColors.backgroundLight;
    final maxUsage = apps.fold<Duration>(
      Duration.zero,
      (longest, app) => app.usage > longest ? app.usage : longest,
    );

    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: Column(
          children: [
            AppCenteredNavHeader(
              title: l10n.digitalBalanceAllAppsTitle,
              backLabel: l10n.insightsBack,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                itemCount: apps.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final entry = apps[index];
                  final fraction = maxUsage.inMilliseconds <= 0
                      ? 0.0
                      : (entry.usage.inMilliseconds / maxUsage.inMilliseconds)
                            .clamp(0.0, 1.0);
                  return Container(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    decoration:
                        digitalBalanceCardDecoration(
                          colorScheme,
                          isDark,
                        ).copyWith(
                          color: entry.isDeenFocus
                              ? digitalBalanceMintFill(colorScheme, isDark)
                              : null,
                        ),
                    child: Row(
                      children: [
                        FocusAppIcon(
                          label: entry.appName,
                          iconBytes: entry.iconBytes,
                          size: 32,
                          radius: 8,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.appName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: entry.isDeenFocus
                                          ? colorScheme.primary
                                          : colorScheme.onSurface,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: fraction,
                                  minHeight: 6,
                                  color: entry.isDeenFocus
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant.withValues(
                                          alpha: 0.45,
                                        ),
                                  backgroundColor: colorScheme.outlineVariant
                                      .withValues(alpha: 0.28),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          formatDigitalBalanceDuration(l10n, entry.usage),
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
