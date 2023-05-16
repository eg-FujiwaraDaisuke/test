// @dart=2.9

import 'package:flutter_test/flutter_test.dart';
import 'package:minden/features/localize/data/datasources/localized_info_datasource.dart';
import 'package:minden/features/localize/data/models/localized_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  LocalizedInfoDataSourceImpl dataSource;

  SharedPreferences.setMockInitialValues({});

  setUp(() async {
    dataSource = LocalizedInfoDataSourceImpl();
  });

  final jaModel = LocalizedModel.fromJson({'language_code': 'ja'});
  final enModel = LocalizedModel.fromJson({'language_code': 'en'});
  group('datasource test', () {
    test(
      'should be a subclass of LocalizedInfoModel entity',
      () async {
        expect(jaModel, isA<LocalizedModel>());
      },
    );
    test(
      'should return LocalizedInfoModel from SharedPreferences when there is one in the cache',
      () async {
        final result = await dataSource.getLocalizedInfo(osLanguageCode: 'ja');
        expect(result, jaModel);
      },
    );
    test(
      'should return LocalizedInfoModel from SharedPreferences when there is one in the cache',
      () async {
        final result = await dataSource.getLocalizedInfo(osLanguageCode: 'en');
        expect(result, enModel);
      },
    );

    test(
      'should return "en" from SharedPreferences when there is one in the cache',
      () async {
        final model = await dataSource.updateLocalizedInfo('en');
        final result = await dataSource.getLocalizedInfo(osLanguageCode: '');
        expect(model.languageCode, result.languageCode);
      },
    );
  });
}
