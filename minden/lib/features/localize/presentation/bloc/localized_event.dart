import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LocalizedEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetLocalizedInfoEvent extends LocalizedEvent {
  GetLocalizedInfoEvent(this.languageCode);

  final String languageCode;

  @override
  List<Object> get props => [languageCode];
}

class UpdateLocalizedInfoEvent extends LocalizedEvent {
  UpdateLocalizedInfoEvent(this.languageCode);

  final String languageCode;

  @override
  List<Object> get props => [languageCode];
}
