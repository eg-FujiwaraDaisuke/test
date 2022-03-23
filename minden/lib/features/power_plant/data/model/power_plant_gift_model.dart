import 'package:minden/features/power_plant/domain/entities/power_plant_gift.dart';

class PowerPlantGiftModel extends PowerPlantGift {
  const PowerPlantGiftModel({
    required giftTypeId,
    required giftTypeName,
  }) : super(
          giftTypeId: giftTypeId,
          giftTypeName: giftTypeName,
        );

  factory PowerPlantGiftModel.fromTag(PowerPlantGift gift) {
    return PowerPlantGiftModel(
      giftTypeId: gift.giftTypeId,
      giftTypeName: gift.giftTypeName,
    );
  }

  factory PowerPlantGiftModel.fromJson(Map<String, dynamic> gift) {
    return PowerPlantGiftModel.fromTag(PowerPlantGift.fromJson(gift));
  }
}
