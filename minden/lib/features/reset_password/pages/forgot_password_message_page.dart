import 'package:flutter/material.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/common/widget/button/button_size.dart';
import 'package:minden/features/reset_password/pages/reset_password_page.dart';
import 'package:minden/utile.dart';

class ForgotPasswordMessagePage extends StatelessWidget {
  const ForgotPasswordMessagePage({
    required this.loginId,
  }) : super();
  final String loginId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                i18nTranslate(context, 'forgot_reset_send_mail'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: const Color(0xFF575292),
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w700,
                  height: calcFontHeight(lineHeight: 24.62, fontSize: 17),
                ),
              ),
              const SizedBox(
                height: 38,
              ),
              Image.asset(
                'assets/images/login/chara.png',
                width: 140,
                height: 140,
              ),
              const SizedBox(
                height: 10,
              ),
              Button(
                onTap: () {
                  final route = NoAnimationMaterialPageRoute(
                    builder: (context) => ResetPasswordPage(loginId: loginId),
                    settings: const RouteSettings(name: '/login/resetPassword'),
                  );
                  Navigator.pushReplacement(context, route);
                },
                text: i18nTranslate(context, '次へ'),
                size: ButtonSize.L,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
