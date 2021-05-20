import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:minden/features/startup/domain/entities/startup_info.dart';

// data - model

// 実装ガイド
// entityとmodelを定義するのは「扱う層が異なるため」と考えるのが良さそうです。
// （ドメイン層でmodelは扱わないし、データ層でentityを扱わないようにするため）
class StartupInfoModel extends StartupInfo {
  StartupInfoModel({
    @required String storeUrl,
    @required bool hasLatestVersion,
    @required String latestVersion,
  }) : super(
          storeUrl: storeUrl,
          hasLatestVersion: hasLatestVersion,
          latestVersion: latestVersion,
        );

  factory StartupInfoModel.fromJson(Map<String, dynamic> json) {
    return StartupInfoModel(
      storeUrl: json["store_url"],
      hasLatestVersion: json["has_latest_version"],
      latestVersion: json["latest_version"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "store_url": storeUrl,
      "has_latest_version": hasLatestVersion,
      "latest_version": latestVersion,
    };
  }
}
