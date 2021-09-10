import 'package:minden/features/common/widget/button/button_size.dart';

class ButtonStyle {
  ButtonStyle({required this.width, required this.height});
  final double width;
  final double height;
}

final buttonStyle = {
  ButtonSize.S: ButtonStyle(width: 180, height: 54),
  ButtonSize.M: ButtonStyle(width: 399, height: 50),
  ButtonSize.L: ButtonStyle(width: 399, height: 50),
};
