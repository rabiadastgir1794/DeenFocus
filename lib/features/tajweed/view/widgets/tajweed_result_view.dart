import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../model/tajweed_models.dart';
import '../../model/tajweed_practice_args.dart';
import '../../viewmodel/tajweed_practice_view_model.dart';

/// Post-scoring results: word accuracy, exact-match badge, and the ayah
/// rendered as normal, continuous Arabic text with a single color-coded
/// status per *word* (ok/minor/major/sub/miss/extra) from the native
/// `TajweedScoreResult` — purely presentational, no scoring logic here.
/// Lexical identity is decided natively; pronunciation quality overlays
/// matched words only.
class TajweedResultView extends StatelessWidget {
  const TajweedResultView({
    super.key,
    required this.viewModel,
    required this.args,
    required this.onDone,
  });

  final TajweedPracticeViewModel viewModel;
  final TajweedPracticeArgs args;
  final VoidCallback onDone;

  Color _statusColor(ColorScheme colorScheme, TajweedTokenStatus status) {
    switch (status) {
      case TajweedTokenStatus.ok:
        return const Color(0xFF2E7D32); // green
      case TajweedTokenStatus.minor:
      case TajweedTokenStatus.major:
        return const Color(0xFFF9A825); // orange — pronunciation issue
      case TajweedTokenStatus.sub:
        return colorScheme.error; // red — wrong word
      case TajweedTokenStatus.miss:
        return colorScheme.onSurfaceVariant; // grey
      case TajweedTokenStatus.extra:
        return const Color(0xFF6A1B9A); // purple
    }
  }

  String _statusLabel(TajweedTokenStatus status) {
    switch (status) {
      case TajweedTokenStatus.ok:
        return 'Correct';
      case TajweedTokenStatus.minor:
        return 'Minor slip';
      case TajweedTokenStatus.major:
        return 'Mispronounced';
      case TajweedTokenStatus.sub:
        return 'Wrong word';
      case TajweedTokenStatus.miss:
        return 'Missed';
      case TajweedTokenStatus.extra:
        return 'Extra';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final result = viewModel.result;
    if (result == null) return const SizedBox.shrink();

    final accuracyPercent = (result.wordAccuracy * 100).clamp(0, 100).toStringAsFixed(0);
    final summary = result.tokenSummary;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (result.exactMatch
                            ? const Color(0xFF2E7D32)
                            : colorScheme.primary)
                        .withValues(alpha: 0.12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$accuracyPercent%',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: result.exactMatch
                          ? const Color(0xFF2E7D32)
                          : colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  result.exactMatch ? 'Exact match!' : 'Word accuracy',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.35),
              ),
            ),
            child: _AyahText(
              tokens: result.tokens,
              arabicFontFamily: args.arabicFontFamily,
              defaultColor: colorScheme.onSurface,
              statusColor: (status) => _statusColor(colorScheme, status),
              statusLabel: _statusLabel,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 14,
            runSpacing: 8,
            children: [
              _LegendItem(color: _statusColor(colorScheme, TajweedTokenStatus.ok), label: 'Correct (${summary.ok})'),
              _LegendItem(color: _statusColor(colorScheme, TajweedTokenStatus.minor), label: 'Pronunciation (${summary.minor + summary.major})'),
              _LegendItem(color: _statusColor(colorScheme, TajweedTokenStatus.sub), label: 'Wrong word (${summary.sub})'),
              _LegendItem(color: _statusColor(colorScheme, TajweedTokenStatus.miss), label: 'Missed (${summary.miss})'),
              _LegendItem(color: _statusColor(colorScheme, TajweedTokenStatus.extra), label: 'Extra (${summary.extra})'),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => viewModel.tryAgain(),
                  icon: const Icon(Icons.replay_rounded),
                  label: const Text('Try again'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onDone,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Done'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Renders the ayah as one continuous, naturally-shaped Arabic paragraph
/// (never boxed per-word — that breaks Arabic letter connections/ligatures)
/// with a soft per-word background highlight for status. Tapping a word
/// shows its status via a SnackBar in lieu of a hover tooltip (not
/// meaningful on touch devices).
class _AyahText extends StatelessWidget {
  const _AyahText({
    required this.tokens,
    required this.arabicFontFamily,
    required this.defaultColor,
    required this.statusColor,
    required this.statusLabel,
  });

  final List<TajweedToken> tokens;
  final String arabicFontFamily;
  final Color defaultColor;
  final Color Function(TajweedTokenStatus status) statusColor;
  final String Function(TajweedTokenStatus status) statusLabel;

  @override
  Widget build(BuildContext context) {
    // "extra" tokens (spoken but not part of the ayah) only ever come from
    // the lexical fallback path and would corrupt the reference text if
    // interleaved — surface them separately instead of inline.
    final ayahTokens = tokens
        .where((t) => t.status != TajweedTokenStatus.extra)
        .toList(growable: false);
    final extraTokens = tokens
        .where((t) => t.status == TajweedTokenStatus.extra)
        .toList(growable: false);

    final spans = <InlineSpan>[];
    for (var i = 0; i < ayahTokens.length; i++) {
      final t = ayahTokens[i];
      final color = statusColor(t.status);
      spans.add(
        TextSpan(
          text: t.text,
          style: TextStyle(
            color: t.status == TajweedTokenStatus.ok ? defaultColor : color,
            decoration: t.status == TajweedTokenStatus.miss
                ? TextDecoration.lineThrough
                : null,
            decorationColor: color,
            backgroundColor: t.status == TajweedTokenStatus.ok
                ? null
                : color.withValues(alpha: 0.14),
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                    content: Text('${t.text} — ${statusLabel(t.status)}'),
                  ),
                );
            },
        ),
      );
      if (i != ayahTokens.length - 1) {
        spans.add(const TextSpan(text: ' '));
      }
    }

    return Column(
      children: [
        Text.rich(
          TextSpan(children: spans),
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: arabicFontFamily,
            fontSize: 26,
            height: 2.0,
          ),
        ),
        if (extraTokens.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'Extra words heard: ${extraTokens.map((t) => t.text).join(' ')}',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: arabicFontFamily,
              fontSize: 18,
              color: statusColor(TajweedTokenStatus.extra),
            ),
          ),
        ],
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
