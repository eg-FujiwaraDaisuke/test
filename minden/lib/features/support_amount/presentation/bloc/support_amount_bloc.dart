import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/support_amount/domain/usecase/support_amount_usecase.dart';
import 'package:minden/features/support_amount/presentation/bloc/support_amount_event.dart';
import 'package:minden/features/support_amount/presentation/bloc/support_amount_state.dart';

class GetSupportAmountBloc
    extends Bloc<SupportAmountEvent, SupportAmountState> {
  GetSupportAmountBloc(this.usecase) : super(const SupportAmountStateInitial());
  final GetSupportAmount usecase;

  @override
  Stream<SupportAmountState> mapEventToState(
    SupportAmountEvent event,
  ) async* {
    if (event is GetSupportAmountEvent) {
      try {
        yield const SupportAmountStateLoading();

        final failureOrUser = await usecase(GetSupportAmountParams());

        yield failureOrUser.fold<SupportAmountState>(
          (failure) => throw failure,
          (supportAmount) => SupportAmountStateLoaded(supportAmount),
        );
      } on RefreshTokenExpiredException catch (e) {
        yield SupportAmountStateLoadError(
          message: e.toString(),
          needLogin: true,
        );
      } catch (e) {
        yield SupportAmountStateLoadError(
          message: e.toString(),
          needLogin: false,
        );
      }
    }
  }
}
