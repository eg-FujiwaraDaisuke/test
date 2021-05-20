import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class LocalCacheFailure extends Failure {}

class ServerFailure extends Failure {}

class ConnectionFailure extends Failure {}

class SupportVersionFailure extends Failure {
  SupportVersionFailure({
    @required this.actionUrl,
    @required this.supportVersion,
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
    @required this.description,
    @required this.actionUrl,
  });

  final String description;
  final String actionUrl;

  @override
  List<Object> get props => [
        description,
        actionUrl,
      ];
}
