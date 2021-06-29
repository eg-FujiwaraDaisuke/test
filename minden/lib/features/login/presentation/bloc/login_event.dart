part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class GetLoginUserInfo extends LoginEvent {
  final String loginId;
  final String loginPassword;
  const GetLoginUserInfo(this.loginId, this.loginPassword);

  @override
  List<Object> get props => [loginId, loginPassword];
}
