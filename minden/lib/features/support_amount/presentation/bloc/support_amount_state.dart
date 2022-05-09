import 'package:equatable/equatable.dart';
import 'package:minden/features/power_plant/domain/entities/support_history.dart';
import 'package:minden/features/support_amount/domain/entities/support_amount.dart';

abstract class SupportAmountState extends Equatable {
  const SupportAmountState();
}

class SupportAmountStateInitial extends SupportAmountState {
  const SupportAmountStateInitial();

  @override
  List<Object> get props => [];
}

class SupportAmountStateLoading extends SupportAmountState {
  const SupportAmountStateLoading();

  @override
  List<Object> get props => [];
}


class SupportAmountStateLoaded extends SupportAmountState {
  const SupportAmountStateLoaded(this.supportAmount);

  final SupportAmount supportAmount;

  @override
  List<Object> get props => [supportAmount];
}

class SupportAmountStateLoadError extends SupportAmountState {
  const SupportAmountStateLoadError({
    required this.message,
    required this.needLogin,
  });

  final String message;
  final bool needLogin;

  @override
  List<Object> get props => [message];
}
