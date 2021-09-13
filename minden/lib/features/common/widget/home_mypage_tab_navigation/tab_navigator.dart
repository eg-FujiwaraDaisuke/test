import 'package:flutter/material.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_page.dart';
import 'package:minden/features/user/presentation/pages/user_page.dart';

import 'home_mypage_tab.dart';

class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState>? navigatorKey;
  final TabItem tabItem;

  TabNavigator({
    required this.navigatorKey,
    required this.tabItem,
  }) : super();

  Map<TabItem, WidgetBuilder> _routeBuliders(BuildContext context) {
    return {
      TabItem.home: (context) => PowerPlantHomePage(),
      TabItem.mypage: (context) => UserPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routerbuilders = _routeBuliders(context);

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routerbuilders[tabItem]!(context),
        );
      },
    );
  }
}
