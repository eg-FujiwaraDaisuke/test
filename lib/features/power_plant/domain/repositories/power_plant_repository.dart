import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_detail.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_gift.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_participant.dart';
import 'package:minden/features/power_plant/domain/entities/power_plants_response.dart';
import 'package:minden/features/power_plant/domain/entities/support_action.dart';
import 'package:minden/features/power_plant/domain/entities/support_history.dart';
import 'package:minden/features/power_plant/domain/entities/tag_response.dart';

abstract class PowerPlantRepository {
  /// 顔の見える発電所情報取得（一覧）
  /// [tagId] フィルタタグid
  Future<Either<PowerPlantFailure, PowerPlantsResponse>> getPowerPlant(
    String? tagId,
    String? giftTypeId,
  );

  /// 顔の見える発電所情報取得（詳細）
  /// [plantId] 発電所id
  Future<Either<PowerPlantFailure, PowerPlantDetail>> getPowerPlantDetail(
    String plantId,
  );

  /// 発電所応援ユーザー取得（一覧）
  Future<Either<PowerPlantFailure, PowerPlantParticipant>>
      getPowerPlantParticipants(
    String plantId, [
    int page,
  ]);

  /// 発電所大切にしているタグ（一覧）
  Future<Either<PowerPlantFailure, TagResponse>> getPowerPlantTags(
    String plantId,
  );

  /// [historyType] 応援予約 or 応援履歴
  Future<Either<PowerPlantFailure, SupportHistory>> getPowerPlantHistory(
    String historyType,
    String? userId,
  );

  /// 応援ボタン表示制御API
  Future<Either<PowerPlantFailure, SupportAction>> getSupportAction(
    String plantId,
  );

  /// 発電所の特典（一覧）
  Future<Either<PowerPlantFailure, List<PowerPlantGift>>> getGift();
}
