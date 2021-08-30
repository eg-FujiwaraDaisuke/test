import 'package:equatable/equatable.dart';

class Profile {
  final String accountId;
  final String name;
  final String contractor;
  final String icon;
  final String bio;
  final String wallPaper;
  final List<Tag> tags;
  final SelectPowerPlant selectedPowerPlant;

  Profile({
    required this.accountId,
    required this.name,
    required this.contractor,
    required this.icon,
    required this.bio,
    required this.wallPaper,
    required this.tags,
    required this.selectedPowerPlant,
  });
}

class Tag extends Equatable {
  final String tagId;
  final String tagName;
  Tag({
    required this.tagId,
    required this.tagName,
  });

  @override
  List<Object> get props => [tagId, tagName];
}

class SelectPowerPlant {
  final String plantId;
  final String name;
  final List<String> images;
  final String catchphrase;
  final int location;
  final Object capacity;
  final String powerGenerationMethods;
  final bool isNewArrivals;

  SelectPowerPlant({
    required this.plantId,
    required this.name,
    required this.images,
    required this.catchphrase,
    required this.location,
    required this.capacity,
    required this.powerGenerationMethods,
    required this.isNewArrivals,
  });
}
