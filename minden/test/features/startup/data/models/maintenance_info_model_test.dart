// @dart=2.9
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:minden/features/startup/data/models/startup_info_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final model = StartupInfoModel(
    storeUrl: "https://minden.co.jp/",
    hasLatestVersion: false,
    latestVersion: "1.0.0"
  );

  test(
    'should be a subclass of MaintenanceInfo entity',
    () async {
      expect(model, isA<StartupInfoModel>());
    },
  );
  group('fromJson', () {
    test('should return a valid model', () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('maintenance_data.json'));
      final result = StartupInfoModel.fromJson(jsonMap);
      expect(result, model);
    });
  });
}
