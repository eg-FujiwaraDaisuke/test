import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/power_plant/domain/entities/public_power_plant.dart';
import 'package:minden/features/power_plant/domain/entities/public_power_plant_detail.dart';

abstract class PublicPowerPlantRepository {
  /// 顔の見える発電所情報取得（一覧）
  /// [mpNumbers] MP番号の配列(パラメータ無し or mpNumbersの値が空の場合は全件取得される)
  Future<Either<PublicPowerPlantFailure, List<PublicPowerPlant>>>
      getPublicPowerPlant(List<String> mpNumbers);

  /// 顔の見える発電所情報取得（詳細）
  /// [id] MP番号(MP000001等)
  Future<Either<PublicPowerPlantFailure, PublicPowerPlantDetail>>
      getPublicPowerPlantDetail(String id);
}
