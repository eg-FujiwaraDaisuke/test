import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/user/data/model/profile_model.dart';
import 'package:minden/features/user/domain/entities/profile.dart';

class UserModel extends User {
  const UserModel({
    required String loginId,
    required String accountId,
    required String contractor,
    required String limitedPlantId,
    required Profile profile,
  }) : super(
            loginId: loginId,
            accountId: accountId,
            contractor: contractor,
            limitedPlantId: limitedPlantId,
            profile: profile);

  factory UserModel.fromUser(User user) {
    return UserModel(
        loginId: user.loginId,
        accountId: user.accountId,
        contractor: user.contractor,
        limitedPlantId: user.limitedPlantId,
        profile: user.profile);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = User.fromJson(json['user']);
    return UserModel.fromUser(user);
  }
}
