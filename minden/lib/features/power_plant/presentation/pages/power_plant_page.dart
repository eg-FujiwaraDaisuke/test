import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_list_page.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_pickup_page.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_search_by_tag_page.dart';
import 'package:minden/features/power_plant/presentation/viewmodel/power_plant_page_view_model.dart';

class PowerPlantHomeTabData {
  PowerPlantHomeTabData({
    required this.tabName,
    required this.tabPage,
  });

  late final String tabName;
  late final WidgetBuilder tabPage;
}

/// ホーム - トップ
class PowerPlantHomePage extends StatelessWidget {
  PowerPlantHomePage({Key? key}) : super(key: key);

  final tabs = [
    PowerPlantHomeTabData(
        tabName: '発電所一覧', tabPage: (_) => const PowerPlantList()),
    PowerPlantHomeTabData(
        tabName: '発電所を探す', tabPage: (_) => PowerPlantSearchByTag()),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO 初期データ取得
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read(powerPlantPageViewModelProvider.notifier).fetch();
    });

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
          child: TabBarView(
            children: tabs.map((tab) => tab.tabPage(context)).toList(),
          ),
        ),
      ),
    );
  }
}
