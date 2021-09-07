import 'package:minden/features/user/data/model/profile_model.dart';
import 'package:minden/features/user/presentation/pages/thanks_message.dart';

class ProfileDamyData {
  final ProfileModel damyData = ProfileModel(
    userId: '',
    name: 'ユーザーニックネーム',
    icon: '',
    bio: 'ここには、自己紹介文・メッセージが入ります。ここには、自己紹介文・メッセージが入ります。ここには、自己紹介文・メッセージが入ります。',
    wallPaper: '',
    tags: [
      TagModel(tagId: 'タグID', tagName: '地産地消'),
      TagModel(tagId: 'タグID', tagName: 'フェアトレード'),
      TagModel(tagId: 'タグID', tagName: 'エコ'),
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
