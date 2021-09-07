import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:minden/core/env/api_config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/token/data/datasources/encryption_token_data_source.dart';
import 'package:minden/features/token/data/model/token_model.dart';

abstract class TokenDataSource {
  /// appTokenを取得する
  /// [forceRefresh]を指定した場合、appTokenの期限が切れていない場合もサーバーから再取得する
  Future<String> getAppToken(bool forceRefresh);

  /// [refreshToken] を用いて、新しいappToken, refreshTokenを取得する
  Future<TokenModel> requestRefreshToken(String refreshToken);
}

class TokenDataSourceImpl implements TokenDataSource {
  const TokenDataSourceImpl({
    required this.client,
    required this.encryptionTokenDataSource,
  });

  static const _authPath = '/api/v1/auth/renewToken';

  final http.Client client;

  final EncryptionTokenDataSource encryptionTokenDataSource;

  @override
  Future<String> getAppToken(bool forceRefresh) async {
    if (forceRefresh) {
      // 強制再取得
      final refreshToken = await encryptionTokenDataSource.getRefreshToken();
      final token = await requestRefreshToken(refreshToken);

      // 取得したtokenを保持
      await encryptionTokenDataSource.setAppToken(token.appToken);
      await encryptionTokenDataSource.setAppToken(token.refreshToken);

      return token.appToken;
    } else {
      // ローカルに保持しているAppTokenを取り出す
      final appToken = await encryptionTokenDataSource.getAppToken();
      return appToken;
    }
  }

  /// [refreshToken] を用いて、新しいappToken, refreshTokenを取得する
  @override
  Future<TokenModel> requestRefreshToken(String refreshToken) async {
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
