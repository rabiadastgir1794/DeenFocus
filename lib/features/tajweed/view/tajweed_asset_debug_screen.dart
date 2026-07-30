import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/services/tajweed_service.dart';
import '../model/tajweed_models.dart';

/// Temporary Android-only harness to exercise production asset download
/// (`TajweedService.ensureModel` + EventChannel progress) without the real
/// Tajweed UI. Delete this screen (and its Settings entry) once download QA
/// is done — do not evolve it into product UI.
class TajweedAssetDebugScreen extends StatefulWidget {
  const TajweedAssetDebugScreen({super.key});

  @override
  State<TajweedAssetDebugScreen> createState() =>
      _TajweedAssetDebugScreenState();
}

class _TajweedAssetDebugScreenState extends State<TajweedAssetDebugScreen> {
  StreamSubscription<double>? _progressSub;
  bool _installed = false;
  bool _busy = false;
  double _progress = 0;
  String _status = 'Idle';
  String? _error;
  String? _modelPath;
  String? _freeSpace;
  String? _stagingHint;

  @override
  void initState() {
    super.initState();
    assert(
      !kIsWeb && Platform.isAndroid,
      'TajweedAssetDebugScreen is Android-only',
    );
    _progressSub = TajweedService.downloadProgress().listen((p) {
      if (!mounted) return;
      setState(() => _progress = p);
    });
    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
    // ensureModel() refuses when the rollout flag is off.
    await StorageService.setTajweedEnabled(true);
    await _refreshInstalled();
  }

  Future<Directory?> _modelsRoot() async {
    // ModelStore uses Context.getExternalFilesDir(null)/TajweedModels.
    final external = await getExternalStorageDirectory();
    if (external == null) return null;
    return Directory('${external.path}/TajweedModels');
  }

  Future<void> _refreshDiskInfo(Directory? root) async {
    final parent = root?.parent ?? await getExternalStorageDirectory();
    if (parent == null) return;
    try {
      final free = await parent.stat().then((_) async {
        // Stat doesn't give free space; use df via Process on debug only is heavy.
        // Fall back to FileSystemEntity — unavailable on Dart IO. Use a shell-free
        // estimate from the directory's file-system via Process.run('df') is OK
        // for a temporary debug screen.
        final result = await Process.run('df', ['-k', parent.path]);
        final lines = (result.stdout as String).trim().split('\n');
        if (lines.length < 2) return null;
        final parts = lines.last.trim().split(RegExp(r'\s+'));
        // df -k columns: Filesystem, 1K-blocks, Used, Available, Use%, Mounted
        if (parts.length < 4) return null;
        final availKb = int.tryParse(parts[3]);
        if (availKb == null) return null;
        final availMb = availKb / 1024.0;
        return availMb >= 1024
            ? '${(availMb / 1024).toStringAsFixed(2)} GB free'
            : '${availMb.toStringAsFixed(0)} MB free';
      });
      final staging = root == null
          ? null
          : Directory('${root.path}/download-staging');
      final stagingExists = staging != null && await staging.exists();
      if (!mounted) return;
      setState(() {
        _freeSpace = free ?? 'unknown';
        _stagingHint = stagingExists
            ? 'Partial download-staging present (resume possible)'
            : 'No download-staging leftovers';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _freeSpace = 'unknown';
        _stagingHint = null;
      });
    }
  }

  Future<void> _refreshInstalled() async {
    try {
      final available = await TajweedService.isAvailable();
      final root = await _modelsRoot();
      await _refreshDiskInfo(root);
      if (!mounted) return;
      setState(() {
        _installed = available;
        _modelPath = root?.path;
        if (!_busy) {
          _status = available ? 'Model installed' : 'Model not installed';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _installed = false;
        _error = e.toString();
        _status = 'Status check failed';
      });
    }
  }

  Future<void> _ensureModel() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _progress = 0;
      _error = null;
      _status = 'Downloading / verifying…';
    });
    try {
      await TajweedService.ensureModel();
      if (!mounted) return;
      setState(() {
        _status = 'ensureModel() succeeded';
        _progress = 1;
      });
    } on TajweedException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '${e.code}: ${e.message}';
        _status = 'ensureModel() failed'
            '${_progress >= 0.95 ? ' (near end — often disk space during install)' : ''}';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _status = 'ensureModel() failed';
      });
    } finally {
      if (mounted) {
        setState(() => _busy = false);
        await _refreshInstalled();
      }
    }
  }

  Future<void> _deleteModel() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
      _status = 'Deleting installed model…';
    });
    try {
      // Release any open ONNX / file handles before wiping the directory.
      await TajweedService.dispose();
      final root = await _modelsRoot();
      if (root != null && await root.exists()) {
        await root.delete(recursive: true);
      }
      if (!mounted) return;
      setState(() {
        _installed = false;
        _progress = 0;
        _status = 'Model deleted — ready for a fresh ensureModel()';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _status = 'Delete failed';
      });
    } finally {
      if (mounted) {
        setState(() => _busy = false);
        await _refreshInstalled();
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
        title: const Text('Tajweed Asset Debug'),
        actions: [
          IconButton(
            tooltip: 'Refresh status',
            onPressed: _busy ? null : () => unawaited(_refreshInstalled()),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Android-only temporary harness',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Calls production TajweedService.ensureModel() and listens '
                    'to the existing EventChannel for download progress. '
                    'Does not touch the production downloader.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Installed'),
            subtitle: Text(_installed ? 'Yes' : 'No'),
            trailing: Icon(
              _installed ? Icons.check_circle : Icons.cancel_outlined,
              color: _installed ? Colors.green : theme.colorScheme.error,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Status'),
            subtitle: Text(_status),
          ),
          if (_freeSpace != null)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Free space (app files)'),
              subtitle: Text(_freeSpace!),
            ),
          if (_stagingHint != null)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Staging'),
              subtitle: Text(_stagingHint!),
            ),
          if (_modelPath != null)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Model root'),
              subtitle: SelectableText(
                _modelPath!,
                style: theme.textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: 8),
          Text('Download progress: $percent%'),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_busy && _progress <= 0) ? null : _progress.clamp(0.0, 1.0),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(
              _error!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _busy ? null : () => unawaited(_ensureModel()),
            icon: const Icon(Icons.cloud_download_outlined),
            label: Text(_busy ? 'Working…' : 'Ensure model (download)'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _busy || !_installed
                ? null
                : () => unawaited(_deleteModel()),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete installed model'),
          ),
        ],
      ),
    );
  }
}
