import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/hook/use_analytics.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/common/widget/button/button_size.dart';
import 'package:minden/features/login/presentation/bloc/login_bloc.dart';
import 'package:minden/features/reset_password/pages/forgot_password_page.dart';
import 'package:minden/gen/assets.gen.dart';
import 'package:minden/gen/fonts.gen.dart';
import 'package:minden/utile.dart';

class LoginInputPage extends StatefulWidget {
  LoginInputPage({
    required this.isError,
  });

  bool isError = false;

  @override
  _LoginInputPageState createState() => _LoginInputPageState();
}

class _LoginInputPageState extends State<LoginInputPage> {
  bool _isShowPassword = false;
  String _userLoginId = '';
  String _userLoginPassword = '';

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

  void _onInputChangedPassword(value) {
    setState(() {
      _userLoginPassword = value;
    });
  }

  void _onShowPassword() {
    setState(() {
      _isShowPassword = !_isShowPassword;
    });
  }

  /// ログインボタン押下時の処理
  void _onLogin() {
    useButtonAnalytics(ButtonAnalyticsType.requestLogin);

    BlocProvider.of<LoginBloc>(context).add(
      GetLoginUserEvent(
        _userLoginId,
        _userLoginPassword,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    Assets.images.login.logo,
                    width: 159,
                    height: 45,
                  ),
                  const SizedBox(
                    height: 146,
                  ),
                  Container(
                    width: 339,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EmailInput(
                          onChanged: _onInputChangedId,
                          onReset: _onInputResetId,
                        ),
                        const SizedBox(
                          height: 29,
                        ),
                        PasswordInput(
                          isShowPassword: _isShowPassword,
                          onChanged: _onInputChangedPassword,
                          onShowPassword: _onShowPassword,
                        ),
                        Container(
                          child: widget.isError
                              ? Column(
                                  children: [
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      i18nTranslate(context, 'login_error'),
                                      style: TextStyle(
                                        color: const Color(0xFFFF0000)
                                            .withOpacity(0.6),
                                        fontSize: 12,
                                        fontFamily: FontFamily.notoSansJP,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                )
                              : null,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // パスワードリセットリンク押下
                                  useButtonAnalytics(ButtonAnalyticsType
                                      .navigateResetPassword);

                                  final route = NoAnimationMaterialPageRoute(
                                    builder: (context) => ForgotPasswordPage(),
                                    settings: const RouteSettings(
                                        name: '/forgotPassword'),
                                  );
                                  Navigator.push(context, route);
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                    bottom: BorderSide(
                                      color: Color(0xFFFF8C00),
                                    ),
                                  )),
                                  child: Text(
                                    i18nTranslate(
                                        context, 'login_forgot_password'),
                                    style: TextStyle(
                                      fontSize: 11,
                                      letterSpacing:
                                          calcLetterSpacing(letter: 1),
                                      fontFamily: FontFamily.notoSansJP,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFFFF8C00),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Button(
                          onTap: _onLogin,
                          text: i18nTranslate(context, 'login_login'),
                          size: ButtonSize.L,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmailInput extends StatefulWidget {
  const EmailInput({
    required this.onChanged,
    required this.onReset,
  }) : super();
  final Function onChanged;
  final Function onReset;

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
          style: const TextStyle(
            fontSize: 14.0,
            color: Color(0xFF6A6F7D),
            fontFamily: FontFamily.notoSansJP,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
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
                color: const Color(0xFFA7A7A7).withOpacity(0.5),
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFFF8C00),
              ),
            ),
            suffixIcon: IconButton(
              icon: SvgPicture.asset(
                Assets.images.login.cancel,
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
            fontSize: 17,
            color: const Color(0xFF000000),
            fontFamily: FontFamily.notoSansJP,
            fontWeight: FontWeight.w500,
            letterSpacing: calcLetterSpacing(letter: 4),
          ),
        ),
      ],
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    required this.isShowPassword,
    required this.onChanged,
    required this.onShowPassword,
  }) : super();
  final isShowPassword;
  final Function onChanged;
  final Function onShowPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          i18nTranslate(context, 'login_password'),
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6A6F7D),
            fontFamily: FontFamily.notoSansJP,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 14,
        ),
        TextFormField(
          onChanged: (value) {
            onChanged(value);
          },
          obscureText: !isShowPassword,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFA7A7A7).withOpacity(0.5),
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
                color: Color(0xFFA7A7A7),
              ),
              onPressed: () {
                onShowPassword();
              },
            ),
          ),
          style: TextStyle(
            fontSize: 17,
            color: const Color(0xFF000000),
            fontFamily: FontFamily.notoSansJP,
            fontWeight: FontWeight.w500,
            letterSpacing: calcLetterSpacing(letter: 4),
          ),
        ),
      ],
    );
  }
}
