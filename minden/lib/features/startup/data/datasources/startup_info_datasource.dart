import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/startup/data/models/startup_model.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:version/version.dart';

import '../../../../injection_container.dart';

// data - datasource

// 実装ガイド
// dataの取得や保存などの制御する実装をここで行います。
// ビジネスロジックや何かを表示するための実装はここには書きません。
abstract class StartupInfoDataSource {
  Future<StartupModel> getStartupInfo();
}

// データ層は、datasourceはModelを返すことと、エラー発生時はexceptionを投げるようにします。
class StartupInfoDataSourceImpl implements StartupInfoDataSource {
  @override
  Future<StartupModel> getStartupInfo() async {
    await si<RemoteConfig>().fetch();
    await si<RemoteConfig>().fetchAndActivate();

    final maintenanceDescription =
        si<RemoteConfig>().getString("maintenance_description");
    final maintenanceUrl = si<RemoteConfig>().getString("maintenance_url");
    final underMaintenance = si<RemoteConfig>().getBool('under_maintenance');

    final storeUrl = si<RemoteConfig>().getString("store_url");
    final remoteSupportVersion =
        si<RemoteConfig>().getString("support_version");
    final supportVersion = Version.parse(remoteSupportVersion);
    final appVersion = await _appVersion();

    final hasTutorial = await _hasTutorial();

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

    return StartupModel(
      storeUrl: storeUrl,
      hasLatestVersion: appVersion.compareTo(supportVersion) < 0,
      latestVersion: supportVersion.toString(),
      hasTutorial: hasTutorial,
    );
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

  Future<bool> _hasTutorial() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final hasTutorial = sharedPreferences.getBool("has_tutorial") ?? false;
    return hasTutorial;
  }
}
