import 'package:dartz/dartz.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/power_plant/data/datasources/power_plant_data_source.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_detail.dart';
import 'package:minden/features/power_plant/domain/entities/power_plants_response.dart';
import 'package:minden/features/power_plant/domain/repositories/power_plant_repository.dart';

class PublicPowerPlantRepositoryImpl implements PublicPowerPlantRepository {
  PublicPowerPlantRepositoryImpl({required this.publicPowerPlantDataSource});

  final PowerPlantDataSource publicPowerPlantDataSource;

  @override
  Future<Either<PublicPowerPlantFailure, PowerPlantsResponse>> getPowerPlant(
      String tagId) async {
    try {
      final plants = await publicPowerPlantDataSource.getPowerPlant(tagId);
      return Right(plants);
    } on ServerException {
      return left(PublicPowerPlantFailure());
    }
  }

  @override
  Future<Either<PublicPowerPlantFailure, PowerPlantDetail>> getPowerPlantDetail(
      String plantId) async {
    try {
      final plant =
          await publicPowerPlantDataSource.getPowerPlantDetail(plantId);
      return Right(plant);
    } on ServerException {
      return left(PublicPowerPlantFailure());
    }
  }
}
