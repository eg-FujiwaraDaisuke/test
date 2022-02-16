import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/localize/domain/entities/localized.dart';
import 'package:minden/features/localize/domain/usecases/localized_usecase.dart';
import 'package:minden/features/localize/presentation/bloc/localized_event.dart';
import 'package:minden/features/localize/presentation/bloc/localized_state.dart';

class LocalizedBloc extends Bloc<LocalizedEvent, LocalizedState> {
  LocalizedBloc(LocalizedState initialState, this.usecase)
      : super(initialState);

  final GetLocalizedEvent usecase;

  @override
  Stream<LocalizedState> mapEventToState(LocalizedEvent event) async* {
    if (event is GetLocalizedInfoEvent) {
      yield LocalizedStateLoading();
      final info = await usecase(LocalizedInfoParams(event.languageCode));
      yield* _loadedState(info);
    } else if (event is UpdateLocalizedInfoEvent) {
      yield LocalizedStateLoading();
      await usecase.update(LocalizedInfoParams(event.languageCode));
      yield LocalizedStateUpdated();
    }
  }

  Stream<LocalizedState> _loadedState(
    Either<Failure, Localized> info,
  ) async* {
    yield info.fold<LocalizedState>(
      (failure) => LocalizedStateError(),
      (info) {
        return LocalizedStateLoaded(info: info);
      },
    );
  }
}
