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
  const SupportPowerPlantUpdated();
  @override
  List<Object> get props => [];
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
