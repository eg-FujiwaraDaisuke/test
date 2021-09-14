import 'package:flutter/material.dart';

class WallPaperArcPainter extends CustomPainter {
  Color color;
  WallPaperArcPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) async {
    final rightPath = Path()
      ..moveTo(
        size.width,
        size.height - 30,
      )
      ..quadraticBezierTo(
        size.width / 2 + 100,
        size.height,
        size.width / 2,
        size.height,
      )
      ..lineTo(
        size.width,
        size.height,
      )
      ..close();
    final leftPath = Path()
      ..moveTo(
        0,
        size.height - 30,
      )
      ..quadraticBezierTo(
        size.width / 2 - 100,
        size.height,
        size.width / 2,
        size.height,
      )
      ..lineTo(
        0,
        size.height,
      )
      ..close();

    final paint = Paint()..color = color;

    canvas.drawPath(rightPath, paint);
    canvas.drawPath(leftPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
