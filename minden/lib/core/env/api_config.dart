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
}
