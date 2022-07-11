import 'package:equatable/equatable.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_participant_user.dart';

/// 応援ユーザー情報
class PowerPlantParticipantAllUser extends Equatable {
  const PowerPlantParticipantAllUser({
    required this.plantId,
    required this.yearMonth,
    required this.userList,
    required this.participantSize,
  });

  /// MP番号
  final String plantId;

  /// 発電署名
  final String yearMonth;

  /// 応援ユーザー
  final List<PowerPlantParticipantUser> userList;

  /// 応援ユーザー総数
  final int participantSize;

  @override
  List<Object> get props => [
        plantId,
      ];

  /// 条件に従ってを並び替えた応援ユーザーのリスト
  List<PowerPlantParticipantUser> get orderedUserList {
    // アイコンが設定されているユーザーを前にする
    return List.of(userList)
      ..sort((a, b) {
        // 名前、アイコンありユーザーを優先する
        if (a.hasIconAndName && !b.hasIconAndName) {
          return -1;
        }
        if (!a.hasIconAndName && b.hasIconAndName) {
          return 1;
        }

        return userList.indexOf(a).compareTo(userList.indexOf(b));
      });
  }
}
