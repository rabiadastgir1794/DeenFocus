import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../l10n/app_localizations.dart';
import '../../model/restricted_mode_content.dart';

/// Shared Salah / Child / Night restricted overlay.
class RestrictedModeScreen extends StatelessWidget {
  const RestrictedModeScreen({
    super.key,
    required this.kind,
    required this.onPrimary,
  });

  final RestrictedModeKind kind;
  final VoidCallback onPrimary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final content = RestrictedModeContent.resolve(l10n, kind);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final theme = _RestrictedTheme.of(kind, dark: dark);
    final overlay = theme.isDark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: ColoredBox(
        color: theme.canvasTop,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = _RestrictedScale.fromSize(
              Size(constraints.maxWidth, constraints.maxHeight),
            );
            return DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [theme.canvasTop, theme.canvasBottom],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, scale.gap(4), 20, 16),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                width: scale.hero,
                                height: scale.hero,
                                child: Image.asset(
                                  theme.asset,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                  gaplessPlayback: true,
                                  errorBuilder: (context, error, stackTrace) {
                                    return ColoredBox(
                                      color: theme.canvasTop,
                                      child: Icon(
                                        kind == RestrictedModeKind.night
                                            ? Icons.nightlight_round
                                            : kind == RestrictedModeKind.child
                                            ? Icons.hourglass_bottom
                                            : Icons.mosque_outlined,
                                        size: scale.hero * 0.4,
                                        color: theme.accent,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: scale.gap(8)),
                              Text(
                                content.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: theme.accent,
                                  fontWeight: FontWeight.w800,
                                  fontSize: scale.titleSize,
                                  height: 1.15,
                                ),
                              ),
                              SizedBox(height: scale.gap(10)),
                              Text(
                                content.message,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: theme.body,
                                  fontWeight: FontWeight.w500,
                                  fontSize: scale.bodySize,
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: scale.gap(8)),
                              Text(
                                content.info,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: theme.muted,
                                  fontWeight: FontWeight.w500,
                                  fontSize: scale.captionSize,
                                  height: 1.35,
                                ),
                              ),
                              SizedBox(height: scale.gap(16)),
                              Text(
                                '“${content.quote}”',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: theme.accent,
                                  fontWeight: FontWeight.w700,
                                  fontSize: scale.bodySize,
                                  height: 1.4,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              SizedBox(height: scale.gap(6)),
                              Text(
                                '(${content.quoteSource})',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: theme.muted,
                                  fontWeight: FontWeight.w500,
                                  fontSize: scale.captionSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: scale.ctaHeight,
                        child: FilledButton(
                          onPressed: onPrimary,
                          style: FilledButton.styleFrom(
                            backgroundColor: theme.button,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          child: Text(
                            content.cta,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RestrictedTheme {
  const _RestrictedTheme({
    required this.asset,
    required this.canvasTop,
    required this.canvasBottom,
    required this.accent,
    required this.body,
    required this.muted,
    required this.button,
    required this.isDark,
  });

  final String asset;
  final Color canvasTop;
  final Color canvasBottom;
  final Color accent;
  final Color body;
  final Color muted;
  final Color button;
  final bool isDark;

  factory _RestrictedTheme.of(RestrictedModeKind kind, {required bool dark}) {
    switch (kind) {
      case RestrictedModeKind.child:
        if (dark) {
          return const _RestrictedTheme(
            asset: 'assets/restricted/child.png',
            canvasTop: Color(0xFF0A1812),
            canvasBottom: Color(0xFF12241C),
            accent: Color(0xFFE8F6EE),
            body: Color(0xFFD5E8DC),
            muted: Color(0xFF9BB5A8),
            button: Color(0xFF2A8A5E),
            isDark: true,
          );
        }
        return const _RestrictedTheme(
          asset: 'assets/restricted/child.png',
          canvasTop: Color(0xFFE6F6EC),
          canvasBottom: Color(0xFFF7FCF8),
          accent: Color(0xFF145C40),
          body: Color(0xFF2C3F36),
          muted: Color(0xFF5C7268),
          button: Color(0xFF1A6B4A),
          isDark: false,
        );
      case RestrictedModeKind.salah:
        if (dark) {
          return const _RestrictedTheme(
            asset: 'assets/restricted/salah.png',
            canvasTop: Color(0xFF10180C),
            canvasBottom: Color(0xFF1A2414),
            accent: Color(0xFFE8F2D8),
            body: Color(0xFFD4DEC8),
            muted: Color(0xFFA3B090),
            button: Color(0xFF3D8A4A),
            isDark: true,
          );
        }
        return const _RestrictedTheme(
          asset: 'assets/restricted/salah.png',
          canvasTop: Color(0xFFEAF6DC),
          canvasBottom: Color(0xFFF8FBF2),
          accent: Color(0xFF164A2A),
          body: Color(0xFF2C3A28),
          muted: Color(0xFF5A6B52),
          button: Color(0xFF2D6B3A),
          isDark: false,
        );
      case RestrictedModeKind.night:
        return const _RestrictedTheme(
          asset: 'assets/restricted/night.png',
          canvasTop: Color(0xFF071018),
          canvasBottom: Color(0xFF122033),
          accent: Color(0xFFFFFFFF),
          body: Color(0xFFE8F1F8),
          muted: Color(0xFFC5D4E2),
          button: Color(0xFF4A7BA7),
          isDark: true,
        );
    }
  }
}

class _RestrictedScale {
  const _RestrictedScale({
    required this.hero,
    required this.titleSize,
    required this.bodySize,
    required this.captionSize,
    required this.ctaHeight,
    required this.factor,
  });

  final double hero;
  final double titleSize;
  final double bodySize;
  final double captionSize;
  final double ctaHeight;
  final double factor;

  factory _RestrictedScale.fromSize(Size size) {
    final factor = (size.height / 844).clamp(0.8, 1.0);
    final hero = math.min(size.width * 0.92, size.height * 0.44);
    return _RestrictedScale(
      hero: hero.clamp(280, 400),
      titleSize: 28 * factor,
      bodySize: 16 * factor,
      captionSize: 14 * factor,
      ctaHeight: 54 * factor,
      factor: factor,
    );
  }

  double gap(double base) => base * factor;
}
