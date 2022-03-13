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
    required this.freeLink,
    required this.twitterLink,
    required this.facebookLink,
    required this.instagramLink,
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

  /// 自由リンク
  final String freeLink;

  /// Twitterリンク
  final String twitterLink;

  /// Facebookリンク
  final String facebookLink;

  /// Instagramリンク
  final String instagramLink;

  @override
  List<Object> get props => [
        userId,
      ];
}
