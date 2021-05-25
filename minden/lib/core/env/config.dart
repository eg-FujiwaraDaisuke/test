enum Flavor {
  DEVELOP,
  STAGING,
  PRODUCT,
}

class Config {
  static String PRDFLAVOR = "prod";
  static String STGFLAVOR = "staging";
  static String DEVFLAVOR = "dev";

  static late final Flavor _environment;

  static bool get isDevelop => Config._environment == Flavor.DEVELOP;

  static bool get isStaging => Config._environment == Flavor.STAGING;

  static bool get isProduct => Config._environment == Flavor.PRODUCT;

  static void setEnvironment(String environment) {
    if (environment == PRDFLAVOR) {
      _environment = Flavor.PRODUCT;
    } else if (environment == STGFLAVOR) {
      _environment = Flavor.STAGING;
    } else if (environment == DEVFLAVOR) {
      _environment = Flavor.DEVELOP;
    } else {
      _environment = Flavor.PRODUCT;
    }
  }

  static String getEnvironmentString() {
    switch (_environment) {
      case Flavor.DEVELOP:
        return DEVFLAVOR;
      case Flavor.STAGING:
        return STGFLAVOR;
      case Flavor.PRODUCT:
        return PRDFLAVOR;
      default:
        return "error environment";
    }
  }
}
