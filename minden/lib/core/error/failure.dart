import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class LocalCacheFailure extends Failure {}

class ServerFailure extends Failure {}

class ConnectionFailure extends Failure {}

class LoginFailure extends Failure {}

/// RefreshTokenの新規払い出しエラー
class RenewTokenFailure extends Failure {}

/// 顔の見える発電性情報取得エラー
class PublicPowerPlantFailure extends Failure {}

class SupportVersionFailure extends Failure {
  SupportVersionFailure({
    required this.actionUrl,
    required this.supportVersion,
  });

  final String actionUrl;
  final String supportVersion;

  @override
  List<Object> get props => [
        actionUrl,
        supportVersion,
      ];
}

class UnderMaintenanceFailure extends Failure {
  UnderMaintenanceFailure({
    required this.description,
    required this.actionUrl,
  });

  final String description;
  final String actionUrl;

  @override
  List<Object> get props => [
        description,
        actionUrl,
      ];
}
