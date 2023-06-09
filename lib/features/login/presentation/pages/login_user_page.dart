import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                      Text('userId : ${state.user.profile.userId}'),
                      Text('bio : ${state.user.profile.bio}'),
                      Text('name : ${state.user.profile.name}'),
                      Text('icon : ${state.user.profile.icon}'),
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
