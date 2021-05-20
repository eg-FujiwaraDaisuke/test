import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LocalizedEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetLocalizedInfoEvent extends LocalizedEvent {
  final String languageCode;

  GetLocalizedInfoEvent(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}

class UpdateLocalizedInfoEvent extends LocalizedEvent {
  final String languageCode;

  UpdateLocalizedInfoEvent(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}
