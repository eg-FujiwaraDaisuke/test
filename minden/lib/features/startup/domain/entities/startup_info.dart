import 'package:equatable/equatable.dart';

// 仕様
// アプリ起動時にサービスがメンテ状態の際は、メンテナンスである表示を行いアプリ外のURLへ飛ばしたい。
// サービスのバージョンがアプリのバージョン以上だったら必ずストアへ飛ばしたい。
// サービスのバージョンのpatchがアプリのバージョン以上だったらユーザーの任意でストアへ飛ばしたい。
// domain - entity

// 実装ガイド
// コーディングはclean architecture構造の内側から始めるので、このentityから始めます。
// entityは仕様で扱うデータ群を表すので、設計後変更されにくいためです。
// StartupInfoの各プロパティはアプリ起動時にremote configより取得するメンテ関係のデータをもとにして作られています。
//
// storeUrl : 各OSのストアURL
// supportVersion : アプリのサポートバージョン
// latestVersion : サービスの最新バージョン
class StartupInfo extends Equatable {
  StartupInfo({
    required this.storeUrl,
    required this.hasLatestVersion,
    required this.latestVersion,
  });

  final String storeUrl;
  final bool hasLatestVersion;
  final String latestVersion;

  @override
  List<Object> get props => [
        storeUrl,
        hasLatestVersion,
        latestVersion,
      ];
}
