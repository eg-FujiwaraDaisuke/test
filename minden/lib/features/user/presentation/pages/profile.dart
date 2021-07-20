class Profile {
  final String accountId;
  final String name;
  final String contractor;
  final String icon;
  final String bio;
  final String wallPaper;
  final List<Tags> tags;
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

class Tags {
  final String tagId;
  final String tagName;
  Tags({
    required this.tagId,
    required this.tagName,
  });
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