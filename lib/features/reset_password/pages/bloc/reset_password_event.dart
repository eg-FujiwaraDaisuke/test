part of 'reset_password_bloc.dart';

abstract class PasswordEvent extends Equatable {
  const PasswordEvent();
}

class ResetPasswordEvent extends PasswordEvent {
  const ResetPasswordEvent({required this.loginId});

  final String loginId;

  @override
  List<Object> get props => [loginId];
}

class UpdatePasswordEvent extends PasswordEvent {
  const UpdatePasswordEvent({
    required this.loginId,
    required this.confirmationCode,
    required this.newPassword,
  });

  final String loginId;
  final String confirmationCode;
  final String newPassword;

  @override
  List<Object> get props => [loginId, confirmationCode, newPassword];
}
