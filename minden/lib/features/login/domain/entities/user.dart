import 'package:equatable/equatable.dart';
import 'package:minden/features/user/domain/entities/profile.dart';

class User extends Equatable {
  const User({
    required this.loginId,
    required this.accountId,
    required this.contractor,
    required this.limitedPlantId,
    required this.supportableNumber,
    required this.profile,
    required this.isNewbie,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // from API
    if (json['user'] != null) {
      return User(
        loginId: json['user']['loginId'],
        accountId: json['user']['accountId'],
        contractor: json['user']['contractor'],
        limitedPlantId: json['user']['limitedPlantId'],
        supportableNumber: json['user']['supportableNumber'],
        isNewbie: json['isNewbie'],
        profile: Profile.fromJson(json['user']),
      );
    }

    // from restore
    return User(
      loginId: json['loginId'],
      accountId: json['accountId'],
      contractor: json['contractor'],
      limitedPlantId: json['limitedPlantId'],
      supportableNumber: json['supportableNumber'],
      isNewbie: json['isNewbie'],
      profile: Profile.fromJson(json['profile']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loginId': loginId,
      'accountId': accountId,
      'contractor': contractor,
      'limitedPlantId': limitedPlantId,
      'supportableNumber': supportableNumber,
      'isNewbie': isNewbie,
      'profile': profile.toJson(),
    };
  }

  final String loginId;
  final String accountId;
  final String contractor;
  final String limitedPlantId;
  final int supportableNumber;
  final Profile profile;
  final bool isNewbie;

  @override
  List<Object> get props => [];
}
