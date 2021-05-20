import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/startup_info.dart';

@immutable
abstract class StartupState extends Equatable {
  @override
  List<Object> get props => [];
}

class StartupStateEmpty extends StartupState {}

class StartupStateLoading extends StartupState {}

class StartupStateLoaded extends StartupState {
  final StartupInfo info;

  StartupStateLoaded({@required this.info});

  @override
  List<Object> get props => [info];
}

class StartupStateError extends StartupState {
  final String localizedKey;
  final String actionKey;
  final List<String> args;
  final String actionUrl;

  StartupStateError({
    @required this.localizedKey,
    @required this.actionKey,
    this.args,
    this.actionUrl,
  });

  @override
  List<Object> get props => [localizedKey, args, actionKey, actionUrl];
}
