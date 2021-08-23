import 'package:flutter/material.dart';
import 'package:minden/features/common/widget/button/botton_style.dart';
import 'botton_size.dart';

class Botton extends StatelessWidget {
  Botton({required this.onTap, required this.text, required this.size})
      : super();

  final Function onTap;
  final String text;
  final BottonSize size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          width: bottonStyle[size]!.width,
          height: bottonStyle[size]!.height,
          decoration: BoxDecoration(
            color: Color(0xFFFF8C00),
            borderRadius: BorderRadius.all(
              Radius.circular(bottonStyle[size]!.height * 0.5),
            ),
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomLeft,
              colors: [
                Color(0xFFFF8C00),
                Color(0xFFFFC277),
              ],
              stops: [
                0.0,
                1.0,
              ],
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'NotoSansJP',
                fontWeight: FontWeight.w700,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
