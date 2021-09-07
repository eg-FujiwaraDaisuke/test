import 'package:flutter/material.dart';
import 'package:minden/features/login/domain/entities/user.dart';

class LoginUserPage extends StatelessWidget {
  final User user;
  const LoginUserPage({required this.user}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login_user_page'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          child: ListView(
            children: [
              Text('userId : ${user.profile.userId}'),
            ],
          ),
        ),
      ),
    );
  }
}
