import 'package:equatable/equatable.dart';

// domain - entity

class Localized extends Equatable {
  const Localized({
    required this.languageCode,
  });

  final String languageCode;

  @override
  List<Object> get props => [
        languageCode,
      ];
}
