import 'package:flutter/material.dart';
import 'package:minden/features/login/domain/entities/user.dart';

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
              Text('accountId : ${user.accountId}'),
              Text('loginId : ${user.loginId}'),
              Text('name : ${user.name}'),
              Text('bio : ${user.bio}'),
              Text('icon : ${user.icon}'),
              Text('wallPaper : ${user.wallPaper}'),
              Text('userId : ${user.userId}'),
            ],
          ),
        ),
      ),
    );
  }
}
