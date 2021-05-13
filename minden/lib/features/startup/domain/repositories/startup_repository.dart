import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/startup/domain/entities/maintenance_info.dart';

abstract class StartupRepository {
  Future<Either<Failure, MaintenanceInfo>> getMaintenanceInfo();
}