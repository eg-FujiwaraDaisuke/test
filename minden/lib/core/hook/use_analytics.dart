import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:minden/core/hook/use_logger.dart';

// ボタン操作時のトラッキング用イベント名
const String _tapButtonEventName = 'tap_button';

// トラッキング時の、ボタン種別
const String _tapButtonEventParamsName = 'name';

void useButtonAnalytics(ButtonAnalyticsType type) {
  logD('Analytics: $_tapButtonEventName: ${type.name}');

  // NOTE: FirebaseAnalyticsのインスタンスはシングルトンなため都度呼び出しは問題になりづらい
  FirebaseAnalytics.instance.logEvent(
    name: _tapButtonEventName,
    parameters: {
      _tapButtonEventParamsName: type.name,
    },
  );
}

enum ButtonAnalyticsType {
  // ログイン画面 - ログインボタン押下
  requestLogin,
  // ログイン画面 - パスワードリセットリンク押下
  navigateResetPassword,
  // パスワードリセット画面 - パスワードリセットボタン押下
  requestResetPassword,
  // タグ設定画面 - 次へ押下
  navigateConfirmTagSettings,
  // タグ設定確認画面 - 決定押下
  completeTagSettings,
  // 発電所をタグで探すタブ - タグ押下
  navigateSearchByTagPowerPlant,
  // 発電所詳細画面 - この発電所を応援するボタン押下
  navigateSupportPowerPlant,
  // ユーザー一覧ポップアップ - ユーザーアイコン押下
  navigateParticipantUser,
  // 発電所応援ポップアップ - 決定する押下
  decideSupportPowerPlant,
  // プロフィール画面 - タグ押下
  navigateSearchByTagPowerPlantFromProfile,
  // プロフィール画面 - このユーザーを報告押下
  requestIssueReport,
  // プロフィール編集画面 - アイコン編集ボタン押下
  requestChangeProfileIcon,
  // プロフィール編集画面 - 背景編集ボタン押下
  requestChangeProfileWallpaper,
  // プロフィール編集画面 - タグ設定「＋」ボタン押下
  requestChangeProfileTags,
}

extension ButtonAnalyticsTypeExt on ButtonAnalyticsType {
  String get name {
    switch (this) {
      case ButtonAnalyticsType.requestLogin:
        return 'requestLogin';
      case ButtonAnalyticsType.navigateResetPassword:
        return 'navigateResetPassword';
      case ButtonAnalyticsType.requestResetPassword:
        return 'requestResetPassword';
      case ButtonAnalyticsType.navigateConfirmTagSettings:
        return 'navigateConfirmTagSettings';
      case ButtonAnalyticsType.completeTagSettings:
        return 'completeTagSettings';
      case ButtonAnalyticsType.navigateSearchByTagPowerPlant:
        return 'navigateSearchByTagPowerPlant';
      case ButtonAnalyticsType.navigateSupportPowerPlant:
        return 'navigateSupportPowerPlant';
      case ButtonAnalyticsType.navigateParticipantUser:
        return 'navigateParticipantUser';
      case ButtonAnalyticsType.decideSupportPowerPlant:
        return 'decideSupportPowerPlant';
      case ButtonAnalyticsType.navigateSearchByTagPowerPlantFromProfile:
        return 'navigateSearchByTagPowerPlantFromProfile';
      case ButtonAnalyticsType.requestIssueReport:
        return 'requestIssueReport';
      case ButtonAnalyticsType.requestChangeProfileIcon:
        return 'requestChangeProfileIcon';
      case ButtonAnalyticsType.requestChangeProfileWallpaper:
        return 'requestChangeProfileWallpaper';
      case ButtonAnalyticsType.requestChangeProfileTags:
        return 'requestChangeProfileTags';
    }
  }
}
