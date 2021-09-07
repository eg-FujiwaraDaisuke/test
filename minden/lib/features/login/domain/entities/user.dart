import 'package:equatable/equatable.dart';
import 'package:minden/features/user/domain/entities/profile.dart';

class User extends Equatable {
  const User({
    required this.loginId,
    required this.accountId,
    required this.contractor,
    required this.limitedPlantId,
    required this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        loginId: json['loginId'],
        accountId: json['accountId'],
        contractor: json['contractor'],
        limitedPlantId: json['limitedPlantId'],
        profile: Profile.fromJson(json));
  }

  Map<String, dynamic> toJson() {
    return {
      'loginId': loginId,
      'accountId': accountId,
      'contractor': contractor,
      'limitedPlantId': limitedPlantId,
      'profile': profile.toJson(),
    };
  }

  final String loginId;
  final String accountId;
  final String contractor;
  final String limitedPlantId;
  final Profile profile;

  @override
  List<Object> get props => [loginId];
}
