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
  Stream<PowerPlantState> mapEventToState(PowerPlantEvent event,) async* {
    if (event is GetPowerPlantsEvent) {
      try {
        yield const PowerPlantLoading();

        final failureOrUser =
        await usecase(GetPowerPlantParams(tagId: event.tagId));

        yield failureOrUser.fold<PowerPlantState>((failure) {
          throw failure;
        },
                (plants) {
              return PowerPlantsLoaded(plants);
            });
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
  Stream<PowerPlantState> mapEventToState(PowerPlantEvent event,) async* {
    if (event is GetPowerPlantsEvent) {
      try {
        yield const PowerPlantLoading();

        final failureOrUser =
        await usecase(GetPowerPlantParams(historyType: event.historyType));

        yield failureOrUser.fold<PowerPlantState>((failure) => throw failure,
                (plants) {
              return PowerPlantsLoaded(plants);
            });
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
  Stream<PowerPlantState> mapEventToState(PowerPlantEvent event,) async* {
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
  Stream<PowerPlantState> mapEventToState(PowerPlantEvent event,) async* {
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
