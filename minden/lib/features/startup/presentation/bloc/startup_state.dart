import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/maintenance_info.dart';

@immutable
abstract class StartupState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends StartupState {}

class Loading extends StartupState {}

class Loaded extends StartupState {
  final MaintenanceInfo info;

  Loaded({@required this.info});

  @override
  List<Object> get props => [info];
}

class Error extends StartupState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
