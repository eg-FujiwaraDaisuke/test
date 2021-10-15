import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'transition_screen_event.dart';
part 'transition_screen_state.dart';

class TransitionScreenBloc
    extends Bloc<TransitionScreenEvent, TransitionState> {
  TransitionScreenBloc(TransitionState initialState) : super(initialState);
  @override
  Stream<TransitionState> mapEventToState(
    TransitionScreenEvent event,
  ) async* {
    if (event is TransitionScreenEvent) {
      yield TransitionScreenStart(event.screen);
      yield const TransitionScreenCompleted();
    }
  }
}
