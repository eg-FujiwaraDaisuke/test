import 'package:equatable/equatable.dart';

// domain - entity

class Localized extends Equatable {
  Localized({
    required this.languageCode,
  });

  final String languageCode;

  @override
  List<Object> get props => [
        languageCode,
      ];
}
