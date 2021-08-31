import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:minden/features/login/data/model/user_model.dart';
import 'package:minden/features/login/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tUserModel = UserModel(
    contractor: "�݂�ȁ@�d��",
    accountId: "20190707085551963zhayz",
    wallPaper:
        "https://dq2i58msgjbtb.cloudfront.net/media/1629388524511-nakajo@minden.co.jp-Screenshot_(5).png",
    loginId: "nakajo@minden.co.jp",
    name: "<b>a</b>",
    icon:
        "https://dq2i58msgjbtb.cloudfront.net/media/1629388524511-nakajo@minden.co.jp-Screenshot_(5).png",
    limitedPlantId: "MP2021080805",
    bio: "<html> <b>a</b></html>",
    supports: null,
    contracts: Contracts(contractId: "契約プランID", name: "契約プラン名称"),
    userId: "20190707085551963zhayz",
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
        "contractor": "�݂�ȁ@�d��",
        "accountId": "20190707085551963zhayz",
        "wallPaper":
            "https://dq2i58msgjbtb.cloudfront.net/media/1629388524511-nakajo@minden.co.jp-Screenshot_(5).png",
        "loginId": "nakajo@minden.co.jp",
        "name": "<b>a</b>",
        "icon":
            "https://dq2i58msgjbtb.cloudfront.net/media/1629388524511-nakajo@minden.co.jp-Screenshot_(5).png",
        "limitedPlantId": "MP2021080805",
        "bio": "<html> <b>a</b></html>",
        "supports": null,
        "contracts": {"contract_id": "契約プランID", "name": "契約プラン名称"},
        "userId": "20190707085551963zhayz"
      };
      expect(result, expectedJsonMap);
    });
  });
}
