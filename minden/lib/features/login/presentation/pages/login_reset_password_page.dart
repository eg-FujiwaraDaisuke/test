import 'package:flutter/material.dart';
import 'package:minden/core/util/string_util.dart';
import '../../../../utile.dart';

class LoginResetPasswordPage extends StatefulWidget {
  @override
  _LoginResetPasswordPageState createState() => _LoginResetPasswordPageState();
}

class _LoginResetPasswordPageState extends State<LoginResetPasswordPage> {
  String _inputPassword = '';
  String _reinputPassword = '';

  bool _isShowInputPassword = false;
  bool _isShowReinputPassword = false;

  void _onInputChangedPassword(value) {
    setState(() {
      _inputPassword = value;
    });
  }

  void _onReInputChangedPassword(value) {
    setState(() {
      _reinputPassword = value;
    });
  }

  void _onShowInputPassword() {
    setState(() {
      _isShowInputPassword = !_isShowInputPassword;
    });
  }

  void _onShowReinputPassword() {
    setState(() {
      _isShowReinputPassword = !_isShowReinputPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
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
                height: 34,
              ),
              PasswordInput(
                hintText: i18nTranslate(context, 'reset_password_hint_text'),
                isShowPassword: _isShowInputPassword,
                onChanged: _onInputChangedPassword,
                onShowPassword: _onShowInputPassword,
              ),
              SizedBox(
                height: 20,
              ),
              PasswordInput(
                hintText: i18nTranslate(context, 'reset_password_re_input'),
                isShowPassword: _isShowReinputPassword,
                onChanged: _onReInputChangedPassword,
                onShowPassword: _onShowReinputPassword,
              ),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  // TODO 設定を完了する
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
                      i18nTranslate(context, 'profile_setting_complete'),
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

class PasswordInput extends StatelessWidget {
  final isShowPassword;
  final hintText;
  final Function onChanged;
  final Function onShowPassword;

  PasswordInput(
      {required this.isShowPassword,
      required this.onChanged,
      required this.onShowPassword,
      required this.hintText})
      : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          onChanged: (value) {
            onChanged(value);
          },
          obscureText: !isShowPassword,
          decoration: InputDecoration(
            hintText: hintText,
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
              icon: Icon(
                isShowPassword
                    ? Icons.visibility
                    : Icons.visibility_off_outlined,
                color: Color(0xFFA7A7A7),
              ),
              onPressed: () {
                onShowPassword();
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
