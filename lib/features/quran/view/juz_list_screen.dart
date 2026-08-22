import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../data/quran_local_repository.dart';
import '../reading_engine/mushaf_metadata.dart';
import 'juz_reading_screen.dart';
import 'quran_reading_settings_launcher.dart';

/// Lists all 30 Juz (Phase 1 — Juz View). Tapping one opens
/// [JuzReadingScreen] scoped to that Juz's ayah range.
class JuzListScreen extends StatefulWidget {
  const JuzListScreen({super.key});

  @override
  State<JuzListScreen> createState() => _JuzListScreenState();
}

class _JuzListScreenState extends State<JuzListScreen> {
  bool _loading = true;
  List<JuzInfo> _juzList = const <JuzInfo>[];
  Map<int, String> _surahNames = const <int, String>{};
  int? _lastOpenedJuz;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final results = await Future.wait<Object?>([
      MushafMetadata.load(),
      QuranLocalRepository.instance.getSurahs(),
      StorageService.quranLastJuz,
    ]);
    if (!mounted) return;
    final metadata = results[0] as MushafMetadata;
    final surahs = results[1] as List<SurahSummary>;
    setState(() {
      _juzList = metadata.juzList;
      _surahNames = {for (final s in surahs) s.number: s.name};
      _lastOpenedJuz = results[2] as int?;
      _loading = false;
    });
  }

  Future<void> _openJuz(int juzNumber) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => JuzReadingScreen(juzNumber: juzNumber),
      ),
    );
    if (!mounted) return;
    final last = await StorageService.quranLastJuz;
    if (mounted) setState(() => _lastOpenedJuz = last);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.quranModeJuz,
        actions: [
          QuranReadingSettingsLauncher.appBarAction(context),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
              itemCount: _juzList.length,
              separatorBuilder: (_, _) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                final juz = _juzList[index];
                final isLastOpened = juz.number == _lastOpenedJuz;
                return _JuzTile(
                  juz: juz,
                  startSurahName: _surahNames[juz.startSurah] ?? '',
                  endSurahName: _surahNames[juz.endSurah] ?? '',
                  isLastOpened: isLastOpened,
                  onTap: () => _openJuz(juz.number),
                );
              },
            ),
    );
  }
}

class _JuzTile extends StatelessWidget {
  const _JuzTile({
    required this.juz,
    required this.startSurahName,
    required this.endSurahName,
    required this.isLastOpened,
    required this.onTap,
  });

  final JuzInfo juz;
  final String startSurahName;
  final String endSurahName;
  final bool isLastOpened;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final rangeLabel = juz.startSurah == juz.endSurah
        ? '$startSurahName ${juz.startAyah}–${juz.endAyah}'
        : '$startSurahName ${juz.startAyah} – $endSurahName ${juz.endAyah}';

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isLastOpened
              ? colorScheme.primary.withValues(alpha: 0.5)
              : colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  juz.number.toString(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n.quranJuzLabel} ${juz.number}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      rangeLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isLastOpened)
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Icon(
                    Icons.bookmark_rounded,
                    size: 18.sp,
                    color: colorScheme.primary,
                  ),
                ),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
