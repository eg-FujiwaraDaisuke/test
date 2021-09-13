import 'package:equatable/equatable.dart';
import 'package:minden/features/support_plant/domain/entities/support.dart';
import 'package:minden/features/user/domain/entities/profile.dart';

class User extends Equatable {
  const User({
    required this.loginId,
    required this.accountId,
    required this.contractor,
    required this.limitedPlantId,
    required this.supportableNumber,
    required this.profile,
    required this.supports,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final List<Support> supports = json['supports']?.map<Tag>((e) {
          return Support.fromJson(e);
        }).toList() ??
        [];

    return User(
      loginId: json['loginId'],
      accountId: json['accountId'],
      contractor: json['contractor'],
      limitedPlantId: json['limitedPlantId'],
      supportableNumber: json['supportableNumber'],
      profile: Profile.fromJson(json),
      supports: supports,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loginId': loginId,
      'accountId': accountId,
      'contractor': contractor,
      'limitedPlantId': limitedPlantId,
      'supportableNumber': supportableNumber,
      'profile': profile.toJson(),
      'supports': supports.map((e) => e.toJson()),
    };
  }

  final String loginId;
  final String accountId;
  final String contractor;
  final String limitedPlantId;
  final int supportableNumber;
  final Profile profile;
  final List<Support> supports;

  @override
  List<Object> get props => [loginId];
}
