import 'package:flutter/material.dart';

/// Tab用のカスタムインジケーター
class TabIndicator extends Decoration {
  final double indicatorHeight;
  final double indicatorWidth;
  final Color indicatorColor;

  const TabIndicator({
    this.indicatorHeight = 3,
    this.indicatorWidth = 24,
    this.indicatorColor = const Color(0xFFFF8C00),
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _TabIndicatorPaint(this, onChanged);
  }
}

class _TabIndicatorPaint extends BoxPainter {
  final TabIndicator decoration;

  _TabIndicatorPaint(
    this.decoration,
    VoidCallback? onChanged,
  ) : super(onChanged);

  @override
  void paint(
    Canvas canvas,
    Offset offset,
    ImageConfiguration configuration,
  ) {
    final size = configuration.size;

    if (size != null) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
            _generateRect(offset, size),
            Radius.circular(8),
          ),
          _generatePaint());
    }
  }

  /// タブの左右中央に、幅固定のインジケーターを表示する
  Rect _generateRect(Offset offset, Size size) {
    return Offset(
          offset.dx + (size.width - decoration.indicatorWidth) / 2,
          size.height - decoration.indicatorHeight,
        ) &
        Size(
          decoration.indicatorWidth,
          decoration.indicatorHeight,
        );
  }

  Paint _generatePaint() {
    final Paint paint = Paint();
    paint.color = decoration.indicatorColor;
    paint.style = PaintingStyle.fill;

    return paint;
  }
}
