import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/maintenance_info.dart';

@immutable
abstract class StartupState extends Equatable {
  @override
  List<Object> get props => [];
}

class StartupStateEmpty extends StartupState {}

class StartupStateLoading extends StartupState {}

class StartupStateLoaded extends StartupState {
  final MaintenanceInfo info;

  StartupStateLoaded({@required this.info});

  @override
  List<Object> get props => [info];
}

class StartupStateError extends StartupState {
  final String message;

  StartupStateError({@required this.message});

  @override
  List<Object> get props => [message];
}
