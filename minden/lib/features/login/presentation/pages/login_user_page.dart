import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/login/presentation/bloc/login_bloc.dart';

class LoginUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login_user_page'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocProvider.value(
            value: BlocProvider.of<LoginBloc>(context),
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoginLoaded) {
                  return ListView(
                    children: [
                      Text('accountId : ${state.user.accountId}'),
                      Text('loginId : ${state.user.loginId}'),
                      Text('name : ${state.user.name}'),
                      Text('bio : ${state.user.bio}'),
                      Text('icon : ${state.user.icon}'),
                      Text('wallPaper : ${state.user.wallPaper}'),
                      Text('userId : ${state.user.userId}'),
                    ],
                  );
                }
                return Container();
              },
            )),
      ),
    );
  }
}
