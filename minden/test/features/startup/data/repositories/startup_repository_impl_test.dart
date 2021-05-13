import 'package:flutter_test/flutter_test.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/startup/data/datasources/maintenance_info_datasource.dart';
import 'package:minden/features/startup/data/models/maintenance_info_model.dart';
import 'package:minden/features/startup/data/repositories/startup_repository_impl.dart';
import 'package:mockito/mockito.dart';

class MockMaintenanceInfoDataSource extends Mock
    implements MaintenanceInfoDataSource {
  @override
  Future<MaintenanceInfoModel> getMaintenanceInfo() async {
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
      final info = await repository.getMaintenanceInfo();
      info.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
        },
        (model) {
          expect(model, isA<MaintenanceInfoModel>());
        },
      );
    });
  });
}
