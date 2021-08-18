import 'package:equatable/equatable.dart';

class Token extends Equatable {
  const Token({
    required this.appToken,
    required this.refreshToken,
  });

  final String appToken;
  final String refreshToken;

  @override
  List<Object> get props => [
        appToken,
        refreshToken,
      ];
}
