part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();

  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  const LoginLoading();

  @override
  List<Object> get props => [];
}

class LoginLoaded extends LoginState {
  const LoginLoaded({required this.user});

  final User user;

  @override
  List<Object> get props => [user];
}

class LoginError extends LoginState {
  const LoginError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
