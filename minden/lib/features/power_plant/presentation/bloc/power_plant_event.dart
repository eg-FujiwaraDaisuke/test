import 'package:equatable/equatable.dart';

abstract class PowerPlantEvent extends Equatable {
  const PowerPlantEvent();
}

class GetPowerPlantsEvent extends PowerPlantEvent {
  GetPowerPlantsEvent({
    this.tagId,
    this.historyType,
  });

  String? tagId;
  String? historyType;

  @override
  List<Object> get props => [];
}

class GetPowerPlantEvent extends PowerPlantEvent {
  GetPowerPlantEvent({
    this.plantId,
  });

  String? plantId;

  @override
  List<Object> get props => [];
}

class GetSupportHistoryEvent extends PowerPlantEvent {
  GetSupportHistoryEvent({
    required this.historyType,
  });

  String historyType;

  @override
  List<Object> get props => [];
}
