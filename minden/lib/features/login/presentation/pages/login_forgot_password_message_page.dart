import 'package:flutter/material.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/utile.dart';

class LoginForgotPasswordMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                i18nTranslate(context, 'forgot_reset_send_mail'),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 17.0,
                    color: Color(0xFF787877),
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w700,
                    height: calcFontHeight(lineHeight: 24.62, fontSize: 17)),
              ),
              SizedBox(
                height: 38,
              ),
              Image.asset(
                'assets/images/login/chara.png',
                width: 140,
                height: 140,
              )
            ],
          ),
        ),
      ),
    );
  }
}
