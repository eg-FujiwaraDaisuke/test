part of 'transition_screen_bloc.dart';

abstract class TransitionEvent extends Equatable {
  const TransitionEvent();
}

class TransitionScreenEvent extends TransitionEvent {
  TransitionScreenEvent(
    this.screen,
  );

  String screen;
  @override
  List<Object> get props => [];
}
