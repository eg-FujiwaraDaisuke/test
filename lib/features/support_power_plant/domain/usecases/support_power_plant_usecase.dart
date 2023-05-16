import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/support_power_plant/domain/repositories/support_power_plant_repository.dart';
import 'package:minden/features/user/domain/entities/profile.dart';

// domain - usecase
class UpdateSupportPowerPlant
    extends UseCase<Success, UpdateSupportPowerPlantParams> {
  UpdateSupportPowerPlant(this.repository);

  final SupportPowerPlantRepository repository;

  @override
  Future<Either<Failure, Success>> call(
      UpdateSupportPowerPlantParams params) async {
    return await repository.update(params.plantIdList);
  }
}

class UpdateSupportPowerPlantParams extends Equatable {
  const UpdateSupportPowerPlantParams(this.plantIdList);

  final Map<String, List<Map<String, String>>> plantIdList;

  @override
  List<Object> get props => [];
}
