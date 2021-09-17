import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/features/power_plant/presentation/viewmodel/power_plant_page_view_model.dart';
import 'package:minden/features/support_history_power_plant/presentation/pages/support_history_power_plant_list.dart';

class SupportPowerPlantTabData {
  SupportPowerPlantTabData({
    required this.tabName,
    required this.tabPage,
  });

  late final String tabName;
  late final WidgetBuilder tabPage;
}

/// ホーム - トップ
class SupportHistoryPowerPlantPage extends StatelessWidget {
  SupportHistoryPowerPlantPage({Key? key}) : super(key: key);

  final tabs = [
    SupportPowerPlantTabData(
      tabName: '次に応援する発電所',
      tabPage: (_) => const SupportHistoryPowerPlantList(),
    ),
    SupportPowerPlantTabData(
      tabName: '応援した発電所',
      tabPage: (_) => const SupportHistoryPowerPlantList(),
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
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
            onTap: Navigator.of(context).pop,
            child: Center(
              child: SvgPicture.asset(
                'assets/images/common/leading_back.svg',
                fit: BoxFit.fill,
                width: 44,
                height: 44,
              ),
            ),
          ),
          bottom: TabBar(
            indicatorColor: const Color(0xFFFF8C00),
            tabs: tabs
                .map((tab) => Text(
                      tab.tabName,
                      textAlign: TextAlign.center,
                    ))
                .toList(),
          ),
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
