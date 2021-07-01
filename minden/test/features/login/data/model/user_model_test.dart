import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:minden/features/login/data/model/user_model.dart';
import 'package:minden/features/login/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tUserModel = UserModel(
    key: "20190707085551963zhayz",
    loginId: "nakajo@minden.co.jp",
    name: "�݂�ȁ@�d��",
    secret: "20000102",
    provider: "MINDEN",
    service: "portal",
    email: "nakajo@minden.co.jp",
  );

  test('should be a subclass', () async {
    expect(tUserModel, isA<User>());
  });

  group('fromJson', () {
    test('fromJson', () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('login_data.json'));
      final result = UserModel.fromJson(jsonMap);
      expect(result, tUserModel);
    });
  });

  group('toJson', () {
    test('toJson', () async {
      final result = tUserModel.toJson();
      final expectedJsonMap = {
        "key": "20190707085551963zhayz",
        "loginId": "nakajo@minden.co.jp",
        "name": "�݂�ȁ@�d��",
        "secret": "20000102",
        "provider": "MINDEN",
        "service": "portal",
        "email": "nakajo@minden.co.jp",
      };
      expect(result, expectedJsonMap);
    });
  });
}
