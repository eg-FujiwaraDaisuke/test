import 'package:flutter/foundation.dart';

enum Flavor {
  dev,
  staging,
  prod,
  undefined,
}

class Config {
  static const String kProdFlavor = 'prod';
  static const String kStagingFlavor = 'staging';
  static const String kDevFlavor = 'dev';

  static Flavor _environment = Flavor.undefined;

  static bool get isDevelop => _environment == Flavor.dev;

  static bool get isStaging => _environment == Flavor.staging;

  static bool get isProduct => _environment == Flavor.prod;

  static bool get isUndefined => _environment == Flavor.undefined;

  static void setEnvironment(String environment) {
    assert(isUndefined,
        'Environment modify Error. $_environment is already set up.');

    if (environment == kProdFlavor) {
      _environment = Flavor.prod;
    } else if (environment == kStagingFlavor) {
      _environment = Flavor.staging;
    } else if (environment == kDevFlavor) {
      _environment = Flavor.dev;
    } else {
      if (kReleaseMode) {
        _environment = Flavor.prod;
      } else {
        assert(false, 'error environment');
      }
    }
  }

  static String getEnvironmentString() {
    switch (_environment) {
      case Flavor.dev:
        return _environmentString(Flavor.dev);
      case Flavor.staging:
        return _environmentString(Flavor.staging);
      case Flavor.prod:
        return _environmentString(Flavor.prod);
      default:
        assert(false, 'error environment');
        return _environmentString(Flavor.undefined);
    }
  }

  static String _environmentString(Flavor flavor) {
    return flavor.toString().split('.').last;
  }
}
