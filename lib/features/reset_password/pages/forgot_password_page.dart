import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/common/widget/button/button_size.dart';
import 'package:minden/features/reset_password/data/datasources/reset_password_repository_datasource.dart';
import 'package:minden/features/reset_password/data/repositories/reset_password_repository_repository_impl.dart';
import 'package:minden/features/reset_password/domain/usecases/reset_password_repository_usecase.dart';
import 'package:minden/features/reset_password/pages/bloc/reset_password_bloc.dart';
import 'package:minden/features/reset_password/pages/forgot_password_message_page.dart';
import 'package:minden/gen/assets.gen.dart';
import 'package:minden/utile.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late ResetPasswordBloc _passwordBloc;
  String _userLoginId = '';
  String _erorrText = '';

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
  void initState() {
    super.initState();
    _passwordBloc = ResetPasswordBloc(
      const PasswordInitial(),
      ResetPassword(
        ResetPasswordRepositoryImpl(
          dataSource: ResetPasswordDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );

    _passwordBloc.stream.listen((event) {
      if (event is ResetPasswordLoading) {
        Loading.show(context);
        return;
      }
      Loading.hide();

      if (event is ResetPasswordLoaded) {
        // 変更用のメールアドレスを置くたらページ遷移
        final route = NoAnimationMaterialPageRoute(
          builder: (context) =>
              ForgotPasswordMessagePage(loginId: _userLoginId),
          settings: const RouteSettings(name: '/login/forgotPasswordMessage'),
        );
        Navigator.pushReplacement(context, route);
      }
      if (event is ResetPasswordError) {
        setState(() {
          _erorrText = event.message;
        });
      }
    });
  }

  @override
  void dispose() {
    _passwordBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Center(
            child: SvgPicture.asset(
              Assets.images.common.leadingBack,
              fit: BoxFit.fill,
              width: 44,
              height: 44,
            ),
          ),
        ),
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
                height: 49,
              ),
              EmailInput(
                onChanged: _onInputChangedId,
                onReset: _onInputResetId,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                _erorrText,
                style: const TextStyle(
                  color: Color(0xFFFF0000),
                  fontSize: 12,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 43,
              ),
              Button(
                onTap: () {
                  _passwordBloc.add(ResetPasswordEvent(loginId: _userLoginId));
                },
                text: i18nTranslate(context, 'forgot_password_send_reset_link'),
                size: ButtonSize.L,
              ),
            ],
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
            fontSize: 14,
            color: Color(0xFF6A6F7D),
            fontFamily: 'NotoSansJP',
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
