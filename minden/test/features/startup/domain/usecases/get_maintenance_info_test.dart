import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/startup/domain/entities/startup_info.dart';
import 'package:minden/features/startup/domain/repositories/startup_repository.dart';
import 'package:minden/features/startup/domain/usecases/get_startup_info.dart';
import 'package:mockito/mockito.dart';

class MockStartupRepository extends Mock implements StartupRepository {}

void main() {
  GetStartupInfo usecase;
  MockStartupRepository mockStartupRepository;

  setUp(() {
    mockStartupRepository = MockStartupRepository();
    usecase = GetStartupInfo(mockStartupRepository);
  });

  final maintenanceInfo = StartupInfo(
      maintenanceUrl: "", maintenanceDescription: "", underMaintenance: false);
  test(
    'should get maintenance info from the repository',
    () async {
      when(mockStartupRepository.getStartupInfo())
          .thenAnswer((_) async => Right(maintenanceInfo));

      final result = await usecase(NoParams());

      expect(result, Right(maintenanceInfo));

      verify(mockStartupRepository.getStartupInfo());

      verifyNoMoreInteractions(mockStartupRepository);
    },
  );
}
