import 'package:flutter/foundation.dart';
import 'package:minden/features/startup/domain/entities/startup_info.dart';

// data - model

// 実装ガイド
// entityとmodelを定義するのは「扱う層が異なるため」と考えるのが良さそうです。
// （ドメイン層でmodelは扱わないし、データ層でentityを扱わないようにするため）
class StartupInfoModel extends StartupInfo {
  StartupInfoModel({
    @required String maintenanceUrl,
    @required String maintenanceDescription,
    @required bool underMaintenance,
  }) : super(
            maintenanceUrl: maintenanceUrl,
            maintenanceDescription: maintenanceDescription,
            underMaintenance: underMaintenance);

  factory StartupInfoModel.fromJson(Map<String, dynamic> json) {
    return StartupInfoModel(
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
