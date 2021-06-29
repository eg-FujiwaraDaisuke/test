part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class GetLoginUserInfo extends LoginEvent {
  final String inputLoginId;
  final String inputPassword;
  const GetLoginUserInfo(this.inputLoginId, this.inputPassword);

  @override
  List<Object> get props => [inputLoginId, inputPassword];
}
