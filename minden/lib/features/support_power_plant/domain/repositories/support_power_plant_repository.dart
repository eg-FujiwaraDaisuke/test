import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/features/user/domain/entities/profile.dart';

abstract class SupportPowerPlantRepository {
  Future<Either<Failure, Success>> update(
    Map<String, List<Map<String, String>>> plantIdList,
  );
}
