class User {
  late String key;
  late String loginId;
  late String name;
  late String secret;
  late String provider;
  late String service;
  late String email;
  late String error;

  User({
    required this.key,
    required this.loginId,
    required this.name,
    required this.secret,
    required this.provider,
    required this.service,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['loginId'] = this.loginId;
    data['name'] = this.name;
    data['secret'] = this.secret;
    data['provider'] = this.provider;
    data['service'] = this.service;
    data['email'] = this.email;
    return data;
  }
}
