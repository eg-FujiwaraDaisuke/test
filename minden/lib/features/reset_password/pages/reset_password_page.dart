import 'package:flutter/material.dart';
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/common/widget/button/button_size.dart';
import 'package:minden/utile.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  String _decideCode = '';
  String _inputPassword = '';
  String _reinputPassword = '';

  bool _isShowInputPassword = false;
  bool _isShowReinputPassword = false;

  @override
  void initState() {
    super.initState();
    final newPas = '1';
    RegExp reg = RegExp(r'^([0-9a-zA-Z]{8,})+$');
    print(reg.hasMatch(newPas));
  }

  void _onInputChangedDecideCode(value) {
    setState(() {
      _decideCode = value;
    });
  }

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
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                i18nTranslate(context, 'forgot_password_reset'),
                style: const TextStyle(
                  color: Color(0xFF575292),
                  fontSize: 20,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              DecideCodeInput(
                hintText: i18nTranslate(context, 'reset_password_decide_code'),
                onChanged: _onInputChangedDecideCode,
              ),
              const SizedBox(
                height: 47,
              ),
              PasswordInput(
                hintText: i18nTranslate(context, 'reset_password_hint_text'),
                isShowPassword: _isShowInputPassword,
                onChanged: _onInputChangedPassword,
                onShowPassword: _onShowInputPassword,
              ),
              const SizedBox(
                height: 20,
              ),
              PasswordInput(
                hintText: i18nTranslate(context, 'reset_password_re_input'),
                isShowPassword: _isShowReinputPassword,
                onChanged: _onReInputChangedPassword,
                onShowPassword: _onShowReinputPassword,
              ),
              const SizedBox(
                height: 50,
              ),
              Button(
                  onTap: () {
                    // TODO ここでパスワード変更APIを叩く
                    logD(_decideCode);
                  },
                  text: i18nTranslate(context, 'profile_setting_complete'),
                  size: ButtonSize.L)
            ],
          ),
        ),
      ),
    );
  }
}

class DecideCodeInput extends StatelessWidget {
  const DecideCodeInput({
    required this.onChanged,
    required this.hintText,
  }) : super();

  final String hintText;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hintText,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6A6F7D),
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          onChanged: (value) {
            onChanged(value);
          },
          decoration: const InputDecoration(
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFFF8C00),
              ),
            ),
            border: OutlineInputBorder(),
            fillColor: Colors.white,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 15,
            ),
          ),
          style: const TextStyle(
            fontSize: 17,
            color: Color(0xFF000000),
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput(
      {required this.isShowPassword,
      required this.onChanged,
      required this.onShowPassword,
      required this.hintText})
      : super();
  final bool isShowPassword;
  final String hintText;
  final Function onChanged;
  final Function onShowPassword;

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
                color: const Color(0xFFA7A7A7).withOpacity(0.5),
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFFF8C00),
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isShowPassword
                    ? Icons.visibility
                    : Icons.visibility_off_outlined,
                color: const Color(0xFFA7A7A7),
              ),
              onPressed: () {
                onShowPassword();
              },
            ),
          ),
          style: TextStyle(
            fontSize: 17,
            color: const Color(0xFF000000),
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w500,
            letterSpacing: calcLetterSpacing(letter: 4),
          ),
        ),
      ],
    );
  }
}
