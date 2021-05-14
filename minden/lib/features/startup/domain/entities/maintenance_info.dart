import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class MaintenanceInfo extends Equatable {
  MaintenanceInfo({
    @required this.maintenanceUrl,
    @required this.supportVersion,
  });

  String maintenanceUrl;
  String supportVersion;

  @override
  List<Object> get props => [maintenanceUrl, supportVersion];
}
