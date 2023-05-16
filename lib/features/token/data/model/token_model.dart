import 'package:minden/features/token/domain/entities/token.dart';

class TokenModel extends Token {
  const TokenModel({
    required String appToken,
    required String refreshToken,
  }) : super(
          appToken: appToken,
          refreshToken: refreshToken,
        );

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      appToken: json['appToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appToken': appToken,
      'refreshToken': refreshToken,
    };
  }
}
