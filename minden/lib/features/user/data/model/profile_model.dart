import 'package:minden/features/user/domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required userId,
    required name,
    required icon,
    required bio,
    required wallPaper,
    required tags,
  }) : super(
            userId: userId,
            name: name,
            icon: icon,
            bio: bio,
            wallPaper: wallPaper,
            tags: tags);

  factory ProfileModel.fromProfile(Profile profile) {
    return ProfileModel(
        userId: profile.userId,
        name: profile.name,
        icon: profile.icon,
        bio: profile.bio,
        wallPaper: profile.wallPaper,
        tags: profile.tags);
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel.fromProfile(Profile.fromJson(json));
  }
}

