import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/env/api_config.dart';
import 'package:minden/core/error/exceptions.dart';
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
    required this.secureStorage,
  });

  static const _authPath = '/api/v1/auth/renewToken';

  static const _encryptionKey = 'encryption_key';

  static const _encryptionBox = 'encryption_box';

  static const _appTokenKey = 'app_token_key';

  static const _refreshTokenKey = 'refresh_token_key';

  final http.Client client;

  final FlutterSecureStorage secureStorage;

  @override
  Future<String> getAppToken(bool forceRefresh) async {
    final box = await _getEncryptedBox();

    if (forceRefresh) {
      // 強制再取得
      final String refreshToken = box.get(_refreshTokenKey);
      final token = await requestRefreshToken(refreshToken);

      // 取得したtokenを保持
      await box.putAll({
        _appTokenKey: token.appToken,
        _refreshTokenKey: token.refreshToken,
      });

      return token.appToken;
    } else {
      // ローカルに保持しているAppTokenを取り出す
      final String appToken = box.get(_appTokenKey);
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

  /// 暗号化されたBoxを取得する
  Future<Box> _getEncryptedBox() async {
    final key = await _getEncryptionKey();

    final box = Hive.openBox(
      _encryptionBox,
      encryptionCipher: HiveAesCipher(key),
    );

    return box;
  }

  /// 暗号化鍵を取得する
  /// 初回の場合、生成して返す
  Future<List<int>> _getEncryptionKey() async {
    final hasKey = await secureStorage.containsKey(key: _encryptionKey);

    if (!hasKey) {
      // 初回の場合、生成する
      final key = Hive.generateSecureKey();

      await secureStorage.write(
        key: _encryptionKey,
        value: base64UrlEncode(key),
      );
    }

    final encryptionKey =
        base64Url.decode((await secureStorage.read(key: _encryptionKey))!);

    return encryptionKey;
  }
}
