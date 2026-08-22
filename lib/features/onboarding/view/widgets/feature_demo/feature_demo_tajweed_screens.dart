import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../../core/constants/spacing.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../quran/reading_engine/quran_transliteration.dart';
import '../../../../quran/reading_engine/reading_mode.dart';
import '../../../../quran/view/widgets/continue_reading_card.dart';
import '../../../../quran/view/widgets/quran_reading_mode_tabs.dart';
import '../../../../quran/view/widgets/tajweed_legend_row.dart';
import '../../../../tajweed/model/tajweed_models.dart';
import '../../../../tajweed/view/widgets/tajweed_mic_button.dart';
import '../../../../tajweed/view/widgets/tajweed_waveform.dart';
import '../demo_guide/demo_guide_arrow.dart';
import 'feature_demo_controller.dart';
import 'feature_demo_tajweed_sample.dart';

part 'feature_demo_tajweed_chrome.dart';
part 'feature_demo_tajweed_quran.dart';
part 'feature_demo_tajweed_surah.dart';
part 'feature_demo_tajweed_download.dart';
part 'feature_demo_tajweed_practice.dart';
part 'feature_demo_tajweed_result.dart';
