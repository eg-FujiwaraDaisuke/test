class ThanksMessage {
  final bool isNew;
  final String title;
  final String message;
  final DateTime time;
  final PowerPlant powerPlant;

  ThanksMessage({
    required this.isNew,
    required this.title,
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

class ThanksMessageDamyData {
  final List<ThanksMessage> damyData = [
    ThanksMessage(
      isNew: true,
      title: '応援ありがとうございます！',
      message: '応援ありがとうございます！',
      time: DateTime(2021, 06, 25),
      powerPlant: PowerPlant(
        plantId: '生産者ID',
        name: '生産者名称',
        images: [''],
        catchphrase: 'キャッチフレーズ',
      ),
    ),
    ThanksMessage(
      isNew: false,
      title: '応援ありがとうございます！',
      message: '応援ありがとうございます！',
      time: DateTime(2021, 06, 25),
      powerPlant: PowerPlant(
        plantId: '生産者ID',
        name: '生産者名称',
        images: [''],
        catchphrase: 'キャッチフレーズ',
      ),
    ),
    ThanksMessage(
      isNew: false,
      title: '応援ありがとうございます！',
      message: '応援ありがとうございます！',
      time: DateTime(2021, 06, 25),
      powerPlant: PowerPlant(
        plantId: '生産者ID',
        name: '生産者名称',
        images: [''],
        catchphrase: 'キャッチフレーズ',
      ),
    ),
    ThanksMessage(
      isNew: false,
      title: '応援ありがとうございます！',
      message: '応援ありがとうございます！',
      time: DateTime(2021, 06, 25),
      powerPlant: PowerPlant(
        plantId: '生産者ID',
        name: '生産者名称',
        images: [''],
        catchphrase: 'キャッチフレーズ',
      ),
    ),
    ThanksMessage(
      isNew: false,
      title: '応援ありがとうございます！',
      message: '応援ありがとうございます！応援ありがとうございます！',
      time: DateTime(2021, 06, 25),
      powerPlant: PowerPlant(
        plantId: '生産者ID',
        name: '生産者名称',
        images: [''],
        catchphrase: 'キャッチフレーズ',
      ),
    ),
    ThanksMessage(
      isNew: false,
      title: '応援ありがとうございます！',
      message:
          '応援ありがとうございます！応援ありがとうございます！応援ありがとうございます！応援ありがとうございます！応援ありがとうございます！応援ありがとうございます！応援ありがとうございます！応援ありがとうございます！',
      time: DateTime(2021, 06, 25),
      powerPlant: PowerPlant(
        plantId: '生産者ID',
        name: '生産者名称生産者名称',
        images: [''],
        catchphrase: 'キャッチフレーズ',
      ),
    ),
    ThanksMessage(
      isNew: false,
      title: '応援ありがとうございます！',
      message: '応援ありがとうございます！応援ありがとうございます！応援ありがとうございます！応援ありがとうございます！',
      time: DateTime(2021, 06, 25),
      powerPlant: PowerPlant(
        plantId: '生産者ID',
        name: '生産者名称',
        images: [''],
        catchphrase: 'キャッチフレーズ',
      ),
    )
  ];
}
