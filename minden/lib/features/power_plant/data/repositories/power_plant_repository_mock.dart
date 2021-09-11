import 'package:dartz/dartz.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/power_plant/data/model/power_plant_model.dart';
import 'package:minden/features/power_plant/data/model/tag_model.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_detail.dart';
import 'package:minden/features/power_plant/domain/entities/power_plants_response.dart';
import 'package:minden/features/power_plant/domain/repositories/power_plant_repository.dart';

class PowerPlantRepositoryMock implements PowerPlantRepository {
  @override
  Future<Either<PowerPlantFailure, PowerPlantsResponse>> getPowerPlant(
      String? tagId) async {
    try {
      final data = PowerPlantsResponse(
        tag: const TagModel(
          tagId: '1',
          tagName: 'テストタグ',
        ),
        powerPlants: [
          PowerPlantModel(
            plantId: '1',
            areaCode: '1',
            name: 'ABC発電所',
            viewAddress: '東京都',
            voltageType: '1',
            powerGenerationMethod: '太陽光発電',
            renewableType: '1',
            generationCapacity: '1234',
            displayOrder: '1',
            isRecommend: true,
            ownerName: '1',
            startDate: DateTime.now(),
            endDate: DateTime.now(),
            plantImage1: '1',
            supportGiftName: '1',
            shortCatchphrase: '1',
            catchphrase: 'キャッチフレーズ',
            thankYouMessage: '1',
          ),
        ],
      );
      return Right(data);
    } on ServerException {
      return left(PowerPlantFailure());
    }
  }

  @override
  Future<Either<PowerPlantFailure, PowerPlantDetail>> getPowerPlantDetail(
      String plantId) async {
    try {
      final data = PowerPlantDetail(
        plantId: '1',
        areaCode: '1',
        name: 'ABC発電所',
        viewAddress: '東京都',
        voltageType: '1',
        powerGenerationMethod: '太陽光発電',
        renewableType: '1',
        generationCapacity: '1234',
        displayOrder: '1',
        isRecommend: true,
        ownerName: '1',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        plantImage1: '1',
        supportGiftName: '1',
        shortCatchphrase: '1',
        catchphrase: 'キャッチフレーズ',
        thankYouMessage: '1',
      );
      return Right(data);
    } on ServerException {
      return left(PowerPlantFailure());
    }
  }
}
