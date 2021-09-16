import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:minden/features/power_plant/presentation/pages/power_plant_detail_page.dart';

import 'package:minden/features/power_plant/presentation/viewmodel/power_plant_page_view_model.dart';
import 'package:minden/features/support_power_plant/presentation/pages/support_history_power_plant_page.dart';

class SupportPowerPlantTabData {
  SupportPowerPlantTabData({
    required this.tabName,
    required this.tabPage,
  });

  late final String tabName;
  late final WidgetBuilder tabPage;
}

/// ホーム - トップ
class SupportPowerPlantPage extends StatelessWidget {
  SupportPowerPlantPage({Key? key}) : super(key: key);

  final tabs = [
    SupportPowerPlantTabData(
      tabName: '次に応援する発電所',
      tabPage: (_) => const PowerPlantDetailPage(powerPlantId: 'MP2021080802'),
    ),
    SupportPowerPlantTabData(
      tabName: '応援した発電所',
      tabPage: (_) => const SupportHistoryPowerPlantPage(),
    ),
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
                indicatorColor: Color(0xFFFF8C00),
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
