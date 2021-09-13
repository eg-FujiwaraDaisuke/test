import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class WallPaperPainter extends CustomPainter {
  WallPaperPainter({this.wallPaperImage}) : super();
  ui.Image? wallPaperImage;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(
        0,
        0,
      )
      ..lineTo(
        size.width,
        0,
      )
      ..lineTo(
        size.width,
        size.height - 40,
      )
      ..quadraticBezierTo(
        size.width / 2 + 100,
        size.height,
        size.width / 2,
        size.height,
      )
      ..lineTo(
        size.width / 2,
        size.height,
      )
      ..quadraticBezierTo(
        size.width / 2 - 100,
        size.height,
        0,
        size.height - 40,
      )
      ..lineTo(
        0,
        size.height - 40,
      )
      ..close();

    final paint = Paint()..color = const Color(0xFFFFFB92);

    if (wallPaperImage == null) {
      canvas.drawPath(path, paint);
    } else {
      canvas.drawImage(wallPaperImage!, const Offset(0, 0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
