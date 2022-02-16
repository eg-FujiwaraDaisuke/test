import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class StartupEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetStartupInfoEvent extends StartupEvent {
  GetStartupInfoEvent();

  @override
  List<Object> get props => [];
}
