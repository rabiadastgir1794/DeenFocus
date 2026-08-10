import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// Search field + filtered list for learning modules.
class LearningSearchableList extends StatelessWidget {
  const LearningSearchableList({
    super.key,
    required this.itemCount,
    required this.totalCount,
    required this.itemBuilder,
    required this.query,
    required this.onQueryChanged,
    this.emptyMessage,
  });

  final int itemCount;
  final int totalCount;
  final IndexedWidgetBuilder itemBuilder;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final countLabel = query.trim().isEmpty
        ? l10n.libraryItemCount(totalCount)
        : l10n.librarySearchResultCount(itemCount, totalCount);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            onChanged: onQueryChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: l10n.librarySearchHint,
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.45,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              countLabel,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
        Expanded(
          child: itemCount == 0
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      emptyMessage ?? l10n.librarySearchEmpty,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  itemCount: itemCount,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: itemBuilder,
                ),
        ),
      ],
    );
  }
}
