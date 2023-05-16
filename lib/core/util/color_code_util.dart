import 'package:flutter/material.dart';

Color getColorFromCode(String colorCode) {
  if (colorCode == '1') {
    return const Color(0xFFFFC2BE);
  }
  if (colorCode == '2') {
    return const Color(0xFFFFCE95);
  }
  if (colorCode == '3') {
    return const Color(0xFFFFFFB2);
  }
  if (colorCode == '4') {
    return const Color(0xFFC0E1FE);
  }
  if (colorCode == '5') {
    return const Color(0xFFB2F1B9);
  }
  return const Color(0xFFFFC2BE);
}
