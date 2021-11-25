import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/features/reset_password/domain/usecases/reset_password_repository_usecase.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  ResetPasswordBloc(PasswordState initialState, this.usecase)
      : super(initialState);
  final ResetPassword usecase;

  @override
  Stream<PasswordState> mapEventToState(
    PasswordEvent event,
  ) async* {
    if (event is ResetPasswordEvent) {
      try {
        yield const ResetPasswordLoading();
        final failureOrSuccess =
            await usecase(ResetPasswordParams(loginId: event.loginId));

        yield failureOrSuccess.fold(
          (failure) => throw failure,
          (success) => const ResetPasswordLoaded(),
        );
      } catch (e) {
        yield ResetPasswordError(message: e.toString());
      }
    }
  }
}

class UpdatePasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  UpdatePasswordBloc(PasswordState initialState, this.usecase)
      : super(initialState);
  final UpdatePassword usecase;

  @override
  Stream<PasswordState> mapEventToState(
    PasswordEvent event,
  ) async* {
    if (event is UpdatePasswordEvent) {
      try {
        yield const PasswordUpdataing();
        final failureOrSuccess = await usecase(UpdatePasswordParams(
            loginId: event.loginId,
            confirmationCode: event.confirmationCode,
            newPassword: event.newPassword));

        yield failureOrSuccess.fold(
          (failure) => throw failure,
          (success) => const PasswordUpdated(),
        );
      } catch (e) {
        yield ResetPasswordError(message: e.toString());
      }
    }
  }
}
