import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LogoutState extends Equatable {
  @override
  List<Object> get props => [];
}

class LogoutStateInitial extends LogoutState {}

class LogoutStateLoading extends LogoutState {}

class LogoutStateLoaded extends LogoutState {}

class LogoutStateError extends LogoutState {}
