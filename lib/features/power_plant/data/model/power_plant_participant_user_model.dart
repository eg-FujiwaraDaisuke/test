import 'package:minden/features/power_plant/domain/entities/power_plant_participant_user.dart';

class PowerPlantParticipantUserModel extends PowerPlantParticipantUser {
  const PowerPlantParticipantUserModel({
    required String userId,
    required String name,
    required String contractor,
    required String? icon,
    required String bio,
    required String wallpaper,
    required freeLink,
    required twitterLink,
    required facebookLink,
    required instagramLink,
  }) : super(
          userId: userId,
          name: name,
          contractor: contractor,
          icon: icon,
          bio: bio,
          wallpaper: wallpaper,
          freeLink: freeLink,
          twitterLink: twitterLink,
          facebookLink: facebookLink,
          instagramLink: instagramLink,
        );

  factory PowerPlantParticipantUserModel.fromJson(Map<String, dynamic> json) {
    return PowerPlantParticipantUserModel(
      userId: json['userId'],
      name: json['name'],
      contractor: json['contractor'],
      icon: json['icon'],
      bio: json['bio'],
      wallpaper: json['wallpaper'],
      freeLink: json['freeLink'],
      twitterLink: json['twitterLink'],
      facebookLink: json['facebookLink'],
      instagramLink: json['instagramLink'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'contractor': contractor,
      'icon': icon,
      'bio': bio,
      'wallpaper': wallpaper,
    };
  }
}
