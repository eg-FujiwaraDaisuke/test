import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:minden/core/env/api_config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/token/data/model/token_model.dart';

abstract class TokenDataSource {
  Future<TokenModel> getToken(String refreshToken);
}

class TokenDataSourceImpl implements TokenDataSource {
  const TokenDataSourceImpl({required this.client});

  static const _authPath = '/api/v1/auth/renewToken';

  final http.Client client;

  @override
  Future<TokenModel> getToken(String refreshToken) async {
    final body = json.encode({});
    final env = ApiConfig.apiEndpoint();

    final defaultHeaders = env['headers']! as Map<String, String>;
    final headers = {'refreshToken': refreshToken, ...defaultHeaders};

    final response = await client.post(
      Uri.parse((env['url']! as String) + _authPath),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return TokenModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
