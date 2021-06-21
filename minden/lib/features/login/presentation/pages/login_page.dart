import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/utile.dart';

class LoginPage extends StatefulWidget {
  LoginPage() : super();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _checkBox = false;

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
                    EmailInput(),
                    SizedBox(
                      height: 29,
                    ),
                    PasswordInput(),
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
                    SizedBox(
                      height: 21,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Checkbox(
                                  activeColor: Color(0xFFFF8C00),
                                  value: _checkBox,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _checkBox = value ?? false;
                                    });
                                  },
                                ),
                                Text(
                                  "自動ログインを有効",
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
                      onTap: () {
                        print('login');
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

class EmailInput extends StatefulWidget {
  EmailInput({Key? key}) : super(key: key);

  @override
  _EmailInputState createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
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
        TextField(
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
              icon: Icon(Icons.remove),
              onPressed: () {
                debugPrint('remove');
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

class PasswordInput extends StatefulWidget {
  PasswordInput({Key? key}) : super(key: key);

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  var _showPassword = false;
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
        TextField(
          obscureText: !_showPassword,
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
              icon: Icon(Icons.remove),
              onPressed: () {
                debugPrint('remove');
              },
            ),
          ),
          style: TextStyle(
            fontSize: 17.0,
            color: Color(0xFF000000),
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w500,
            letterSpacing: calcLetterSpacing(letter: 400),
          ),
        ),
      ],
    );
  }
}
