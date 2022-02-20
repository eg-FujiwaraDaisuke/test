import 'package:flutter/material.dart';
import 'package:minden/core/firebase/analytics_factory.dart';
import 'package:minden/features/common/widget/home_mypage_tab_navigation/home_mypage_tab.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_page.dart';
import 'package:minden/features/user/presentation/pages/user_page.dart';

class TabNavigator extends StatelessWidget {
  const TabNavigator({
    required this.navigatorKey,
    required this.tabItem,
  }) : super();
  final GlobalKey<NavigatorState>? navigatorKey;
  final TabItem tabItem;

  Map<TabItem, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      TabItem.home: (context) => PowerPlantHomePage(),
      TabItem.mypage: (context) => UserPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routerBuilders = _routeBuilders(context);

    return Navigator(
      key: navigatorKey,
      observers: [
        createAnalyticsObserver(),
      ],
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routerBuilders[tabItem]!(context),
          settings: RouteSettings(
            name: {
              TabItem.home: PowerPlantHomePage.routeName,
              TabItem.mypage: UserPage.routeName,
            }[tabItem],
          ),
        );
      },
    );
  }
}
