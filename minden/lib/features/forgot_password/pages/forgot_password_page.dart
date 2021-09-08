import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/core/util/string_util.dart';

import 'package:minden/features/login/presentation/pages/login_page.dart';
import '../../../../utile.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String _userLoginId = '';

  void _onInputChangedId(value) {
    setState(() {
      _userLoginId = value;
    });
  }

  void _onInputResetId() {
    setState(() {
      _userLoginId = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Center(
            child: SvgPicture.asset(
              'assets/images/common/leading_back.svg',
              fit: BoxFit.fill,
              width: 44.0,
              height: 44.0,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 21),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                i18nTranslate(context, 'forgot_password_reset'),
                style: TextStyle(
                  color: Color(0xFF787877),
                  fontSize: 20,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 49,
              ),
              EmailInput(
                onChanged: _onInputChangedId,
                onReset: _onInputResetId,
              ),
              SizedBox(
                height: 43,
              ),
              GestureDetector(
                onTap: () {
                  // TODO リセットリンクを送る
                  final route = NoAnimationMaterialPageRoute(
                    builder: (context) => ForgotPasswordPage(),
                    settings:
                        RouteSettings(name: "/login/forgotPasswordMessage"),
                  );
                  Navigator.pushReplacement(context, route);
                },
                child: Container(
                  width: 399,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFFF8C00),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      i18nTranslate(context, 'forgot_password_send_reset_link'),
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
            ],
          ),
        ),
      ),
    );
  }
}

class EmailInput extends StatefulWidget {
  final Function onChanged;
  final Function onReset;

  const EmailInput({
    required this.onChanged,
    required this.onReset,
  }) : super();

  @override
  _EmailInputState createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          i18nTranslate(context, 'login_id'),
          style: TextStyle(
            fontSize: 14.0,
            color: Color(0xFF6A6F7D),
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 14,
        ),
        TextFormField(
          controller: _controller,
          onChanged: (value) {
            widget.onChanged(value);
          },
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFA7A7A7).withOpacity(0.5),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFFF8C00),
              ),
            ),
            suffixIcon: IconButton(
              icon: SvgPicture.asset(
                'assets/images/login/cancel.svg',
                width: 26,
                height: 26,
              ),
              onPressed: () {
                widget.onReset();
                _controller.clear();
              },
            ),
          ),
          style: TextStyle(
            fontSize: 17.0,
            color: Color(0xFF000000),
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w500,
            letterSpacing: calcLetterSpacing(letter: 4),
          ),
        ),
      ],
    );
  }
}
