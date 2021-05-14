import 'package:flutter/foundation.dart';
import 'package:minden/features/startup/domain/entities/maintenance_info.dart';

class MaintenanceInfoModel extends MaintenanceInfo {
  MaintenanceInfoModel({
    @required String maintenanceUrl,
    @required String supportVersion,
  }) : super(maintenanceUrl: maintenanceUrl, supportVersion: supportVersion);

  factory MaintenanceInfoModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceInfoModel(
        maintenanceUrl: json["maintenance_url"],
        supportVersion: json["support_version"]
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'maintenance_url' : maintenanceUrl,
      'support_version' : supportVersion
    };
  }
}

