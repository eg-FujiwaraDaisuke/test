// @dart=2.9
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/startup/data/datasources/startup_info_datasource.dart';
import 'package:minden/features/startup/data/models/startup_model.dart';
import 'package:minden/features/startup/data/repositories/startup_repository_impl.dart';
import 'package:mockito/mockito.dart';

class MockMaintenanceInfoDataSource extends Mock
    implements StartupInfoDataSource {
  @override
  Future<StartupModel> getStartupInfo() async {
    return StartupModel(
      storeUrl: '',
      hasLatestVersion: false,
      latestVersion: '',
      hasTutorial: false,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  StartupRepositoryImpl repository;
  MockMaintenanceInfoDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockMaintenanceInfoDataSource();
    repository = StartupRepositoryImpl(
      dataSource: mockDataSource,
    );
  });

  group('getStartupInfo', () {
    test('should check StartupInfoModel', () async {
      const MethodChannel('plugins.flutter.io/connectivity')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'check') {
          return 'wifi';
        }
        return null;
      });

      final info = await repository?.getStartupInfo();
      info?.fold(
        (failure) {},
        (model) {
          expect(model, isA<StartupModel>());
        },
      );
    });
    test('should check connection error', () async {
      const MethodChannel('plugins.flutter.io/connectivity')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'check') {
          return '';
        }
        return null;
      });

      final info = await repository?.getStartupInfo();
      info?.fold(
        (failure) {
          expect(failure, isA<ConnectionFailure>());
        },
        (model) {},
      );
    });
  });
}
