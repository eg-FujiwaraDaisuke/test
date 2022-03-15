import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minden/core/success/account.dart';
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/features/home/presentation/pages/home_page.dart';
import 'package:minden/features/login/presentation/bloc/login_bloc.dart';
import 'package:minden/features/login/presentation/pages/login_input_page.dart';
import 'package:minden/features/profile_setting/presentation/pages/profile_setting_name_page.dart';
import 'package:minden/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  static Route<dynamic> route() {
    return NoAnimationMaterialPageRoute(
      builder: (context) => LoginPage(),
      settings: const RouteSettings(name: LoginPage.routeName),
    );
  }

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
        listener: (context, state) async {
          if (state is LoginLoading) {
            Loading.show(context);
            return;
          }
          Loading.hide();

          if (state is LoginLoaded) {
            await si<Account>().prepare();

            if (state.user.isNewbie) {
              Navigator.push(context, ProfileSettingNamePage.route());
              return;
            } else {
              final sharedPreferences = await SharedPreferences.getInstance();
              await sharedPreferences.setBool('has_profile', true);
            }

            Navigator.pushReplacement(context, HomePage.route());
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
