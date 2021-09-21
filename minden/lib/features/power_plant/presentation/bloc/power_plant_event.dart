import 'package:equatable/equatable.dart';

abstract class PowerPlantEvent extends Equatable {
  const PowerPlantEvent();
}

class GetPowerPlantsEvent extends PowerPlantEvent {
  GetPowerPlantsEvent({
    this.tagId,
  });

  String? tagId;

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
