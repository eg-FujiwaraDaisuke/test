import 'dart:convert';

import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/token/data/datasources/encryption_token_data_source.dart';

import '../../injection_container.dart';

class Account {
  late String _appToken;
  late String _refreshToken;
  late User _me;

  String get appToken => _appToken;

  String get refreshToken => _refreshToken;

  String get userId => _me.profile.userId ?? '';

  bool isMe(String userId) {
    if (userId.isEmpty) {
      return false;
    }
    final storedUserId = _me.profile.userId ?? '';
    return storedUserId == userId;
  }

  Future<void> prepare() async {
    print("appToken : ${_appToken}");
    _appToken = await si<EncryptionTokenDataSourceImpl>().getAppToken();
    print("appToken : ${_appToken}");
    print("_refreshToken : ${_refreshToken}");
    _refreshToken = await si<EncryptionTokenDataSourceImpl>().getRefreshToken();
    print("_refreshToken : ${_refreshToken}");

    final jsonData = await si<EncryptionTokenDataSourceImpl>().restoreUser();
    final userJson = json.decode(jsonData);

    _me = User.fromJson(userJson);
    if (_me.loginId == null) {
      print('#### you need login ####');
    }
    print("${_appToken}, ${_refreshToken}, ${_me.toJson()}");
  }
}
