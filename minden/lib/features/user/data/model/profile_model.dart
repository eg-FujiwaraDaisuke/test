import 'package:minden/features/power_plant/domain/entities/power_plant.dart';
import 'package:minden/features/profile_setting/domain/entities/tag.dart';
import 'package:minden/features/user/domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel(
      {required userId,
      required name,
      required icon,
      required bio,
      required wallPaper,
      required tags,
      required selectedPowerPlants})
      : super(
            userId: userId,
            name: name,
            icon: icon,
            bio: bio,
            wallPaper: wallPaper,
            tags: tags,
            selectedPowerPlants: selectedPowerPlants);

  factory ProfileModel.fromJson(Map<String, dynamic> elem) {
    final List<Tag> tags = elem['tags']?.map<Tag>((e) {
          return Tag.fromJson(e);
        }).toList() ??
        [];
    final List<PowerPlant> selectedPowerPlants =
        elem['selectedPowerPlants']?.map<PowerPlant>((e) {
              return PowerPlant.fromJson(e);
            }).toList() ??
            [];
    return ProfileModel(
        userId: elem['userId'],
        name: elem['name'],
        icon: elem['icon'],
        bio: elem['bio'],
        wallPaper: elem['wallPaper'],
        tags: tags,
        selectedPowerPlants: selectedPowerPlants);
  }
}
