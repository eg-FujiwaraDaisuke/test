import 'dart:io';

import 'package:minden/core/success/account.dart';
import 'package:minden/injection_container.dart';

import 'config.dart';

class ApiConfig {
  static final _endpoint = {
    Config.kDevFlavor: {
      'url': 'https://www.dev.minapp.minden.co.jp',
      'headers': {
        HttpHeaders.contentTypeHeader: 'application/json',
      }
    },
    Config.kStagingFlavor: {
      'url': 'https://www.stg.minapp.minden.co.jp',
      'headers': {
        HttpHeaders.contentTypeHeader: 'application/json',
      }
    },
    Config.kProdFlavor: {
      'url': 'https://www.minapp.minden.co.jp',
      'headers': {
        HttpHeaders.contentTypeHeader: 'application/json',
      }
    }
  };

  static Map<String, dynamic> apiEndpoint() {
    return _endpoint[Config.getEnvironmentString()] as Map<String, dynamic>;
  }

  static Map<String, String> tokenHeader() {
    final env = _endpoint[Config.getEnvironmentString()] as Map<String, dynamic>;
    final defaultHeaders = env['headers']! as Map<String, String>;
    final appToken = si<Account>().appToken;
    final refreshToken = si<Account>().refreshToken;
    return {
      'appToken': appToken,
      'refreshToken': refreshToken,
      ...defaultHeaders
    };
  }
}
