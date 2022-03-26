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

/// 発電所一覧
class PowerPlantList extends StatefulWidget {
  PowerPlantList({this.tagId});

  static const String routeName = '/home/top/list';

  String? tagId;

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
              return ListView.builder(
                itemCount: numPowerPlant + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index < numPowerPlant) {
                    final powerPlant = state.powerPlants.powerPlants[index];
                    final direction = searchDirectionByIndex(index);
                    return PowerPlantListItem(
                      powerPlant: powerPlant,
                      direction: direction,
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(18, 14, 18, 66),
                      child: Text(
                        '※アプリではピックアップしている$numPowerPlantヶ所の発電所を表示しております。',
                        style: const TextStyle(
                          color: Color(0xff7d7e7f),
                          fontFamily: 'NotoSansJP',
                          fontSize: 10,
                        ),
                      ),
                    );
                  }
                },
              );
            }
            return Container();
          },
        ),
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
}
