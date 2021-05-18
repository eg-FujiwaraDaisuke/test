import 'package:flutter/foundation.dart';
import 'package:minden/features/startup/domain/entities/maintenance_info.dart';

// data - model

// 実装ガイド
// entityとmodelを定義するのは「扱う層が異なるため」と考えるのが良さそうです。
// （ドメイン層でmodelは扱わないし、データ層でentityを扱わないようにするため）
class MaintenanceInfoModel extends MaintenanceInfo {
  MaintenanceInfoModel({
    @required String maintenanceUrl,
    @required String maintenanceDescription,
    @required bool underMaintenance,
  }) : super(
            maintenanceUrl: maintenanceUrl,
            maintenanceDescription: maintenanceDescription,
            underMaintenance: underMaintenance);

  factory MaintenanceInfoModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceInfoModel(
      maintenanceUrl: json["maintenance_url"],
      maintenanceDescription: json["maintenance_description"],
      underMaintenance: json['under_maintenance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maintenance_url': maintenanceUrl,
      'maintenance_description': maintenanceDescription,
      'under_maintenance': underMaintenance,
    };
  }
}
