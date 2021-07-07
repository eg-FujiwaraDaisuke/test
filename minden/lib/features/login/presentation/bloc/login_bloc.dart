import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/login/domain/usecases/get_login_user.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final GetLoginUser usecase;

  LoginBloc(LoginState initialState, this.usecase) : super(initialState);

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is GetLoginUserInfo) {
      try {
        yield LoginLoading();
        final failureOrUser = await usecase(Params(
          id: event.inputLoginId,
          password: event.inputPassword,
        ));

        print(failureOrUser);

        yield failureOrUser.fold<LoginState>(
          (failure) => throw UnimplementedError(),
          (user) => LoginLoaded(user: user),
        );
      } catch (e) {
        yield LoginError(e.toString());
      }
    }
  }
}
