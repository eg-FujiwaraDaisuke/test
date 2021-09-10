import 'package:minden/features/token/data/datasources/encryption_token_data_source.dart';
import 'package:minden/injection_container.dart';

import 'config.dart';

class ApiConfig {
  static final _endpoint = {
    Config.kDevFlavor: {
      'url': 'https://www.dev.minapp.minden.co.jp',
      'headers': {
        'content-type': 'application/json',
      }
    },
    Config.kStagingFlavor: {
      'url': 'https://www.stg.minapp.minden.co.jp',
      'headers': {
        'content-type': 'application/json',
      }
    },
    Config.kProdFlavor: {
      'url': 'https://www.minapp.minden.co.jp',
      'headers': {
        'content-type': 'application/json',
      }
    }
  };

  static Map<String, Object> apiEndpoint() {
    return _endpoint[Config.getEnvironmentString()] as Map<String, Object>;
  }

  static Future<Map<String, String>> tokenHeader() async {
    final env = _endpoint[Config.getEnvironmentString()] as Map<String, Object>;
    final defaultHeaders = env['headers']! as Map<String, String>;
    final appToken = await si<EncryptionTokenDataSourceImpl>().getAppToken();
    final refreshToken =
        await si<EncryptionTokenDataSourceImpl>().getRefreshToken();
    return {
      'appToken': appToken,
      'refreshToken': refreshToken,
      ...defaultHeaders
    };
  }
}
