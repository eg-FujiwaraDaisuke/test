import 'package:minden/features/power_plant/domain/entities/power_plant_participant_user.dart';

class PowerPlantParticipantUserModel extends PowerPlantParticipantUser {
  const PowerPlantParticipantUserModel({
    required String userId,
    required String name,
    required String contractor,
    required String icon,
    required String bio,
    required String wallpaper,
  }) : super(
          userId: userId,
          name: name,
          contractor: contractor,
          icon: icon,
          bio: bio,
          wallpaper: wallpaper,
        );

  factory PowerPlantParticipantUserModel.fromJson(Map<String, dynamic> json) {
    return PowerPlantParticipantUserModel(
      userId: json['userId'],
      name: json['name'],
      contractor: json['contractor'],
      icon: json['icon'],
      bio: json['bio'],
      wallpaper: json['wallpaper'],
    );
  }
}
