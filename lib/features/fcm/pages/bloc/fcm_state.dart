part of 'fcm_bloc.dart';

abstract class FcmState extends Equatable {
  const FcmState();

  @override
  List<Object> get props => [];
}

class FcmStateInitial extends FcmState {}

class FcmStateUpdateing extends FcmState {}

class FcmStateUpdated extends FcmState {}

class FcmStateError extends FcmState {
  const FcmStateError({
    required this.message,
    required this.needLogin,
  });

  final String message;
  final bool needLogin;

  @override
  List<Object> get props => [message];
}
