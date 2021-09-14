import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/env/api_config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/success/account.dart';
import 'package:minden/features/token/data/datasources/encryption_token_data_source.dart';
import 'package:minden/features/token/data/model/token_model.dart';

import '../../../../injection_container.dart';

final tokenDataSourceProvider = Provider<TokenDataSource>((ref) =>
    TokenDataSourceImpl(
        client: http.Client(),
        encryptionTokenDataSource:
            ref.read(encryptionTokenDataSourceProvider)));

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

      await si<Account>().prepare();

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
    final endpoint = ApiConfig.apiEndpoint();

    final headers = {
      'refreshToken': refreshToken,
      ...ApiConfig.contentTypeHeaderApplicationXFormUrlEncoded
    };

    print("### ${headers}");

    final response = await client.get(
      Uri.parse(endpoint + _authPath),
      headers: headers,
    );

    print("### token response ${response.statusCode} ${response.body}");

    if (response.statusCode == 200) {
      return TokenModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
