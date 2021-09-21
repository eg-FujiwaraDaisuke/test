import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_detail.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_participant.dart';
import 'package:minden/features/power_plant/domain/entities/power_plants_response.dart';
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

class GetPowerPlantParams extends Equatable {
  GetPowerPlantParams({
    this.plantId,
    this.tagId,
  });

  String? plantId;
  String? tagId;

  @override
  List<Object> get props => [];
}
