import 'package:equatable/equatable.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_participant_user.dart';

/// 応援ユーザー情報
class PowerPlantParticipant extends Equatable {
  const PowerPlantParticipant({
    required this.participantSize,
    required this.page,
    required this.total,
    required this.plantId,
    required this.yearMonth,
    required this.userList,
  });

  /// 応援ユーザー総数
  final int participantSize;

  /// ページ
  final String page;

  /// 応援ユーザー総数?
  final int total;

  /// MP番号
  final String plantId;

  /// 発電署名
  final String yearMonth;

  /// 応援ユーザー
  final List<PowerPlantParticipantUser> userList;

  @override
  List<Object> get props => [
        page,
        plantId,
      ];

  /// 条件に従ってを並び替えた応援ユーザーのリスト
  List<PowerPlantParticipantUser> get orderedUserList {
    // アイコンが設定されているユーザーは後ろにする
    return List.of(userList)
      ..sort((a, b) {
        if (a.hasIcon && !b.hasIcon) {
          return -1;
        }
        if (!a.hasIcon && b.hasIcon) {
          return 1;
        }
        return userList.indexOf(a).compareTo(userList.indexOf(b));
      });
  }
}
