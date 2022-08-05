import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/features/power_plant/data/datasources/power_plant_data_source.dart';
import 'package:minden/features/power_plant/data/repositories/power_plant_repository_impl.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant.dart';
import 'package:minden/features/power_plant/domain/usecase/power_plant_usecase.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_bloc.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_event.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_state.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_list_item.dart';

class SupportHistoryPowerPlantList extends StatefulWidget {
  const SupportHistoryPowerPlantList({
    required this.historyType,
    this.userId,
  });

  final String historyType;
  final String? userId;

  @override
  State<StatefulWidget> createState() {
    return _SupportHistoryPowerPlantListState();
  }
}

class _SupportHistoryPowerPlantListState
    extends State<SupportHistoryPowerPlantList> {
  late GetPowerPlantsHistoryBloc _historyBloc;

  @override
  void initState() {
    super.initState();
    _historyBloc = GetPowerPlantsHistoryBloc(
      const PowerPlantStateInitial(),
      GetPowerPlantsHistory(
        PowerPlantRepositoryImpl(
          powerPlantDataSource: PowerPlantDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );

    _historyBloc.add(GetSupportHistoryEvent(
        historyType: widget.historyType, userId: widget.userId));
  }

  @override
  void dispose() {
    Loading.hide();
    _historyBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _historyBloc,
      child: BlocListener<GetPowerPlantsHistoryBloc, PowerPlantState>(
        listener: (context, state) {
          if (state is HistoryLoading) {
/*
            Loading.show(context);
*/
            return;
          }
        },
        child: BlocBuilder<GetPowerPlantsHistoryBloc, PowerPlantState>(
          builder: (context, state) {
            if (state is HistoryLoaded) {
              Loading.hide();
              var index = 0;
              return Column(
                  children:
                      state.history.powerPlants.map((supportHistoryPowerPlant) {
                final direction = searchDirectionByIndex(index);
                final year = supportHistoryPowerPlant.yearMonth.substring(0, 4);
                final day =
                    int.parse(supportHistoryPowerPlant.yearMonth.substring(4))
                        .toString();
                index++;
                return PowerPlantListItem(
                  powerPlant:
                      PowerPlant.fromJson(supportHistoryPowerPlant.toJson()),
                  direction: direction,
                  isShowCatchphras: false,
                  fromApp: supportHistoryPowerPlant.fromApp,
                  supportedData:
                      widget.historyType == 'history' ? '$year年$day月' : null,
                  reservedDate: widget.historyType == 'reservation'
                      ? '$year年$day月'
                      : null,
                );
              }).toList());
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
