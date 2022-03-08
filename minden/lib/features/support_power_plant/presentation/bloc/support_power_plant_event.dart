part of 'support_power_plant_bloc.dart';

abstract class SupportPowerPlantEvent extends Equatable {
  const SupportPowerPlantEvent();
}

class UpdateSupportPowerPlantEvent extends SupportPowerPlantEvent {
  const UpdateSupportPowerPlantEvent(this.newRegistPowerPlants);

  /// 新たに応援することになった発電所一覧
  final List<PowerPlant> newRegistPowerPlants;

  Map<String, List<Map<String, String>>> get plantIdList => {
        'plantIdList': newRegistPowerPlants
            .map((powerPlant) => {'plantId': powerPlant.plantId})
            .toList()
      };

  @override
  List<Object> get props => [newRegistPowerPlants];
}
