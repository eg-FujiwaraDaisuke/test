import 'package:minden/features/user/presentation/pages/profile.dart';

class ProfileDamyData {
  final Profile damyData = Profile(
    accountId: 'アカウントID',
    name: 'ユーザーニックネーム',
    contractor: '契約者名',
    icon: '',
    bio: 'ここには、自己紹介文・メッセージが入ります。ここには、自己紹介文・メッセージが入ります。ここには、自己紹介文・メッセージが入ります。',
    wallPaper: '',
    tags: [
      Tag(tagId: 'タグID', tagName: '使い捨てしません'),
      Tag(tagId: 'タグID', tagName: '大切'),
      Tag(tagId: 'タグID', tagName: '大切'),
      Tag(tagId: 'タグID', tagName: '大切'),
      Tag(tagId: 'タグID', tagName: '無農薬野菜好き'),
      Tag(tagId: 'タグID', tagName: '大切'),
    ],
    selectedPowerPlant: SelectPowerPlant(
      plantId: '生産者ID',
      name: '生産者名称',
      images: [''],
      catchphrase: 'キャッチフレーズ',
      location: 0,
      capacity: {},
      powerGenerationMethods: '発電方法',
      isNewArrivals: true,
    ),
  );
}
