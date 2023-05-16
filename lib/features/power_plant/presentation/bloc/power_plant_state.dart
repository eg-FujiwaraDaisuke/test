import 'package:equatable/equatable.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_detail.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_gift.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_participant.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_participant_all_user.dart';
import 'package:minden/features/power_plant/domain/entities/power_plants_response.dart';
import 'package:minden/features/power_plant/domain/entities/support_action.dart';
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

class SupportActionLoaded extends PowerPlantState {
  const SupportActionLoaded(this.supportAction);

  final SupportAction supportAction;

  @override
  List<Object> get props => [];
}

class GiftLoaded extends PowerPlantState {
  const GiftLoaded(this.powerPlantGifts);

  final List<PowerPlantGift> powerPlantGifts;

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

class AllParticipantLoaded extends PowerPlantState {
  const AllParticipantLoaded(this.participant);

  final PowerPlantParticipantAllUser participant;

  @override
  List<Object> get props => [participant];
}

class PowerPlantLoading extends PowerPlantState {
  const PowerPlantLoading();

  @override
  List<Object> get props => [];
}

class SupportActionLoading extends PowerPlantState {
  const SupportActionLoading();

  @override
  List<Object> get props => [];
}

class GiftLoading extends PowerPlantState {
  const GiftLoading();

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
