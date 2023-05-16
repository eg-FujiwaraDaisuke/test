part of 'support_power_plant_bloc.dart';

abstract class SupportPowerPlantEvent extends Equatable {
  const SupportPowerPlantEvent();
}

class UpdateSupportPowerPlantEvent extends SupportPowerPlantEvent {
  const UpdateSupportPowerPlantEvent(
    this.newSupportPowerPlant,
    this.supportPowerPlants,
  );

  /// 新たに応援することになった発電所一覧
  final PowerPlant newSupportPowerPlant;

  /// 応援する発電所一覧
  final List<PowerPlant> supportPowerPlants;

  Map<String, List<Map<String, String>>> get plantIdList => {
        'plantIdList': supportPowerPlants
            .map((powerPlant) => {'plantId': powerPlant.plantId})
            .toList()
      };

  @override
  List<Object> get props => [
        newSupportPowerPlant,
        supportPowerPlants,
      ];
}
