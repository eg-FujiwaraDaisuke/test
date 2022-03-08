import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant.dart';
import 'package:minden/features/support_power_plant/domain/usecases/support_power_plant_usecase.dart';

part 'support_power_plant_event.dart';
part 'support_power_plant_state.dart';

class UpdateSupportPowerPlantBloc
    extends Bloc<SupportPowerPlantEvent, SupportPowerPlantState> {
  UpdateSupportPowerPlantBloc(SupportPowerPlantState initialState, this.usecase)
      : super(initialState);
  final UpdateSupportPowerPlant usecase;

  @override
  Stream<SupportPowerPlantState> mapEventToState(
    SupportPowerPlantEvent event,
  ) async* {
    if (event is UpdateSupportPowerPlantEvent) {
      // 新たに応援する発電所一覧
      final powerPlants = event.newRegistPowerPlants;

      try {
        yield const SupportPowerPlantUpdating();

        final failureOrSuccess =
            await usecase(UpdateSupportPowerPlantParams(event.plantIdList));

        yield failureOrSuccess.fold<SupportPowerPlantState>(
          (failure) => throw failure,
          (success) => SupportPowerPlantUpdated(
            supportPowerPlants: powerPlants,
          ),
        );
      } on RefreshTokenExpiredException catch (e) {
        yield SupportPowerPlantError(message: e.toString(), needLogin: true);
      } catch (e) {
        yield SupportPowerPlantError(message: e.toString(), needLogin: false);
      }
    }
  }
}
