import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/login/data/model/user_model.dart';

abstract class UserDataSource {
  Future<UserModel> getLoginUser(String id, String password);
}

class UserDataSourceImpl implements UserDataSource {
  final http.Client client;
  UserDataSourceImpl({required this.client});

  @override
  Future<UserModel> getLoginUser(String id, String password) async {
    final body = json.encode({'loginId': id, 'password': password});

    final response = await client.post(
      'https://bgzprevlv9.execute-api.ap-northeast-1.amazonaws.com/dev/auth',
      headers: {
        'content-type': 'application/json',
        'x-client-id': '5vf80b3tln2q7ge87af1vtcutc'
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
