import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:minden/features/startup/presentation/bloc/startup_event.dart';
import 'package:minden/features/startup/presentation/bloc/startup_state.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/startup_info.dart';
import '../../domain/usecases/get_startup_info.dart';

class StartupBloc extends Bloc<StartupEvent, StartupState> {
  final GetStartupInfo usecase;

  StartupBloc(StartupState initialState, this.usecase) : super(initialState);

  @override
  Stream<StartupState> mapEventToState(
    StartupEvent event,
  ) async* {
    if (event is GetStartupInfoEvent) {
      yield StartupStateLoading();
      final failureOrInfo = await usecase.call(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrInfo);
    }
  }

  Stream<StartupState> _eitherLoadedOrErrorState(
    Either<Failure, StartupInfo> failureOrInfo,
  ) async* {
    yield failureOrInfo.fold<StartupState>(
      (failure) => StartupStateError(message: _mapFailureToMessage(failure)),
      (info) {
        return StartupStateLoaded(info: info);
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return "SERVER_FAILURE_MESSAGE";
      default:
        return 'Unexpected error';
    }
  }
}
