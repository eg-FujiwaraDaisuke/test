import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/login/login_api.dart';
import 'package:minden/features/login/presentation/pages/login_user_page.dart';
import 'package:minden/utile.dart';

class LoginPage extends StatefulWidget {
  LoginPage() : super();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAutoLogin = false;
  bool isShowPassword = false;
  bool isError = false;
  String userLoginId = '';
  String userLoginPassword = '';

  void onInputChangedId(value) {
    setState(() {
      userLoginId = value;
    });
  }

  void onInputResetId() {
    setState(() {
      userLoginId = '';
    });
  }

  void onInputChangedPassword(value) {
    setState(() {
      userLoginPassword = value;
    });
  }

  void onShowPassword() {
    setState(() {
      isShowPassword = !isShowPassword;
    });
  }

  void login() async {
    final res = await getUserData(id: userLoginId, password: userLoginPassword);

    if (res['statusCode'] == 200) {
      final route = NoAnimationMaterialPageRoute(
        builder: (context) => LoginUserPage(user: res['user']),
        settings: RouteSettings(name: "LoginUserPage"),
      );
      Navigator.pushReplacement(context, route);
    } else {
      setState(() {
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/login/logo.svg',
                width: 159,
                height: 45,
              ),
              SizedBox(
                height: 146,
              ),
              Container(
                width: 339,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EmailInput(
                      onChanged: onInputChangedId,
                      onReset: onInputResetId,
                    ),
                    SizedBox(
                      height: 29,
                    ),
                    PasswordInput(
                      isShowPassword: isShowPassword,
                      onChanged: onInputChangedPassword,
                      onShowPassword: onShowPassword,
                    ),
                    Container(
                      child: isError
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  i18nTranslate(context, 'login_error'),
                                  style: TextStyle(
                                    color: Color(0xFFFF0000).withOpacity(0.6),
                                    fontSize: 12,
                                    fontFamily: 'NotoSansJP',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          : null,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 13.0,
                                  width: 13.0,
                                  child: Checkbox(
                                    activeColor: Color(0xFFFF8C00),
                                    value: isAutoLogin,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isAutoLogin = value ?? false;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  i18nTranslate(context, 'login_auto_login'),
                                  style: TextStyle(
                                    fontSize: 11,
                                    letterSpacing: calcLetterSpacing(letter: 1),
                                    fontFamily: 'NotoSansJP',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // TODO パスワードリセットページに遷移
                              print('パスワードをお忘れですか？');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                bottom: const BorderSide(
                                  color: Color(0xFFFF8C00),
                                  width: 1,
                                ),
                              )),
                              child: Text(
                                i18nTranslate(context, 'login_forgot_password'),
                                style: TextStyle(
                                  fontSize: 11,
                                  letterSpacing: calcLetterSpacing(letter: 1),
                                  fontFamily: 'NotoSansJP',
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFFF8C00),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    GestureDetector(
                      onTap: () {
                        login();
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
                            i18nTranslate(context, 'login_login'),
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
                    SizedBox(
                      height: 27,
                    ),
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // TODO アカウント作成ページに飛ばす
                              print('アカウント作成');
                            },
                            child: Text(
                              i18nTranslate(context, 'login_create_account'),
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'NotoSansJP',
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFF8C00),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 17,
                          ),
                          GestureDetector(
                            onTap: () {
                              // TODO どこかのページに飛ばす
                              print('ログインせずに利用する');
                            },
                            child: Text(
                              i18nTranslate(context, 'login_not_login_use'),
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'NotoSansJP',
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF787877),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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

class PasswordInput extends StatelessWidget {
  final isShowPassword;
  final Function onChanged;
  final Function onShowPassword;

  PasswordInput({
    required this.isShowPassword,
    required this.onChanged,
    required this.onShowPassword,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          i18nTranslate(context, 'login_password'),
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
