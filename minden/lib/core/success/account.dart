import 'dart:convert';

import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/token/data/datasources/encryption_token_data_source.dart';
import 'package:minden/injection_container.dart';

class Account {
  String? _appToken = '';
  String? _refreshToken = '';
  User? _me;

  String? get appToken => _appToken;

  String? get refreshToken => _refreshToken;

  String get userId => _me?.profile.userId ?? '';

  bool isMe(String userId) {
    if (userId.isEmpty) {
      return false;
    }
    final storedUserId = _me?.profile.userId ?? '';
    return storedUserId == userId;
  }

  Future<void> prepare() async {
    _appToken = await si<EncryptionTokenDataSourceImpl>().getAppToken();
    logD('appToken : $_appToken');

    _refreshToken = await si<EncryptionTokenDataSourceImpl>().getRefreshToken();
    logD('_refreshToken : $_refreshToken');

    final jsonData = await si<EncryptionTokenDataSourceImpl>().restoreUser();
    if (jsonData.isEmpty) {
      logD('#### you need login ####');
      return;
    }
    final Map<String, dynamic> userJson = json.decode(jsonData);
    if (userJson.isEmpty) {
      logD('#### you need login ####');
      return;
    }

    _me = User.fromJson(userJson);
    logD('${_me?.toJson()}');
    logD('$_appToken, $_refreshToken, ${_me?.toJson()}');
  }
}
