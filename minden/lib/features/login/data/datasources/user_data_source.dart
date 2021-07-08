import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:minden/core/env/config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/login/data/model/user_model.dart';

abstract class UserDataSource {
  Future<UserModel> getLoginUser(String id, String password);
}

class UserDataSourceImpl implements UserDataSource {
  final http.Client client;
  UserDataSourceImpl({required this.client});

  final _loginApiEnvironment = {
    Config.kDevFlavor: {
      'url': 'https://www.dev.minapp.minden.co.jp',
      'headers': {
        'content-type': 'application/json',
      }
    },
    Config.kStagingFlavor: {
      'url': 'https://www.stg.minapp.minden.co.jp',
      'headers': {
        'content-type': 'application/json',
      }
    },
    Config.isProduct: {
      'url': 'https://www.minapp.minden.co.jp',
      'headers': {
        'content-type': 'application/json',
      }
    }
  };
  final _authEndpoint = '/api/v1/auth';

  @override
  Future<UserModel> getLoginUser(String id, String password) async {
    final env = _loginApiEnvironment[Config.getEnvironmentString()];
    final body = json.encode({'loginId': id, 'password': password});
    final response = await client.post(
      Uri.parse((env?['url'] as String) + _authEndpoint),
      headers: {'content-type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 201) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
