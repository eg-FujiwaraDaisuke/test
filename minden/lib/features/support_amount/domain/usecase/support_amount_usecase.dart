import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/support_amount/domain/entities/support_amount.dart';
import 'package:minden/features/support_amount/domain/repositories/support_amount_repository.dart';

class GetSupportAmount extends UseCase<SupportAmount, GetSupportAmountParams> {
  GetSupportAmount(this.repository);

  final SupportAmountRepository repository;

  @override
  Future<Either<Failure, SupportAmount>> call(
      GetSupportAmountParams params) async {
    return repository.getSupportAmount();
  }
}

class GetSupportAmountParams extends Equatable {
  @override
  List<Object> get props => [];
}
