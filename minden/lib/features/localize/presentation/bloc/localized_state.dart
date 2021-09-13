import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:minden/features/localize/domain/entities/localized.dart';

@immutable
abstract class LocalizedState extends Equatable {
  @override
  List<Object> get props => [];
}

class LocalizedStateEmpty extends LocalizedState {}

class LocalizedStateLoading extends LocalizedState {}

class LocalizedStateLoaded extends LocalizedState {
  final Localized info;

  LocalizedStateLoaded({required this.info});

  @override
  List<Object> get props => [info];
}

class LocalizedStateUpdated extends LocalizedState {}

class LocalizedStateError extends LocalizedState {}
