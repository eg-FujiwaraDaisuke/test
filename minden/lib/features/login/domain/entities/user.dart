import 'package:equatable/equatable.dart';

class User extends Equatable {
  String contractor;
  String accountId;
  String wallPaper;
  String loginId;
  String name;
  String icon;
  String limitedPlantId;
  String bio;
  Supports supports;
  Contracts contracts;
  String userId;

  User({
    required this.contractor,
    required this.accountId,
    required this.wallPaper,
    required this.loginId,
    required this.name,
    required this.icon,
    required this.limitedPlantId,
    required this.bio,
    required this.supports,
    required this.contracts,
    required this.userId,
  });

  @override
  List<Object> get props => [
        contractor,
        accountId,
        wallPaper,
        loginId,
        name,
        icon,
        limitedPlantId,
        bio,
        supports,
        contracts,
        userId
      ];
}

class Contracts extends Equatable {
  String contractId;
  String name;

  Contracts({
    required this.contractId,
    required this.name,
  });

  @override
  List<Object> get props => [
        contractId,
        name,
      ];
}

class Supports extends Equatable {
  String yearMonth;
  String plantId;
  String status;

  Supports({
    required this.yearMonth,
    required this.plantId,
    required this.status,
  });

  @override
  List<Object> get props => [yearMonth, plantId, status];
}
