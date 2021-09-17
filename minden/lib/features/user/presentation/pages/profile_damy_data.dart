import 'package:minden/features/profile_setting/domain/entities/tag.dart';
import 'package:minden/features/user/domain/entities/profile.dart';

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
    selectedPowerPlants: [],
  );
}
