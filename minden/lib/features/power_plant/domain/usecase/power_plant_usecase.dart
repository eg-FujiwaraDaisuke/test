import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_detail.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_participant.dart';
import 'package:minden/features/power_plant/domain/entities/power_plants_response.dart';
import 'package:minden/features/power_plant/domain/entities/support_action.dart';
import 'package:minden/features/power_plant/domain/entities/support_history.dart';
import 'package:minden/features/power_plant/domain/entities/tag_response.dart';
import 'package:minden/features/power_plant/domain/repositories/power_plant_repository.dart';

class GetPowerPlants extends UseCase<PowerPlantsResponse, GetPowerPlantParams> {
  GetPowerPlants(this.repository);

  final PowerPlantRepository repository;

  @override
  Future<Either<Failure, PowerPlantsResponse>> call(
      GetPowerPlantParams params) async {
    return await repository.getPowerPlant(params.tagId);
  }
}

class GetPowerPlantsHistory
    extends UseCase<SupportHistory, GetPowerPlantParams> {
  GetPowerPlantsHistory(this.repository);

  final PowerPlantRepository repository;

  @override
  Future<Either<Failure, SupportHistory>> call(
      GetPowerPlantParams params) async {
    return await repository.getPowerPlantHistory(
        params.historyType!, params.userId);
  }
}

class GetPowerPlant extends UseCase<PowerPlantDetail, GetPowerPlantParams> {
  GetPowerPlant(this.repository);

  final PowerPlantRepository repository;

  @override
  Future<Either<Failure, PowerPlantDetail>> call(
      GetPowerPlantParams params) async {
    return await repository.getPowerPlantDetail(params.plantId!);
  }
}

class GetPowerPlantParticipant
    extends UseCase<PowerPlantParticipant, GetPowerPlantParams> {
  GetPowerPlantParticipant(this.repository);

  final PowerPlantRepository repository;

  @override
  Future<Either<Failure, PowerPlantParticipant>> call(
      GetPowerPlantParams params) async {
    return await repository.getPowerPlantParticipants(params.plantId!);
  }
}

class GetPowerPlantTags extends UseCase<TagResponse, GetPowerPlantParams> {
  GetPowerPlantTags(this.repository);

  final PowerPlantRepository repository;

  @override
  Future<Either<Failure, TagResponse>> call(GetPowerPlantParams params) async {
    return await repository.getPowerPlantTags(params.plantId!);
  }
}

class GetSupportAction extends UseCase<SupportAction, GetPowerPlantParams> {
  GetSupportAction(this.repository);

  final PowerPlantRepository repository;

  @override
  Future<Either<Failure, SupportAction>> call(
      GetPowerPlantParams params) async {
    return await repository.getSupportAction(params.plantId!);
  }
}

class GetPowerPlantParams extends Equatable {
  GetPowerPlantParams({
    this.plantId,
    this.tagId,
    this.historyType,
    this.userId,
  });

  String? plantId;
  String? userId;
  String? tagId;
  String? historyType;

  @override
  List<Object> get props => [];
}
