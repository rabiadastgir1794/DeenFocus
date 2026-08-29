import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'content_share_payload.dart';
import 'content_share_service.dart';

/// Same outlined share glyph used on dua / library cards (`Icons.share_outlined`).
class ShareGlyph extends StatelessWidget {
  const ShareGlyph({super.key, required this.color, this.size = 22});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.share_outlined, size: size, color: color);
  }
}

/// Captures [child] as a branded share image. The share control sits outside
/// the [RepaintBoundary] so it is not in the screenshot.
class ShareableCard extends StatefulWidget {
  const ShareableCard({
    super.key,
    required this.child,
    this.alignment = Alignment.topRight,
    this.padding = const EdgeInsets.all(4),
    this.shareIconSize = 22,
  });

  final Widget child;
  final Alignment alignment;
  final EdgeInsets padding;
  final double shareIconSize;

  @override
  State<ShareableCard> createState() => _ShareableCardState();
}

class _ShareableCardState extends State<ShareableCard> {
  final GlobalKey _boundaryKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final pinBottom = widget.alignment.y > 0;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final horizontalInset = widget.padding.right;
    return Stack(
      children: [
        RepaintBoundary(key: _boundaryKey, child: widget.child),
        Positioned(
          top: pinBottom ? null : widget.padding.top,
          bottom: pinBottom ? widget.padding.bottom : null,
          right: isRtl ? null : horizontalInset,
          left: isRtl ? horizontalInset : null,
          child: CardShareIconButton(
            boundaryKey: _boundaryKey,
            iconSize: widget.shareIconSize,
          ),
        ),
      ],
    );
  }
}

class CardShareIconButton extends StatefulWidget {
  const CardShareIconButton({
    super.key,
    required this.boundaryKey,
    this.iconSize = 22,
    this.color,
    this.circled = false,
  });

  final GlobalKey boundaryKey;
  final double iconSize;
  final Color? color;

  /// Light gray circle matching ayah `_ActionIcon` chrome.
  final bool circled;

  @override
  State<CardShareIconButton> createState() => _CardShareIconButtonState();
}

class _CardShareIconButtonState extends State<CardShareIconButton> {
  bool _sharing = false;

  Future<void> _share() async {
    if (_sharing) return;
    setState(() => _sharing = true);
    try {
      await ContentShareService.shareCard(
        context: context,
        boundaryKey: widget.boundaryKey,
        payload: const ContentSharePayload(title: ''),
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final glyph = ShareGlyph(
      color: widget.color ?? colorScheme.primary,
      size: widget.iconSize,
    );
    final onShare = _sharing ? null : _share;

    if (widget.circled) {
      return Tooltip(
        message: l10n.libraryShare,
        child: Material(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onShare,
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: glyph,
            ),
          ),
        ),
      );
    }

    final compact = widget.iconSize <= 16;

    return IconButton(
      tooltip: l10n.libraryShare,
      visualDensity: VisualDensity.compact,
      padding: compact ? EdgeInsets.zero : const EdgeInsets.all(6),
      constraints: BoxConstraints(
        minWidth: compact ? 20 : 32,
        minHeight: compact ? 20 : 32,
      ),
      style: compact
          ? IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            )
          : null,
      icon: glyph,
      onPressed: onShare,
    );
  }
}
