import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../model/library_fiqh.dart';

class FiqhTopicCard extends StatelessWidget {
  const FiqhTopicCard({
    super.key,
    required this.topic,
    required this.backgroundColor,
  });

  final FiqhTopic topic;
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
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.balance_outlined,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              topic.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _Section(
              label: l10n.libraryFiqhOverview,
              body: topic.overview,
            ),
            const SizedBox(height: 16),
            _Section(
              label: l10n.libraryFiqhKeyPoints,
              body: topic.keyPoints,
            ),
            const SizedBox(height: 16),
            _Section(
              label: l10n.libraryFiqhDifferences,
              body: topic.differences,
            ),
            const SizedBox(height: 16),
            _Section(
              label: l10n.libraryFiqhCommonGround,
              body: topic.commonGround,
              highlighted: true,
            ),
          ],
        ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.label,
    required this.body,
    this.highlighted = false,
  });

  final String label;
  final String body;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final content = Text(
      body,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.55,
            color: highlighted ? colorScheme.onSurface : null,
          ),
    );

    if (!highlighted) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            content,
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          content,
        ],
      ),
    );
  }
}
