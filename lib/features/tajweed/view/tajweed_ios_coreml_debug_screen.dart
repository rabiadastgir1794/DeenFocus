import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/services/tajweed_service.dart';
import '../viewmodel/tajweed_practice_view_model.dart';

/// DEBUG-only iOS harness: pick Official vs DIY CoreML without touching the
/// production Cloudflare `catalog.json`.
class TajweedIosCoreMlDebugScreen extends StatefulWidget {
  const TajweedIosCoreMlDebugScreen({super.key});

  @override
  State<TajweedIosCoreMlDebugScreen> createState() =>
      _TajweedIosCoreMlDebugScreenState();
}

class _TajweedIosCoreMlDebugScreenState extends State<TajweedIosCoreMlDebugScreen> {
  StreamSubscription<double>? _progressSub;
  String _source = 'official';
  Map<String, dynamic> _info = const {};
  bool _busy = false;
  bool _overrideAllowed = false;
  double _progress = 0;
  String _status = 'Idle';
  String? _error;

  static const _options = <(String, String)>[
    ('official', 'Official CoreML (v1.2.0 ANE)'),
    ('diy', 'DIY CoreML (v1.1.0 palette-8)'),
    ('catalog', 'Production catalog (live DIY)'),
  ];

  @override
  void initState() {
    super.initState();
    assert(kDebugMode && !kIsWeb && Platform.isIOS);
    _progressSub = TajweedService.downloadProgress().listen((p) {
      if (!mounted) return;
      setState(() => _progress = p);
    });
    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
    await StorageService.setTajweedEnabled(true);
    await _refresh();
  }

  Future<void> _refresh() async {
    try {
      final allowed = await TajweedService.isDevCoreMlOverrideAllowed();
      final source = await TajweedService.getDevCoreMlSource();
      final info = await TajweedService.getActiveCoreMlInfo();
      if (!mounted) return;
      setState(() {
        _overrideAllowed = allowed;
        _source = source;
        _info = info;
        if (!allowed) {
          _status =
              'Native override DISABLED — need a full Debug rebuild '
              '(flutter clean && flutter run). Hot reload is not enough.';
        } else if (info['available'] == true) {
          final api = info['encoderApi'] ?? info['resolvedApi'];
          final ver = info['version'] ?? '?';
          final match = info['packMatchesSelection'] != false;
          _status = match
              ? 'Active: $api v$ver'
              : 'Mismatch: disk=$api v$ver, selection=$source — tap a model below';
        } else {
          _status = 'No active pack';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _status = 'Status check failed';
      });
    }
  }

  Future<void> _install(String source) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _progress = 0;
      _error = null;
      _source = source;
      _status = 'Installing $source… (Official ≈ 261 MB)';
    });
    try {
      await TajweedService.setDevCoreMlSource(source);
      TajweedModelSession.invalidateBecauseDevSourceSwitch();
      await TajweedModelSession.ensurePrepared(
        onAfterEnsure: () {
          if (!mounted) return;
          setState(() => _progress = 1);
        },
      );
      if (!mounted) return;
      setState(() {
        _status = 'Installed $source';
        _progress = 1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Switched to $source')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _status = 'Install failed';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
        await _refresh();
      }
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
    final percent = (_progress * 100).clamp(0, 100).toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('iOS CoreML Debug'),
        actions: [
          IconButton(
            onPressed: _busy ? null : () => unawaited(_refresh()),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Debug builds only. Release/TestFlight always use production catalog.json.\n'
            'After this fix you must FULL REBUILD (not hot restart): stop app → '
            'flutter clean && flutter run',
            style: theme.textTheme.bodySmall,
          ),
          if (!_overrideAllowed) ...[
            const SizedBox(height: 12),
            Material(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'overrideAllowed=false — Official/DIY switch cannot work until '
                  'you rebuild the native Debug binary.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text('Status', style: theme.textTheme.titleSmall),
          Text(_status),
          const SizedBox(height: 8),
          Text('Download progress: $percent%'),
          LinearProgressIndicator(
            value: (_busy && _progress <= 0) ? null : _progress.clamp(0.0, 1.0),
          ),
          const SizedBox(height: 20),
          Text('Install model', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          ..._options.map((opt) {
            final (value, label) = opt;
            final selected = _source == value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: FilledButton.tonal(
                onPressed: (_busy || !_overrideAllowed)
                    ? null
                    : () => unawaited(_install(value)),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: selected
                      ? theme.colorScheme.primaryContainer
                      : null,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    selected ? '● $label' : '○ $label',
                  ),
                ),
              ),
            );
          }),
          if (_info.isNotEmpty) ...[
            const SizedBox(height: 16),
            SelectableText(
              _info.entries.map((e) => '${e.key}: ${e.value}').join('\n'),
              style: theme.textTheme.bodySmall,
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(
              _error!,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ],
        ],
      ),
    );
  }
}
