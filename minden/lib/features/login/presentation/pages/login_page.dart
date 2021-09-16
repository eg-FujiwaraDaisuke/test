import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/features/login/presentation/bloc/login_bloc.dart';
import 'package:minden/features/login/presentation/pages/login_input_page.dart';
import 'package:minden/features/profile_setting/presentation/pages/profile_setting_name_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider.value(
      value: BlocProvider.of<LoginBloc>(context),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            Loading.show(context);
            return;
          }
          Loading.hide();

          if (state is LoginLoaded) {
            // TODO ユーザー情報の設定が完了してるかのフラグをみて遷移先を変更する
            final route = NoAnimationMaterialPageRoute(
              builder: (context) => ProfileSettingNamePage(),
              settings: const RouteSettings(name: '/profileSetting/name'),
            );
            Navigator.push(context, route);
            return;
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is LoginInitial) {
              return _buildInitialInput(isError: false);
            } else if (state is LoginError) {
              return _buildInitialInput(isError: true);
            }
            return _buildInitialInput(isError: false);
          },
        ),
      ),
    ));
  }

  Widget _buildInitialInput({
    required bool isError,
  }) {
    return LoginInputPage(isError: isError);
  }
}
