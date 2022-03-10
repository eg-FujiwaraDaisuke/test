import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minden/core/firebase/dynamic_links_route_mapper.dart';
import 'package:minden/core/provider/firebase_dynamic_links_provider.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_detail_page.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_list_page.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_search_by_tag_page.dart';
import 'package:minden/features/transition_screen/presentation/bloc/transition_screen_bloc.dart';

class PowerPlantHomeTabData {
  PowerPlantHomeTabData({
    required this.tabName,
    required this.tabPage,
  });

  late final String tabName;
  late final WidgetBuilder tabPage;
}

/// ホームタブ
class PowerPlantHomePage extends StatefulWidget {
  static const String routeName = '/home/top';

  @override
  _PowerPlantHomePageState createState() => _PowerPlantHomePageState();
}

class _PowerPlantHomePageState extends State<PowerPlantHomePage> {
  late TransitionScreenBloc _transitionScreenBloc;

  final tabs = [
    PowerPlantHomeTabData(
      tabName: '発電所一覧',
      tabPage: (_) => PowerPlantList(),
    ),
    PowerPlantHomeTabData(
      tabName: '発電所を探す',
      tabPage: (_) => const PowerPlantSearchByTag(),
    ),
  ];

  @override
  void initState() {
    super.initState();

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
              children: tabs.map((tab) => tab.tabPage(context)).toList(),
            );
          }),
        ),
      ),
    );
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
