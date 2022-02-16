import 'package:equatable/equatable.dart';

/// 応援ユーザー詳細
class PowerPlantParticipantUser extends Equatable {
  const PowerPlantParticipantUser({
    required this.userId,
    required this.name,
    required this.contractor,
    required this.icon,
    required this.bio,
    required this.wallpaper,
  });

  /// ユーザーid
  final String userId;

  /// ユーザー名
  final String? name;

  /// 契約者名
  final String contractor;

  /// ユーザーアイコン
  final String icon;

  /// bio
  final String bio;

  /// 壁紙
  final String wallpaper;

  @override
  List<Object> get props => [
        userId,
      ];
}
