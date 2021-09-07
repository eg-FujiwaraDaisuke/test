import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/features/login/data/datasources/user_data_source.dart';
import 'package:minden/features/login/data/repositories/login_repository_impl.dart';
import 'package:minden/features/login/domain/usecases/get_login_user.dart';
import 'package:minden/features/login/presentation/bloc/login_bloc.dart';
import 'package:minden/features/login/presentation/pages/login_input_page.dart';
import 'package:minden/features/login/presentation/pages/login_user_page.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage() : super();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _bloc = LoginBloc(
    const LoginInitial(),
    GetLoginUser(
      LoginRepositoryImpl(
        userDataSource: UserDataSourceImpl(client: http.Client()),
      ),
    ),
  );

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider.value(
      value: _bloc,
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            Loading.show(context);
            return;
          }
          Loading.hide();

          if (state is LoginLoaded) {
            final route = NoAnimationMaterialPageRoute(
              builder: (context) => LoginUserPage(
                user: state.user,
              ),
              settings: const RouteSettings(name: '/login/user'),
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
