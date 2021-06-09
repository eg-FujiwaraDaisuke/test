import 'package:flutter/foundation.dart';

enum Flavor {
  DEVELOP,
  STAGING,
  PRODUCT,
  UNDEFINED,
}

class Config {
  static const String kProdFlavor = "prod";
  static const String kStagingFlavor = "staging";
  static const String kDevFlavor = "dev";

  static Flavor _environment = Flavor.UNDEFINED;

  static bool get isDevelop => _environment == Flavor.DEVELOP;

  static bool get isStaging => _environment == Flavor.STAGING;

  static bool get isProduct => _environment == Flavor.PRODUCT;

  static bool get isUndefined => _environment == Flavor.UNDEFINED;

  static void setEnvironment(String environment) {
    assert(isUndefined,
        "Environment modify Error. $_environment is already set up.");

    if (environment == kProdFlavor) {
      _environment = Flavor.PRODUCT;
    } else if (environment == kStagingFlavor) {
      _environment = Flavor.STAGING;
    } else if (environment == kDevFlavor) {
      _environment = Flavor.DEVELOP;
    } else {
      if (kReleaseMode) {
        _environment = Flavor.PRODUCT;
      } else {
        assert(false, "error environment");
      }
    }
  }

  static String getEnvironmentString() {
    switch (_environment) {
      case Flavor.DEVELOP:
        return _environmentString(Flavor.DEVELOP);
      case Flavor.STAGING:
        return _environmentString(Flavor.STAGING);
      case Flavor.PRODUCT:
        return _environmentString(Flavor.PRODUCT);
      default:
        assert(false, "error environment");
        return _environmentString(Flavor.UNDEFINED);
    }
  }

  static String _environmentString(Flavor flavor) {
    return flavor.toString().split(".").last;
  }
}
