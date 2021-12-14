import 'package:equatable/equatable.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_detail.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_participant.dart';
import 'package:minden/features/power_plant/domain/entities/power_plants_response.dart';
import 'package:minden/features/power_plant/domain/entities/support_history.dart';

abstract class PowerPlantState extends Equatable {
  const PowerPlantState();
}

class PowerPlantStateInitial extends PowerPlantState {
  const PowerPlantStateInitial();

  @override
  List<Object> get props => [];
}

class PowerPlantsLoaded extends PowerPlantState {
  const PowerPlantsLoaded(this.powerPlants);

  final PowerPlantsResponse powerPlants;

  @override
  List<Object> get props => [powerPlants];
}

class PowerPlantLoaded extends PowerPlantState {
  const PowerPlantLoaded(this.powerPlant);

  final PowerPlantDetail powerPlant;

  @override
  List<Object> get props => [powerPlant];
}

class HistoryLoaded extends PowerPlantState {
  const HistoryLoaded(this.history);

  final SupportHistory history;

  @override
  List<Object> get props => [];
}

class HistoryLoading extends PowerPlantState {
  const HistoryLoading();

  @override
  List<Object> get props => [];
}

class ParticipantLoaded extends PowerPlantState {
  const ParticipantLoaded(this.participant);

  final PowerPlantParticipant participant;

  @override
  List<Object> get props => [participant];
}

class PowerPlantLoading extends PowerPlantState {
  const PowerPlantLoading();

  @override
  List<Object> get props => [];
}

class PowerPlantLoadError extends PowerPlantState {
  const PowerPlantLoadError({
    required this.message,
    required this.needLogin,
  });

  final String message;
  final bool needLogin;

  @override
  List<Object> get props => [message];
}
