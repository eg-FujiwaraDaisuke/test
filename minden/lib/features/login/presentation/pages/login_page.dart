import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/features/login/data/model/user.dart';
import 'package:minden/features/login/login_api_repository.dart';
import 'package:minden/features/login/presentation/bloc/login_bloc.dart';
import 'package:minden/features/login/presentation/pages/login_input_page.dart';
import 'package:minden/features/login/presentation/pages/login_user_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage() : super();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => LoginBloc(LoginInitial(), LoginApiRepository()),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            Loading.show(context);
            return;
          }
          Loading.hide();
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is LoginInitial) {
              return buildInitialInput(isError: false);
            } else if (state is LoginLoaded) {
              return buildUserInfo(state.user);
            } else if (state is LoginError) {
              return buildInitialInput(isError: true);
            }
            return buildInitialInput(isError: false);
          },
        ),
      ),
    ));
  }

  Widget buildInitialInput({required bool isError}) {
    return LoginInputPage(isError: isError);
  }

  Widget buildUserInfo(User user) {
    return LoginUserPage(
      user: user,
    );
  }
}
