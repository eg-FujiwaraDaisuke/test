import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/login/domain/repositories/login_repository.dart';
import 'package:minden/features/login/domain/usecases/get_login_user.dart';
import 'package:mockito/mockito.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  late GetLoginUser usecase;
  late MockLoginRepository mockLoginRepository;

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    usecase = GetLoginUser(mockLoginRepository);
  });

  final tId = 'nakajo@minden.co.jp';
  final tPassword = '1234qwer';
  final tUser = User(
    key: "20190707085551963zhayz",
    loginId: "nakajo@minden.co.jp",
    name: "�݂�ȁ@�d��",
    secret: "20000102",
    provider: "MINDEN",
    service: "portal",
    email: "nakajo@minden.co.jp",
  );

  test('should get user', () async {
    when(mockLoginRepository.getLoginUser(tId, tPassword))
        .thenAnswer((_) async => Right(tUser));

    final result = await usecase.execute(id: tId, password: tPassword);

    expect(result, Right(tUser));
    verify(mockLoginRepository.getLoginUser(tId, tPassword));
    verifyNoMoreInteractions(mockLoginRepository);
  });
}
