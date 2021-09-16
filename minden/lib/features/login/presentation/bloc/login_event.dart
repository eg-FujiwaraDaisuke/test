part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class GetLoginUserEvent extends LoginEvent {
  const GetLoginUserEvent(this.inputLoginId, this.inputPassword);

  final String inputLoginId;
  final String inputPassword;

  @override
  List<Object> get props => [inputLoginId, inputPassword];
}
