import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/startup/domain/entities/startup.dart';
import 'package:minden/features/startup/domain/usecases/startup_usecase.dart';
import 'package:minden/features/startup/presentation/bloc/startup_event.dart';
import 'package:minden/features/startup/presentation/bloc/startup_state.dart';

class StartupBloc extends Bloc<StartupEvent, StartupState> {
  final GetStartupInfo usecase;

  StartupBloc(StartupState initialState, this.usecase) : super(initialState);

  @override
  Stream<StartupState> mapEventToState(StartupEvent event) async* {
    if (event is GetStartupInfoEvent) {
      yield StartupStateLoading();
      final failureOrInfo = await usecase(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrInfo);
    }
  }

  Stream<StartupState> _eitherLoadedOrErrorState(
      Either<Failure, Startup> failureOrInfo) async* {
    yield failureOrInfo.fold<StartupState>(
      (failure) => _buildError(failure),
      (info) {
        return StartupStateLoaded(info: info);
      },
    );
  }

  StartupStateError _buildError(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return StartupStateError(
            localizedKey: 'unsupported_error', actionKey: 'ok');
      case SupportVersionFailure:
        return StartupStateError(
          localizedKey: 'update_version_message_%s',
          actionKey: 'store_action',
          args: [(failure as SupportVersionFailure).supportVersion],
          actionUrl: (failure).actionUrl,
        );
      case UnderMaintenanceFailure:
        return StartupStateError(
          localizedKey: (failure as UnderMaintenanceFailure).description,
          actionKey: 'maintenance_action',
          actionUrl: failure.actionUrl,
        );
      default:
        return StartupStateError(
            localizedKey: 'unsupported_error', actionKey: 'ok');
    }
  }
}
