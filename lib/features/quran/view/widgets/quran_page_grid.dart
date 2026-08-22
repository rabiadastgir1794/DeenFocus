import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 604-page Mushaf grid with calendar-style cumulative read progress.
class QuranPageGrid extends StatelessWidget {
  const QuranPageGrid({
    super.key,
    required this.totalPages,
    required this.highestCompletedPage,
    required this.onPageTap,
  });

  final int totalPages;
  final int highestCompletedPage;
  final ValueChanged<int> onPageTap;

  static const _columns = 5;

  /// Grid as a [SliverGrid] for embedding in a parent [CustomScrollView].
  Widget buildSliver() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _columns,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 0,
        childAspectRatio: 1.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final page = index + 1;
          return _PageCell(
            page: page,
            highestCompletedPage: highestCompletedPage,
            columns: _columns,
            onTap: () => onPageTap(page),
          );
        },
        childCount: totalPages,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Page numbers run left→right; keep LTR so start/end circles don't flip.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: GridView.builder(
        padding: EdgeInsets.only(bottom: 8.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _columns,
          mainAxisSpacing: 8.h,
          crossAxisSpacing: 0,
          childAspectRatio: 1.0,
        ),
        itemCount: totalPages,
        itemBuilder: (context, index) {
          final page = index + 1;
          return _PageCell(
            page: page,
            highestCompletedPage: highestCompletedPage,
            columns: _columns,
            onTap: () => onPageTap(page),
          );
        },
      ),
    );
  }
}

class _PageCell extends StatelessWidget {
  const _PageCell({
    required this.page,
    required this.highestCompletedPage,
    required this.columns,
    required this.onTap,
  });

  final int page;
  final int highestCompletedPage;
  final int columns;
  final VoidCallback onTap;

  bool get _inRange =>
      highestCompletedPage > 0 && page <= highestCompletedPage;
  bool get _isStart => _inRange && page == 1;
  bool get _isEnd =>
      _inRange && page == highestCompletedPage && highestCompletedPage > 1;
  bool get _isSingle => _inRange && highestCompletedPage == 1;

  BorderRadius _stripRadius(int col) {
    final isFirstCol = col == 0;
    final isLastCol = col == columns - 1;
    // Round at row edges and at the range start/end (mid-row end gets a pill tip).
    final roundLeft = isFirstCol || _isStart;
    final roundRight = isLastCol || _isEnd;
    return BorderRadius.horizontal(
      left: Radius.circular(roundLeft ? 999.r : 0),
      right: Radius.circular(roundRight ? 999.r : 0),
    );
  }

  Widget _circle(ColorScheme colorScheme, double size) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$page',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rangeFill = isDark
        ? colorScheme.primary.withValues(alpha: 0.2)
        : colorScheme.primary.withValues(alpha: 0.14);

    if (!_inRange) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Center(
            child: Text(
              '$page',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
          ),
        ),
      );
    }

    final col = (page - 1) % columns;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cellSize = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;
        final circleSize = cellSize * 0.68;
        final stripHeight = circleSize * 0.78;

        if (_isSingle) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(),
              child: Center(child: _circle(colorScheme, circleSize)),
            ),
          );
        }

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: stripHeight,
                      decoration: BoxDecoration(
                        color: rangeFill,
                        borderRadius: _stripRadius(col),
                      ),
                    ),
                  ),
                  // Start circle — flush to left edge of the strip.
                  if (_isStart)
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Center(child: _circle(colorScheme, circleSize)),
                    ),
                  // End circle — flush to right edge of the strip.
                  if (_isEnd)
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Center(child: _circle(colorScheme, circleSize)),
                    ),
                  // Middle pages — number only.
                  if (!_isStart && !_isEnd)
                    Center(
                      child: Text(
                        '$page',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
