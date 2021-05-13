import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/startup/data/models/maintenance_info_model.dart';
import 'package:minden/features/startup/domain/entities/maintenance_info.dart';

abstract class MaintenanceInfoDataSource {
  Future<MaintenanceInfoModel> getMaintenanceInfo();
}

class MaintenanceInfoDataSourceImpl implements MaintenanceInfoDataSource {
  @override
  Future<MaintenanceInfoModel> getMaintenanceInfo() async {
    return MaintenanceInfoModel.fromJson({});
  }
}