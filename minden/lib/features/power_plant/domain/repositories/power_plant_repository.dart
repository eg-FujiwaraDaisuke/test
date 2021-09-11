import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_detail.dart';
import 'package:minden/features/power_plant/domain/entities/power_plants_response.dart';

abstract class PublicPowerPlantRepository {
  /// 顔の見える発電所情報取得（一覧）
  /// [tagId] フィルタタグid
  Future<Either<PublicPowerPlantFailure, PowerPlantsResponse>> getPowerPlant(
      String tagId);

  /// 顔の見える発電所情報取得（詳細）
  /// [plantId] 発電所id
  Future<Either<PublicPowerPlantFailure, PowerPlantDetail>> getPowerPlantDetail(
      String plantId);
}
