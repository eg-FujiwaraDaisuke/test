import 'package:equatable/equatable.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_participant_user.dart';

/// 応援ユーザー情報
class PowerPlantParticipant extends Equatable {
  const PowerPlantParticipant({
    required this.page,
    required this.total,
    required this.plantId,
    required this.yearMonth,
    required this.userList,
  });

  /// ページ
  final String page;

  /// 応援ユーザー総数
  final String total;

  /// MP番号
  final String plantId;

  /// 発電署名
  final String yearMonth;

  /// 表示用設備所在地
  final List<PowerPlantParticipantUser> userList;

  @override
  List<Object> get props => [
        page,
        plantId,
      ];
}
