import 'package:minden/features/power_plant/data/model/power_plant_participant_user_model.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant.dart';

class PowerPlantModel extends PowerPlant {
  const PowerPlantModel({
    required String plantId,
    required String areaCode,
    required String name,
    required String viewAddress,
    required String voltageType,
    required String powerGenerationMethod,
    required String renewableType,
    required double generationCapacity,
    required int displayOrder,
    required bool isRecommend,
    required String ownerName,
    required DateTime startDate,
    required DateTime endDate,
    required String plantImage1,
    String? supportGiftName,
    String? shortCatchphrase,
    String? catchphrase,
    String? thankYouMessage,
    List<PowerPlantParticipantUserModel> userList = const [],
    String? giftName,
    String? giftDescription,
    String? giftImage,
  }) : super(
          plantId: plantId,
          areaCode: areaCode,
          name: name,
          viewAddress: viewAddress,
          voltageType: voltageType,
          powerGenerationMethod: powerGenerationMethod,
          renewableType: renewableType,
          generationCapacity: generationCapacity,
          displayOrder: displayOrder,
          isRecommend: isRecommend,
          ownerName: ownerName,
          startDate: startDate,
          endDate: endDate,
          plantImage1: plantImage1,
          supportGiftName: supportGiftName,
          shortCatchphrase: shortCatchphrase,
          catchphrase: catchphrase,
          thankYouMessage: thankYouMessage,
          userList: userList,
          giftName: giftName,
          giftDescription: giftDescription,
          giftImage: giftImage,
        );

  factory PowerPlantModel.fromProfile(PowerPlant powerPlant) {
    return PowerPlantModel(
      plantId: powerPlant.plantId,
      areaCode: powerPlant.areaCode,
      name: powerPlant.name,
      viewAddress: powerPlant.viewAddress,
      voltageType: powerPlant.voltageType,
      powerGenerationMethod: powerPlant.powerGenerationMethod,
      renewableType: powerPlant.renewableType,
      generationCapacity: powerPlant.generationCapacity,
      displayOrder: powerPlant.displayOrder,
      isRecommend: powerPlant.isRecommend,
      ownerName: powerPlant.ownerName,
      startDate: powerPlant.startDate,
      endDate: powerPlant.endDate,
      plantImage1: powerPlant.plantImage1,
      supportGiftName: powerPlant.supportGiftName,
      shortCatchphrase: powerPlant.shortCatchphrase,
      catchphrase: powerPlant.catchphrase,
      thankYouMessage: powerPlant.thankYouMessage,
      userList: powerPlant.userList,
      giftName: powerPlant.giftName,
      giftDescription: powerPlant.giftDescription,
      giftImage: powerPlant.giftImage,
    );
  }

  factory PowerPlantModel.fromJson(Map<String, dynamic> json) {
    return PowerPlantModel.fromProfile(PowerPlant.fromJson(json));
  }
}
