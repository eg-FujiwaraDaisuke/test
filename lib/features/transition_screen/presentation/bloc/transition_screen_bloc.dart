import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'transition_screen_event.dart';
part 'transition_screen_state.dart';

class TransitionScreenBloc extends Bloc<TransitionEvent, TransitionState> {
  TransitionScreenBloc(TransitionState initialState) : super(initialState);
  @override
  Stream<TransitionState> mapEventToState(
    TransitionEvent event,
  ) async* {
    if (event is TransitionScreenEvent) {
      yield TransitionScreenStart(event.screen, event.isFirst);
      yield const TransitionScreenCompleted();
    }

    if (event is TransitionMessagePageEvent) {
      yield TransitionMessagePageStart(event.messageId);
      yield const TransitionScreenCompleted();
    }
  }
}
