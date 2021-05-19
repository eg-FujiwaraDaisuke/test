import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/startup/domain/entities/maintenance_info.dart';
import 'package:minden/features/startup/domain/repositories/startup_repository.dart';
import 'package:minden/features/startup/domain/usecases/get_maintenance_info.dart';
import 'package:mockito/mockito.dart';

class MockStartupRepository extends Mock implements StartupRepository {}

void main() {
  GetMaintenanceInfo usecase;
  MockStartupRepository mockStartupRepository;

  setUp(() {
    mockStartupRepository = MockStartupRepository();
    usecase = GetMaintenanceInfo(mockStartupRepository);
  });

  final maintenanceInfo = MaintenanceInfo(
      maintenanceUrl: "", maintenanceDescription: "", underMaintenance: false);
  test(
    'should get maintenance info from the repository',
    () async {
      when(mockStartupRepository.getMaintenanceInfo())
          .thenAnswer((_) async => Right(maintenanceInfo));

      final result = await usecase(NoParams());

      expect(result, Right(maintenanceInfo));

      verify(mockStartupRepository.getMaintenanceInfo());

      verifyNoMoreInteractions(mockStartupRepository);
    },
  );
}
