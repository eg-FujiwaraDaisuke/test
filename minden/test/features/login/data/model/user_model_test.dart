import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:minden/features/login/data/model/user_model.dart';
import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/user/data/model/profile_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tUserModel = UserModel(
    // key: '20190707085551963zhayz',
    loginId: 'nakajo@minden.co.jp',
    accountId: '',
    limitedPlantId: '',
    supportableNumber: 1,
    contractor: '',
    isNewbie: false,
    // userId: '',
    // name: '�݂�ȁ@�d��',
    // secret: '20000102',
    // provider: 'MINDEN',
    // service: 'portal',
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
        'contractor': '�݂�ȁ@�d��',
        'accountId': '20190707085551963zhayz',
        'wallPaper':
            'https://dq2i58msgjbtb.cloudfront.net/media/1629388524511-nakajo@minden.co.jp-Screenshot_(5).png',
        'loginId': 'nakajo@minden.co.jp',
        'userId': '',
        'name': '�݂�ȁ@�d��',
        'secret': '20000102',
        'provider': 'MINDEN',
        'service': 'portal',
        'email': 'nakajo@minden.co.jp',
      };
      expect(result, expectedJsonMap);
    });
  });
}
