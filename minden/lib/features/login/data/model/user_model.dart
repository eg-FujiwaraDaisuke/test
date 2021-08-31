import 'package:minden/features/login/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String contractor,
    required String accountId,
    required String wallPaper,
    required String loginId,
    required String name,
    required String icon,
    required String limitedPlantId,
    required String bio,
    required Supports supports,
    required Contracts contracts,
    required String userId,
  }) : super(
          contractor: contractor,
          accountId: accountId,
          wallPaper: wallPaper,
          loginId: loginId,
          name: name,
          icon: icon,
          limitedPlantId: limitedPlantId,
          bio: bio,
          supports: supports,
          contracts: contracts,
          userId: userId,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      contractor: json['user']['contractor'],
      accountId: json['user']['accountId'],
      wallPaper: json['user']['wallPaper'],
      loginId: json['user']['loginId'],
      name: json['user']['name'],
      icon: json['user']['icon'],
      limitedPlantId: json['user']['limitedPlantId'],
      bio: json['user']['bio'],
      supports: Supports(
        yearMonth: json['user']['supports']['yearMonth'],
        plantId: json['user']['supports']['plantId'],
        status: json['user']['supports']['status'],
      ),
      contracts: Contracts(
        contractId: json['user']['contracts']['contract_id'],
        name: json['user']['contracts']['name'],
      ),
      userId: json['user']['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contractor': contractor,
      'accountId': accountId,
      'wallPaper': wallPaper,
      'loginId': loginId,
      'name': name,
      'icon': icon,
      'limitedPlantId': limitedPlantId,
      'bio': bio,
      'supports': {
        'yearMonth': supports.yearMonth,
        'plantId': supports.plantId,
        'status': supports.status
      },
      'contracts': {
        'name': contracts.name,
        'contract_id': contracts.contractId
      },
      'userId': userId,
    };
  }
}
