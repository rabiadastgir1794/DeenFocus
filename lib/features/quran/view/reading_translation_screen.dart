import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/services/quran_translation_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/superwall/app_superwall.dart';
import '../../../core/superwall/premium_gate.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';

/// Pick, download, and switch Quran translation packs.
///
/// English (`en`) is free. Other languages require an active subscription.
class ReadingTranslationScreen extends StatefulWidget {
  const ReadingTranslationScreen({super.key});

  @override
  State<ReadingTranslationScreen> createState() =>
      _ReadingTranslationScreenState();
}

class _ReadingTranslationScreenState extends State<ReadingTranslationScreen> {
  bool _loading = true;
  List<QuranTranslationOption> _translationOptions =
      const <QuranTranslationOption>[];
  String _selectedTranslation = QuranTranslationService.defaultLanguageCode;
  String? _downloadingLanguage;
  double _downloadProgress = 0;
  StreamSubscription<double>? _downloadProgressSub;

  @override
  void initState() {
    super.initState();
    QuranTranslationService.installationRevision.addListener(
      _onTranslationRevision,
    );
    unawaited(_load());
  }

  @override
  void dispose() {
    QuranTranslationService.installationRevision.removeListener(
      _onTranslationRevision,
    );
    _downloadProgressSub?.cancel();
    super.dispose();
  }

  void _onTranslationRevision() {
    unawaited(_refresh());
  }

  Future<void> _load() async {
    final selected = await StorageService.quranTranslationLanguage;
    if (mounted) setState(() => _selectedTranslation = selected);
    await _refresh();
  }

