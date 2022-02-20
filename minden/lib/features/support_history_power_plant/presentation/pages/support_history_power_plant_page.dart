import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

  static const String routeName = '/user/supportPowerPlant';

  final tabs = [
    SupportPowerPlantTabData(
      tabName: '次に応援する発電所',
      tabPage: (_) => const SingleChildScrollView(
          child: SupportHistoryPowerPlantList('reservation')),
    ),
    SupportPowerPlantTabData(
      tabName: '応援した発電所',
      tabPage: (_) => const SingleChildScrollView(
          child: SupportHistoryPowerPlantList('history')),
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
