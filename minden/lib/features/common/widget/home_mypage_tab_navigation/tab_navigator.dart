import 'package:flutter/material.dart';
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
          settings: RouteSettings(
            name: {
              TabItem.home: "/home",
              TabItem.mypage: "/mypage",
            }[tabItem],
          ),
        );
      },
    );
  }
}
