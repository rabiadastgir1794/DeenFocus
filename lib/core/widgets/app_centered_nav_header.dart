import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Back on the start edge, optional trailing controls on the end edge, and a
/// title (and optional subtitle) centered in the bar.
///
/// Both sides are given the same width — the wider control's natural width —
/// so the title stays centered without clipping either side. A fixed fraction
/// of the bar is not wide enough for two actions on phones under ~400dp
/// (the surah reader overflowed by 1.8px at 393pt).
class AppCenteredNavHeader extends StatelessWidget {
  const AppCenteredNavHeader({
    super.key,
    required this.title,
    required this.backLabel,
    required this.onBack,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final String backLabel;
  final VoidCallback onBack;

  /// Optional trailing control (for example a settings action, or a row of
  /// them). It keeps its natural size; [FittedBox] scales it down only when
  /// the bar is narrower than the controls themselves.
  final Widget? trailing;

  bool get _hasSubtitle {
    final value = subtitle;
    return value != null && value.trim().isNotEmpty;
  }

  Widget _backButton(ColorScheme colorScheme) {
    return TextButton.icon(
      onPressed: onBack,
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        visualDensity: VisualDensity.compact,
      ),
      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
      label: Text(
        backLabel,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _fitted(Widget child, AlignmentGeometry alignment) {
    return FittedBox(fit: BoxFit.scaleDown, alignment: alignment, child: child);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: _CenteredNavBar(
          textDirection: Directionality.of(context),
          leading: _fitted(
            _backButton(colorScheme),
            AlignmentDirectional.centerStart,
          ),
          middle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (_hasSubtitle) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    height: 1.2,
                  ),
                ),
              ],
            ],
          ),
          trailing: _fitted(
            trailing ?? const SizedBox.shrink(),
            AlignmentDirectional.centerEnd,
          ),
        ),
      ),
    );
  }
}

/// Gap between a side slot and the title, matching the previous inset.
const double _kTitleGap = 4;

class _CenteredNavBar extends MultiChildRenderObjectWidget {
  _CenteredNavBar({
    required Widget leading,
    required Widget middle,
    required Widget trailing,
    required this.textDirection,
  }) : super(children: <Widget>[leading, middle, trailing]);

  final TextDirection textDirection;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderCenteredNavBar(textDirection: textDirection);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderCenteredNavBar renderObject,
  ) {
    renderObject.textDirection = textDirection;
  }
}

class _NavHeaderParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderCenteredNavBar extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _NavHeaderParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _NavHeaderParentData> {
  _RenderCenteredNavBar({required TextDirection textDirection})
    : _textDirection = textDirection;

  TextDirection _textDirection;
  TextDirection get textDirection => _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _NavHeaderParentData) {
      child.parentData = _NavHeaderParentData();
    }
  }

  RenderBox _childAt(int index) {
    RenderBox? child = firstChild;
    for (var i = 0; i < index; i++) {
      child = childAfter(child!);
    }
    return child!;
  }

  void _position(RenderBox child, double x, double height) {
    final parentData = child.parentData! as _NavHeaderParentData;
    parentData.offset = Offset(x, (height - child.size.height) / 2);
  }

  @override
  void performLayout() {
    final double maxWidth = constraints.maxWidth;
    assert(maxWidth.isFinite, 'AppCenteredNavHeader needs a bounded width.');

    final BoxConstraints loose = BoxConstraints(
      maxWidth: maxWidth,
      maxHeight: constraints.maxHeight,
    );
    final RenderBox leading = _childAt(0);
    final RenderBox middle = _childAt(1);
    final RenderBox trailing = _childAt(2);

    leading.layout(loose, parentUsesSize: true);
    trailing.layout(loose, parentUsesSize: true);

    final double leadingWidth = leading.size.width;
    final double trailingWidth = trailing.size.width;
    final double side = math.max(leadingWidth, trailingWidth);

    late final double leadingSlot;
    late final double trailingSlot;
    late final double middleMax;
    late final double gap;

    if (side * 2 + _kTitleGap * 2 <= maxWidth) {
      // Equal slots keep the title on the bar's center line.
      gap = _kTitleGap;
      leadingSlot = side;
      trailingSlot = side;
      middleMax = maxWidth - side * 2 - gap * 2;
    } else {
      // Narrower than both controls. Keep each at its natural size when
      // possible; FittedBox scales a side only if it still cannot fit.
      gap = 0;
      trailingSlot = math.min(trailingWidth, maxWidth);
      leadingSlot = math.min(
        leadingWidth,
        math.max(0, maxWidth - trailingSlot),
      );
      middleMax = math.max(0, maxWidth - leadingSlot - trailingSlot);
      if (leadingSlot < leadingWidth) {
        leading.layout(
          BoxConstraints(
            maxWidth: leadingSlot,
            maxHeight: constraints.maxHeight,
          ),
          parentUsesSize: true,
        );
      }
      if (trailingSlot < trailingWidth) {
        trailing.layout(
          BoxConstraints(
            maxWidth: trailingSlot,
            maxHeight: constraints.maxHeight,
          ),
          parentUsesSize: true,
        );
      }
    }

    middle.layout(
      BoxConstraints(
        minWidth: middleMax,
        maxWidth: middleMax,
        maxHeight: constraints.maxHeight,
      ),
      parentUsesSize: true,
    );

    final double height = constraints.constrainHeight(
      math.max(
        leading.size.height,
        math.max(middle.size.height, trailing.size.height),
      ),
    );
    size = constraints.constrain(Size(maxWidth, height));

    final bool rtl = textDirection == TextDirection.rtl;
    if (!rtl) {
      _position(leading, 0, height);
      _position(middle, leadingSlot + gap, height);
      _position(trailing, maxWidth - trailing.size.width, height);
    } else {
      _position(trailing, 0, height);
      _position(middle, trailingSlot + gap, height);
      _position(leading, maxWidth - leading.size.width, height);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
