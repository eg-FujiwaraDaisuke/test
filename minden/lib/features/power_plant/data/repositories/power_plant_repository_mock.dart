import 'package:dartz/dartz.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/power_plant/data/model/power_plant_model.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_detail.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_participant.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_participant_user.dart';
import 'package:minden/features/power_plant/domain/entities/power_plants_response.dart';
import 'package:minden/features/power_plant/domain/entities/tag_response.dart';
import 'package:minden/features/power_plant/domain/repositories/power_plant_repository.dart';
import 'package:minden/features/profile_setting/data/models/tag_model.dart';
import 'package:minden/features/profile_setting/domain/entities/tag.dart';

class PowerPlantRepositoryMock implements PowerPlantRepository {
  @override
  Future<Either<PowerPlantFailure, PowerPlantsResponse>> getPowerPlant(
      String? tagId) async {
    try {
      final data = PowerPlantsResponse(
        tag: const TagModel(
          tagId: 1,
          tagName: 'テストタグ',
          colorCode: '1',
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
            generationCapacity: 1234,
            displayOrder: 1,
            isRecommend: true,
            ownerName: '1',
            startDate: DateTime.now(),
            endDate: DateTime.now(),
            plantImage1: '1',
            supportGiftName: '1',
            shortCatchphrase: '田んぼの上に\nソーラーパネルを',
            catchphrase: 'キャッチフレーズ',
            thankYouMessage: '1',
          ),
          PowerPlantModel(
            plantId: '2',
            areaCode: '1',
            name: 'DEF発電所',
            viewAddress: '神奈川県',
            voltageType: '1',
            powerGenerationMethod: '太陽光発電',
            renewableType: '1',
            generationCapacity: 1234,
            displayOrder: 1,
            isRecommend: true,
            ownerName: '1',
            startDate: DateTime.now(),
            endDate: DateTime.now(),
            plantImage1: '1',
            supportGiftName: '1',
            shortCatchphrase: '横浜を突き抜ける風を、エネルギーに。',
            catchphrase: 'キャッチフレーズ',
            thankYouMessage: '1',
          ),
          PowerPlantModel(
            plantId: '3',
            areaCode: '1',
            name: 'GHI発電所',
            viewAddress: '沖縄県',
            voltageType: '1',
            powerGenerationMethod: '水力発電',
            renewableType: '1',
            generationCapacity: 1234,
            displayOrder: 1,
            isRecommend: true,
            ownerName: '1',
            startDate: DateTime.now(),
            endDate: DateTime.now(),
            plantImage1: '1',
            supportGiftName: '1',
            shortCatchphrase: '海風も、日本海の恵み',
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
        generationCapacity: 1234,
        displayOrder: 1,
        isRecommend: true,
        ownerName: '1',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        plantImage1: '1',
        supportGiftName: '1',
        shortCatchphrase: '1',
        catchphrase: '田んぼの上にソーラーパネルを設置した発電所。農薬を減らしておいしいお米をつくっている。',
        thankYouMessage: '1',
        ownerMessage: '''
　こんにちは。私は山形県米沢市で2019年からソーラーシェアリングと言う農地で発電しながら下の土地でお米を栽培しています。応援特典として1年間(12月から11月まで)10回以上応援していただいた方に、新米つや姫3合（450g）をお送りします。私の所属する米沢稔りの会で産地直送の販売もしています。山形県エコファーマーの認証を受け化学肥料や農薬を減らした特別栽培の美味しいお米を食べて下さい。田んぼでは日本一規模が大きい発電所です。''',
      );
      return Right(data);
    } on ServerException {
      return left(PowerPlantFailure());
    }
  }

  @override
  Future<Either<PowerPlantFailure, PowerPlantParticipant>>
      getPowerPlantParticipants(String plantId) async {
    try {
      const data = PowerPlantParticipant(
          page: '1',
          total: 4,
          plantId: '1',
          yearMonth: '202109',
          userList: [
            PowerPlantParticipantUser(
              userId: '1',
              name: 'さとう',
              contractor: '1',
              icon:
                  'https://ca.slack-edge.com/T02HZH8HZ-U017YCHMU05-043558546a4e-512',
              bio: '1',
              wallpaper:
                  'https://ca.slack-edge.com/T02HZH8HZ-U017YCHMU05-043558546a4e-512',
            ),
            PowerPlantParticipantUser(
              userId: '2',
              name: 'やまだ',
              contractor: '2',
              icon:
                  'https://ca.slack-edge.com/T02HZH8HZ-U017YCHMU05-043558546a4e-512',
              bio: '1',
              wallpaper:
                  'https://ca.slack-edge.com/T02HZH8HZ-U017YCHMU05-043558546a4e-512',
            ),
            PowerPlantParticipantUser(
              userId: '1',
              name: 'さとう',
              contractor: '1',
              icon:
                  'https://ca.slack-edge.com/T02HZH8HZ-U017YCHMU05-043558546a4e-512',
              bio: '1',
              wallpaper:
                  'https://ca.slack-edge.com/T02HZH8HZ-U017YCHMU05-043558546a4e-512',
            ),
            PowerPlantParticipantUser(
              userId: '2',
              name: 'やまだ',
              contractor: '2',
              icon:
                  'https://ca.slack-edge.com/T02HZH8HZ-U017YCHMU05-043558546a4e-512',
              bio: '1',
              wallpaper:
                  'https://ca.slack-edge.com/T02HZH8HZ-U017YCHMU05-043558546a4e-512',
            ),
          ]);
      return Right(data);
    } on ServerException {
      return left(PowerPlantFailure());
    }
  }

  @override
  Future<Either<PowerPlantFailure, TagResponse>> getPowerPlantTags(
      String plantId) async {
    try {
      const data = TagResponse(
        tags: [
          Tag(tagId: 1, tagName: '使い捨てしません', colorCode: '1'),
          Tag(tagId: 2, tagName: '環境負荷ゼロ', colorCode: '1'),
          Tag(tagId: 3, tagName: 'フェアトレード', colorCode: '1')
        ],
      );
      return const Right(data);
    } on ServerException {
      return left(PowerPlantFailure());
    }
  }

  /// [historyType] 応援予約 or 応援履歴
  Future<Either<PowerPlantFailure, PowerPlantsResponse>> getPowerPlantHistory(
    String historyType,
  ) async {
    try {
      final data = PowerPlantsResponse(
        tag: const TagModel(
          tagId: 1,
          tagName: 'テストタグ',
          colorCode: '1'
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
            generationCapacity: 1234,
            displayOrder: 1,
            isRecommend: true,
            ownerName: '1',
            startDate: DateTime.now(),
            endDate: DateTime.now(),
            plantImage1: '1',
            supportGiftName: '1',
            shortCatchphrase: '田んぼの上に\nソーラーパネルを',
            catchphrase: 'キャッチフレーズ',
            thankYouMessage: '1',
          ),
          PowerPlantModel(
            plantId: '2',
            areaCode: '1',
            name: 'DEF発電所',
            viewAddress: '神奈川県',
            voltageType: '1',
            powerGenerationMethod: '太陽光発電',
            renewableType: '1',
            generationCapacity: 1234,
            displayOrder: 1,
            isRecommend: true,
            ownerName: '1',
            startDate: DateTime.now(),
            endDate: DateTime.now(),
            plantImage1: '1',
            supportGiftName: '1',
            shortCatchphrase: '横浜を突き抜ける風を、エネルギーに。',
            catchphrase: 'キャッチフレーズ',
            thankYouMessage: '1',
          ),
          PowerPlantModel(
            plantId: '3',
            areaCode: '1',
            name: 'GHI発電所',
            viewAddress: '沖縄県',
            voltageType: '1',
            powerGenerationMethod: '水力発電',
            renewableType: '1',
            generationCapacity: 1234,
            displayOrder: 1,
            isRecommend: true,
            ownerName: '1',
            startDate: DateTime.now(),
            endDate: DateTime.now(),
            plantImage1: '1',
            supportGiftName: '1',
            shortCatchphrase: '海風も、日本海の恵み',
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
}
