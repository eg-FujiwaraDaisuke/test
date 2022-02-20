import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:minden/core/hook/use_logger.dart';
import 'package:minden/features/login/presentation/pages/login_page.dart';
import 'package:minden/features/message/presentation/pages/message_page.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_detail_page.dart';
import 'package:minden/features/profile_setting/presentation/pages/profile_setting_name_page.dart';
import 'package:minden/features/profile_setting/presentation/pages/profile_setting_tags_decision_page.dart';
import 'package:minden/features/profile_setting/presentation/pages/profile_setting_tags_page.dart';
import 'package:minden/features/reset_password/pages/reset_password_page.dart';
import 'package:minden/features/startup/presentation/pages/tutorial_page.dart';
import 'package:minden/features/support_history_power_plant/presentation/pages/support_history_power_plant_page.dart';
import 'package:minden/features/user/presentation/pages/profile_edit_page.dart';
import 'package:minden/features/user/presentation/pages/profile_page.dart';

/// FirebaseAnalyticsObserverを生成する
/// NOTE: NavigatorObserverは、単一のNavigatorにのみ紐付け可能なため、同じ内容で複数生成可能とする
FirebaseAnalyticsObserver createAnalyticsObserver() {
  return FirebaseAnalyticsObserver(
    analytics: FirebaseAnalytics.instance,
    nameExtractor: nameExtractor,
  );
}

/// RouteSettingsに設定したrouteNameに基づき、
/// Firebase Analyticsのscreen_viewに送る値を抽出する
/// NOTE: Navigatorを用いない繊維（TabView）については、別な仕組みでscreen_viewを送る
String? nameExtractor(RouteSettings settings) {
  final routeName = settings.name;

  logD('Extract target route. routeName: $routeName');

  switch (routeName) {
    case TutorialPage.routeName:
    case LoginPage.routeName:
    case ResetPasswordPage.routeName:
    // ホームタブ
    // NOTE: TabView, ポップアップのトラッキングは別な仕組みで行う
    case PowerPlantDetailPage.routeName:
    // マイページタブ
    case ProfilePage.routeName:
    case ProfileEditPage.routeName:
    case ProfileSettingNamePage.routeName:
    case ProfileSettingTagsPage.routeName:
    case ProfileSettingTagsDecisionPage.routeName:
    case SupportHistoryPowerPlantPage.routeName:
    case MessagePage.routeName:
      return routeName;
    default:
      logW('Undefined route name for analytics. routeName: $routeName}');
      return routeName;
  }
}
