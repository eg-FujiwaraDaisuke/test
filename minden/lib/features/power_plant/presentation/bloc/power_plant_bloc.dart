import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:minden/core/error/failure.dart';
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

        final failureOrUser =
            await usecase(GetPowerPlantParams(tagId: event.tagId));

        yield failureOrUser.fold<PowerPlantState>(
            (failure) => throw ServerFailure(), (plants) {
          return PowerPlantsLoaded(plants);
        });
      } catch (e) {
        yield PowerPlantLoadError(e.toString());
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

        yield failureOrUser.fold<PowerPlantState>(
            (failure) => throw ServerFailure(), (plant) {
          return PowerPlantLoaded(plant);
        });
      } catch (e) {
        yield PowerPlantLoadError(e.toString());
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

        yield failureOrUser.fold<PowerPlantState>(
                (failure) => throw ServerFailure(), (participant) {
          return ParticipantLoaded(participant);
        });
      } catch (e) {
        yield PowerPlantLoadError(e.toString());
      }
    }
  }
}
