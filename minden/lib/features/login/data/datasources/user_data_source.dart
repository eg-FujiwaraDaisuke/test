import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:minden/core/env/api_config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/features/login/data/model/user_model.dart';
import 'package:minden/features/token/data/datasources/encryption_token_data_source.dart';
import 'package:minden/injection_container.dart';

abstract class UserDataSource {
  Future<UserModel> getLoginUser(String id, String password);
}

class UserDataSourceImpl implements UserDataSource {
  UserDataSourceImpl({required this.client});

  final http.Client client;

  final _authPath = '/api/v1/auth';

  @override
  Future<UserModel> getLoginUser(String id, String password) async {
    final body = json.encode({'loginId': id, 'password': password});
    final endpoint = ApiConfig.apiEndpoint();

    final response = await client.post(
      Uri.parse(endpoint + _authPath),
      headers: ApiConfig.contentTypeHeaderApplicationJson,
      body: body,
    );

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final tokenElement = json.decode(responseBody);
      await si<EncryptionTokenDataSourceImpl>()
          .setAppToken(tokenElement['appToken']);
      await si<EncryptionTokenDataSourceImpl>()
          .setRefreshToken(tokenElement['refreshToken']);

      logD('${json.decode(responseBody)}');
      final user = UserModel.fromJson(json.decode(responseBody));
      logD('login : ${user.toJson()}');
      await si<EncryptionTokenDataSourceImpl>()
          .storeUser(json.encode(user.toJson()));
      return user;
    } else {
      throw ServerException();
    }
  }
}
