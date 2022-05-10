import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/support_amount/domain/entities/support_amount.dart';

abstract class SupportAmountRepository {
  Future<Either<SupportAmountFailure, SupportAmount>> getSupportAmount();
}
