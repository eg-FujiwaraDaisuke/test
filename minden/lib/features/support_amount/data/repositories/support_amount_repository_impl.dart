import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/repository/retry_process_mixin.dart';
import 'package:minden/features/support_amount/data/datasources/support_amount_data_source.dart';
import 'package:minden/features/support_amount/domain/entities/support_amount.dart';
import 'package:minden/features/support_amount/domain/repositories/support_amount_repository.dart';

final powerPlantRepositoryProvider = Provider<SupportAmountRepository>(
  (ref) {
    return SupportAmountRepositoryImpl(
      supportAmountDataSource: ref.read(supportAmountDataSourceProvider),
    );
  },
);

class SupportAmountRepositoryImpl
    with RetryProcessMixin
    implements SupportAmountRepository {
  SupportAmountRepositoryImpl({
    required this.supportAmountDataSource,
  });

  final SupportAmountDataSource supportAmountDataSource;

  @override
  Future<Either<SupportAmountFailure, SupportAmount>> getSupportAmount() async {
    try {
      final supportAmmount =
          await retryRequest(supportAmountDataSource.getSupportAmount);

      return Right(supportAmmount);
    } on ServerException {
      return left(SupportAmountFailure());
    }
  }
}
