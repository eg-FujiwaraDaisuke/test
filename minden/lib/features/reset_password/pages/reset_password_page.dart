import 'package:flutter/material.dart';
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/common/widget/button/button_size.dart';
import 'package:minden/features/login/presentation/pages/login_page.dart';
import 'package:minden/features/reset_password/data/datasources/reset_password_repository_datasource.dart';
import 'package:minden/features/reset_password/data/repositories/reset_password_repository_repository_impl.dart';
import 'package:minden/features/reset_password/domain/usecases/reset_password_repository_usecase.dart';
import 'package:minden/features/reset_password/pages/bloc/reset_password_bloc.dart';
import 'package:minden/utile.dart';
import 'package:http/http.dart' as http;

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({required this.loginId});
  final String loginId;
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late UpdatePasswordBloc _updatePasswordBloc;
  String _decideCode = '';
  String _inputPassword = '';
  String _reinputPassword = '';

  bool _isShowInputPassword = false;
  bool _isShowReinputPassword = false;
  bool _isErorr = false;

  @override
  void initState() {
    super.initState();
    _updatePasswordBloc = UpdatePasswordBloc(
      const PasswordInitial(),
      UpdatePassword(
        ResetPasswordRepositoryImpl(
          dataSource: ResetPasswordDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );

    _updatePasswordBloc.stream.listen((event) {
      if (event is PasswordUpdataing) {
        Loading.show(context);
        return;
      }
      Loading.hide();

      if (event is PasswordUpdated) {
        // 変更用のメールアドレスを置くたらログイン画面に飛ばす
        final route = NoAnimationMaterialPageRoute(
          builder: (context) => LoginPage(),
          settings: const RouteSettings(name: '/login'),
        );
        Navigator.pushReplacement(context, route);
      }
      if (event is ResetPasswordError) {
        setState(() {
          _isErorr = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _updatePasswordBloc.close();
    super.dispose();
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
                height: 20,
              ),
              if (_isErorr) const Text('エラー'),
              const SizedBox(
                height: 50,
              ),
              Button(
                  onTap: () {
                    // TODO ここでパスワード変更APIを叩く
                    //英数6桁
                    RegExp codeReg = RegExp(r'^([0-9a-zA-Z]{6,})+$');
                    //英数８文字以上32文字以下、数字または英字最低２つ以上
                    RegExp passwordReg = RegExp(
                        r'^(?=.*?[A-Za-z].*?[A-Za-z])(?=.*?[0-9].*?[0-9])[A-Za-z0-9]{8,32}$');

                    if (codeReg.hasMatch(_decideCode) &&
                        passwordReg.hasMatch(_inputPassword) &&
                        _inputPassword == _reinputPassword &&
                        !widget.loginId.isEmpty) {
                      _updatePasswordBloc.add(UpdatePasswordEvent(
                        loginId: widget.loginId,
                        confirmationCode: _decideCode,
                        newPassword: _inputPassword,
                      ));
                      return;
                    }

                    setState(() {
                      _isErorr = true;
                    });
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
