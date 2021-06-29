import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/features/login/data/model/user.dart';
import 'package:minden/features/login/login_api_repository.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginApiRepository repository;

  LoginBloc(LoginState initialState, this.repository) : super(initialState);

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is GetLoginUserInfo) {
      try {
        yield LoginLoading();
        final user = await repository.fetchUserData(
            id: event.loginId, password: event.loginPassword);
        print(user.email);
        yield LoginLoaded(user);
      } catch (e) {
        yield LoginError(e.toString());
      }
    }
  }
}