  Future<void> _refresh() async {
    try {
      final options = await QuranTranslationService.listAvailable(
        forceRefresh: true,
      );
      final selected = await StorageService.quranTranslationLanguage;
      if (!mounted) return;
      setState(() {
        _translationOptions = options;
        _selectedTranslation = selected;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _labelFor(QuranTranslationOption option) {
    final name = option.displayName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return option.languageCode.toUpperCase();
  }

  String? _sizeLabel(QuranTranslationOption option) {
    final bytes = option.approxSizeBytes;
    if (bytes == null || bytes <= 0) return null;
    final mb = bytes / (1024 * 1024);
    if (mb >= 10) return '${mb.round()} MB';
    return '${mb.toStringAsFixed(1)} MB';
  }

  List<QuranTranslationOption> get _installedOptions {
    final installed = _translationOptions
        .where((o) => o.installed)
        .toList(growable: false);
    return [
      ...installed.where((o) => o.languageCode == _selectedTranslation),
      ...installed.where((o) => o.languageCode != _selectedTranslation),
    ];
  }

  List<QuranTranslationOption> get _availableOptions => _translationOptions
      .where((o) => !o.installed)
      .toList(growable: false);

  _TranslationRowStatus _statusFor(QuranTranslationOption option) {
    if (_downloadingLanguage == option.languageCode) {
      return _TranslationRowStatus.downloading;
    }
    if (option.installed) {
      return option.languageCode == _selectedTranslation
          ? _TranslationRowStatus.selected
          : _TranslationRowStatus.installed;
    }
    if (QuranTranslationService.isDefaultLanguage(option.languageCode)) {
      return _TranslationRowStatus.installing;
    }
    return _TranslationRowStatus.download;
  }

  Future<void> _withPremiumIfNeeded(
    QuranTranslationOption option,
    Future<void> Function() action,
  ) async {
    if (!QuranTranslationService.requiresPremium(option.languageCode)) {
      await action();
      return;
    }
    if (!mounted) return;
    await PremiumGate.presentIfNeeded(
      context: context,
      debugContext: 'quran_translation:${option.languageCode}',
      onAccess: () => unawaited(action()),
    );
  }

  Future<void> _selectInstalled(QuranTranslationOption option) async {
    await _withPremiumIfNeeded(option, () async {
      await QuranTranslationService.selectLanguage(option.languageCode);
      if (!mounted) return;
      setState(() => _selectedTranslation = option.languageCode);
    });
  }

  Future<void> _downloadAndSelect(QuranTranslationOption option) async {
    await _withPremiumIfNeeded(option, () async {
      if (_downloadingLanguage != null) return;
      setState(() {
        _downloadingLanguage = option.languageCode;
        _downloadProgress = 0;
      });
      await _downloadProgressSub?.cancel();
      _downloadProgressSub = QuranTranslationService.downloadProgress().listen((
        p,
      ) {
        if (!mounted) return;
        setState(() => _downloadProgress = p);
      });
      try {
        await QuranTranslationService.ensureTranslation(option.languageCode);
        await QuranTranslationService.selectLanguage(option.languageCode);
        if (!mounted) return;
        setState(() {
          _selectedTranslation = option.languageCode;
          _downloadingLanguage = null;
        });
        await _refresh();
      } on QuranTranslationException {
        if (!mounted) return;
        setState(() => _downloadingLanguage = null);
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(
            content: Text(
              'Could not download ${_labelFor(option)}. Try again when online.',
            ),
          ),
        );
      } catch (_) {
        if (!mounted) return;
        setState(() => _downloadingLanguage = null);
      } finally {
        await _downloadProgressSub?.cancel();
        _downloadProgressSub = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(title: l10n.readingSettingsTranslationSection),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ValueListenableBuilder<bool>(
              valueListenable: AppSuperwall.subscriptionActiveNotifier,
              builder: (context, isSubscribed, _) {
                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
                  children: [
                    if (_installedOptions.isNotEmpty) ...[
                      _TranslationSectionHeader(
                        label: l10n.readingSettingsInstalledTranslations,
                      ),
                      _SettingsGroup(
                        children: _rowsFor(
                          _installedOptions,
                          l10n,
                          isSubscribed: isSubscribed,
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                    if (_availableOptions.isNotEmpty) ...[
                      _TranslationSectionHeader(
                        label: l10n.readingSettingsAvailableTranslations,
                      ),
                      _SettingsGroup(
                        children: _rowsFor(
                          _availableOptions,
                          l10n,
                          isSubscribed: isSubscribed,
                        ),
                      ),
                    ],
                    if (_installedOptions.isEmpty &&
                        _availableOptions.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 48.h),
                          child: Text(
                            l10n.readingSettingsTranslationDownloading,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
    );
  }

  List<Widget> _rowsFor(
    List<QuranTranslationOption> options,
    AppLocalizations l10n, {
    required bool isSubscribed,
  }) {
    final rows = <Widget>[];
    for (var i = 0; i < options.length; i++) {
      if (i > 0) rows.add(const _SettingsDivider());
      final option = options[i];
      final locked =
          QuranTranslationService.requiresPremium(option.languageCode) &&
          !isSubscribed;
      rows.add(
        _TranslationOptionRow(
          key: ValueKey<String>(option.packId),
          label: _labelFor(option),
          sizeLabel: _sizeLabel(option),
          status: _statusFor(option),
          progress: _downloadProgress,
          selectedLabel: l10n.readingSettingsTranslationSelected,
          installedLabel: l10n.readingSettingsTranslationInstalled,
          downloadLabel: l10n.readingSettingsTranslationDownload,
          installingLabel: l10n.readingSettingsTranslationInstalling,
          downloadingLabel: l10n.readingSettingsTranslationDownloading,
          showPremiumBadge: locked,
          onSelect: () => unawaited(_selectInstalled(option)),
          onDownload: () => unawaited(_downloadAndSelect(option)),
        ),
      );
    }
    return rows;
  }
}

enum _TranslationRowStatus {
  selected,
  installed,
  downloading,
  installing,
  download,
}

class _TranslationSectionHeader extends StatelessWidget {
  const _TranslationSectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 8.h),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _TranslationOptionRow extends StatelessWidget {
  const _TranslationOptionRow({
    super.key,
    required this.label,
    required this.sizeLabel,
    required this.status,
    required this.progress,
    required this.selectedLabel,
    required this.installedLabel,
    required this.downloadLabel,
    required this.installingLabel,
    required this.downloadingLabel,
    required this.onSelect,
    required this.onDownload,
    this.showPremiumBadge = false,
  });

  final String label;
  final String? sizeLabel;
  final _TranslationRowStatus status;
  final double progress;
  final String selectedLabel;
  final String installedLabel;
  final String downloadLabel;
  final String installingLabel;
  final String downloadingLabel;
  final VoidCallback onSelect;
  final VoidCallback onDownload;
  final bool showPremiumBadge;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = status == _TranslationRowStatus.selected;
    final installed =
        status == _TranslationRowStatus.selected ||
        status == _TranslationRowStatus.installed;

    final VoidCallback? onTap = switch (status) {
      _TranslationRowStatus.installed => onSelect,
      _TranslationRowStatus.download => onDownload,
      _ => null,
    };

    final Widget leading = switch (status) {
      _TranslationRowStatus.selected ||
      _TranslationRowStatus.installed => Icon(
        Icons.check_circle_rounded,
        size: 20.sp,
        color: colorScheme.primary,
      ),
      _TranslationRowStatus.download => Icon(
        showPremiumBadge
            ? Icons.lock_outline_rounded
            : Icons.download_rounded,
        size: 20.sp,
        color: colorScheme.onSurfaceVariant,
      ),
      _TranslationRowStatus.downloading ||
      _TranslationRowStatus.installing => SizedBox(
        width: 20.sp,
        height: 20.sp,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          value: status == _TranslationRowStatus.downloading && progress > 0
              ? progress
              : null,
        ),
      ),
    };

    final Widget trailing = switch (status) {
      _TranslationRowStatus.selected => Text(
        selectedLabel,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
      _TranslationRowStatus.installed => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showPremiumBadge) ...[
            Icon(
              Icons.lock_outline_rounded,
              size: 14.sp,
              color: colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 4.w),
          ],
          Text(
            installedLabel,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
      _TranslationRowStatus.installing => Text(
        installingLabel,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      _TranslationRowStatus.download => Text(
        downloadLabel,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      _TranslationRowStatus.downloading => SizedBox(
        width: 96.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              downloadingLabel,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            SizedBox(height: 4.h),
            LinearProgressIndicator(value: progress > 0 ? progress : null),
            SizedBox(height: 2.h),
            Text(
              '${(progress * 100).clamp(0, 99).round()}%',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    };

    final subtitle = !installed ? sizeLabel : null;

    return Material(
      color: selected
          ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.55)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              leading,
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.22),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 16.w,
      endIndent: 16.w,
      color: Theme.of(context).colorScheme.outlineVariant.withValues(
        alpha: 0.22,
      ),
    );
  }
}
