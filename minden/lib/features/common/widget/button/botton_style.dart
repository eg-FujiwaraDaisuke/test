import 'package:minden/features/common/widget/button/botton_size.dart';

class BottonStyle {
  BottonStyle({required this.width, required this.height});
  final double width;
  final double height;
}

final bottonStyle = {
  BottonSize.S: BottonStyle(width: 180, height: 54),
  BottonSize.M: BottonStyle(width: 399, height: 50),
  BottonSize.L: BottonStyle(width: 399, height: 50),
};
