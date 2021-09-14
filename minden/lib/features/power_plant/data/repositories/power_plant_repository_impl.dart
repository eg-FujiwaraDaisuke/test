import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/power_plant/data/datasources/power_plant_data_source.dart';
import 'package:minden/features/power_plant/data/repositories/power_plant_repository_mock.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_detail.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_participant.dart';
import 'package:minden/features/power_plant/domain/entities/power_plants_response.dart';
import 'package:minden/features/power_plant/domain/entities/tag_response.dart';
import 'package:minden/features/power_plant/domain/repositories/power_plant_repository.dart';

const bool replaceMock = true;

final powerPlantRepositoryProvider = Provider<PowerPlantRepository>(
  (ref) {
    if (replaceMock) {
      return PowerPlantRepositoryMock();
    } else {
      return PowerPlantRepositoryImpl(
        powerPlantDataSource: ref.read(powerPlantDataSourceProvider),
      );
    }
  },
);

class PowerPlantRepositoryImpl implements PowerPlantRepository {
  PowerPlantRepositoryImpl({required this.powerPlantDataSource});

  final PowerPlantDataSource powerPlantDataSource;

  @override
  Future<Either<PowerPlantFailure, PowerPlantsResponse>> getPowerPlant(
      String? tagId) async {
    try {
      final plants = await powerPlantDataSource.getPowerPlant(tagId);
      return Right(plants);
    } on ServerException {
      return left(PowerPlantFailure());
    }
  }

  @override
  Future<Either<PowerPlantFailure, PowerPlantDetail>> getPowerPlantDetail(
      String plantId) async {
    try {
      final plant = await powerPlantDataSource.getPowerPlantDetail(plantId);
      return Right(plant);
    } on ServerException {
      return left(PowerPlantFailure());
    }
  }

  @override
  Future<Either<PowerPlantFailure, PowerPlantParticipant>>
      getPowerPlantParticipants(String plantId) async {
    try {
      final plant =
          await powerPlantDataSource.getPowerPlantParticipants(plantId);
      return Right(plant);
    } on ServerException {
      return left(PowerPlantFailure());
    }
  }

  @override
  Future<Either<PowerPlantFailure, TagResponse>> getPowerPlantTags(
      String plantId) async {
    try {
      final plant = await powerPlantDataSource.getPowerPlantTags(plantId);
      return Right(plant);
    } on ServerException {
      return left(PowerPlantFailure());
    }
  }
}
