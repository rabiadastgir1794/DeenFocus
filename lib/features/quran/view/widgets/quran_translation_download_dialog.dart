import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/services/quran_translation_service.dart';

/// Blocks until a translation pack finishes downloading (or the user cancels).
/// Returns `true` on success.
Future<bool> showQuranTranslationDownloadDialog(
  BuildContext context, {
  required String languageCode,
  String? displayName,
}) async {
  final label = displayName ?? languageCode.toUpperCase();
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _QuranTranslationDownloadDialog(
      languageCode: languageCode,
      displayName: label,
    ),
  );
  return result == true;
}

class _QuranTranslationDownloadDialog extends StatefulWidget {
  const _QuranTranslationDownloadDialog({
    required this.languageCode,
    required this.displayName,
  });

  final String languageCode;
  final String displayName;

  @override
  State<_QuranTranslationDownloadDialog> createState() =>
      _QuranTranslationDownloadDialogState();
}

class _QuranTranslationDownloadDialogState
    extends State<_QuranTranslationDownloadDialog> {
  double _progress = 0;
  String? _error;
  StreamSubscription<double>? _progressSub;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _progressSub = QuranTranslationService.downloadProgress().listen((p) {
      if (!mounted) return;
      setState(() => _progress = p);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => unawaited(_run()));
  }

  Future<void> _run() async {
    if (_started) return;
    _started = true;
    try {
      await QuranTranslationService.ensureTranslation(widget.languageCode);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on QuranTranslationException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  @override
  void dispose() {
    _progressSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text('Downloading ${widget.displayName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_error == null) ...[
            LinearProgressIndicator(value: _progress > 0 ? _progress : null),
            const SizedBox(height: 12),
            Text(
              _progress >= 1.0
                  ? 'Finishing…'
                  : '${(_progress * 100).clamp(0, 99).round()}%',
              style: theme.textTheme.bodyMedium,
            ),
          ] else
            Text(_error!, style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            )),
        ],
      ),
      actions: [
        if (_error != null)
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
      ],
    );
  }
}
