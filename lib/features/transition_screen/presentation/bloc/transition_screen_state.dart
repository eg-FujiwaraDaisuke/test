part of 'transition_screen_bloc.dart';

abstract class TransitionState extends Equatable {
  const TransitionState();
}

class TransitionScreenInitial extends TransitionState {
  const TransitionScreenInitial();
  @override
  List<Object> get props => [];
}

class TransitionScreenStart extends TransitionState {
  const TransitionScreenStart(this.screen, this.isFirst);
  final String screen;
  final bool isFirst;
  @override
  List<Object> get props => [];
}

class TransitionMessagePageStart extends TransitionState {
  const TransitionMessagePageStart(this.messageId);
  final String messageId;
  @override
  List<Object> get props => [];
}

class TransitionScreenCompleted extends TransitionState {
  const TransitionScreenCompleted();

  @override
  List<Object> get props => [];
}
