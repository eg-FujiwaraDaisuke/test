import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/features/login/login_api.dart';
import 'package:minden/utile.dart';

class LoginPage extends StatefulWidget {
  LoginPage() : super();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool checkBox = false;
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

  void getUserData() async {
    final res = await login(id: userLoginId, password: userLoginPassword);
    // print('getUserData:' + res);
    if (res['statusCode'] == 200) {
      print(res['user']);
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
                                  '※メールアドレスまたはパスワードが正しくありません。',
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
                                    value: checkBox,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        checkBox = value ?? false;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  "自動ログインを有効にする",
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
                                'パスワードをお忘れですか？',
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
                      onTap: () async {
                        print('login');
                        getUserData();
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
                            'ログイン',
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
                              'アカウント作成',
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
                              'ログインせずに利用する',
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

class EmailInput extends StatelessWidget {
  final Function onChanged;
  final Function onReset;

  const EmailInput({
    required this.onChanged,
    required this.onReset,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ログインID（メールアドレス）',
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
                onReset();
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
    @required this.isShowPassword,
    required this.onChanged,
    required this.onShowPassword,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'パスワード',
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
                debugPrint('remove');
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
