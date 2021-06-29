import 'package:flutter/material.dart';
import 'package:minden/features/login/data/model/user.dart';

class LoginUserPage extends StatelessWidget {
  final User user;
  const LoginUserPage({required this.user}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('login_user_page'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          child: ListView(
            children: [
              Text('key : ${user.key}'),
              Text('loginId : ${user.loginId}'),
              Text('name : ${user.name}'),
              Text('secret : ${user.secret}'),
              Text('provider : ${user.provider}'),
              Text('service : ${user.service}'),
              Text('email : ${user.email}'),
            ],
          ),
        ),
      ),
    );
  }
}
