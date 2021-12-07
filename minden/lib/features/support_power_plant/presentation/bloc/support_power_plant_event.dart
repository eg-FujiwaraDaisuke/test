part of 'support_power_plant_bloc.dart';

abstract class SupportPowerPlantEvent extends Equatable {
  const SupportPowerPlantEvent();
}

class UpdateSupportPowerPlantEvent extends SupportPowerPlantEvent {
  const UpdateSupportPowerPlantEvent(this.plantIdList);

  final Map<String, List<Map<String, String>>> plantIdList;

  @override
  List<Object> get props => [plantIdList];
}
