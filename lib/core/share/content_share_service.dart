import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_text_theme.dart';
import 'content_share_payload.dart';

/// Captures a learning content card, stamps DeenFocus branding, and opens
/// the native share sheet with a short intro + store link.
class ContentShareService {
  ContentShareService._();

  static const String appIconAsset = 'assets/app_icon.png';

  static const String iosStoreUrl =
      'https://apps.apple.com/pk/app/deen-focused-quran-salah/id6761078270';
  static const String androidStoreUrl =
      'https://play.google.com/store/apps/details?id=com.rnr.deenfocus';
  static const String tagline = 'Quran • Salah • Learn • Grow';

  /// Temporary: both stores until a DeenFocus domain hosts a smart download URL.
  static String get storeLinksBlock =>
      'iOS: $iosStoreUrl\n\nAndroid: $androidStoreUrl';

  static String composeShareMessage(AppLocalizations l10n) {
    return const ContentSharePayload(title: '').buildMessage(
      intro: l10n.contentShareIntro,
      exploreLabel: l10n.contentShareExplore,
      storeLinks: storeLinksBlock,
    );
  }

  static Future<void> shareIntro({required BuildContext context}) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await SharePlus.instance.share(
        ShareParams(text: composeShareMessage(l10n)),
      );
    } catch (_) {
      if (context.mounted) _showFailed(context, l10n);
    }
  }

  static Future<void> shareCard({
    required BuildContext context,
    required GlobalKey boundaryKey,
    required ContentSharePayload payload,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await WidgetsBinding.instance.endOfFrame;
      final png = await _captureBrandedPng(boundaryKey);
      if (png == null) {
        if (context.mounted) _showFailed(context, l10n);
        return;
      }

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/deenfocus-share-${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(png, flush: true);

      final message = composeShareMessage(l10n);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'image/png')],
          text: message,
        ),
      );
    } catch (_) {
      if (context.mounted) _showFailed(context, l10n);
    }
  }

  static void _showFailed(BuildContext context, AppLocalizations l10n) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(content: Text(l10n.contentShareFailed)),
    );
  }

  static Future<Uint8List?> _captureBrandedPng(GlobalKey key) async {
    final context = key.currentContext;
    if (context == null) return null;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderRepaintBoundary) return null;
    if (renderObject.size.isEmpty) return null;

    final ratio = MediaQuery.maybeDevicePixelRatioOf(context) ?? 2.0;
    final pixelRatio = ratio.clamp(2.0, 3.0);
    final card = await renderObject.toImage(pixelRatio: pixelRatio);
    try {
      final logo = await _loadLogo((40 * pixelRatio).round());
      try {
        final composed = await _compose(card, logo, pixelRatio);
        try {
          final byteData = await composed.toByteData(
            format: ui.ImageByteFormat.png,
          );
          return byteData?.buffer.asUint8List();
        } finally {
          composed.dispose();
        }
      } finally {
        logo.dispose();
      }
    } finally {
      card.dispose();
    }
  }

  static Future<ui.Image> _loadLogo(int width) async {
    final data = await rootBundle.load(appIconAsset);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  static Future<ui.Image> _compose(
    ui.Image card,
    ui.Image logo,
    double pixelRatio,
  ) async {
    final pad = 24.0 * pixelRatio;
    final footerH = 72.0 * pixelRatio;
    final width = card.width + pad * 2;
    final height = pad + card.height + footerH + pad;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final bg = Paint()..color = const Color(0xFFFFFDF8);
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), bg);
    canvas.drawImage(card, Offset(pad, pad), Paint());

    final dividerY = pad + card.height;
    canvas.drawLine(
      Offset(pad, dividerY + 8 * pixelRatio),
      Offset(width - pad, dividerY + 8 * pixelRatio),
      Paint()
        ..color = const Color(0x1A000000)
        ..strokeWidth = 1 * pixelRatio,
    );

    final iconSize = 40.0 * pixelRatio;
    final iconX = pad;
    final iconY = dividerY + (footerH - iconSize) / 2 + 4 * pixelRatio;
    final iconRect = Rect.fromLTWH(iconX, iconY, iconSize, iconSize);
    final rrect = RRect.fromRectAndRadius(
      iconRect,
      Radius.circular(10 * pixelRatio),
    );
    canvas.save();
    canvas.clipRRect(rrect);
    paintImage(
      canvas: canvas,
      rect: iconRect,
      image: logo,
      fit: BoxFit.cover,
    );
    canvas.restore();

    final textX = iconX + iconSize + 10 * pixelRatio;
    final textW = width - textX - pad;
    final title = _paragraph(
      text: 'DeenFocus',
      fontSize: 16 * pixelRatio,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF111111),
      width: textW,
    );
    final subtitle = _paragraph(
      text: tagline,
      fontSize: 11 * pixelRatio,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF6B7280),
      width: textW,
    );
    final textBlockH = title.height + 4 * pixelRatio + subtitle.height;
    final textY = iconY + (iconSize - textBlockH) / 2;
    canvas.drawParagraph(title, Offset(textX, textY));
    canvas.drawParagraph(
      subtitle,
      Offset(textX, textY + title.height + 4 * pixelRatio),
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(width.round(), height.round());
    picture.dispose();
    return image;
  }

  static ui.Paragraph _paragraph({
    required String text,
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    required double width,
  }) {
    final builder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        fontFamily: kAppFontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        maxLines: 1,
        ellipsis: '…',
      ),
    )..pushStyle(ui.TextStyle(color: color, fontFamily: kAppFontFamily));
    builder.addText(text);
    final paragraph = builder.build();
    paragraph.layout(ui.ParagraphConstraints(width: width));
    return paragraph;
  }
}
