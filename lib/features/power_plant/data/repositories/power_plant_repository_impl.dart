import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/repository/retry_process_mixin.dart';
import 'package:minden/features/power_plant/data/datasources/power_plant_data_source.dart';
import 'package:minden/features/power_plant/data/repositories/power_plant_repository_mock.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_detail.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_gift.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_participant.dart';
import 'package:minden/features/power_plant/domain/entities/power_plants_response.dart';
import 'package:minden/features/power_plant/domain/entities/support_action.dart';
import 'package:minden/features/power_plant/domain/entities/support_history.dart';
import 'package:minden/features/power_plant/domain/entities/tag_response.dart';
import 'package:minden/features/power_plant/domain/repositories/power_plant_repository.dart';

const bool replaceMock = false;

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

class PowerPlantRepositoryImpl
    with RetryProcessMixin
    implements PowerPlantRepository {
  PowerPlantRepositoryImpl({required this.powerPlantDataSource});

  final PowerPlantDataSource powerPlantDataSource;

  @override
  Future<Either<PowerPlantFailure, PowerPlantsResponse>> getPowerPlant(
    String? tagId,
    String? giftTypeId,
  ) async {
    try {
      final plants =
          await retryRequest(() => powerPlantDataSource.getPowerPlant(
                tagId,
                giftTypeId,
              ));

      return Right(plants);
    } on ServerException {
      return left(PowerPlantFailure());
    }
  }

  @override
  Future<Either<PowerPlantFailure, PowerPlantDetail>> getPowerPlantDetail(
      String plantId) async {
    try {
      final plant = await retryRequest(
          () => powerPlantDataSource.getPowerPlantDetail(plantId));
      return Right(plant);
    } on ServerException {
      return left(PowerPlantFailure());
    }
  }

  @override
  Future<Either<PowerPlantFailure, PowerPlantParticipant>>
      getPowerPlantParticipants(
    String plantId, [
    int page = 1,
  ]) async {
    try {
      final plant = await retryRequest(
          () => powerPlantDataSource.getPowerPlantParticipants(plantId, page));
      return Right(plant);
    } on ServerException {
      return left(PowerPlantFailure());
    }
  }

  @override
  Future<Either<PowerPlantFailure, TagResponse>> getPowerPlantTags(
      String plantId) async {
    try {
      final plant = await retryRequest(
          () => powerPlantDataSource.getPowerPlantTags(plantId));
      return Right(plant);
    } on ServerException {
      return left(PowerPlantFailure());
    }
  }

  /// [historyType] 応援予約 or 応援履歴
  @override
  Future<Either<PowerPlantFailure, SupportHistory>> getPowerPlantHistory(
      String historyType, String? userId) async {
    try {
      final history = await retryRequest(
          () => powerPlantDataSource.getPowerPlantHistory(historyType, userId));
      return Right(history);
    } on ServerException {
      return left(PowerPlantFailure());
    }
  }

  @override
  Future<Either<PowerPlantFailure, SupportAction>> getSupportAction(
    String plantId,
  ) async {
    try {
      final supportAction = await retryRequest(
          () => powerPlantDataSource.getSupportAction(plantId));
      return Right(supportAction);
    } on ServerException {
      return left(PowerPlantFailure());
    }
  }

  @override
  Future<Either<PowerPlantFailure, List<PowerPlantGift>>> getGift() async {
    try {
      final powerPlantGift =
          await retryRequest(powerPlantDataSource.getPlantsGifts);
      return Right(powerPlantGift);
    } on ServerException {
      return left(PowerPlantFailure());
    }
  }
}
