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

  User get me => _me;

  bool isMe(String userId) {
    if (userId.isEmpty) {
      return false;
    }
    final storedUserId = _me.profile.userId ?? "";
    return storedUserId == userId;
  }

  Future<void> prepare() async {
    _appToken = await si<EncryptionTokenDataSourceImpl>().getAppToken();
    _refreshToken = await si<EncryptionTokenDataSourceImpl>().getRefreshToken();

    final jsonData = await si<EncryptionTokenDataSourceImpl>().restoreUser();
    _me = User.fromJson(json.decode(jsonData));
    print("${_me.loginId?.isEmpty ?? "#### you need login #### "}");
    print("${_appToken}, ${_refreshToken}, ${_me.toJson() ?? ""}");
  }
}
