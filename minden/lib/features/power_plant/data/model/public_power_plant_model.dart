import 'package:minden/features/power_plant/domain/entities/public_power_plant.dart';

class PublicPowerPlantModel extends PublicPowerPlant {
  const PublicPowerPlantModel({
    required String id,
    required String areaCode,
    required String name,
    required String viewAddress,
    required String voltageType,
    required String powerGenerationMethod,
    required String renewableType,
    required String generationCapacity,
    required String displayOrder,
    required bool isRecommend,
    required String ownerName,
    required DateTime startDate,
    required DateTime endDate,
    required String plantImage1,
    String? supportGiftName,
  }) : super(
          id: id,
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
        );

  factory PublicPowerPlantModel.fromJson(Map<String, dynamic> json) {
    return PublicPowerPlantModel(
      id: json['id'],
      areaCode: json['areaCode'],
      name: json['name'],
      viewAddress: json['viewAddress'],
      voltageType: json['voltageType'],
      powerGenerationMethod: json['powerGenerationMethod'],
      renewableType: json['renewableType'],
      generationCapacity: json['generationCapacity'],
      displayOrder: json['displayOrder'],
      isRecommend: json['isRecommend'],
      ownerName: json['ownerName'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      plantImage1: json['plantImage1'],
      supportGiftName: json['supportGiftName'],
    );
  }
}
