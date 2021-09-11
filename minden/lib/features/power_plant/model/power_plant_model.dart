import 'package:minden/features/power_plant/domain/power_plant.dart';

@Deprecated('UI側で利用するモデル変更されたら削除')
class PowerPlantModel extends PowerPlant {
  PowerPlantModel(
      {required plantId,
      required name,
      required images,
      required catchPhrase,
      required location,
      required capacity,
      required powerGenerationMethods,
      required isNewArrivals,
      required created,
      required modified})
      : super(
          plantId: plantId,
          name: name,
          images: images,
          catchPhrase: catchPhrase,
          location: location,
          capacity: capacity,
          powerGenerationMethods: powerGenerationMethods,
          isNewArrivals: isNewArrivals,
          created: created,
          modified: modified,
        );

  factory PowerPlantModel.fromJson(Map<String, dynamic> json) {
    return PowerPlantModel(
      plantId: json['plant_id'],
      name: json['name'],
      // NOTE: fromJsonの既存実装だと手間なので、Freezedで実現予定
      images: (json['images'] as List<dynamic>)
          .map((i) => PowerPlantImageModel.fromJson(i)),
      catchPhrase: json['catchphrase'],
      location: json['location'],
      capacity: json['capacity'],
      powerGenerationMethods: json['power_generation_methods'],
      isNewArrivals: json['is_new_arrivals'],
      created: json['created'],
      modified: json['modified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plant_id': plantId,
      'name': name,
      'images': images,
      'catchphrase': catchPhrase,
      'location': location,
      'capacity': capacity,
      'power_generation_methods': powerGenerationMethods,
      'is_new_arrivals': isNewArrivals,
      'created': created,
      'modified': modified,
    };
  }
}

class PowerPlantImageModel extends PowerPlantImage {
  PowerPlantImageModel({required url})
      : super(
          url: url,
        );

  factory PowerPlantImageModel.fromJson(Map<String, dynamic> json) {
    return PowerPlantImageModel(
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url};
  }
}
