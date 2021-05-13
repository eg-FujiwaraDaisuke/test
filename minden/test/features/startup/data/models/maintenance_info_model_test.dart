import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:minden/features/startup/data/models/maintenance_info_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final model = MaintenanceInfoModel();

  test(
    'should be a subclass of MaintenanceInfo entity',
        () async {
      expect(model, isA<MaintenanceInfoModel>());
    },
  );
  group('fromJson', () {
    test('should return a valid model',
        () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('maintenance_data.json'));
      final result = MaintenanceInfoModel.fromJson(jsonMap);
      expect(result, model);
    });
  });
}
