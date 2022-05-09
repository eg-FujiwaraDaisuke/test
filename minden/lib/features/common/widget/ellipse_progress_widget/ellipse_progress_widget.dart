import 'dart:math';

import 'package:flutter/material.dart';

/// 楕円の円周に沿って線が伸びる形のグラフ
/// 0(楕円右)から時計回りに線が伸びる
class EllipseProgressWidget extends StatelessWidget {
  const EllipseProgressWidget({
    required this.progress,
    this.backgroundColor = Colors.white,
    required this.strokeColor,
    required this.strokeWidth,
    this.delay = Duration.zero,
    required this.duration,
  });

  /// 0 ~ 1
  final double progress;
  final Color backgroundColor;
  final Color strokeColor;
  final double strokeWidth;
  /// 線が伸びるアニメーションを開始するタイミング
  final Duration delay;
  /// 線が伸びるアニメーションの字間
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Future(() async {
        await Future.delayed(delay);
        return true;
      }),
      builder: (context, snapshot) {
        if (snapshot.data != true) {
          return Container();
        }
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: progress),
          duration: duration,
          builder: (context, value, child) {
            return CustomPaint(
              key: ValueKey(value),
              painter: _EllipseProgressPainter(
                sweepAngle: value * 2 * pi,
                backgroundColor: backgroundColor,
                strokeColor: strokeColor,
                strokeWidth: strokeWidth,
              ),
            );
          },
        );
      },
    );
  }
}

class _EllipseProgressPainter extends CustomPainter {
  _EllipseProgressPainter({
    required this.sweepAngle,
    required this.backgroundColor,
    required this.strokeColor,
    required this.strokeWidth,
  });

  final double sweepAngle;
  final Color backgroundColor;
  final Color strokeColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..drawOval(
          Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: size.width - strokeWidth,
            height: size.height - strokeWidth,
          ),
          Paint()..color = backgroundColor)
      ..drawArc(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: size.width - strokeWidth,
          height: size.height - strokeWidth,
        ),
        0,
        sweepAngle,
        false,
        Paint()
          ..color = strokeColor
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
      );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
