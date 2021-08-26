import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:minden/core/env/api_config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/login/data/model/user_model.dart';

abstract class UserDataSource {
  Future<UserModel> getLoginUser(String id, String password);
}

class UserDataSourceImpl implements UserDataSource {
  final http.Client client;
  UserDataSourceImpl({required this.client});

  final _authPath = '/api/v1/auth';

  @override
  Future<UserModel> getLoginUser(String id, String password) async {
    final body = json.encode({'loginId': id, 'password': password});
    final env = ApiConfig.apiEndpoint();

    final response = await client.post(
      Uri.parse((env['url'] as String) + _authPath),
      headers: env['headers'] as Map<String, String>,
      body: body,
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
