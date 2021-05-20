import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

// domain - entity

class LocalizedInfo extends Equatable {
  LocalizedInfo({
    @required this.languageCode,
  });

  final String languageCode;

  @override
  List<Object> get props => [
        languageCode,
      ];
}
