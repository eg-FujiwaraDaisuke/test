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
      'url': 'https://www.dev.minapp.minden.co.jp/api/v1/auth',
      'headers': {
        'content-type': 'application/json',
      }
    },
    Config.kStagingFlavor: {
      'url':
          'https://pwr8b8ylx4.execute-api.ap-northeast-1.amazonaws.com/stg/auth',
      'headers': {
        'content-type': 'application/json',
        'x-client-id': '215g1bfg97b8shlchhupgklc6h'
      }
    },
    Config.isProduct: {
      'url':
          'https://btzj4dqhvc.execute-api.ap-northeast-1.amazonaws.com/prod/auth',
      'headers': {
        'content-type': 'application/json',
        'x-client-id': '22sem99lu00jv6ilrj1r1ijdko'
      }
    }
  };

  @override
  Future<UserModel> getLoginUser(String id, String password) async {
    final env = _loginApiEnvironment[Config.getEnvironmentString()];
    final body = json.encode({'loginId': id, 'password': password});
    final response = await client.post(
      Uri.parse(env?['url'] as String),
      headers: {'content-type': 'application/json'},
      body: body,
    );
    print(env);
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 201) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
