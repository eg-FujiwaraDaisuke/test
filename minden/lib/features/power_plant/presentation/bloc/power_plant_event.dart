import 'package:equatable/equatable.dart';

abstract class PowerPlantEvent extends Equatable {
  const PowerPlantEvent();
}

class GetPowerPlantsEvent extends PowerPlantEvent {
  const GetPowerPlantsEvent({
    this.tagId,
    this.giftTypeId,
    this.historyType,
  });

  final String? tagId;
  final String? giftTypeId;
  final String? historyType;

  @override
  List<Object> get props => [];
}

class GetPowerPlantEvent extends PowerPlantEvent {
  const GetPowerPlantEvent({
    this.plantId,
  });

  final String? plantId;

  @override
  List<Object> get props => [];
}

class GetSupportHistoryEvent extends PowerPlantEvent {
  const GetSupportHistoryEvent({
    required this.historyType,
    this.userId,
  });

  final String historyType;
  final String? userId;

  @override
  List<Object> get props => [];
}

class GetSupportActionEvent extends PowerPlantEvent {
  const GetSupportActionEvent({
    required this.plantId,
  });

  final String plantId;

  @override
  List<Object> get props => [];
}

class GetGiftEvent extends PowerPlantEvent {
  const GetGiftEvent();

  @override
  List<Object> get props => [];
}
