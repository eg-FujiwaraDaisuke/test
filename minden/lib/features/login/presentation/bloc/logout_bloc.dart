import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/login/domain/usecases/logout_usecase.dart';
import 'package:minden/features/login/presentation/bloc/logout_event.dart';
import 'package:minden/features/login/presentation/bloc/logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  LogoutBloc(LogoutState initialState, this.usecase) : super(initialState);

  final LogoutUser usecase;

  @override
  Stream<LogoutState> mapEventToState(LogoutEvent event) async* {
    if (event is LogoutEvent) {
      yield LogoutStateLoading();
      await usecase(NoParams());
      yield LogoutStateLoaded();
    }
  }
}
