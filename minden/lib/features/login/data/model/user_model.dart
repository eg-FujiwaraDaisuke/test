import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/support_plant/domain/entities/support.dart';
import 'package:minden/features/user/domain/entities/profile.dart';

class UserModel extends User {
  const UserModel({
    required String loginId,
    required String accountId,
    required String contractor,
    required String limitedPlantId,
    required int supportableNumber,
    required Profile profile,
    required List<Support> supports,
  }) : super(
            loginId: loginId,
            accountId: accountId,
            contractor: contractor,
            limitedPlantId: limitedPlantId,
            supportableNumber: supportableNumber,
            profile: profile,
            supports: supports);

  factory UserModel.fromUser(User user) {
    // print(user.profile);
    return UserModel(
        loginId: user.loginId,
        accountId: user.accountId,
        contractor: user.contractor,
        limitedPlantId: user.limitedPlantId,
        supportableNumber: user.supportableNumber,
        profile: user.profile,
        supports: user.supports);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = User.fromJson(json['user']);
    return UserModel.fromUser(user);
  }
}
