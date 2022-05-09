import 'package:equatable/equatable.dart';

abstract class SupportAmountEvent extends Equatable {
  const SupportAmountEvent();
}

class GetSupportAmountEvent extends SupportAmountEvent {
  const GetSupportAmountEvent();

  @override
  List<Object> get props => [];
}
