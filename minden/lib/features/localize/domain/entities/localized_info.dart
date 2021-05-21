import 'package:equatable/equatable.dart';

// domain - entity

class LocalizedInfo extends Equatable {
  LocalizedInfo({
    required this.languageCode,
  });

  final String languageCode;

  @override
  List<Object> get props => [
        languageCode,
      ];
}
