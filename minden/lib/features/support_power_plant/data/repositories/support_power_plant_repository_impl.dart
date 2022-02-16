import 'package:dartz/dartz.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/repository/retry_process_mixin.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/features/support_power_plant/data/datasources/support_power_plant_datasources.dart';
import 'package:minden/features/support_power_plant/domain/repositories/support_power_plant_repository.dart';

class SupportPowerPlantRepositoryImpl
    with RetryProcessMixin
    implements SupportPowerPlantRepository {
  const SupportPowerPlantRepositoryImpl({required this.dataSource});

  final SupportPowerPlantDataSource dataSource;

  @override
  Future<Either<Failure, Success>> update(
      Map<String, List<Map<String, String>>> plantIdList) async {
    try {
      final success = await retryRequest(() => dataSource.update(plantIdList));
      return Right(success);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
