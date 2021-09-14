import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/user/domain/entities/profile.dart';

class UserModel extends User {
  const UserModel({
    required String loginId,
    required String accountId,
    required String contractor,
    required String limitedPlantId,
    required int supportableNumber,
    required bool isNewbie,
    required Profile profile,
  }) : super(
            loginId: loginId,
            accountId: accountId,
            contractor: contractor,
            limitedPlantId: limitedPlantId,
            supportableNumber: supportableNumber,
            isNewbie: isNewbie,
            profile: profile);

  factory UserModel.fromUser(User user) {
    return UserModel(
        loginId: user.loginId,
        accountId: user.accountId,
        contractor: user.contractor,
        limitedPlantId: user.limitedPlantId,
        supportableNumber: user.supportableNumber,
        isNewbie: user.isNewbie,
        profile: user.profile);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = User.fromJson(json);
    return UserModel.fromUser(user);
  }
}
