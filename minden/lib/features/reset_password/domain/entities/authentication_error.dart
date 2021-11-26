import 'package:equatable/equatable.dart';

class AuthenticationError extends Equatable {
  const AuthenticationError({
    required this.statusCode,
    required this.message,
  });

  factory AuthenticationError.fromJson(Map<String, dynamic> elem) {
    return AuthenticationError(
        statusCode: elem['statusCode'], message: elem['message']);
  }

  final int statusCode;
  final String message;

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'statusCode': statusCode,
    };
  }

  @override
  List<Object?> get props => [message];
}
