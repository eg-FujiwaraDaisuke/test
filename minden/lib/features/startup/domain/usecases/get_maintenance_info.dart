import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/startup/domain/entities/maintenance_info.dart';
import 'package:minden/features/startup/domain/repositories/startup_repository.dart';

class GetMaintenanceInfo extends UseCase<MaintenanceInfo, NoParams> {
  final StartupRepository repository;

  GetMaintenanceInfo(this.repository);

  Future<Either<Failure, MaintenanceInfo>> call(NoParams params) async {
    return await repository.getMaintenanceInfo();
  }
}
