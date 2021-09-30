import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/fcm/domain/usecases/update_fcm_token.dart';

part 'fcm_event.dart';
part 'fcm_state.dart';

class UpdateFcmTokenBloc extends Bloc<FcmEvent, FcmState> {
  UpdateFcmTokenBloc(FcmState initialState, this.usecase) : super(initialState);
  final UpdateFcmToken usecase;

  @override
  Stream<FcmState> mapEventToState(FcmEvent event) async* {
    if (event is UpdateFcmTokenEvent) {
      try {
        yield FcmStateUpdateing();
        final failureOrSuccess =
            await usecase(Params(fcmToken: event.fcmToken));

        yield failureOrSuccess.fold<FcmState>(
          (failure) => throw failure,
          (success) => FcmStateUpdated(),
        );
      } on RefreshTokenExpiredException catch (e) {
        yield FcmStateError(message: e.toString(), needLogin: true);
      } catch (e) {
        yield FcmStateError(message: e.toString(), needLogin: false);
      }
    }
  }
}
