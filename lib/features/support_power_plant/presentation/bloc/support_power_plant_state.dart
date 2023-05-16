part of 'support_power_plant_bloc.dart';

abstract class SupportPowerPlantState extends Equatable {
  const SupportPowerPlantState();
}

class SupportPowerPlantInitial extends SupportPowerPlantState {
  const SupportPowerPlantInitial();

  @override
  List<Object> get props => [];
}

class SupportPowerPlantUpdating extends SupportPowerPlantState {
  const SupportPowerPlantUpdating();

  @override
  List<Object> get props => [];
}

class SupportPowerPlantUpdated extends SupportPowerPlantState {
  const SupportPowerPlantUpdated({
    required this.newSupportPowerPlant,
    required this.supportPowerPlants,
  });

  /// 新たに応援することになった発電所一覧
  final PowerPlant newSupportPowerPlant;

  /// 応援する発電所一覧
  final List<PowerPlant> supportPowerPlants;

  @override
  List<Object> get props => [
        newSupportPowerPlant,
        supportPowerPlants,
      ];
}

class SupportPowerPlantError extends SupportPowerPlantState {
  const SupportPowerPlantError({
    required this.message,
    required this.needLogin,
  });

  final String message;
  final bool needLogin;

  @override
  List<Object> get props => [message];
}
