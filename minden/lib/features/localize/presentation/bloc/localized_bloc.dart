import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:minden/features/localize/domain/entities/localized_info.dart';
import 'package:minden/features/localize/domain/usecases/get_localized_info.dart';
import 'package:minden/features/localize/presentation/bloc/localized_event.dart';
import 'package:minden/features/localize/presentation/bloc/localized_state.dart';

import '../../../../core/error/failure.dart';

class LocalizedBloc extends Bloc<LocalizedEvent, LocalizedState> {
  final GetLocalizedInfo usecase;

  LocalizedBloc(LocalizedState initialState, this.usecase)
      : super(initialState);

  @override
  Stream<LocalizedState> mapEventToState(
    LocalizedEvent event,
  ) async* {
    if (event is GetLocalizedInfoEvent) {
      yield LocalizedStateLoading();
      final info =
          await usecase(LocalizedInfoParams(event.languageCode));
      yield* _loadedState(info);
    } else if (event is UpdateLocalizedInfoEvent) {
      yield LocalizedStateLoading();
      await usecase
          .update(LocalizedInfoParams(event.languageCode));
      yield LocalizedStateUpdated();
    }
  }

  Stream<LocalizedState> _loadedState(
    Either<Failure, LocalizedInfo> info,
  ) async* {
    yield info.fold<LocalizedState>(
      (failure) => LocalizedStateError(),
      (info) {
        return LocalizedStateLoaded(info: info);
      },
    );
  }
}
