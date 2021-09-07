import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/power_plant/data/datasources/public_power_plant_data_source.dart';
import 'package:minden/features/power_plant/domain/entities/public_power_plant.dart';
import 'package:minden/features/power_plant/domain/entities/public_power_plant_detail.dart';
import 'package:minden/features/power_plant/domain/repositories/public_power_plant_repository.dart';

final publicPowerPlantRepositoryProvider = Provider<PublicPowerPlantRepository>(
    (ref) => PublicPowerPlantRepositoryImpl(
        publicPowerPlantDataSource:
            ref.read(publicPowerPlantDataSourceProvider)));

class PublicPowerPlantRepositoryImpl implements PublicPowerPlantRepository {
  PublicPowerPlantRepositoryImpl({required this.publicPowerPlantDataSource});

  final PublicPowerPlantDataSource publicPowerPlantDataSource;

  @override
  Future<Either<PublicPowerPlantFailure, List<PublicPowerPlant>>>
      getPublicPowerPlant(List<String> mpNumbers) async {
    try {
      final plants =
          await publicPowerPlantDataSource.getPublicPowerPlant(mpNumbers);
      return Right(plants);
    } on ServerException {
      return left(PublicPowerPlantFailure());
    }
  }

  @override
  Future<Either<PublicPowerPlantFailure, PublicPowerPlantDetail>>
      getPublicPowerPlantDetail(String id) async {
    try {
      final plant =
          await publicPowerPlantDataSource.getPublicPowerPlantDetail(id);
      return Right(plant);
    } on ServerException {
      return left(PublicPowerPlantFailure());
    }
  }
}
