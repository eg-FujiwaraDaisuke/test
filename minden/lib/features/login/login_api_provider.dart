import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:minden/core/env/config.dart';
import 'package:minden/features/login/data/model/user.dart';
import 'dart:convert' as convert;
import 'package:minden/features/login/presentation/bloc/login_bloc.dart';

// ログイン検証用コード
class LoginApiProvider {
  final _client = http.Client();

  final _loginApiEnvironment = {
    Config.kDevFlavor: {
      'url':
          'https://bgzprevlv9.execute-api.ap-northeast-1.amazonaws.com/dev/auth',
      'headers': {
        'content-type': 'application/json',
        'x-client-id': '5vf80b3tln2q7ge87af1vtcutc'
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

  Future<User> fetchUserData({
    required String id,
    required String password,
  }) async {
    try {
      final body = json.encode({'loginId': id, 'password': password});
      final env = _loginApiEnvironment[Config.getEnvironmentString()];

      final response = await _client.post(Uri.parse(env?['url'] as String),
          headers: env?['headers'] as Map<String, String>, body: body);

      if (response.statusCode != 200) {
        throw LoginError("error");
      }
      return User.fromJson(convert.jsonDecode(response.body));
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      throw LoginError("Exception occured: $error stackTrace: $stacktrace");
    }
  }
}
