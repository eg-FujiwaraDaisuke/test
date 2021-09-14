import 'package:minden/features/power_plant/data/model/power_plant_model.dart';
import 'package:minden/features/power_plant/domain/entities/power_plants_response.dart';
import 'package:minden/features/profile_setting/data/models/tag_model.dart';

class PowerPlantsResponseModel extends PowerPlantsResponse {
  const PowerPlantsResponseModel({
    required TagModel tag,
    required List<PowerPlantModel> powerPlants,
  }) : super(
          tag: tag,
          powerPlants: powerPlants,
        );

  factory PowerPlantsResponseModel.fromJson(Map<String, dynamic> json) {
    final Iterable iterable = json['powerPlants'];

    return PowerPlantsResponseModel(
        tag: TagModel.fromJson(json['tag']),
        powerPlants: List<PowerPlantModel>.from(
            iterable.map((model) => PowerPlantModel.fromJson(model))));
  }
}
