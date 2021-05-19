import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

// 仕様
// アプリ起動時にサービスがメンテ状態の際は、メンテナンスである表示を行いアプリ外のURLへ飛ばしたい。

// domain - entity

// 実装ガイド
// コーディングはclean architecture構造の内側から始めるので、このentityから始めます。
// entityは仕様で扱うデータ群を表すので、設計後変更されにくいためです。
// StartupInfoの各プロパティはアプリ起動時にremote configより取得するメンテ関係のデータをもとにして作られています。
//
// maintenanceUrl : 遷移先URL
// maintenanceDescription : メンテナンスの説明表示用
// underMaintenance : メンテの状態 [通常運用中 false / メンテ中 true]

class StartupInfo extends Equatable {
  StartupInfo({
    @required this.maintenanceUrl,
    @required this.maintenanceDescription,
    @required this.underMaintenance,
    @required this.storeUrl,
    @required this.supportVersion,
  });

  final String maintenanceUrl;
  final String maintenanceDescription;
  final bool underMaintenance;
  final String storeUrl;
  final String supportVersion;

  @override
  List<Object> get props => [
        maintenanceUrl,
        maintenanceDescription,
        underMaintenance,
        storeUrl,
        supportVersion
      ];
}
