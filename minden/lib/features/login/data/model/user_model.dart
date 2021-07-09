import 'package:minden/features/login/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String key,
    required String loginId,
    required String name,
    required String secret,
    required String provider,
    required String service,
    required String email,
  }) : super(
          key: key,
          loginId: loginId,
          name: name,
          secret: secret,
          provider: provider,
          service: service,
          email: email,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      key: json['user']['key'],
      loginId: json['user']['loginId'],
      name: json['user']['name'],
      secret: json['user']['secret'],
      provider: json['user']['provider'],
      service: json['user']['service'],
      email: json['user']['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'loginId': loginId,
      'name': name,
      'secret': secret,
      'provider': provider,
      'service': service,
      'email': email,
    };
  }
}
