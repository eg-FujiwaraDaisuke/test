import 'package:flutter/material.dart';
import 'package:minden/features/common/widget/button/button_style.dart';
import 'button_size.dart';

class Button extends StatelessWidget {
  Button(
      {required this.onTap,
      required this.text,
      required this.size,
      this.isActive = true})
      : super();

  final Function onTap;
  final String text;
  final ButtonSize size;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => {
          if (isActive) {onTap()}
        },
        child: Container(
          width: buttonStyle[size]!.width,
          height: buttonStyle[size]!.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(buttonStyle[size]!.height * 0.5),
            ),
            color: isActive ? null : Color(0xFFE0E0E0),
            gradient: isActive
                ? LinearGradient(
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
                  )
                : null,
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
