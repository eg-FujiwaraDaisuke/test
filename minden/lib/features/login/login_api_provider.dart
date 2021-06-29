import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:minden/features/login/data/model/user.dart';
import 'dart:convert' as convert;

import 'package:minden/features/login/presentation/bloc/login_bloc.dart';

// ログイン検証用コード
class LoginApiProvider {
  final _url =
      'https://bgzprevlv9.execute-api.ap-northeast-1.amazonaws.com/dev/auth';
  final _headers = {
    'content-type': 'application/json',
    'x-client-id': '5vf80b3tln2q7ge87af1vtcutc'
  };
  final client = http.Client();

  Future<User> fetchUserData(
      {required String id, required String password}) async {
    try {
      final body = json.encode({'loginId': id, 'password': password});
      final url = Uri.parse(_url);
      final response = await client.post(url, headers: _headers, body: body);

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

// curl -v -X POST -H 'x-client-id:5vf80b3tln2q7ge87af1vtcutc' -H 'accept:application/json'  -H "Content-Type: application/json" -d '{"loginId":"nakajo@minden.co.jp", "password":"1234qwer"}' https://bgzprevlv9.execute-api.ap-northeast-1.amazonaws.com/dev/auth
