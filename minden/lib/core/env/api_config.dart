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

  static Future<Map<String, Object>> apiEndpointWithToken() async {
    final appToken = await si<EncryptionTokenDataSourceImpl>().getAppToken();
    // final refreshToken =
    //     await si<EncryptionTokenDataSourceImpl>().getRefreshToken();
    final env = _endpoint[Config.getEnvironmentString()] as Map<String, Object>;
    final Map<String, Object> defaultHeaders =
        env['headers'] as Map<String, Object>;
    final headers = {
      'appToken': appToken,
      // 'refreshToken': refreshToken,
      ...defaultHeaders
    };
    env['headers'] = headers;
    return env;
  }
}
