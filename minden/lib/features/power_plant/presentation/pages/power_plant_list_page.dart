import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/hook/use_logger.dart';
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/features/login/presentation/bloc/logout_bloc.dart';
import 'package:minden/features/login/presentation/bloc/logout_event.dart';
import 'package:minden/features/login/presentation/pages/login_page.dart';
import 'package:minden/features/power_plant/data/datasources/power_plant_data_source.dart';
import 'package:minden/features/power_plant/data/repositories/power_plant_repository_impl.dart';
import 'package:minden/features/power_plant/domain/usecase/power_plant_usecase.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_bloc.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_event.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_state.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_list_item.dart';
import 'package:url_launcher/url_launcher.dart';

/// 発電所一覧
class PowerPlantList extends StatefulWidget {
  PowerPlantList({
    this.tagId,
    required this.onTapOpenSupportHistory,
  });

  static const String routeName = '/home/top/list';

  String? tagId;
  VoidCallback onTapOpenSupportHistory;

  @override
  State<StatefulWidget> createState() {
    return PowerPlantListState();
  }
}

class PowerPlantListState extends State<PowerPlantList> {
  late GetPowerPlantsBloc _getPowerPlantsBloc;

  @override
  void initState() {
    super.initState();

    _getPowerPlantsBloc = GetPowerPlantsBloc(
      const PowerPlantStateInitial(),
      GetPowerPlants(
        PowerPlantRepositoryImpl(
          powerPlantDataSource: PowerPlantDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );

    _getPowerPlantsBloc.stream.listen((event) async {
      if (event is PowerPlantLoadError) {
        if (event.needLogin) {
          BlocProvider.of<LogoutBloc>(context).add(LogoutEvent());
          Loading.show(context);
          await Future.delayed(const Duration(seconds: 2));
          await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ), (_) {
            Loading.hide();
            return false;
          });
        }
      }
    });
    _getPowerPlantsBloc.add(GetPowerPlantsEvent(tagId: widget.tagId));
  }

  @override
  void dispose() {
    _getPowerPlantsBloc.close();
    Loading.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _getPowerPlantsBloc,
      child: BlocListener<GetPowerPlantsBloc, PowerPlantState>(
        listener: (context, state) {
          if (state is PowerPlantLoading) {
            Loading.show(context);
            return;
          }
          Loading.hide();
        },
        child: BlocBuilder<GetPowerPlantsBloc, PowerPlantState>(
          builder: (context, state) {
            logD('Get power plant. state: $state');

            if (state is PowerPlantsLoaded) {
              final numPowerPlant = state.powerPlants.powerPlants.length;
              return ListView(
                children: [
                  _buildSupportHistoryButton(),
                  for (var i = 0; i < state.powerPlants.powerPlants.length; i++)
                    PowerPlantListItem(
                      powerPlant: state.powerPlants.powerPlants[i],
                      direction: searchDirectionByIndex(i),
                    ),
                  buildLastItem(
                    context: context,
                    numPowerPlant: numPowerPlant,
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildSupportHistoryButton() {
    return Container(
      color: const Color(0xFF82D2A3),
      height: 188,
      child: Stack(
        children: [
          Image.asset(
            'assets/images/power_plant/support_history_button_confetti.png',
            height: 188,
          ),
          Align(
            alignment: const Alignment(0.97, 1),
            child: Image.asset(
              'assets/images/power_plant/support_history_button_character_2.png',
              height: 100,
            ),
          ),
          Align(
            alignment: const Alignment(0.92, -1),
            child: Image.asset(
              'assets/images/power_plant/support_history_button_character_3.png',
              height: 120,
            ),
          ),
          Align(
            alignment: const Alignment(-0.8, -1),
            child: Image.asset(
              'assets/images/power_plant/support_history_button_character_4.png',
              height: 120,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              'assets/images/power_plant/support_history_button_character_5.png',
              height: 120,
            ),
          ),
          Center(
            child: SizedBox(
              width: 260,
              height: 150,
              child: Material(
                elevation: 10,
                color: Colors.white,
                borderRadius: BorderRadius.circular(75),
                child: InkWell(
                  borderRadius: BorderRadius.circular(75),
                  onTap: widget.onTapOpenSupportHistory,
                  child: Stack(
                    children: [
                      const Align(
                        alignment: Alignment(0, -0.6),
                        child: Text(
                          'これまで\nみんなで届けた応援金は...',
                          style: TextStyle(
                            fontFamily: 'NotoSansJP',
                            color: Color(0xFF828282),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/power_plant/support_history_button_character_1.png',
                              height: 90,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'もっと見る',
                                  style: TextStyle(
                                    fontFamily: 'NotoSansJP',
                                    color: Color(0xFF7D7E7F),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Image.asset(
                                    'assets/images/power_plant/support_history_button_arrow.png',
                                    height: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Direction searchDirectionByIndex(int index) {
    switch (index % 4) {
      case 0:
        return Direction.topLeft;
      case 1:
        return Direction.topRight;
      case 2:
        return Direction.bottomRight;
      case 3:
        return Direction.bottomLeft;
      default:
        return Direction.topLeft;
    }
  }

  Widget buildLastItem({
    required BuildContext context,
    required int numPowerPlant,
  }) {
    const textStyle = TextStyle(
      fontFamily: 'NotoSansJP',
      fontSize: 10,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 14, 36),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            launch('https://portal.minden.co.jp');
          },
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/power_plant/character_smile.png',
                  width: 92,
                ),
                SizedBox(
                  width: 190,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'アプリではピックアップしている$numPowerPlantヶ所\n'
                              'の発電所から応援先を選択できます。\n',
                          style: textStyle.copyWith(
                            color: const Color(0xff828282),
                          ),
                        ),
                        TextSpan(
                          text: 'マイページ（WEB）',
                          style: textStyle.copyWith(
                            color: const Color(0xff75c975),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'では全ての発電所を\n'
                              '掲載しています。',
                          style: textStyle.copyWith(
                            color: const Color(0xff828282),
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
