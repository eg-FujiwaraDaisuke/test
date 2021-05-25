// @dart=2.9
import 'package:flutter_test/flutter_test.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/startup/data/datasources/startup_info_datasource.dart';
import 'package:minden/features/startup/data/models/startup_info_model.dart';
import 'package:minden/features/startup/data/repositories/startup_repository_impl.dart';
import 'package:mockito/mockito.dart';

class MockMaintenanceInfoDataSource extends Mock
    implements StartupInfoDataSource {
  @override
  Future<StartupInfoModel> getStartupInfo() async {
    throw ServerException();
  }
}

void main() {
  StartupRepositoryImpl repository;
  MockMaintenanceInfoDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockMaintenanceInfoDataSource();
    repository = StartupRepositoryImpl(
      dataSource: mockDataSource,
    );
  });

  group('getMaintenanceInfo', () {
    test('should check if under maintenance', () async {
      final info = await repository?.getStartupInfo();
      info?.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
        },
        (model) {
          expect(model, isA<StartupInfoModel>());
        },
      );
    });
  });
}
