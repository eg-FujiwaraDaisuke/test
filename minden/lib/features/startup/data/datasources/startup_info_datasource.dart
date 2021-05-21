import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/startup/data/models/startup_info_model.dart';
import 'package:package_info/package_info.dart';
import 'package:version/version.dart';

import '../../../../injection_container.dart';

// data - datasource

// 実装ガイド
// dataの取得や保存などの制御する実装をここで行います。
// ビジネスロジックや何かを表示するための実装はここには書きません。
abstract class StartupInfoDataSource {
  Future<StartupInfoModel> getStartupInfo();
}

// データ層は、datasourceはModelを返すことと、エラー発生時はexceptionを投げるようにします。
class StartupInfoDataSourceImpl implements StartupInfoDataSource {
  @override
  Future<StartupInfoModel> getStartupInfo() async {
    await sl<RemoteConfig>().fetch(expiration: const Duration(seconds: 0));
    await sl<RemoteConfig>().activateFetched();

    final maintenanceDescription =
        sl<RemoteConfig>().getString("maintenance_description");
    final maintenanceUrl = sl<RemoteConfig>().getString("maintenance_url");
    final underMaintenance = sl<RemoteConfig>().getBool('under_maintenance');

    final storeUrl = sl<RemoteConfig>().getString("store_url");
    final remoteSupportVersion =
        sl<RemoteConfig>().getString("support_version");
    final supportVersion = Version.parse(remoteSupportVersion);
    final appVersion = await _appVersion();

    print(
        "[version info] app: ${appVersion.toString()}, supportVersion: ${supportVersion.toString()}");

    if (maintenanceUrl.isEmpty && underMaintenance) {
      throw ServerException();
    }
    if (underMaintenance) {
      throw MaintenanceException(
          maintenanceUrl: maintenanceUrl,
          maintenanceDescription: maintenanceDescription);
    }
    if (!await _isSupportVersion(appVersion, supportVersion)) {
      throw SupportVersionException(
        storeUrl: storeUrl,
        supportVersion: supportVersion.toString(),
      );
    }

    return StartupInfoModel(
        storeUrl: storeUrl,
        hasLatestVersion: appVersion.compareTo(supportVersion) < 0,
        latestVersion: supportVersion.toString());
  }

  Future<bool> _isSupportVersion(
    Version appVersion,
    Version supportVersion,
  ) async {
    if (appVersion.major > supportVersion.major) {
      return true;
    }
    if (appVersion.major == supportVersion.major) {
      return appVersion.minor >= supportVersion.minor;
    }
    return false;
  }

  Future<Version> _appVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final Version localVersion = Version.parse(packageInfo.version);
    final Version appVersion = Version(
        localVersion.major, localVersion.minor, localVersion.patch,
        build: packageInfo.buildNumber);
    return appVersion;
  }
}
