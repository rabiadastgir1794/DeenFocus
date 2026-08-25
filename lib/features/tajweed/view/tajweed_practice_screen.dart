import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/superwall/premium_gate.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../model/tajweed_practice_args.dart';
import '../viewmodel/tajweed_practice_view_model.dart';
import 'widgets/tajweed_download_view.dart';
import 'widgets/tajweed_recording_view.dart';
import 'widgets/tajweed_result_view.dart';

/// Production Tajweed practice flow (ADR-006/007 contract, unchanged
/// downloader/native engines): `ensureModel()` -> one-time download screen ->
/// record -> score -> result. All backed by `TajweedPracticeViewModel`.
class TajweedPracticeScreen extends StatefulWidget {
  const TajweedPracticeScreen({super.key, required this.args});

  final TajweedPracticeArgs args;

  @override
  State<TajweedPracticeScreen> createState() => _TajweedPracticeScreenState();
}

class _TajweedPracticeScreenState extends State<TajweedPracticeScreen> {
  late final TajweedPracticeViewModel _viewModel = TajweedPracticeViewModel(
    args: widget.args,
  )..start();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _handleDone() async {
    // Normal ayah practice (mic / Recite button after subscription): just leave.
    if (!widget.args.freePreview) {
      if (context.canPop()) context.pop();
      return;
    }

    // Free "See how it works" demo only: offer the payment screen, then leave.
    var left = false;
    void leaveOnce() {
      if (left || !mounted) return;
      if (!context.canPop()) return;
      left = true;
      context.pop();
    }

    await PremiumGate.presentIfNeeded(
      context: context,
      debugContext: 'tajweed:free_preview_done',
      onAccess: leaveOnce,
    );
    // Non-purchase dismiss / paywall presented: still return to Surah/Settings.
    leaveOnce();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = widget.args.surahName != null
        ? l10n.tajweedPracticeAyahTitle(widget.args.surahName!, widget.args.ref)
        : l10n.tajweedPracticeTitle;

    return ChangeNotifierProvider<TajweedPracticeViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              AppCenteredNavHeader(
                title: title,
                backLabel: l10n.calendarBack,
                onBack: () {
                  if (context.canPop()) context.pop();
                },
              ),
              Expanded(
                child: Consumer<TajweedPracticeViewModel>(
                  builder: (context, viewModel, _) {
                    switch (viewModel.stage) {
                      case TajweedFlowStage.checkingModel:
                        return const Center(child: CircularProgressIndicator());
                      case TajweedFlowStage.downloadingModel:
                      case TajweedFlowStage.downloadFailed:
                        return TajweedDownloadView(viewModel: viewModel);
                      case TajweedFlowStage.recordingReady:
                      case TajweedFlowStage.recording:
                      case TajweedFlowStage.scoring:
                        return TajweedRecordingView(
                          viewModel: viewModel,
                          args: widget.args,
                        );
                      case TajweedFlowStage.result:
                        return TajweedResultView(
                          viewModel: viewModel,
                          args: widget.args,
                          onDone: () => unawaited(_handleDone()),
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
