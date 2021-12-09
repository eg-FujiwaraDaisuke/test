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
import 'package:minden/core/ext/logger_ext.dart';
import 'package:intl/intl.dart';

class SupportHistoryPowerPlantList extends StatefulWidget {
  const SupportHistoryPowerPlantList(this.historyType);

  final String historyType;

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

    _historyBloc.add(GetSupportHistoryEvent(historyType: widget.historyType));
  }

  @override
  void dispose() {
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
            Loading.show(context);
            return;
          }
          Loading.hide();
        },
        child: BlocBuilder<GetPowerPlantsHistoryBloc, PowerPlantState>(
          builder: (context, state) {
            if (state is HistoryLoaded) {
              logV('${state.history.toJson()}');
              return ListView.builder(
                itemCount: state.history.powerPlants.length,
                itemBuilder: (BuildContext context, int index) {
                  final supportHistoryPowerPlant =
                      state.history.powerPlants[index];
                  final direction = searchDirectionByIndex(index);

                  final year =
                      supportHistoryPowerPlant.yearMonth.substring(0, 4);
                  final day =
                      int.parse(supportHistoryPowerPlant.yearMonth.substring(4))
                          .toString();

                  return PowerPlantListItem(
                    key: ValueKey(supportHistoryPowerPlant.plantId),
                    powerPlant:
                        PowerPlant.fromJson(supportHistoryPowerPlant.toJson()),
                    direction: direction,
                    isShowCatchphras: false,
                    aspectRatio: 340 / 289,
                    thumbnailImageHeight: 226,
                    fromApp: supportHistoryPowerPlant.fromApp,
                    supportedData:
                        widget.historyType == 'history' ? '$year年$day日' : null,
                    reservedDate: widget.historyType == 'reservation'
                        ? '$year年$day日'
                        : null,
                  );
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
