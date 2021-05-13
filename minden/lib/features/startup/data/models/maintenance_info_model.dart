import 'package:minden/features/startup/domain/entities/maintenance_info.dart';

class MaintenanceInfoModel extends MaintenanceInfo {
  MaintenanceInfoModel() : super();

  factory MaintenanceInfoModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceInfoModel();
  }
  Map<String, dynamic> toJson() {
    return {};
  }
}
