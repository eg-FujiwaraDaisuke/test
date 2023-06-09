import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:minden/features/startup/domain/entities/startup.dart';

@immutable
abstract class StartupState extends Equatable {
  @override
  List<Object> get props => [];
}

class StartupStateEmpty extends StartupState {}

class StartupStateLoading extends StartupState {}

class StartupStateLoaded extends StartupState {
  StartupStateLoaded({required this.info});

  final Startup info;

  @override
  List<Object> get props => [info];
}

class StartupStateError extends StartupState {
  StartupStateError({
    required this.localizedKey,
    required this.actionKey,
    List<String>? args,
    String? actionUrl,
  })  : args = args,
        actionUrl = actionUrl;

  final String localizedKey;
  final String actionKey;
  final List<String>? args;
  final String? actionUrl;

  @override
  List<Object> get props => [
        localizedKey,
        actionKey,
      ];
}
