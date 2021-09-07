import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:minden/features/login/data/model/user_model.dart';
import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/user/data/model/profile_model.dart';
import 'package:minden/features/user/domain/entities/profile.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tUserModel = UserModel(
    // key: "20190707085551963zhayz",
    loginId: "nakajo@minden.co.jp",
    accountId: "",
    limitedPlantId: "",
    supportableNumber : 1,
    contractor: "",
    // userId: "",
    // name: "�݂�ȁ@�d��",
    // secret: "20000102",
    // provider: "MINDEN",
    // service: "portal",
    // email: 'nakajo@minden.co.jp',
    profile: ProfileModel.fromJson({}),
  );

  test('should be a subclass', () async {
    expect(tUserModel, isA<User>());
  });

  group('fromJson', () {
    test('fromJson', () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('login_data.json'));
      final result = UserModel.fromJson(jsonMap);
      expect(result.loginId, tUserModel.loginId);
    });
  });

  group('toJson', () {
    test('toJson', () async {
      final result = tUserModel.toJson();
      final expectedJsonMap = {
        "key": "20190707085551963zhayz",
        "loginId": "nakajo@minden.co.jp",
        "userId": "",
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
