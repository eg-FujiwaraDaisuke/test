import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/power_plant/domain/usecase/power_plant_usecase.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_event.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_state.dart';

class GetPowerPlantsBloc extends Bloc<PowerPlantEvent, PowerPlantState> {
  GetPowerPlantsBloc(PowerPlantState initialState, this.usecase)
      : super(initialState);
  final GetPowerPlants usecase;

  @override
  Stream<PowerPlantState> mapEventToState(
    PowerPlantEvent event,
  ) async* {
    if (event is GetPowerPlantsEvent) {
      try {
        yield const PowerPlantLoading();

        final failureOrUser = await usecase(GetPowerPlantParams(
          tagId: event.tagId,
          giftTypeId: event.giftTypeId,
        ));

        yield failureOrUser.fold<PowerPlantState>(
          (failure) => throw failure,
          (plants) => PowerPlantsLoaded(plants),
        );
      } on RefreshTokenExpiredException catch (e) {
        yield PowerPlantLoadError(message: e.toString(), needLogin: true);
      } catch (e) {
        yield PowerPlantLoadError(message: e.toString(), needLogin: false);
      }
    }
  }
}

class GetPowerPlantsHistoryBloc extends Bloc<PowerPlantEvent, PowerPlantState> {
  GetPowerPlantsHistoryBloc(PowerPlantState initialState, this.usecase)
      : super(initialState);
  final GetPowerPlantsHistory usecase;

  @override
  Stream<PowerPlantState> mapEventToState(
    PowerPlantEvent event,
  ) async* {
    if (event is GetSupportHistoryEvent) {
      try {
        yield const HistoryLoading();

        final failureOrUser = await usecase(GetPowerPlantParams(
            historyType: event.historyType, userId: event.userId));

        yield failureOrUser.fold<PowerPlantState>(
          (failure) => throw failure,
          (history) => HistoryLoaded(history),
        );
      } on RefreshTokenExpiredException catch (e) {
        yield PowerPlantLoadError(message: e.toString(), needLogin: true);
      } catch (e) {
        yield PowerPlantLoadError(message: e.toString(), needLogin: false);
      }
    }
  }
}

class GetPowerPlantBloc extends Bloc<PowerPlantEvent, PowerPlantState> {
  GetPowerPlantBloc(PowerPlantState initialState, this.usecase)
      : super(initialState);
  final GetPowerPlant usecase;

  @override
  Stream<PowerPlantState> mapEventToState(
    PowerPlantEvent event,
  ) async* {
    if (event is GetPowerPlantEvent) {
      try {
        yield const PowerPlantLoading();

        final failureOrUser =
            await usecase(GetPowerPlantParams(plantId: event.plantId));

        yield failureOrUser.fold<PowerPlantState>((failure) => throw failure,
            (plant) {
          return PowerPlantLoaded(plant);
        });
      } on RefreshTokenExpiredException catch (e) {
        yield PowerPlantLoadError(message: e.toString(), needLogin: true);
      } catch (e) {
        yield PowerPlantLoadError(message: e.toString(), needLogin: false);
      }
    }
  }
}

class GetParticipantBloc extends Bloc<PowerPlantEvent, PowerPlantState> {
  GetParticipantBloc(PowerPlantState initialState, this.usecase)
      : super(initialState);
  final GetPowerPlantParticipant usecase;

  @override
  Stream<PowerPlantState> mapEventToState(
    PowerPlantEvent event,
  ) async* {
    if (event is GetPowerPlantEvent) {
      try {
        yield const PowerPlantLoading();

        final failureOrUser =
            await usecase(GetPowerPlantParams(plantId: event.plantId));

        yield failureOrUser.fold<PowerPlantState>((failure) => throw failure,
            (participant) {
          return ParticipantLoaded(participant);
        });
      } on RefreshTokenExpiredException catch (e) {
        yield PowerPlantLoadError(message: e.toString(), needLogin: true);
      } catch (e) {
        yield PowerPlantLoadError(message: e.toString(), needLogin: false);
      }
    }
  }
}

class GetSupportActionBloc extends Bloc<PowerPlantEvent, PowerPlantState> {
  GetSupportActionBloc(PowerPlantState initialState, this.usecase)
      : super(initialState);
  final GetSupportAction usecase;

  @override
  Stream<PowerPlantState> mapEventToState(
    PowerPlantEvent event,
  ) async* {
    if (event is GetSupportActionEvent) {
      try {
        yield const SupportActionLoading();

        final failureOrUser =
            await usecase(GetPowerPlantParams(plantId: event.plantId));

        yield failureOrUser.fold<PowerPlantState>(
          (failure) => throw failure,
          (supportAction) => SupportActionLoaded(supportAction),
        );
      } on RefreshTokenExpiredException catch (e) {
        yield PowerPlantLoadError(message: e.toString(), needLogin: true);
      } catch (e) {
        yield PowerPlantLoadError(message: e.toString(), needLogin: false);
      }
    }
  }
}

class GetGiftBloc extends Bloc<PowerPlantEvent, PowerPlantState> {
  GetGiftBloc(PowerPlantState initialState, this.usecase) : super(initialState);
  final GetGift usecase;

  @override
  Stream<PowerPlantState> mapEventToState(
    PowerPlantEvent event,
  ) async* {
    if (event is GetGiftEvent) {
      try {
        yield const GiftLoading();

        final failureOrUser = await usecase(GetPowerPlantParams());

        yield failureOrUser.fold<PowerPlantState>(
          (failure) => throw failure,
          (gift) => GiftLoaded(gift),
        );
      } on RefreshTokenExpiredException catch (e) {
        yield PowerPlantLoadError(message: e.toString(), needLogin: true);
      } catch (e) {
        yield PowerPlantLoadError(message: e.toString(), needLogin: false);
      }
    }
  }
}
