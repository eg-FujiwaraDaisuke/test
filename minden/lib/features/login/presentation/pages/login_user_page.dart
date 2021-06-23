import 'package:flutter/material.dart';

class LoginUserPage extends StatelessWidget {
  final Map<dynamic, dynamic> user;
  const LoginUserPage({required this.user}) : super();

  @override
  Widget build(BuildContext context) {
    print(user);
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Text('key : ${user['key']}'),
            Text('loginId : ${user['loginId']}'),
            Text('name : ${user['name']}'),
            Text('secret : ${user['secret']}'),
            Text('provider : ${user['provider']}'),
            Text('service : ${user['service']}'),
            Text('email : ${user['email']}'),
          ],
        ),
      ),
    );
  }
}

// {key: 20190707085551963zhayz, loginId: nakajo@minden.co.jp, name: ï¿½Ýï¿½È@ï¿½dï¿½ï¿½, secret: 20000102, provider: MINDEN, service: portal, email: nakajo@minden.co.jp}
