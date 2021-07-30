class ThanksMessage {
  final bool isNew;
  final String message;
  final DateTime time;
  final PowerPlant powerPlant;

  ThanksMessage({
    required this.isNew,
    required this.message,
    required this.time,
    required this.powerPlant,
  });
}

class PowerPlant {
  final String plantId;
  final String name;
  final List<String> images;
  final String catchphrase;

  PowerPlant({
    required this.plantId,
    required this.name,
    required this.images,
    required this.catchphrase,
  });
}
