part of 'transition_screen_bloc.dart';

abstract class TransitionEvent extends Equatable {
  const TransitionEvent();
}

class TransitionScreenEvent extends TransitionEvent {
  TransitionScreenEvent(this.screen, this.isFirst);

  String screen;
  bool isFirst;
  @override
  List<Object> get props => [];
}

class TransitionMessagePageEvent extends TransitionEvent {
  TransitionMessagePageEvent(
    this.messageId,
  );

  String messageId;
  @override
  List<Object> get props => [];
}
