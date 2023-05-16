import 'package:equatable/equatable.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant.dart';
import 'package:minden/features/profile_setting/domain/entities/tag.dart';

class Profile extends Equatable {
  const Profile({
    required this.userId,
    required this.name,
    required this.icon,
    required this.bio,
    required this.wallPaper,
    required this.freeLink,
    required this.twitterLink,
    required this.facebookLink,
    required this.instagramLink,
    required this.tags,
    required this.selectedPowerPlants,
  });

  factory Profile.fromJson(Map<String, dynamic> elem) {
    final List<Tag> tags = elem['tags']?.map<Tag>((e) {
          return Tag.fromJson(e);
        }).toList() ??
        [];
    final List<PowerPlant> selectedPowerPlants =
        elem['selectedPowerPlants']?.map<PowerPlant>((e) {
              return PowerPlant.fromJson(e);
            }).toList() ??
            [];
    return Profile(
        userId: elem['userId'],
        name: elem['name'],
        icon: elem['icon'],
        bio: elem['bio'],
        wallPaper: elem['wallPaper'],
        freeLink: elem['freeLink'],
        twitterLink: elem['twitterLink'],
        facebookLink: elem['facebookLink'],
        instagramLink: elem['instagramLink'],
        tags: tags,
        selectedPowerPlants: selectedPowerPlants);
  }

  final String? userId;
  final String? name;
  final String? icon;
  final String? bio;
  final String? wallPaper;
  final String? freeLink;
  final String? twitterLink;
  final String? facebookLink;
  final String? instagramLink;
  final List<Tag> tags;
  final List<PowerPlant> selectedPowerPlants;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'icon': icon,
      'bio': bio,
      'wallPaper': wallPaper,
      'freeLink': freeLink,
      'twitterLink': twitterLink,
      'facebookLink': facebookLink,
      'instagramLink': instagramLink,
      'tags': tags.map((e) => e.toJson()).toList(),
      'selectedPowerPlants':
          selectedPowerPlants.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [userId];
}
