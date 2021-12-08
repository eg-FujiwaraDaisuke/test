import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/features/reset_password/domain/usecases/reset_password_repository_usecase.dart';
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
      try {
        yield const SupportPowerPlantUpdating();

        final failureOrSuccess =
            await usecase(UpdateSupportPowerPlantParams(event.plantIdList));

        yield failureOrSuccess.fold<SupportPowerPlantState>(
          (failure) => throw failure,
          (success) => const SupportPowerPlantUpdated(),
        );
      } on RefreshTokenExpiredException catch (e) {
        yield SupportPowerPlantError(message: e.toString(), needLogin: true);
      } catch (e) {
        yield SupportPowerPlantError(message: e.toString(), needLogin: false);
      }
    }
  }
}
