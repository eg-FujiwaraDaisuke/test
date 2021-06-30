import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String key;
  final String loginId;
  final String name;
  final String secret;
  final String provider;
  final String service;
  final String email;

  User({
    required this.key,
    required this.loginId,
    required this.name,
    required this.secret,
    required this.provider,
    required this.service,
    required this.email,
  });

  @override
  List<Object> get props => [
        key,
        loginId,
        name,
        secret,
        provider,
        service,
        email,
      ];
}
