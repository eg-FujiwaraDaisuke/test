import 'dart:io';

import 'package:minden/core/success/account.dart';
import 'package:minden/injection_container.dart';

import 'config.dart';

class ApiConfig {
  static final Map<String, dynamic> _endpoint = {
    Config.kDevFlavor: 'https://www.dev.minapp.minden.co.jp',
    Config.kStagingFlavor: 'https://www.stg.minapp.minden.co.jp',
    Config.kProdFlavor: 'https://www.minapp.minden.co.jp',
  };

  static final contentTypeHeaderApplicationJson = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
  };
  static final contentTypeHeaderApplicationXFormUrlEncoded = {
    HttpHeaders.contentTypeHeader:
        'application/x-www-form-urlencoded; charset=UTF-8'
  };
  static final contentTypeHeaderMultipartFormData = {
    HttpHeaders.contentTypeHeader: 'multipart/form-data'
  };

  static String apiEndpoint() => _endpoint[Config.getEnvironmentString()];

  static Map<String, String> tokenHeader() {
    final appToken = si<Account>().appToken;
    final refreshToken = si<Account>().refreshToken;
    return {
      'appToken': appToken,
      'refreshToken': refreshToken,
    };
  }
}
