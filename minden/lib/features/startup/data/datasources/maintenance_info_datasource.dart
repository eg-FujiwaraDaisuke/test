import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:minden/features/startup/data/models/maintenance_info_model.dart';

import '../../../../injection_container.dart';

abstract class MaintenanceInfoDataSource {
  Future<MaintenanceInfoModel> getMaintenanceInfo();
}

class MaintenanceInfoDataSourceImpl implements MaintenanceInfoDataSource {
  @override
  Future<MaintenanceInfoModel> getMaintenanceInfo() async {
    await sl<RemoteConfig>().fetch(expiration: const Duration(seconds: 0));
    await sl<RemoteConfig>().activateFetched();
    final supportVersion = sl<RemoteConfig>().getString("support_version");
    final maintenanceUrl = sl<RemoteConfig>().getString("maintenance_url");
    return MaintenanceInfoModel.fromJson({
      "support_version": supportVersion,
      "maintenance_url": maintenanceUrl,
    });
  }
}
