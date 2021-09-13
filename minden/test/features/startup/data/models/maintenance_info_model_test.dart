// @dart=2.9
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:minden/features/startup/data/models/startup_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final model = StartupModel(
    storeUrl: "https://minden.co.jp/",
    hasLatestVersion: false,
    latestVersion: "1.0.0",
    hasTutorial: true,
  );

  test(
    'should be a subclass of MaintenanceInfo entity',
        () async {
      expect(model, isA<StartupModel>());
    },
  );
  group('fromJson', () {
    test('should return a valid model', () async {
      final Map<String, dynamic> jsonMap =
      json.decode(fixture('maintenance_data.json'));
      final result = StartupModel.fromJson(jsonMap);
      expect(result, model);
    });
  });
}
