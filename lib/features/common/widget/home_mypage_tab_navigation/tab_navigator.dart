import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:minden/core/firebase/analytics_factory.dart';
import 'package:minden/core/hook/use_logger.dart';
import 'package:minden/features/common/widget/home_mypage_tab_navigation/home_mypage_tab.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_page.dart';
import 'package:minden/features/user/presentation/pages/user_page.dart';

class TabNavigator extends StatelessWidget {
  const TabNavigator({
    required this.navigatorKey,
    required this.tabItem,
    required this.isCurrentTab,
  }) : super();
  final GlobalKey<NavigatorState>? navigatorKey;
  final TabItem tabItem;
  final bool isCurrentTab;

  Map<TabItem, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      TabItem.home: (context) => PowerPlantHomePage(),
      TabItem.menu: (context) => UserPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routerBuilders = _routeBuilders(context);

    if (isCurrentTab) {
      sendScreenViewByTabChanged();
    }

    return Navigator(
      key: navigatorKey,
      observers: [
        if (isCurrentTab) createAnalyticsObserver(),
      ],
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routerBuilders[tabItem]!(context),
          settings: RouteSettings(
            name: {
              TabItem.home: PowerPlantHomePage.routeName,
              TabItem.menu: UserPage.routeName,
            }[tabItem],
          ),
        );
      },
    );
  }

  /// タブ切り替えなど、Navigatorを伴わない画面遷移（Offstageなど）の場合、
  /// 現在表示中のrouteをScreenViewとして送信する
  String? sendScreenViewByTabChanged() {
    navigatorKey?.currentState?.popUntil((route) {
      final currentPath = route.settings.name;
      logD('TabChanged. route: $currentPath');

      // FirebaseAnalyticsObserverのコードを流用
      final screenName = mindenNameExtractor(route.settings);
      if (screenName != null) {
        FirebaseAnalytics.instance.setCurrentScreen(screenName: screenName);
      }

      return true;
    });
  }
}
