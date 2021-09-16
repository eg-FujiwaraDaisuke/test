import 'package:minden/features/startup/domain/entities/startup.dart';

// data - model

// 実装ガイド
// entityとmodelを定義するのは「扱う層が異なるため」と考えるのが良さそうです。
// （ドメイン層でmodelは扱わないし、データ層でentityを扱わないようにするため）
class StartupModel extends Startup {
  StartupModel({
    required String storeUrl,
    required bool hasLatestVersion,
    required String latestVersion,
    required bool hasTutorial,
  }) : super(
            storeUrl: storeUrl,
            hasLatestVersion: hasLatestVersion,
            latestVersion: latestVersion,
            hasTutorial: hasTutorial);

  factory StartupModel.fromJson(Map<String, dynamic> json) {
    return StartupModel(
        storeUrl: json['store_url'],
        hasLatestVersion: json['has_latest_version'],
        latestVersion: json['latest_version'],
        hasTutorial: json['has_tutorial']);
  }

  Map<String, dynamic> toJson() {
    return {
      'store_url': storeUrl,
      'has_latest_version': hasLatestVersion,
      'latest_version': latestVersion,
      'has_tutorial': hasTutorial
    };
  }
}
