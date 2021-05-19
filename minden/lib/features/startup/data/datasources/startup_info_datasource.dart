import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/startup/data/models/startup_info_model.dart';

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
    if (maintenanceUrl?.isEmpty ?? true && underMaintenance) {
      throw ServerException();
    }
    return StartupInfoModel(
        maintenanceUrl: maintenanceUrl,
        maintenanceDescription: maintenanceDescription,
        underMaintenance: underMaintenance);
  }
}
