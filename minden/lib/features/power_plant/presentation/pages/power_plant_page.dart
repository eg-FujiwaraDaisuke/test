import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minden/core/firebase/analytics_factory.dart';
import 'package:minden/core/firebase/dynamic_links_route_mapper.dart';
import 'package:minden/core/hook/use_logger.dart';
import 'package:minden/core/provider/firebase_dynamic_links_provider.dart';
import 'package:minden/features/common/widget/home_mypage_tab_navigation/home_mypage_tab.dart';
import 'package:minden/features/home/presentation/pages/home_page.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_detail_page.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_list_page.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_search_menu.dart';
import 'package:minden/features/support_history/presentation/support_history_page.dart';
import 'package:minden/features/transition_screen/presentation/bloc/transition_screen_bloc.dart';

class PowerPlantHomeTabData {
  PowerPlantHomeTabData({
    required this.tabName,
    required this.tabPage,
    required this.tabPageRoute,
  });

  late final String tabName;
  late final WidgetBuilder tabPage;
  late final String tabPageRoute;
}

/// ホームタブ
class PowerPlantHomePage extends StatefulHookWidget {
  static const String routeName = '/home/top';

  @override
  _PowerPlantHomePageState createState() => _PowerPlantHomePageState();
}

class _PowerPlantHomePageState extends State<PowerPlantHomePage>
    with SingleTickerProviderStateMixin {
  late TransitionScreenBloc _transitionScreenBloc;

  final tabs = [
    PowerPlantHomeTabData(
      tabName: '発電所一覧',
      tabPage: (_) => PowerPlantList(),
      tabPageRoute: PowerPlantList.routeName,
    ),
    PowerPlantHomeTabData(
      tabName: '発電所を探す',
      tabPage: (_) => const PowerPlantSearchMenu(),
      tabPageRoute: PowerPlantSearchMenu.routeName,
    ),
    PowerPlantHomeTabData(
      tabName: '応援の軌跡',
      tabPage: (_) => const SupportHistoryPage(),
      tabPageRoute: SupportHistoryPage.routeName,
    ),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      // NOTE: 仕様により、タブ切り替えアニメーション中と、完了時の通知が2回飛んでくる
      // よって完了時のみ検知する
      if (!_tabController.indexIsChanging) {
        sendScreenTabViewEvent(_tabController.index);
      }
    });

    _transitionScreenBloc = BlocProvider.of<TransitionScreenBloc>(context);
    _transitionScreenBloc.stream.listen((event) {
      if (event is TransitionScreenStart) {
        if (event.screen == 'PowerPlantHomePage') {
          if (event.isFirst) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final homePageTab = useProvider(homePageTabProvider);

    // 画面表示時の、初回表示タブについて、ScreenViewEventを送信する
    // NOTE: BottomNavigation切り替えの場合、0とは限らない
    sendScreenTabViewEvent(_tabController.index, tabItem: homePageTab.state);

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                indicatorColor: const Color(0xFFFF8C00),
                tabs: tabs
                    .map((tab) => Text(
                          tab.tabName,
                          textAlign: TextAlign.center,
                        ))
                    .toList(),
                controller: _tabController,
              ),
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: HookBuilder(builder: (context) {
            // ホームタブにて、DynamicLinksの待受
            final initialDynamicLink = useProvider(pendingDynamicLink);
            final currentDynamicLink = useProvider(pendingDynamicLinkStream);

            final hasInitialLink = initialDynamicLink.data?.value?.link != null;
            final hasCurrentLink = currentDynamicLink.data?.value?.link != null;

            if (hasCurrentLink) {
              // 起動中のDynamicLinksはonLinkで取得する
              navigateByDynamicLinksIfNeeded(
                  currentDynamicLink.data!.value!.link);
            } else if (hasInitialLink) {
              // 起動時のDynamicLinksはonLinkで取得できない（null）ため、nullか否かで判断する
              navigateByDynamicLinksIfNeeded(
                  initialDynamicLink.data!.value!.link);
            }

            return TabBarView(
              controller: _tabController,
              children: tabs.map((tab) => tab.tabPage(context)).toList(),
            );
          }),
        ),
      ),
    );
  }

  void sendScreenTabViewEvent(
    int index, {
    TabItem tabItem = TabItem.home,
  }) {
    if (tabItem != TabItem.home) {
      // NOTE: BottomNavigationの切り替えによっても、
      // 表示中に依らずTabControllerのリスナーが反応するため、
      // BottomNavigationで選択中のタブを参照して、必要なときだけScreenViewEventを送信する
      return;
    }

    final currentPath = tabs[index].tabPageRoute;
    logD('Tab in TabChanged. route: $currentPath');

    // FirebaseAnalyticsObserverのコードを流用
    final screenName = mindenNameExtractor(RouteSettings(name: currentPath));
    if (screenName != null) {
      FirebaseAnalytics.instance.setCurrentScreen(screenName: screenName);
    }
  }

  void navigateByDynamicLinksIfNeeded(Uri uri) {
    final type = typeByUri(uri);

    switch (type) {
      case DynamicLinksType.powerPlantDetail:
        // 発電所詳細画面に遷移
        final plantId = uri.pathSegments.last;
        Navigator.push(context, PowerPlantDetailPage.route(plantId));
        return;
      default:
      // 何もしない
    }
  }
}
