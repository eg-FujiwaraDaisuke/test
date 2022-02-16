import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

/// ホーム - トップ
class PowerPlantHomePage extends StatefulWidget {
  PowerPlantHomePage({Key? key}) : super(key: key);

  @override
  _PowerPlantHomePageState createState() => _PowerPlantHomePageState();
}

class _PowerPlantHomePageState extends State<PowerPlantHomePage> {
  late TransitionScreenBloc _transitionScreenBloc;

  final tabs = [
    PowerPlantHomeTabData(tabName: '発電所一覧', tabPage: (_) => PowerPlantList()),
    PowerPlantHomeTabData(
        tabName: '発電所を探す', tabPage: (_) => const PowerPlantSearchByTag()),
  ];

  @override
  void initState() {
    super.initState();

    _transitionScreenBloc = BlocProvider.of<TransitionScreenBloc>(context);
    _transitionScreenBloc.stream.listen((event) {
      if (event is TransitionScreenStart) {
        if (event.screen == 'PowerPlantHomePage') {
          if (event.isFirst)
            Navigator.popUntil(context, (route) => route.isFirst);
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
          child: TabBarView(
            children: tabs.map((tab) => tab.tabPage(context)).toList(),
          ),
        ),
      ),
    );
  }
}
