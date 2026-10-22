import 'package:deenly/core/widgets/app_centered_nav_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Logical sizes that cover phones, tablets, and both orientations.
const List<Size> _sizes = <Size>[
  Size(320, 568),
  Size(360, 800),
  Size(375, 667),
  Size(390, 844),
  Size(393, 852),
  Size(402, 874),
  Size(430, 932),
  Size(844, 390),
  Size(768, 1024),
  Size(1024, 768),
];

Widget _header({
  String title = "Ali 'Imran",
  String subtitle = "Ali 'Imran • 200 verses",
  String backLabel = 'Back',
  Widget? trailing,
  TextDirection direction = TextDirection.ltr,
  VoidCallback? onBack,
  VoidCallback? onStories,
  VoidCallback? onSettings,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Directionality(
      textDirection: direction,
      child: Scaffold(
        body: AppCenteredNavHeader(
          title: title,
          subtitle: subtitle,
          backLabel: backLabel,
          onBack: onBack ?? () {},
          trailing:
              trailing ??
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onStories ?? () {},
                    icon: const Icon(Icons.auto_stories_rounded),
                  ),
                  IconButton(
                    onPressed: onSettings ?? () {},
                    icon: const Icon(Icons.tune_rounded),
                  ),
                ],
              ),
        ),
      ),
    ),
  );
}

Future<void> _pumpAt(
  WidgetTester tester,
  Size size, {
  double textScale = 1,
  Widget? header,
}) async {
  await tester.binding.setSurfaceSize(size);
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
  await tester.pumpWidget(header ?? _header());
}

void main() {
  testWidgets('two trailing actions fit on a 393pt phone without overflowing', (
    tester,
  ) async {
    var openedStories = false;
    var openedSettings = false;
    var wentBack = false;
    await _pumpAt(
      tester,
      const Size(393, 852),
      header: _header(
        onBack: () => wentBack = true,
        onStories: () => openedStories = true,
        onSettings: () => openedSettings = true,
      ),
    );

    expect(tester.takeException(), isNull);

    final Rect header = tester.getRect(find.byType(AppCenteredNavHeader));
    final Rect stories = tester.getRect(find.byType(IconButton).at(0));
    final Rect settings = tester.getRect(find.byType(IconButton).at(1));
    expect(stories.right, lessThanOrEqualTo(header.right));
    expect(settings.right, closeTo(header.right - 8, 0.5));
    expect(stories.left, greaterThanOrEqualTo(header.left));

    final Rect title = tester.getRect(find.text("Ali 'Imran"));
    expect(title.center.dx, closeTo(header.center.dx, 0.5));

    final Rect subtitle = tester.getRect(find.text("Ali 'Imran • 200 verses"));
    expect(subtitle.center.dx, closeTo(header.center.dx, 0.5));
    expect(title.right, lessThanOrEqualTo(stories.left));

    await tester.tap(find.byIcon(Icons.auto_stories_rounded));
    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.tap(find.text('Back'));
    expect(openedStories, isTrue);
    expect(openedSettings, isTrue);
    expect(wentBack, isTrue);
  });

  testWidgets('title stays centered for every supported size and direction', (
    tester,
  ) async {
    for (final Size size in _sizes) {
      for (final TextDirection direction in TextDirection.values) {
        await _pumpAt(tester, size, header: _header(direction: direction));
        expect(
          tester.takeException(),
          isNull,
          reason: 'overflow at ${size.width}x${size.height} $direction',
        );

        final Rect header = tester.getRect(find.byType(AppCenteredNavHeader));
        final Rect title = tester.getRect(find.text("Ali 'Imran"));
        expect(
          title.center.dx,
          closeTo(header.center.dx, 0.5),
          reason: 'title drift at ${size.width} $direction',
        );

        final Rect settings = tester.getRect(find.byType(IconButton).at(1));
        expect(settings.left, greaterThanOrEqualTo(0));
        expect(settings.right, lessThanOrEqualTo(size.width + 0.1));
      }
    }

    await _pumpAt(tester, const Size(200, 400));
    expect(tester.takeException(), isNull);
    final Rect settings = tester.getRect(find.byType(IconButton).at(1));
    expect(settings.left, greaterThanOrEqualTo(0));
    expect(settings.right, lessThanOrEqualTo(200.1));
  });

  testWidgets('single action and no action keep the title centered', (
    tester,
  ) async {
    await _pumpAt(
      tester,
      const Size(390, 844),
      header: _header(
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.tune_rounded),
        ),
      ),
    );
    Rect header = tester.getRect(find.byType(AppCenteredNavHeader));
    Rect title = tester.getRect(find.text("Ali 'Imran"));
    expect(title.center.dx, closeTo(header.center.dx, 0.5));
    expect(tester.takeException(), isNull);

    await _pumpAt(
      tester,
      const Size(390, 844),
      header: _header(trailing: const SizedBox.shrink()),
    );
    header = tester.getRect(find.byType(AppCenteredNavHeader));
    title = tester.getRect(find.text("Ali 'Imran"));
    expect(title.center.dx, closeTo(header.center.dx, 0.5));
    expect(tester.takeException(), isNull);
  });

  testWidgets('long labels and large text scale do not overflow', (
    tester,
  ) async {
    const String longTitle = 'Al-Mu’minun and a much longer localized title';
    for (final double scale in <double>[1, 1.3, 2]) {
      for (final Size size in <Size>[
        Size(320, 568),
        Size(360, 800),
        Size(393, 852),
        Size(844, 390),
      ]) {
        await _pumpAt(
          tester,
          size,
          textScale: scale,
          header: _header(
            title: longTitle,
            subtitle: 'Zurück • 200 verses in a longer translation',
            backLabel: 'Zurück',
          ),
        );
        expect(
          tester.takeException(),
          isNull,
          reason: 'overflow at ${size.width} textScale $scale',
        );
        expect(
          tester.getSize(find.text(longTitle)).width,
          lessThan(size.width),
        );
      }
    }
  });
}
