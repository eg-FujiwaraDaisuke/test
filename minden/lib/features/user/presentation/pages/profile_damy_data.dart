import 'package:minden/features/user/domain/entities/profile.dart';
import 'package:minden/features/user/presentation/pages/thanks_message.dart';

class ProfileDamyData {
  final Profile damyData = const Profile(
    userId: '',
    name: 'ユーザーニックネーム',
    icon: '',
    bio: 'ここには、自己紹介文・メッセージが入ります。ここには、自己紹介文・メッセージが入ります。ここには、自己紹介文・メッセージが入ります。',
    wallPaper: '',
    tags: [
      Tag(tagId: 1, tagName: '地産地消'),
      Tag(tagId: 2, tagName: 'フェアトレード'),
      Tag(tagId: 3, tagName: 'エコ'),
    ],
  );
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
