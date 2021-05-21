class ServerException implements Exception {}

class LocalCacheException implements Exception {}

class SupportVersionException implements Exception {
  SupportVersionException({
    required this.storeUrl,
    required this.supportVersion,
  });

  final String storeUrl;
  final String supportVersion;
}

class MaintenanceException implements Exception {
  MaintenanceException({
    required this.maintenanceUrl,
    required this.maintenanceDescription,
  });

  final String maintenanceUrl;
  final String maintenanceDescription;
}
