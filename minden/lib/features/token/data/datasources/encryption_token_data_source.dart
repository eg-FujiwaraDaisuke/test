import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:minden/features/login/domain/entities/user.dart';

/// 暗号化して保存しているTokenを提供するDataSource
abstract class EncryptionTokenDataSource {
  Future<String> getAppToken();

  Future<String> getRefreshToken();

  Future<String> restoreUser();

  Future<void> setAppToken(String appToken);

  Future<void> setRefreshToken(String refreshToken);

  Future<void> storeUser(String userJson);
}

class EncryptionTokenDataSourceImpl implements EncryptionTokenDataSource {
  const EncryptionTokenDataSourceImpl({
    required this.secureStorage,
  });

  static const _encryptionKey = 'encryption_key';

  static const _encryptionBox = 'encryption_box';

  static const _appTokenKey = 'app_token_key';

  static const _refreshTokenKey = 'refresh_token_key';

  static const _userKey = 'user_key';

  final FlutterSecureStorage secureStorage;

  @override
  Future<String> getAppToken() async {
    final box = await _getEncryptedBox();
    final String appToken = box.get(_appTokenKey);
    return appToken;
  }

  @override
  Future<String> getRefreshToken() async {
    final box = await _getEncryptedBox();
    final String refreshToken = box.get(_refreshTokenKey);
    return refreshToken;
  }

  @override
  Future<String> restoreUser() async {
    final box = await _getEncryptedBox();
    final String userJson = box.get(_userKey);
    return userJson;
  }

  @override
  Future<void> setAppToken(String appToken) async {
    final box = await _getEncryptedBox();
    await box.putAll({
      _appTokenKey: appToken,
    });
  }

  @override
  Future<void> setRefreshToken(String refreshToken) async {
    final box = await _getEncryptedBox();
    await box.putAll({
      _refreshTokenKey: refreshToken,
    });
  }

  @override
  Future<void> storeUser(String userJson) async {
    final box = await _getEncryptedBox();
    await box.putAll({
      _userKey: userJson,
    });
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
