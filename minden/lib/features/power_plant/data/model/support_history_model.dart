import 'package:minden/features/power_plant/data/model/power_plant_model.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant.dart';
import 'package:minden/features/power_plant/domain/entities/support_history.dart';

class SupportHistoryModel extends SupportHistory {
  const SupportHistoryModel({
    required int page,
    required int total,
    required String historyType,
    required List<SupportHistoryPowerPlant> powerPlants,
  }) : super(
          page: page,
          total: total,
          historyType: historyType,
          powerPlants: powerPlants,
        );

  factory SupportHistoryModel.fromJson(Map<String, dynamic> json) {
    final List<SupportHistoryPowerPlant> powerPlants =
        json['powerPlants'].map<SupportHistoryPowerPlant>((e) {
              return SupportHistoryPowerPlantModel.fromJson(e);
            }).toList() ??
            [];

    return SupportHistoryModel(
      page: json['page'],
      total: json['total'],
      historyType: json['historyType'],
      powerPlants: powerPlants,
    );
  }
}

class SupportHistoryPowerPlantModel extends SupportHistoryPowerPlant {
  const SupportHistoryPowerPlantModel({
    required String yearMonth,
    required bool fromApp,
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
  }) : super(
          yearMonth: yearMonth,
          fromApp: fromApp,
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
        );

  factory SupportHistoryPowerPlantModel.fromJson(Map<String, dynamic> json) {
    return SupportHistoryPowerPlantModel(
      yearMonth: json['yearMonth'],
      fromApp: json['fromApp'],
      plantId: json['plantId'],
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
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      plantImage1: json['plantImage1'],
      supportGiftName: json['supportGiftName'],
      shortCatchphrase: json['shortCatchphrase'],
      catchphrase: json['catchphrase'],
      thankYouMessage: json['thankYouMessage'],
    );
  }
}
