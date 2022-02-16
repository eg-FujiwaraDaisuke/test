part of 'reset_password_bloc.dart';

abstract class PasswordState extends Equatable {
  const PasswordState();
}

class PasswordInitial extends PasswordState {
  const PasswordInitial();
  @override
  List<Object> get props => [];
}

class ResetPasswordLoading extends PasswordState {
  const ResetPasswordLoading();
  @override
  List<Object> get props => [];
}

class ResetPasswordLoaded extends PasswordState {
  const ResetPasswordLoaded();
  @override
  List<Object> get props => [];
}

class PasswordUpdataing extends PasswordState {
  const PasswordUpdataing();
  @override
  List<Object> get props => [];
}

class PasswordUpdated extends PasswordState {
  const PasswordUpdated();
  @override
  List<Object> get props => [];
}

class ResetPasswordError extends PasswordState {
  const ResetPasswordError({
    required this.message,
  });

  final String message;

  @override
  List<Object> get props => [message];
}
